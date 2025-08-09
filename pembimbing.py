from flask import Blueprint, render_template, request, jsonify, session, flash, redirect, url_for, send_file, abort
import os
import MySQLdb
import traceback
import logging
from datetime import datetime, timedelta
import re
from werkzeug.security import generate_password_hash, check_password_hash

# Import dari utils
from utils import group_anggaran_data, flatten_anggaran_data, format_tanggal_indonesia

# Setup logging untuk pembimbing blueprint (tanpa file handler)
logging.basicConfig(
    level=logging.DEBUG,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.StreamHandler()  # Hanya console handler, tidak ada file handler
    ]
)
logger = logging.getLogger('pembimbing')

# Lazy import untuk menghindari circular import
def get_app_functions():
    """Lazy import untuk mendapatkan fungsi dari app.py"""
    from app import (
        mysql, get_pembimbing_info_from_session, log_pembimbing_activity,
        generate_excel_laba_rugi, generate_pdf_laba_rugi, generate_word_laba_rugi,
        generate_excel_arus_kas, generate_pdf_arus_kas, generate_word_arus_kas,
        generate_excel_neraca, generate_pdf_neraca, generate_word_neraca,
        hitung_neraca_real_time,
        hapus_file_laporan_kemajuan, hapus_file_laporan_akhir, update_laporan_kemajuan_from_anggaran,
        hapus_file_laporan_akhir_terkait
    )
    return {
        'mysql': mysql,
        'get_pembimbing_info_from_session': get_pembimbing_info_from_session,
        'log_pembimbing_activity': log_pembimbing_activity,
        'generate_excel_laba_rugi': generate_excel_laba_rugi,
        'generate_pdf_laba_rugi': generate_pdf_laba_rugi,
        'generate_word_laba_rugi': generate_word_laba_rugi,
        'generate_excel_arus_kas': generate_excel_arus_kas,
        'generate_pdf_arus_kas': generate_pdf_arus_kas,
        'generate_word_arus_kas': generate_word_arus_kas,
        'generate_excel_neraca': generate_excel_neraca,
        'generate_pdf_neraca': generate_pdf_neraca,
        'generate_word_neraca': generate_word_neraca,
        'hitung_neraca_real_time': hitung_neraca_real_time,
        'hapus_file_laporan_kemajuan': hapus_file_laporan_kemajuan,
        'hapus_file_laporan_akhir': hapus_file_laporan_akhir,
        'update_laporan_kemajuan_from_anggaran': update_laporan_kemajuan_from_anggaran,
        'hapus_file_laporan_akhir_terkait': hapus_file_laporan_akhir_terkait
    }

# Import fungsi hitung_neraca_real_time akan dilakukan secara lazy di dalam fungsi

# Create blueprint
pembimbing_bp = Blueprint('pembimbing', __name__, url_prefix='/pembimbing')


@pembimbing_bp.route('/das_pembimbing')
def das_pembimbing():
    logger.info("Dashboard pembimbing dipanggil")
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        logger.warning(f"Akses ditolak untuk dashboard pembimbing: {session.get('user_type', 'None')}")
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        logger.error("Koneksi database tidak tersedia untuk dashboard pembimbing")
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/index pembimbing.html', mahasiswa_bimbingan=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing dengan informasi proposal dan anggota tim
        cursor.execute('''
            SELECT DISTINCT 
                m.id as mahasiswa_id,
                m.nama_ketua,
                m.nim,
                m.program_studi,
                m.perguruan_tinggi,
                m.status as status_mahasiswa,
                p.id as proposal_id,
                p.judul_usaha,
                p.status as status_proposal,
                p.status_admin,
                p.tanggal_buat,
                COUNT(at.id) as jumlah_anggota
            FROM mahasiswa m
            INNER JOIN proposal p ON m.nim = p.nim
            LEFT JOIN anggota_tim at ON p.id = at.id_proposal
            WHERE p.dosen_pembimbing = %s 
            AND p.status IN ('diajukan', 'disetujui', 'ditolak', 'revisi')
            GROUP BY m.id, m.nama_ketua, m.nim, m.program_studi, m.perguruan_tinggi, 
                     m.status, p.id, p.judul_usaha, p.status, p.status_admin, p.tanggal_buat
            ORDER BY p.tanggal_buat DESC
        ''', (session['nama'],))
        
        mahasiswa_bimbingan = cursor.fetchall()
        
        # Hitung statistik untuk dashboard
        total_mahasiswa = len(mahasiswa_bimbingan)
        proposal_lolos = len([m for m in mahasiswa_bimbingan if m['status_admin'] == 'lolos'])
        menunggu_review = len([m for m in mahasiswa_bimbingan if m['status_proposal'] == 'diajukan'])
        proposal_disetujui = len([m for m in mahasiswa_bimbingan if m['status_proposal'] == 'disetujui'])
        
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'dashboard',
                'das_pembimbing',
                'Mengakses dashboard pembimbing'
            )
        
        return render_template('pembimbing/index pembimbing.html', 
                             mahasiswa_bimbingan=mahasiswa_bimbingan,
                             total_mahasiswa=total_mahasiswa,
                             proposal_lolos=proposal_lolos,
                             menunggu_review=menunggu_review,
                             proposal_disetujui=proposal_disetujui)
        
    except Exception as e:
        logger.error(f"Error saat mengambil data dashboard pembimbing: {str(e)}")
        logger.error(traceback.format_exc())
        flash(f'Error saat mengambil data: {str(e)}', 'danger')
        return render_template('pembimbing/index pembimbing.html', 
                             mahasiswa_bimbingan=[],
                             total_mahasiswa=0,
                             proposal_lolos=0,
                             menunggu_review=0,
                             proposal_disetujui=0)

@pembimbing_bp.route('/pembimbing_proposal')
def pembimbing_proposal():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/proposal.html', proposals=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data proposal mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT p.*, 
                   m.nama_ketua, m.perguruan_tinggi, m.program_studi, m.email, m.no_telp,
                   COUNT(at.id) as jumlah_anggota
            FROM proposal p 
            LEFT JOIN mahasiswa m ON p.nim = m.nim
            LEFT JOIN anggota_tim at ON p.id = at.id_proposal
            WHERE p.dosen_pembimbing = %s AND p.status IN ('diajukan', 'disetujui', 'ditolak', 'revisi')
            GROUP BY p.id 
            ORDER BY p.tanggal_buat DESC
        ''', (session['nama'],))
        
        proposals = cursor.fetchall()
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'proposal',
                'daftar_proposal',
                'Melihat daftar proposal mahasiswa bimbingan'
            )
        
        return render_template('pembimbing/proposal.html', proposals=proposals)
        
    except Exception as e:
        flash(f'Error saat mengambil data proposal: {str(e)}', 'danger')
        return render_template('pembimbing/proposal.html', proposals=[])

@pembimbing_bp.route('/get_proposal_detail/<int:proposal_id>')
def pembimbing_get_proposal_detail(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Get proposal details with mahasiswa info, ensure it belongs to this pembimbing
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.perguruan_tinggi, m.program_studi, m.email, m.no_telp
            FROM proposal p 
            LEFT JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s AND p.dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ada akses!'})
        
        # Get team members
        cursor.execute('''
            SELECT * FROM anggota_tim 
            WHERE id_proposal = %s
            ORDER BY id
        ''', (proposal_id,))
        
        anggota = cursor.fetchall()
        
        # Get anggaran data if exists
        cursor.execute('''
            SELECT COUNT(*) as count FROM anggaran_awal WHERE id_proposal = %s
        ''', (proposal_id,))
        anggaran_awal_count = cursor.fetchone()['count']
        
        cursor.execute('''
            SELECT COUNT(*) as count FROM anggaran_bertumbuh WHERE id_proposal = %s
        ''', (proposal_id,))
        anggaran_bertumbuh_count = cursor.fetchone()['count']
        
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and proposal:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'proposal',
                f'proposal_detail_id_{proposal_id}',
                f'Melihat detail proposal "{proposal["judul_usaha"]}"',
                None,
                None,
                None,  # mahasiswa_id tidak tersedia
                proposal_id
            )
        
        return jsonify({
            'success': True, 
            'proposal': proposal,
            'anggota': anggota,
            'anggaran_awal_count': anggaran_awal_count,
            'anggaran_bertumbuh_count': anggaran_bertumbuh_count
        })
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat mengambil data: {str(e)}'})

@pembimbing_bp.route('/update_proposal_status', methods=['POST'])
def pembimbing_update_proposal_status():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        data = request.get_json()
        proposal_id = data.get('proposal_id')
        new_status = data.get('status')  # 'disetujui', 'ditolak', 'revisi'
        catatan = data.get('catatan', '').strip()  # Ambil catatan dari request
        
        if not proposal_id or not new_status:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        # Validasi status yang diizinkan
        if new_status not in ['disetujui', 'ditolak', 'revisi']:
            return jsonify({'success': False, 'message': 'Status tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the proposal belongs to this pembimbing
        cursor.execute('''
            SELECT id FROM proposal 
            WHERE id = %s AND dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ada akses!'})
        
        # Ambil data proposal sebelum update untuk logging
        cursor.execute('''
            SELECT id, judul_usaha, status as status_lama
            FROM proposal 
            WHERE id = %s AND dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        proposal_data = cursor.fetchone()
        
        # Update status proposal dan komentar pembimbing
        if new_status == 'revisi':
            cursor.execute('''
                UPDATE proposal 
                SET status = %s, 
                    komentar_revisi = %s,
                    tanggal_konfirmasi_pembimbing = NOW()
                WHERE id = %s AND dosen_pembimbing = %s
            ''', (new_status, catatan, proposal_id, session['nama']))
        else:
            cursor.execute('''
                UPDATE proposal 
                SET status = %s, 
                    komentar_pembimbing = %s,
                    tanggal_komentar_pembimbing = NOW(),
                    tanggal_konfirmasi_pembimbing = NOW()
                WHERE id = %s AND dosen_pembimbing = %s
            ''', (new_status, catatan, proposal_id, session['nama']))
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and proposal_data:
            jenis_aktivitas = 'setuju' if new_status == 'disetujui' else 'tolak' if new_status == 'ditolak' else 'revisi'
            deskripsi = f'Mengubah status proposal "{proposal_data["judul_usaha"]}" dari {proposal_data["status_lama"]} menjadi {new_status}'
            if catatan:
                deskripsi += f' dengan catatan: {catatan[:100]}...' if len(catatan) > 100 else f' dengan catatan: {catatan}'
            
            # Data untuk tracking perubahan
            data_lama = {'status': proposal_data['status_lama']}
            data_baru = {'status': new_status, 'komentar_pembimbing': catatan}
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                jenis_aktivitas,
                'proposal',
                f'proposal_id_{proposal_id}',
                deskripsi,
                data_lama,
                data_baru,
                None,  # mahasiswa_id tidak tersedia
                proposal_id  # target_proposal_id
            )
        
        cursor.close()
        
        # Pesan sukses berdasarkan status dan komentar
        if catatan:
            message = f'Status proposal berhasil diubah menjadi {new_status} dengan komentar'
        else:
            message = f'Status proposal berhasil diubah menjadi {new_status}'
        
        return jsonify({'success': True, 'message': message})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat update status: {str(e)}'})

@pembimbing_bp.route('/download_proposal/<int:proposal_id>')
def pembimbing_download_proposal(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal!', 'danger')
        return redirect(url_for('pembimbing.pembimbing_proposal'))
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'proposal',
                f'download_proposal_id_{proposal_id}',
                f'Mendownload file proposal ID {proposal_id}',
                None,
                None,
                None,
                proposal_id
            )
        
        # Get proposal file path, ensure it belongs to this pembimbing
        cursor.execute('''
            SELECT file_path, judul_usaha 
            FROM proposal 
            WHERE id = %s AND dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        proposal = cursor.fetchone()
        cursor.close()
        
        if not proposal or not proposal['file_path']:
            flash('File proposal tidak ditemukan!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_proposal'))
        
        file_path = proposal['file_path']
        
        if not os.path.exists(file_path):
            flash('File proposal tidak ditemukan di server!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_proposal'))
        
        # Get file extension and create download filename
        file_extension = os.path.splitext(file_path)[1]
        
        # Ambil nama file asli dari path
        original_filename = os.path.basename(file_path)
        
        # Jika nama file sudah sesuai format yang diinginkan, gunakan itu
        if '_proposal.' in original_filename:
            download_filename = original_filename
        else:
            download_filename = f"{proposal['judul_usaha'].replace(' ', '_')}_proposal{file_extension}"
        
        from flask import send_file
        return send_file(file_path, as_attachment=False)
        
    except Exception as e:
        flash(f'Error saat download file: {str(e)}', 'danger')
        return redirect(url_for('pembimbing.pembimbing_proposal'))


@pembimbing_bp.route('/anggaran_awal/<int:proposal_id>')
def pembimbing_anggaran_awal(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/pengajuan anggaran awal.html', anggaran_data=[], proposal_id=proposal_id)
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the proposal belongs to this pembimbing
        cursor.execute('''
            SELECT id FROM proposal 
            WHERE id = %s AND dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            flash('Proposal tidak ditemukan atau tidak ada akses!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_proposal'))
        
        cursor.execute('''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status,
                   COALESCE(nilai_bantuan, 0) as nilai_bantuan
            FROM anggaran_awal 
            WHERE id_proposal = %s 
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        anggaran_data = cursor.fetchall()
        urutan_kegiatan = [
            "Pengembangan Produk/Riset",
            "Produksi",
            "Legalitas, Perijinan, Sertifikasi, Pengujian Produk, dan Standarisasi",
            "Belanja ATK dan Penunjang"
        ]
        urutan_kegiatan_lower = [k.strip().lower() for k in urutan_kegiatan]
        anggaran_data = sorted(
            anggaran_data,
            key=lambda x: urutan_kegiatan_lower.index(x['kegiatan_utama'].strip().lower()) if x['kegiatan_utama'] and x['kegiatan_utama'].strip().lower() in urutan_kegiatan_lower else 99
        )
        cursor.execute('SELECT judul_usaha, tahapan_usaha FROM proposal WHERE id = %s', (proposal_id,))
        proposal_info = cursor.fetchone()
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and proposal_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'anggaran_awal',
                f'proposal_id_{proposal_id}',
                f'Melihat anggaran awal proposal "{proposal_info["judul_usaha"]}"',
                None,
                None,
                None,
                proposal_id
            )
        
        grouped_data = group_anggaran_data(anggaran_data)
        anggaran_data_flat = flatten_anggaran_data(anggaran_data)
        # Total nilai bantuan pembimbing (kolom sudah COALESCE di SELECT)
        total_nilai_bantuan = sum((row.get('nilai_bantuan', 0) or 0) for row in anggaran_data)
        # Ambil batas min/maks untuk badge seperti mahasiswa
        try:
            cur2 = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur2.execute('SELECT * FROM pengaturan_anggaran ORDER BY id DESC LIMIT 1')
            batas_row = cur2.fetchone() or {}
            batas_min_awal = int(batas_row.get('min_total_awal') or 0)
            batas_max_awal = int(batas_row.get('max_total_awal') or 0)
            cur2.close()
        except Exception:
            batas_min_awal = 0
            batas_max_awal = 0
        return render_template('pembimbing/pengajuan anggaran awal.html', 
                             anggaran_data=anggaran_data, 
                             grouped_data=grouped_data,
                             anggaran_data_flat=anggaran_data_flat,
                             proposal_id=proposal_id,
                              proposal_info=proposal_info,
                              total_nilai_bantuan=total_nilai_bantuan,
                              batas_min_awal=batas_min_awal,
                              batas_max_awal=batas_max_awal)
    except Exception as e:
        flash(f'Error saat mengambil data anggaran: {str(e)}', 'danger')
        return render_template('pembimbing/pengajuan anggaran awal.html', anggaran_data=[], proposal_id=proposal_id, total_nilai_bantuan=0)

@pembimbing_bp.route('/anggaran_bertumbuh/<int:proposal_id>')
def pembimbing_anggaran_bertumbuh(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/pengajuan anggaran bertumbuh.html', anggaran_data=[], proposal_id=proposal_id)
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the proposal belongs to this pembimbing
        cursor.execute('''
            SELECT id FROM proposal 
            WHERE id = %s AND dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            flash('Proposal tidak ditemukan atau tidak ada akses!', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        
        cursor.execute('''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status,
                   COALESCE(nilai_bantuan, 0) as nilai_bantuan
            FROM anggaran_bertumbuh 
            WHERE id_proposal = %s 
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        anggaran_data = cursor.fetchall()
        urutan_kegiatan = [
            "Pengembangan Pasar dan Saluran Distribusi",
            "Pengembangan Produk/Riset",
            "Produksi",
            "Legalitas, perizinan, sertifikasi, dan standarisasi",
            "Belanja ATK dan Penunjang"
        ]
        urutan_kegiatan_lower = [k.strip().lower() for k in urutan_kegiatan]
        anggaran_data = sorted(
            anggaran_data,
            key=lambda x: urutan_kegiatan_lower.index(x['kegiatan_utama'].strip().lower()) if x['kegiatan_utama'] and x['kegiatan_utama'].strip().lower() in urutan_kegiatan_lower else 99
        )
        cursor.execute('SELECT judul_usaha, tahapan_usaha FROM proposal WHERE id = %s', (proposal_id,))
        proposal_info = cursor.fetchone()
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and proposal_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'anggaran_bertumbuh',
                f'proposal_id_{proposal_id}',
                f'Melihat anggaran bertumbuh proposal "{proposal_info["judul_usaha"]}"',
                None,
                None,
                None,
                proposal_id
            )
        
        grouped_data = group_anggaran_data(anggaran_data)
        anggaran_data_flat = flatten_anggaran_data(anggaran_data)
        total_nilai_bantuan = sum((row.get('nilai_bantuan', 0) or 0) for row in anggaran_data)
        # Ambil batas min/maks untuk badge seperti mahasiswa
        try:
            cur2 = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur2.execute('SELECT * FROM pengaturan_anggaran ORDER BY id DESC LIMIT 1')
            batas_row = cur2.fetchone() or {}
            batas_min_bertumbuh = int(batas_row.get('min_total_bertumbuh') or 0)
            batas_max_bertumbuh = int(batas_row.get('max_total_bertumbuh') or 0)
            cur2.close()
        except Exception:
            batas_min_bertumbuh = 0
            batas_max_bertumbuh = 0
        return render_template('pembimbing/pengajuan anggaran bertumbuh.html', 
                             anggaran_data=anggaran_data, 
                             grouped_data=grouped_data,
                             anggaran_data_flat=anggaran_data_flat,
                             proposal_id=proposal_id,
                              proposal_info=proposal_info,
                              total_nilai_bantuan=total_nilai_bantuan,
                              batas_min_bertumbuh=batas_min_bertumbuh,
                              batas_max_bertumbuh=batas_max_bertumbuh)
    except Exception as e:
        flash(f'Error saat mengambil data anggaran: {str(e)}', 'danger')
        return render_template('pembimbing/pengajuan anggaran bertumbuh.html', anggaran_data=[], proposal_id=proposal_id, total_nilai_bantuan=0)

@pembimbing_bp.route('/get_anggaran/<int:anggaran_id>')
def pembimbing_get_anggaran(anggaran_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    try:
        tabel = request.args.get('tabel', 'anggaran_awal')
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                tabel,
                f'{tabel}_detail_id_{anggaran_id}',
                f'Mengambil detail {tabel} ID {anggaran_id}'
            )
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the anggaran belongs to a proposal supervised by this pembimbing
        cursor.execute(f'''
            SELECT aa.* 
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        ''', (anggaran_id, session['nama']))
        
        anggaran = cursor.fetchone()
        cursor.close()
        
        if anggaran:
            return jsonify({'success': True, 'anggaran': anggaran})
        else:
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan atau tidak ada akses!'})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat mengambil data: {str(e)}'})


@pembimbing_bp.route('/monitoring_mahasiswa/produksi')
def pembimbing_monitoring_mahasiswa_produksi():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'produksi_mahasiswa',
            'Melihat halaman monitoring produksi mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/produksi_bahan_baku.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data bahan baku
            cursor.execute('SELECT COUNT(*) as cnt FROM bahan_baku WHERE proposal_id = %s', (proposal_id,))
            bahan_baku_count = cursor.fetchone()['cnt']
            
            # Cek apakah ada data produksi
            cursor.execute('SELECT COUNT(*) as cnt FROM produksi WHERE proposal_id = %s', (proposal_id,))
            produksi_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_bahan_baku'] = bahan_baku_count > 0
            mhs['has_produksi'] = produksi_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/produksi_bahan_baku.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/produksi_bahan_baku.html', mahasiswa_list=[])

@pembimbing_bp.route('/monitoring_mahasiswa/penjualan_produk')
def pembimbing_monitoring_mahasiswa_penjualan_produk():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'penjualan_produk_mahasiswa',
            'Melihat halaman monitoring penjualan produk mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/penjualan_produk.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data penjualan
            cursor.execute('SELECT COUNT(*) as cnt FROM penjualan WHERE proposal_id = %s', (proposal_id,))
            penjualan_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_penjualan'] = penjualan_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        return render_template('pembimbing/penjualan_produk.html', mahasiswa_list=mahasiswa_list)
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/penjualan_produk.html', mahasiswa_list=[])

@pembimbing_bp.route('/monitoring_mahasiswa/laporan_laba_rugi')
def pembimbing_monitoring_mahasiswa_laporan_laba_rugi():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'laporan_laba_rugi_mahasiswa',
            'Melihat halaman monitoring laporan laba rugi mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laba_rugi_produk.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data laba rugi
            cursor.execute('SELECT COUNT(*) as cnt FROM laba_rugi WHERE proposal_id = %s', (proposal_id,))
            laba_rugi_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_laba_rugi'] = laba_rugi_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/laba_rugi_produk.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laba_rugi_produk.html', mahasiswa_list=[])

@pembimbing_bp.route('/laporan_laba_rugi/<int:mahasiswa_id>')
def pembimbing_laporan_laba_rugi(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_laba_rugi.html', proposal_data={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.kategori, p.tahun_nib, p.id as proposal_id, m.nama_ketua, m.nim
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_laba_rugi'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Ambil data laba rugi dari tabel laba_rugi
        cursor.execute('''
            SELECT tanggal_produksi, nama_produk, pendapatan, total_biaya_produksi, 
                   laba_rugi_kotor, biaya_operasional, laba_rugi_bersih
            FROM laba_rugi
            WHERE proposal_id = %s
            ORDER BY tanggal_produksi DESC
        ''', (proposal_id,))
        
        laba_rugi_data = cursor.fetchall()
        
        # Hitung total dari data laba rugi
        total_pendapatan = sum(item['pendapatan'] for item in laba_rugi_data)
        total_biaya_produksi = sum(item['total_biaya_produksi'] for item in laba_rugi_data)
        total_biaya_operasional = sum(item['biaya_operasional'] for item in laba_rugi_data)
        total_laba_kotor = sum(item['laba_rugi_kotor'] for item in laba_rugi_data)
        total_laba_bersih = sum(item['laba_rugi_bersih'] for item in laba_rugi_data)
        
        proposal_data = {
            proposal_id: {
                'proposal': {
                    'id': proposal_id,
                    'judul_usaha': mahasiswa_info['judul_usaha'],
                    'kategori': mahasiswa_info['kategori'],
                    'tahun_nib': mahasiswa_info['tahun_nib'],
                    'nama_ketua': mahasiswa_info['nama_ketua'],
                    'nim': mahasiswa_info['nim']
                },
                'laba_rugi_data': laba_rugi_data,
                'total_pendapatan': total_pendapatan,
                'total_biaya_produksi': total_biaya_produksi,
                'total_biaya_operasional': total_biaya_operasional,
                'total_laba_kotor': total_laba_kotor,
                'total_laba_bersih': total_laba_bersih
            }
        }
        
        cursor.close()
        return render_template('pembimbing/laporan_laba_rugi.html', proposal_data=proposal_data)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_laba_rugi.html', proposal_data={})

@pembimbing_bp.route('/download_laba_rugi', methods=['POST'])
def pembimbing_download_laba_rugi():
    logger.info("Download laba rugi pembimbing dipanggil")
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        logger.warning(f"Akses ditolak untuk download laba rugi: {session.get('user_type', 'None')}")
        return jsonify({'success': False, 'message': 'Unauthorized'})
    
    try:
        proposal_id = request.form.get('proposal_id')
        format_type = request.form.get('format')
        start_date = request.form.get('start_date')
        end_date = request.form.get('end_date')
        
        if not all([proposal_id, format_type, start_date, end_date]):
            return jsonify({'success': False, 'message': 'Parameter tidak lengkap'})
        
        app_funcs = get_app_functions()
        if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
            return jsonify({'success': False, 'message': 'Koneksi database tidak tersedia'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data proposal dan pastikan pembimbing memiliki akses
        cursor.execute('''
            SELECT p.judul_usaha, p.kategori, p.tahun_nib
            FROM proposal p
            WHERE p.id = %s AND p.dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ada akses'})
        
        # Ambil data laba rugi sesuai rentang tanggal
        cursor.execute('''
            SELECT tanggal_produksi, nama_produk, pendapatan, total_biaya_produksi, 
                   laba_rugi_kotor, biaya_operasional, laba_rugi_bersih
            FROM laba_rugi
            WHERE proposal_id = %s AND tanggal_produksi BETWEEN %s AND %s
            ORDER BY tanggal_produksi DESC
        ''', (proposal_id, start_date, end_date))
        
        laba_rugi_data = cursor.fetchall()
        
        # DEBUG: Log data untuk memastikan tidak kosong
        logger.debug(f"=== DEBUG DOWNLOAD LABA RUGI PEMBIMBING ===")
        logger.debug(f"Proposal ID: {proposal_id}")
        logger.debug(f"Start Date: {start_date}")
        logger.debug(f"End Date: {end_date}")
        logger.debug(f"Data count: {len(laba_rugi_data)}")
        logger.debug(f"Data sample: {laba_rugi_data[:2] if laba_rugi_data else 'KOSONG'}")
        logger.debug(f"Proposal data: {proposal}")
        logger.debug("=============================================")
        
        if not laba_rugi_data:
            cursor.close()
            return jsonify({'success': False, 'message': 'Tidak ada data laba rugi untuk periode yang dipilih'})
        
        # Hitung total
        total_pendapatan = sum(item['pendapatan'] for item in laba_rugi_data)
        total_biaya_produksi = sum(item['total_biaya_produksi'] for item in laba_rugi_data)
        total_biaya_operasional = sum(item['biaya_operasional'] for item in laba_rugi_data)
        total_laba_kotor = sum(item['laba_rugi_kotor'] for item in laba_rugi_data)
        total_laba_bersih = sum(item['laba_rugi_bersih'] for item in laba_rugi_data)
        
        # DEBUG: Log totals
        logger.debug(f"=== TOTALS PEMBIMBING ===")
        logger.debug(f"Total Pendapatan: {total_pendapatan}")
        logger.debug(f"Total Biaya Produksi: {total_biaya_produksi}")
        logger.debug(f"Total Biaya Operasional: {total_biaya_operasional}")
        logger.debug(f"Total Laba Kotor: {total_laba_kotor}")
        logger.debug(f"Total Laba Bersih: {total_laba_bersih}")
        logger.debug("==========================")
        
        cursor.close()
        
        # Generate file berdasarkan format dengan pembersihan karakter
        import re
        safe_judul = re.sub(r'[<>:"/\\|?*]', '_', proposal['judul_usaha'])
        filename = f"Laporan_Laba_Rugi_{safe_judul.replace(' ', '_')}_{start_date}_to_{end_date}"
        
        if format_type == 'excel':
            return app_funcs['generate_excel_laba_rugi'](laba_rugi_data, proposal, total_pendapatan, 
                                           total_biaya_produksi, total_biaya_operasional, 
                                           total_laba_kotor, total_laba_bersih, 
                                           start_date, end_date, filename)
        elif format_type == 'pdf':
            return app_funcs['generate_pdf_laba_rugi'](laba_rugi_data, proposal, total_pendapatan, 
                                         total_biaya_produksi, total_biaya_operasional, 
                                         total_laba_kotor, total_laba_bersih, 
                                         start_date, end_date, filename)
        elif format_type == 'word':
            return app_funcs['generate_word_laba_rugi'](laba_rugi_data, proposal, total_pendapatan, 
                                          total_biaya_produksi, total_biaya_operasional, 
                                          total_laba_kotor, total_laba_bersih, 
                                          start_date, end_date, filename)
        else:
            return jsonify({'success': False, 'message': 'Format tidak didukung'})
        
    except Exception as e:
        logger.error('--- ERROR DOWNLOAD LABA RUGI PEMBIMBING ---')
        logger.error(traceback.format_exc())
        return jsonify({'success': False, 'message': f'Error: {str(e)}', 'trace': traceback.format_exc()})

@pembimbing_bp.route('/monitoring_mahasiswa/alat_produksi')
def pembimbing_monitoring_mahasiswa_alat_produksi():
    logger.info("Monitoring alat produksi mahasiswa dipanggil")
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        logger.warning(f"Akses ditolak untuk monitoring alat produksi: {session.get('user_type', 'None')}")
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'alat_produksi_mahasiswa',
            'Melihat halaman monitoring alat produksi mahasiswa'
        )
    
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        logger.error("Koneksi database tidak tersedia untuk monitoring alat produksi")
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_mahsiswa_alat_produksi.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data alat produksi
            cursor.execute('SELECT COUNT(*) as cnt FROM alat_produksi WHERE proposal_id = %s', (proposal_id,))
            alat_produksi_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_alat_produksi'] = alat_produksi_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/daftar_mahsiswa_alat_produksi.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/daftar_mahsiswa_alat_produksi.html', mahasiswa_list=[])

@pembimbing_bp.route('/alat_produksi/<int:mahasiswa_id>')
def pembimbing_alat_produksi(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/alat_produksi.html', alat_produksi_list=[], mahasiswa_info={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_alat_produksi'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Ambil data alat produksi
        cursor.execute('''
            SELECT * FROM alat_produksi 
            WHERE proposal_id = %s 
            ORDER BY tanggal_beli DESC
        ''', (proposal_id,))
        
        alat_produksi_list = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/alat_produksi.html', 
                             alat_produksi_list=alat_produksi_list, 
                             mahasiswa_info=mahasiswa_info)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/alat_produksi.html', alat_produksi_list=[], mahasiswa_info={})

@pembimbing_bp.route('/monitoring_mahasiswa/biaya_operasional')
def pembimbing_monitoring_mahasiswa_biaya_operasional():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'biaya_operasional_mahasiswa',
            'Melihat halaman monitoring biaya operasional mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_mahsiswa_biaya_operasional.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data biaya operasional
            cursor.execute('SELECT COUNT(*) as cnt FROM biaya_operasional WHERE proposal_id = %s', (proposal_id,))
            biaya_operasional_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_biaya_operasional'] = biaya_operasional_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/daftar_mahsiswa_biaya_operasional.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/daftar_mahsiswa_biaya_operasional.html', mahasiswa_list=[])

@pembimbing_bp.route('/monitoring_mahasiswa/biaya_non_operasional')
def pembimbing_monitoring_mahasiswa_biaya_non_operasional():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'monitoring',
            'biaya_non_operasional_mahasiswa',
            'Melihat halaman monitoring biaya non operasional mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_biaya_non_operasional.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data biaya non operasional
            cursor.execute('SELECT COUNT(*) as cnt FROM biaya_non_operasional WHERE proposal_id = %s', (proposal_id,))
            biaya_non_operasional_count = cursor.fetchone()['cnt']
            
            # Tambahkan informasi data yang tersedia
            mhs['has_biaya_non_operasional'] = biaya_non_operasional_count > 0
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/daftar_biaya_non_operasional.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/daftar_biaya_non_operasional.html', mahasiswa_list=[])

@pembimbing_bp.route('/biaya_non_operasional/<int:mahasiswa_id>')
def pembimbing_biaya_non_operasional(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/biaya_non_operasional.html', biaya_non_operasional_list=[], mahasiswa_info={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_biaya_non_operasional'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Ambil data biaya non operasional
        cursor.execute('''
            SELECT * FROM biaya_non_operasional 
            WHERE proposal_id = %s 
            ORDER BY created_at DESC
        ''', (proposal_id,))
        
        biaya_non_operasional_list = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/biaya_non_operasional.html', 
                             biaya_non_operasional_list=biaya_non_operasional_list, 
                             mahasiswa_info=mahasiswa_info)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/biaya_non_operasional.html', biaya_non_operasional_list=[], mahasiswa_info={})

@pembimbing_bp.route('/biaya_operasional/<int:mahasiswa_id>')
def pembimbing_biaya_operasional(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/biaya_operasional.html', biaya_operasional_list=[], mahasiswa_info={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_biaya_operasional'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Ambil data biaya operasional
        cursor.execute('''
            SELECT * FROM biaya_operasional 
            WHERE proposal_id = %s 
            ORDER BY created_at DESC
        ''', (proposal_id,))
        
        biaya_operasional_list = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/biaya_operasional.html', 
                             biaya_operasional_list=biaya_operasional_list, 
                             mahasiswa_info=mahasiswa_info)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/biaya_operasional.html', biaya_operasional_list=[], mahasiswa_info={})

@pembimbing_bp.route('/monitoring_mahasiswa/laporan_arus_kas')
def pembimbing_monitoring_mahasiswa_laporan_arus_kas():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_mahasiswa_arus_kas.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini dengan status proposal
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, 
                   p.id as proposal_id, p.status_admin, p.status as status_proposal
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah proposal sudah lolos
            has_lolos_proposal = mhs['status_admin'] == 'lolos'
            
            if has_lolos_proposal:
                # Cek apakah ada data arus kas dari tabel arus_kas
                cursor.execute('SELECT COUNT(*) as cnt FROM arus_kas WHERE proposal_id = %s', (proposal_id,))
                arus_kas_count = cursor.fetchone()['cnt']
                
                # Jika tidak ada di tabel arus_kas, cek dari tabel individual
                if arus_kas_count == 0:
                    cursor.execute('SELECT COUNT(*) as cnt FROM penjualan WHERE proposal_id = %s', (proposal_id,))
                    penjualan_count = cursor.fetchone()['cnt']
                    
                    cursor.execute('SELECT COUNT(*) as cnt FROM biaya_operasional WHERE proposal_id = %s', (proposal_id,))
                    biaya_operasional_count = cursor.fetchone()['cnt']
                    
                    cursor.execute('SELECT COUNT(*) as cnt FROM biaya_non_operasional WHERE proposal_id = %s', (proposal_id,))
                    biaya_non_operasional_count = cursor.fetchone()['cnt']
                    
                    cursor.execute('SELECT COUNT(*) as cnt FROM alat_produksi WHERE proposal_id = %s', (proposal_id,))
                    alat_produksi_count = cursor.fetchone()['cnt']
                    
                    # Tambahkan informasi data yang tersedia
                    mhs['has_arus_kas'] = (penjualan_count > 0 or biaya_operasional_count > 0 or 
                                          biaya_non_operasional_count > 0 or alat_produksi_count > 0)
                else:
                    mhs['has_arus_kas'] = True
            else:
                mhs['has_arus_kas'] = False
            
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/daftar_mahasiswa_arus_kas.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        logger.error(f"Error in pembimbing_monitoring_mahasiswa_laporan_arus_kas: {str(e)}")
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/daftar_mahasiswa_arus_kas.html', mahasiswa_list=[])

@pembimbing_bp.route('/arus_kas/<int:mahasiswa_id>')
def pembimbing_arus_kas(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/arus_kas.html', mahasiswa_info=None, proposal_data={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id, p.status as status_proposal, p.status_admin
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_arus_kas'))
        
        # Cek apakah proposal sudah lolos
        has_lolos_proposal = mahasiswa_info['status_admin'] == 'lolos'
        
        if not has_lolos_proposal:
            flash('Proposal mahasiswa belum disetujui oleh admin!', 'warning')
            cursor.close()
            return render_template('pembimbing/arus_kas.html', 
                                 mahasiswa_info=mahasiswa_info,
                                 proposal_data={},
                                 has_lolos_proposal=False)
        
        # Ambil data arus kas dari tabel arus_kas
        proposal_id = mahasiswa_info['proposal_id']
        logger.debug(f"DEBUG - proposal_id dari mahasiswa_info: {proposal_id}")
        logger.debug(f"DEBUG - mahasiswa_info: {mahasiswa_info}")
        
        # Ambil bulan yang dipilih (default: bulan ini)
        selected_month = request.args.get('month', datetime.now().strftime('%Y-%m'))
        
        # Parse bulan dan tahun
        if not selected_month:
            selected_month = datetime.now().strftime('%Y-%m')
        
        try:
            selected_date = datetime.strptime(selected_month, '%Y-%m')
            selected_month_year = selected_date.strftime('%B %Y')
        except ValueError:
            selected_date = datetime.now()
            selected_month_year = selected_date.strftime('%B %Y')
        
        # Ambil data arus kas dari tabel arus_kas
        cursor.execute('''
            SELECT total_penjualan, total_biaya_produksi, total_biaya_operasional,
                   total_biaya_non_operasional, kas_bersih_operasional, total_harga_jual_alat,
                   total_harga_alat, kas_bersih_investasi, kas_bersih_pembiayaan, total_kas_bersih
            FROM arus_kas 
            WHERE proposal_id = %s AND bulan_tahun = %s
        ''', (proposal_id, selected_month))
        
        arus_kas_data = cursor.fetchone()
        
        if arus_kas_data:
            # Jika data ada di tabel arus_kas, gunakan data tersebut
            total_penjualan = float(arus_kas_data['total_penjualan'] or 0)
            total_biaya_produksi = float(arus_kas_data['total_biaya_produksi'] or 0)
            total_biaya_operasional = float(arus_kas_data['total_biaya_operasional'] or 0)
            total_biaya_non_operasional = float(arus_kas_data['total_biaya_non_operasional'] or 0)
            kas_bersih_operasional = float(arus_kas_data['kas_bersih_operasional'] or 0)
            total_harga_jual_alat = float(arus_kas_data['total_harga_jual_alat'] or 0)
            total_harga_alat = float(arus_kas_data['total_harga_alat'] or 0)
            kas_bersih_investasi = float(arus_kas_data['kas_bersih_investasi'] or 0)
            kas_bersih_pembiayaan = float(arus_kas_data['kas_bersih_pembiayaan'] or 0)
            total_kas_bersih = float(arus_kas_data['total_kas_bersih'] or 0)
        else:
            # Jika data tidak ada di tabel arus_kas, hitung dari tabel individual
            cursor.execute('''
                SELECT COALESCE(SUM(total), 0) as total_penjualan
                FROM penjualan 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_penjualan, '%%Y-%%m') = %s
            ''', (proposal_id, selected_month))
            total_penjualan = float(cursor.fetchone()['total_penjualan'] or 0)
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_produksi
                FROM bahan_baku 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, selected_month))
            total_biaya_produksi = float(cursor.fetchone()['total_biaya_produksi'] or 0)
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_operasional
                FROM biaya_operasional 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, selected_month))
            total_biaya_operasional = float(cursor.fetchone()['total_biaya_operasional'] or 0)
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_non_operasional
                FROM biaya_non_operasional 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_transaksi, '%%Y-%%m') = %s
            ''', (proposal_id, selected_month))
            total_biaya_non_operasional = float(cursor.fetchone()['total_biaya_non_operasional'] or 0)
            
            cursor.execute('''
                SELECT 
                    COALESCE(SUM(harga), 0) as total_harga_alat,
                    COALESCE(SUM(harga_jual), 0) as total_harga_jual_alat
                FROM alat_produksi 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, selected_month))
            
            alat_data = cursor.fetchone()
            total_harga_alat = float(alat_data['total_harga_alat'] or 0)
            total_harga_jual_alat = float(alat_data['total_harga_jual_alat'] or 0)
            
            # Hitung kas bersih dari kegiatan operasional
            kas_bersih_operasional = total_penjualan - total_biaya_produksi - total_biaya_operasional - total_biaya_non_operasional
            
            # Hitung kas bersih dari kegiatan investasi
            kas_bersih_investasi = total_harga_jual_alat - total_harga_alat
            
            # Hitung kas bersih dari kegiatan pembiayaan (selalu 0)
            kas_bersih_pembiayaan = 0
            
            # Hitung total kas bersih
            total_kas_bersih = kas_bersih_operasional + kas_bersih_investasi
        
        # Siapkan data untuk template
        proposal_data = {
            proposal_id: {
                'proposal': mahasiswa_info,
                'total_penjualan': total_penjualan,
                'total_biaya_produksi': total_biaya_produksi,
                'total_biaya_operasional': total_biaya_operasional,
                'total_biaya_non_operasional': total_biaya_non_operasional,
                'total_harga_alat': total_harga_alat,
                'total_harga_jual_alat': total_harga_jual_alat,
                'kas_bersih_operasional': kas_bersih_operasional,
                'kas_bersih_investasi': kas_bersih_investasi,
                'kas_bersih_pembiayaan': kas_bersih_pembiayaan,
                'total_kas_bersih': total_kas_bersih
            }
        }
        
        # Ambil daftar bulan yang tersedia dari tabel arus_kas
        cursor.execute('''
            SELECT DISTINCT bulan_tahun as month_value
            FROM arus_kas 
            WHERE proposal_id = %s
            ORDER BY bulan_tahun DESC
        ''', (proposal_id,))
        
        available_months = []
        for row in cursor.fetchall():
            month_value = row['month_value']
            try:
                month_date = datetime.strptime(month_value, '%Y-%m')
                month_label = month_date.strftime('%B %Y')
                available_months.append({
                    'value': month_value,
                    'label': month_label
                })
            except ValueError:
                continue
        
        # Jika tidak ada bulan di tabel arus_kas, tambahkan bulan saat ini
        if not available_months:
            current_month = datetime.now().strftime('%Y-%m')
            current_month_label = datetime.now().strftime('%B %Y')
            available_months.append({
                'value': current_month,
                'label': current_month_label
            })
        
        cursor.close()
        
        logger.debug(f"DEBUG - proposal_data yang dikirim ke template: {proposal_data}")
        
        return render_template('pembimbing/arus_kas.html', 
                             mahasiswa_info=mahasiswa_info,
                             proposal_data=proposal_data,
                             proposal_id=proposal_id,
                             selected_month=selected_month,
                             selected_month_year=selected_month_year,
                             available_months=available_months,
                             has_lolos_proposal=True)
        
    except Exception as e:
        logger.error(f"Error in pembimbing_arus_kas: {str(e)}")
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/arus_kas.html', 
                             mahasiswa_info=None, 
                             proposal_data={},
                             has_lolos_proposal=False)

@pembimbing_bp.route('/download_arus_kas', methods=['POST'])
def pembimbing_download_arus_kas():
    import traceback
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Unauthorized'})
    
    try:
        proposal_id = request.form.get('proposal_id')
        format_type = request.form.get('format')
        bulan_tahun = request.form.get('bulan_tahun')
        
        if not all([proposal_id, format_type, bulan_tahun]):
            return jsonify({'success': False, 'message': 'Parameter tidak lengkap'})
        
        app_funcs = get_app_functions()
        if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
            return jsonify({'success': False, 'message': 'Koneksi database tidak tersedia'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Debug: Print parameter yang diterima
        logger.debug(f"DEBUG - proposal_id: {proposal_id}")
        logger.debug(f"DEBUG - session['nama']: {session.get('nama')}")
        
        # Verifikasi bahwa mahasiswa dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.nama_ketua, m.nim, m.program_studi, p.judul_usaha, p.kategori, p.tahun_nib
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.id = %s AND LOWER(p.dosen_pembimbing) = LOWER(%s)
        ''', (proposal_id, session['nama']))
        mahasiswa_info = cursor.fetchone()
        logger.debug(f"DEBUG - mahasiswa_info: {mahasiswa_info}")
        
        # Debug: Cek data proposal dan pembimbing
        if not mahasiswa_info:
            logger.debug("DEBUG - Query gagal, cek data proposal...")
            cursor.execute('SELECT id, nim, dosen_pembimbing, judul_usaha FROM proposal WHERE id = %s', (proposal_id,))
            proposal_data = cursor.fetchone()
            logger.debug(f"DEBUG - proposal_data: {proposal_data}")
            
            if proposal_data:
                logger.debug(f"DEBUG - dosen_pembimbing di DB: '{proposal_data['dosen_pembimbing']}'")
                logger.debug(f"DEBUG - session['nama']: '{session['nama']}'")
                logger.debug(f"DEBUG - Apakah sama? {proposal_data['dosen_pembimbing'] == session['nama']}")
            
            cursor.close()
            return jsonify({'success': False, 'message': 'Data mahasiswa tidak ditemukan atau tidak ada akses'})
        
        # Parse bulan yang dipilih
        if not bulan_tahun:
            return jsonify({'success': False, 'message': 'Bulan tahun tidak boleh kosong'})
        
        try:
            selected_date = datetime.strptime(bulan_tahun, '%Y-%m')
            selected_month_year = selected_date.strftime('%B %Y')
        except ValueError:
            return jsonify({'success': False, 'message': 'Format bulan tahun tidak valid. Gunakan format YYYY-MM'})
        
        # Ambil data arus kas dari tabel arus_kas
        cursor.execute('''
            SELECT total_penjualan, total_biaya_produksi, total_biaya_operasional,
                   total_biaya_non_operasional, kas_bersih_operasional, total_harga_jual_alat,
                   total_harga_alat, kas_bersih_investasi, kas_bersih_pembiayaan, total_kas_bersih
            FROM arus_kas 
            WHERE proposal_id = %s AND bulan_tahun = %s
        ''', (proposal_id, bulan_tahun))
        
        arus_kas_data = cursor.fetchone()
        
        if arus_kas_data:
            # Jika data ada di tabel arus_kas, gunakan data tersebut
            total_penjualan = arus_kas_data['total_penjualan'] or 0
            total_biaya_produksi = arus_kas_data['total_biaya_produksi'] or 0
            total_biaya_operasional = arus_kas_data['total_biaya_operasional'] or 0
            total_biaya_non_operasional = arus_kas_data['total_biaya_non_operasional'] or 0
            kas_bersih_operasional = arus_kas_data['kas_bersih_operasional'] or 0
            total_harga_jual_alat = arus_kas_data['total_harga_jual_alat'] or 0
            total_harga_alat = arus_kas_data['total_harga_alat'] or 0
            kas_bersih_investasi = arus_kas_data['kas_bersih_investasi'] or 0
            kas_bersih_pembiayaan = arus_kas_data['kas_bersih_pembiayaan'] or 0
            total_kas_bersih = arus_kas_data['total_kas_bersih'] or 0
        else:
            # Jika data tidak ada di tabel arus_kas, hitung dari tabel individual
            cursor.execute('''
                SELECT COALESCE(SUM(total), 0) as total_penjualan
                FROM penjualan 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_penjualan, '%%Y-%%m') = %s
            ''', (proposal_id, bulan_tahun))
            total_penjualan = cursor.fetchone()['total_penjualan'] or 0
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_produksi
                FROM bahan_baku 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, bulan_tahun))
            total_biaya_produksi = cursor.fetchone()['total_biaya_produksi'] or 0
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_operasional
                FROM biaya_operasional 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, bulan_tahun))
            total_biaya_operasional = cursor.fetchone()['total_biaya_operasional'] or 0
            
            cursor.execute('''
                SELECT COALESCE(SUM(total_harga), 0) as total_biaya_non_operasional
                FROM biaya_non_operasional 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_transaksi, '%%Y-%%m') = %s
            ''', (proposal_id, bulan_tahun))
            total_biaya_non_operasional = cursor.fetchone()['total_biaya_non_operasional'] or 0
            
            cursor.execute('''
                SELECT 
                    COALESCE(SUM(harga), 0) as total_harga_alat,
                    COALESCE(SUM(harga_jual), 0) as total_harga_jual_alat
                FROM alat_produksi 
                WHERE proposal_id = %s 
                AND DATE_FORMAT(tanggal_beli, '%%Y-%%m') = %s
            ''', (proposal_id, bulan_tahun))
            alat_data = cursor.fetchone()
            total_harga_alat = alat_data['total_harga_alat'] or 0
            total_harga_jual_alat = alat_data['total_harga_jual_alat'] or 0
            
            # Hitung kas bersih
            kas_bersih_operasional = total_penjualan - total_biaya_produksi - total_biaya_operasional - total_biaya_non_operasional
            kas_bersih_investasi = total_harga_jual_alat - total_harga_alat
            kas_bersih_pembiayaan = 0  # Selalu 0 sesuai permintaan
            total_kas_bersih = kas_bersih_operasional + kas_bersih_investasi
        
        # Siapkan data untuk download
        arus_kas_data = {
            'total_penjualan': total_penjualan,
            'total_biaya_produksi': total_biaya_produksi,
            'total_biaya_operasional': total_biaya_operasional,
            'total_biaya_non_operasional': total_biaya_non_operasional,
            'kas_bersih_operasional': kas_bersih_operasional,
            'total_harga_jual_alat': total_harga_jual_alat,
            'total_harga_alat': total_harga_alat,
            'kas_bersih_investasi': kas_bersih_investasi,
            'kas_bersih_pembiayaan': 0,  # Selalu 0 sesuai permintaan
            'total_kas_bersih': total_kas_bersih
        }
        
        cursor.close()
        
        # Generate filename
        filename = f"Laporan_Arus_Kas_{mahasiswa_info['nama_ketua'].replace(' ', '_')}_{mahasiswa_info['judul_usaha'].replace(' ', '_')}_{bulan_tahun}"
        
        if format_type == 'excel':
            return app_funcs['generate_excel_arus_kas'](arus_kas_data, mahasiswa_info, bulan_tahun, selected_month_year, filename)
        elif format_type == 'pdf':
            return app_funcs['generate_pdf_arus_kas'](arus_kas_data, mahasiswa_info, bulan_tahun, selected_month_year, filename)
        elif format_type == 'word':
            return app_funcs['generate_word_arus_kas'](arus_kas_data, mahasiswa_info, bulan_tahun, selected_month_year, filename)
        else:
            return jsonify({'success': False, 'message': 'Format tidak didukung'})
            
    except Exception as e:
        logger.error('--- ERROR DOWNLOAD ARUS KAS PEMBIMBING ---')
        logger.error(traceback.format_exc())
        return jsonify({'success': False, 'message': f'Error: {str(e)}', 'trace': traceback.format_exc()})



@pembimbing_bp.route('/laporan_penjualan/<int:mahasiswa_id>')
def pembimbing_laporan_penjualan(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_penjualan.html', mahasiswa_info=None, penjualan_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_penjualan_produk'))
        
        # Ambil data penjualan
        cursor.execute('''
            SELECT * FROM penjualan 
            WHERE proposal_id = %s
            ORDER BY tanggal_penjualan DESC
        ''', (mahasiswa_info['proposal_id'],))
        
        penjualan_list = cursor.fetchall()
        for penjualan in penjualan_list:
            if penjualan['tanggal_penjualan']:
                try:
                    penjualan['tanggal_penjualan_indo'] = format_tanggal_indonesia(penjualan['tanggal_penjualan'])
                except Exception:
                    penjualan['tanggal_penjualan_indo'] = penjualan['tanggal_penjualan']
            else:
                penjualan['tanggal_penjualan_indo'] = '-'
        cursor.close()
        
        return render_template('pembimbing/laporan_penjualan.html', mahasiswa_info=mahasiswa_info, penjualan_list=penjualan_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_penjualan.html', mahasiswa_info=None, penjualan_list=[])

@pembimbing_bp.route('/bahan_baku/<int:mahasiswa_id>')
def pembimbing_bahan_baku(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/bahan_baku.html', mahasiswa_info=None, bahan_baku_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'monitoring',
                f'bahan_baku_mahasiswa_id_{mahasiswa_id}',
                f'Melihat detail bahan baku mahasiswa ID {mahasiswa_id}',
                None,
                None,
                mahasiswa_id
            )
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_produksi'))
        
        # Ambil data bahan baku
        cursor.execute('''
            SELECT * FROM bahan_baku 
            WHERE proposal_id = %s 
            ORDER BY tanggal_beli DESC
        ''', (mahasiswa_info['proposal_id'],))
        
        bahan_baku_list = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/bahan_baku.html', mahasiswa_info=mahasiswa_info, bahan_baku_list=bahan_baku_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/bahan_baku.html', mahasiswa_info=None, bahan_baku_list=[])

@pembimbing_bp.route('/produksi/<int:mahasiswa_id>')
def pembimbing_produksi(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/produksi.html', mahasiswa_info=None, produksi_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_produksi'))
        
        # Ambil data produksi
        cursor.execute('''
            SELECT * FROM produksi 
            WHERE proposal_id = %s 
            ORDER BY tanggal_produksi DESC
        ''', (mahasiswa_info['proposal_id'],))
        
        produksi_list = cursor.fetchall()
        
        # Tambahkan data bahan baku untuk setiap produksi
        for produksi in produksi_list:
            cursor.execute('''
                SELECT pbb.*, bb.nama_bahan, bb.satuan
                FROM produk_bahan_baku pbb
                JOIN bahan_baku bb ON pbb.bahan_baku_id = bb.id
                WHERE pbb.produksi_id = %s
            ''', (produksi['id'],))
            bahan_baku_list = cursor.fetchall()
            produksi['bahan_baku'] = bahan_baku_list
        
        cursor.close()
        
        return render_template('pembimbing/produksi.html', mahasiswa_info=mahasiswa_info, produksi_list=produksi_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/produksi.html', mahasiswa_info=None, produksi_list=[])


@pembimbing_bp.route('/update_anggaran', methods=['POST'])
def pembimbing_update_anggaran():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    try:
        # Handle both JSON and form data
        if request.is_json:
            data = request.get_json()
        else:
            data = request.form.to_dict()
        
        anggaran_id = data.get('id')
        tabel = data.get('tabel', 'anggaran_awal')
        if not anggaran_id:
            return jsonify({'success': False, 'message': 'ID anggaran tidak ditemukan!'})
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the anggaran belongs to a proposal supervised by this pembimbing
        cursor.execute(f'''
            SELECT aa.id 
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        ''', (anggaran_id, session['nama']))
        
        anggaran = cursor.fetchone()
        if not anggaran:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan atau tidak ada akses!'})
        
        # Ambil data lama untuk logging
        cursor.execute(f'''
            SELECT aa.*, p.judul_usaha
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s
        ''', (anggaran_id,))
        data_lama = cursor.fetchone()
        
        # Ambil dan validasi data dari request
        kegiatan_utama = data.get('kegiatan_utama', '').strip()
        kegiatan = data.get('kegiatan', '').strip()
        nama_barang = data.get('nama_barang', '').strip()
        penanggung_jawab = data.get('penanggung_jawab', '').strip()
        satuan = data.get('satuan', '').strip()
        target_capaian = data.get('target_capaian', '').strip()
        keterangan = data.get('keterangan', '').strip()
        
        # Validasi dan konversi tipe data numerik
        try:
            kuantitas = int(data.get('kuantitas', 0))
            if kuantitas < 0:
                return jsonify({'success': False, 'message': 'Kuantitas tidak boleh negatif!'})
        except (ValueError, TypeError):
            return jsonify({'success': False, 'message': 'Kuantitas harus berupa angka!'})
        
        try:
            harga_satuan = float(data.get('harga_satuan', 0))
            if harga_satuan < 0:
                return jsonify({'success': False, 'message': 'Harga satuan tidak boleh negatif!'})
        except (ValueError, TypeError):
            return jsonify({'success': False, 'message': 'Harga satuan harus berupa angka!'})
        
        try:
            jumlah = float(data.get('jumlah', 0))
            if jumlah < 0:
                return jsonify({'success': False, 'message': 'Jumlah tidak boleh negatif!'})
        except (ValueError, TypeError):
            return jsonify({'success': False, 'message': 'Jumlah harus berupa angka!'})
        
        # Validasi field yang required
        if not kegiatan:
            return jsonify({'success': False, 'message': 'Kegiatan harus diisi!'})
        if not penanggung_jawab:
            return jsonify({'success': False, 'message': 'Penanggung jawab harus diisi!'})
        if not target_capaian:
            return jsonify({'success': False, 'message': 'Target capaian harus diisi!'})
        if not nama_barang:
            return jsonify({'success': False, 'message': 'Nama barang harus diisi!'})
        if not satuan:
            return jsonify({'success': False, 'message': 'Satuan harus diisi!'})
        
        # Validasi satuan tidak boleh kosong
        if not satuan or satuan.strip() == '':
            return jsonify({'success': False, 'message': 'Satuan harus diisi!'})
        
        # Update data anggaran
        cursor.execute(f'''
            UPDATE {tabel} SET 
                kegiatan_utama = %s, kegiatan = %s, nama_barang = %s, penanggung_jawab = %s,
                satuan = %s, harga_satuan = %s, target_capaian = %s, keterangan = %s,
                kuantitas = %s, jumlah = %s
            WHERE id = %s
        ''', (
            kegiatan_utama, kegiatan, nama_barang, penanggung_jawab,
            satuan, harga_satuan, target_capaian, keterangan,
            kuantitas, jumlah, anggaran_id
        ))
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and data_lama:
            data_lama_log = {
                'kegiatan_utama': data_lama.get('kegiatan_utama'),
                'kegiatan': data_lama.get('kegiatan'),
                'nama_barang': data_lama.get('nama_barang'),
                'kuantitas': data_lama.get('kuantitas'),
                'harga_satuan': data_lama.get('harga_satuan'),
                'jumlah': data_lama.get('jumlah')
            }
            data_baru_log = {
                'kegiatan_utama': kegiatan_utama,
                'kegiatan': kegiatan,
                'nama_barang': nama_barang,
                'kuantitas': kuantitas,
                'harga_satuan': harga_satuan,
                'jumlah': jumlah
            }
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'edit',
                tabel,
                f'{tabel}_id_{anggaran_id}',
                f'Mengedit {tabel} ID {anggaran_id} untuk proposal "{data_lama["judul_usaha"]}"',
                data_lama_log,
                data_baru_log,
                None,  # mahasiswa_id tidak tersedia
                data_lama.get('id_proposal')
            )
        
        cursor.close()
        return jsonify({'success': True, 'message': 'Data anggaran berhasil diperbarui!'})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat memperbarui data: {str(e)}'})

@pembimbing_bp.route('/delete_anggaran', methods=['POST'])
def pembimbing_delete_anggaran():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    try:
        # Handle both JSON and form data
        if request.is_json:
            data = request.get_json()
        else:
            data = request.form.to_dict()
        
        anggaran_id = data.get('id')
        tabel = data.get('tabel', 'anggaran_awal')
        
        if not anggaran_id:
            return jsonify({'success': False, 'message': 'ID anggaran tidak ditemukan!'})
        
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the anggaran belongs to a proposal supervised by this pembimbing
        cursor.execute(f'''
            SELECT aa.*, p.id as proposal_id, p.judul_usaha, p.tahapan_usaha, p.nim
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        ''', (anggaran_id, session['nama']))
        
        anggaran = cursor.fetchone()
        if not anggaran:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan atau tidak ada akses!'})
        
        proposal_id = anggaran['proposal_id']
        tahapan_usaha = anggaran['tahapan_usaha']
        nim = anggaran['nim']
        
        # Tentukan tabel laporan berdasarkan tahapan usaha
        if 'bertumbuh' in tahapan_usaha.lower():
            tabel_laporan_kemajuan = 'laporan_kemajuan_bertumbuh'
            tabel_laporan_akhir = 'laporan_akhir_bertumbuh'
        else:
            tabel_laporan_kemajuan = 'laporan_kemajuan_awal'
            tabel_laporan_akhir = 'laporan_akhir_awal'
        
        # Hapus data laporan kemajuan terkait
        cursor.execute(f'DELETE FROM {tabel_laporan_kemajuan} WHERE id_proposal = %s', (proposal_id,))
        laporan_kemajuan_deleted = cursor.rowcount
        logger.info(f"✅ Berhasil menghapus {laporan_kemajuan_deleted} data laporan kemajuan untuk proposal {proposal_id}")
        
        # Hapus data laporan akhir terkait
        cursor.execute(f'DELETE FROM {tabel_laporan_akhir} WHERE id_proposal = %s', (proposal_id,))
        laporan_akhir_deleted = cursor.rowcount
        logger.info(f"✅ Berhasil menghapus {laporan_akhir_deleted} data laporan akhir untuk proposal {proposal_id}")
        
        # Hapus file laporan kemajuan
        app_funcs['hapus_file_laporan_kemajuan'](proposal_id, nim)
        
        # Hapus file laporan akhir
        app_funcs['hapus_file_laporan_akhir'](proposal_id, nim)
        
        # Hapus data anggaran
        cursor.execute(f'DELETE FROM {tabel} WHERE id = %s', (anggaran_id,))
        anggaran_deleted = cursor.rowcount
        
        # Cek apakah ada baris yang terhapus
        if anggaran_deleted == 0:
            cursor.close()
            return jsonify({'success': False, 'message': 'Gagal menghapus data anggaran!'})
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and anggaran:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'hapus',
                tabel,
                f'{tabel}_id_{anggaran_id}',
                f'Menghapus {tabel} ID {anggaran_id} "{anggaran["nama_barang"]}" untuk proposal "{anggaran["judul_usaha"]}" beserta laporan kemajuan dan akhir',
                {
                    'kegiatan': anggaran.get('kegiatan'),
                    'nama_barang': anggaran.get('nama_barang'),
                    'kuantitas': anggaran.get('kuantitas'),
                    'harga_satuan': anggaran.get('harga_satuan'),
                    'jumlah': anggaran.get('jumlah'),
                    'laporan_kemajuan_deleted': laporan_kemajuan_deleted,
                    'laporan_akhir_deleted': laporan_akhir_deleted
                },
                None,
                None,  # mahasiswa_id tidak tersedia
                proposal_id
            )
        
        cursor.close()
        
        message = f'Data anggaran berhasil dihapus!'
        if laporan_kemajuan_deleted > 0:
            message += f' {laporan_kemajuan_deleted} data laporan kemajuan juga dihapus.'
        if laporan_akhir_deleted > 0:
            message += f' {laporan_akhir_deleted} data laporan akhir juga dihapus.'
        if laporan_kemajuan_deleted > 0 or laporan_akhir_deleted > 0:
            message += ' File-file terkait juga dihapus.'
        
        return jsonify({'success': True, 'message': message})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat menghapus data: {str(e)}'})

@pembimbing_bp.route('/get_anggaran_by_id', methods=['GET'])
def pembimbing_get_anggaran_by_id():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        anggaran_id = request.args.get('id')
        tabel = request.args.get('tabel', 'anggaran_awal')
        
        if not anggaran_id:
            return jsonify({'success': False, 'message': 'ID anggaran tidak ditemukan!'})
        
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the anggaran belongs to a proposal supervised by this pembimbing
        cursor.execute(f'''
            SELECT aa.* 
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        ''', (anggaran_id, session['nama']))
        
        anggaran = cursor.fetchone()
        cursor.close()
        
        if not anggaran:
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan atau tidak ada akses!'})
        
        return jsonify({'success': True, 'data': anggaran})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat mengambil data: {str(e)}'})

@pembimbing_bp.route('/konfirmasi_anggaran', methods=['POST'])
def pembimbing_konfirmasi_anggaran():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        data = request.get_json()
        anggaran_id = data.get('id')
        status = data.get('status')  # 'disetujui', 'ditolak', 'revisi'
        jenis = data.get('jenis')  # 'anggaran_awal', 'anggaran_bertumbuh'
        
        if not anggaran_id or not status:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        # Tentukan tabel berdasarkan jenis
        if jenis == 'anggaran_bertumbuh':
            tabel = 'anggaran_bertumbuh'
        else:
            tabel = 'anggaran_awal'
        
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Verify the anggaran belongs to a proposal supervised by this pembimbing
        cursor.execute(f'''
            SELECT aa.id 
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        ''', (anggaran_id, session['nama']))
        
        anggaran = cursor.fetchone()
        if not anggaran:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan atau tidak ada akses!'})
        
        # Get proposal ID from anggaran first
        cursor.execute(f'''
            SELECT id_proposal FROM {tabel} WHERE id = %s
        ''', (anggaran_id,))
        
        anggaran = cursor.fetchone()
        if not anggaran:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan!'})
        
        proposal_id = anggaran['id_proposal']
        
        # Ambil data anggaran sebelum update untuk logging
        cursor.execute(f'''
            SELECT aa.*, p.judul_usaha 
            FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s
        ''', (anggaran_id,))
        anggaran_data = cursor.fetchone()
        
        # Update status anggaran
        cursor.execute(f'''
            UPDATE {tabel} 
            SET status = %s 
            WHERE id = %s
        ''', (status, anggaran_id))
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and anggaran_data:
            jenis_aktivitas = 'setuju' if status == 'disetujui' else 'tolak' if status == 'ditolak' else 'revisi'
            modul = 'anggaran_awal' if tabel == 'anggaran_awal' else 'anggaran_bertumbuh'
            deskripsi = f'Mengubah status {modul} ID {anggaran_id} menjadi {status} untuk proposal "{anggaran_data["judul_usaha"]}"'
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                jenis_aktivitas,
                modul,
                f'{modul}_id_{anggaran_id}',
                deskripsi,
                {'status': anggaran_data.get('status', 'pending')},
                {'status': status},
                None,  # mahasiswa_id tidak tersedia
                proposal_id
            )
        
        # Update laporan kemajuan setiap kali status berubah (tidak hanya disetujui)
        # Tentukan tabel laporan kemajuan berdasarkan tabel anggaran
        if tabel == 'anggaran_awal':
            tabel_laporan = 'laporan_kemajuan_awal'
        else:
            tabel_laporan = 'laporan_kemajuan_bertumbuh'
        
        # Update laporan kemajuan dengan data anggaran terbaru
        logger.debug(f"Debug: Calling update_laporan_kemajuan_from_anggaran for proposal {proposal_id}")
        app_funcs['update_laporan_kemajuan_from_anggaran'](cursor, proposal_id, tabel_laporan, tabel)
        
        # Check if all anggaran for this proposal are approved
        cursor.execute(f'''
            SELECT COUNT(*) as total, 
                   SUM(CASE WHEN status = 'disetujui' THEN 1 ELSE 0 END) as approved
            FROM {tabel} 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        result = cursor.fetchone()
        if result['total'] > 0 and result['total'] == result['approved']:
                # All anggaran approved, update proposal status
                cursor.execute('''
                    UPDATE proposal 
                    SET status = 'disetujui' 
                    WHERE id = %s AND dosen_pembimbing = %s
                ''', (proposal_id, session['nama']))
        
        app_funcs['mysql'].connection.commit()
        cursor.close()
        
        return jsonify({'success': True, 'message': f'Status anggaran berhasil diubah menjadi {status}!'})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/update_anggaran_status/<int:anggaran_id>', methods=['POST'])
def pembimbing_update_anggaran_status(anggaran_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    try:
        data = request.get_json()
        status = data.get('status')
        tabel = data.get('tabel', 'anggaran_awal')
        
        if status not in ['disetujui', 'ditolak', 'revisi']:
            return jsonify({'success': False, 'message': 'Status tidak valid!'})
        
        if tabel not in ['anggaran_awal', 'anggaran_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel anggaran tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Validasi bahwa anggaran milik mahasiswa yang dibimbing oleh pembimbing ini
        query = f"""
            SELECT aa.id FROM {tabel} aa
            JOIN proposal p ON aa.id_proposal = p.id
            WHERE aa.id = %s AND p.dosen_pembimbing = %s
        """
        cursor.execute(query, (anggaran_id, session['nama']))
        anggaran = cursor.fetchone()
        
        if not anggaran:
            return jsonify({'success': False, 'message': 'Anggaran tidak ditemukan atau tidak memiliki akses!'})
        
        # Ambil proposal_id dari anggaran
        cursor.execute(f"SELECT id_proposal FROM {tabel} WHERE id = %s", (anggaran_id,))
        anggaran_data = cursor.fetchone()
        if not anggaran_data:
            return jsonify({'success': False, 'message': 'Data anggaran tidak ditemukan!'})
        
        proposal_id = anggaran_data['id_proposal']
        
        # Update status anggaran
        update_query = f"UPDATE {tabel} SET status = %s WHERE id = %s"
        cursor.execute(update_query, (status, anggaran_id))
        
        # Update laporan kemajuan setiap kali status berubah (tidak hanya disetujui)
        # Tentukan tabel laporan kemajuan berdasarkan tabel anggaran
        if tabel == 'anggaran_awal':
            tabel_laporan = 'laporan_kemajuan_awal'
        else:
            tabel_laporan = 'laporan_kemajuan_bertumbuh'
        
        # Update laporan kemajuan dengan data anggaran terbaru
        logger.debug(f"Debug: Calling update_laporan_kemajuan_from_anggaran for proposal {proposal_id}")
        app_funcs['update_laporan_kemajuan_from_anggaran'](cursor, proposal_id, tabel_laporan, tabel)
        
        app_funcs['mysql'].connection.commit()
        
        return jsonify({'success': True, 'message': f'Status anggaran berhasil diupdate menjadi {status}!'})
        
    except Exception as e:
        logger.error(f"Error updating anggaran status: {e}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengupdate status anggaran!'})
    finally:
        if 'cursor' in locals():
            cursor.close()

@pembimbing_bp.route('/pembimbing_laporan_kemajuan')
def pembimbing_laporan_kemajuan():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'laporan_kemajuan',
            'daftar_laporan_kemajuan',
            'Melihat halaman daftar laporan kemajuan mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan kemajuan.html', mahasiswa_list=[])
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini beserta proposal dan tahapan_usaha
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, m.program_studi, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        mahasiswa_all = cursor.fetchall()
        print(f"DEBUG LAPORAN KEMAJUAN: Total mahasiswa yang dibimbing: {len(mahasiswa_all)}")
        mahasiswa_list = []
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            tahapan = (mhs.get('tahapan_usaha') or '').lower()
            
            if 'bertumbuh' in tahapan:
                tabel_laporan = 'laporan_kemajuan_bertumbuh'
                tabel_anggaran = 'anggaran_bertumbuh'
            else:
                tabel_laporan = 'laporan_kemajuan_awal'
                tabel_anggaran = 'anggaran_awal'
            
            # TRIGGER: Cek apakah sudah ada data laporan kemajuan untuk proposal ini
            cursor.execute(f"SELECT COUNT(*) as cnt FROM {tabel_laporan} WHERE id_proposal = %s", (proposal_id,))
            cnt = cursor.fetchone()['cnt']
            
            # Jika belum ada data laporan kemajuan, buat dari anggaran yang sudah direview
            if cnt == 0:
                print(f"DEBUG: Membuat laporan kemajuan untuk proposal {proposal_id}")
                print(f"DEBUG: Menggunakan tabel anggaran: {tabel_anggaran}")
                
                # Tambahkan kolom nilai_bantuan jika belum ada
                try:
                    cursor.execute(f'ALTER TABLE {tabel_laporan} ADD COLUMN nilai_bantuan DECIMAL(15,2) DEFAULT 0.00')
                    app_funcs['mysql'].connection.commit()
                    print(f"DEBUG: Berhasil menambahkan kolom nilai_bantuan ke tabel {tabel_laporan}")
                except Exception as e:
                    if "Duplicate column name" in str(e):
                        print(f"DEBUG: Kolom nilai_bantuan sudah ada di tabel {tabel_laporan}")
                    else:
                        print(f"DEBUG: Error menambahkan kolom nilai_bantuan: {str(e)}")
                
                # Cek apakah ada data anggaran dengan status_reviewer sudah_direview
                cursor.execute(f'''
                    SELECT COUNT(*) as cnt_anggaran 
                    FROM {tabel_anggaran} 
                    WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
                ''', (proposal_id,))
                cnt_anggaran = cursor.fetchone()['cnt_anggaran']
                print(f"DEBUG: Ditemukan {cnt_anggaran} data anggaran dengan status_reviewer 'sudah_direview'")
                
                if cnt_anggaran > 0:
                    try:
                        cursor.execute(f'''
                            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                                   nama_barang, satuan, status, status_reviewer, nilai_bantuan
                            FROM {tabel_anggaran} 
                            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
                            ORDER BY kegiatan_utama, kegiatan, nama_barang
                        ''', (proposal_id,))
                        anggaran_data = cursor.fetchall()
                        print(f"DEBUG: Berhasil mengambil {len(anggaran_data)} data anggaran")
                        
                        if anggaran_data:
                            print(f"DEBUG: Sample data - kegiatan_utama: {anggaran_data[0].get('kegiatan_utama', 'N/A')}")
                            print(f"DEBUG: Sample data - nama_barang: {anggaran_data[0].get('nama_barang', 'N/A')}")
                            
                            for anggaran in anggaran_data:
                                try:
                                    cursor.execute(f'''
                                        INSERT INTO {tabel_laporan} (
                                            id_proposal, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian,
                                            nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status, nilai_bantuan
                                        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                    ''', (
                                        proposal_id, anggaran['kegiatan_utama'], anggaran['kegiatan'], 
                                        anggaran['penanggung_jawab'], anggaran['target_capaian'], anggaran['nama_barang'],
                                        0, anggaran['satuan'], 0, 0, '', 'draf', anggaran.get('nilai_bantuan', 0)
                                    ))
                                    print(f"DEBUG: Berhasil INSERT data untuk kegiatan: {anggaran.get('kegiatan_utama', 'N/A')}")
                                except Exception as insert_error:
                                    print(f"DEBUG: Error saat INSERT: {str(insert_error)}")
                                    print(f"DEBUG: Data yang gagal INSERT: {anggaran}")
                                    raise insert_error
                            
                            app_funcs['mysql'].connection.commit()
                            print(f"DEBUG: Berhasil membuat {len(anggaran_data)} data laporan kemajuan untuk proposal {proposal_id}")
                        else:
                            print(f"DEBUG: Tidak ada data anggaran yang sudah direview untuk proposal {proposal_id}")
                    except Exception as e:
                        print(f"DEBUG: Error dalam proses pembuatan laporan kemajuan: {str(e)}")
                        app_funcs['mysql'].connection.rollback()
                else:
                    print(f"DEBUG: Tidak ada anggaran dengan status_reviewer 'sudah_direview' untuk proposal {proposal_id}")
            else:
                print(f"DEBUG: Data laporan kemajuan sudah ada untuk proposal {proposal_id}")
            
            # Cek ulang apakah sekarang ada data laporan kemajuan
            cursor.execute(f"SELECT COUNT(*) as cnt FROM {tabel_laporan} WHERE id_proposal = %s", (proposal_id,))
            cnt = cursor.fetchone()['cnt']
            if cnt > 0:
                mahasiswa_list.append(mhs)
        cursor.close()
        return render_template('pembimbing/laporan kemajuan.html', mahasiswa_list=mahasiswa_list)
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan kemajuan.html', mahasiswa_list=[])

@pembimbing_bp.route('/konfirmasi_laporan_kemajuan', methods=['POST'])
def pembimbing_konfirmasi_laporan_kemajuan():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        data = request.get_json()
        laporan_id = data.get('id')
        tabel_laporan = data.get('tabel_laporan')
        action = data.get('action')  # 'setuju', 'tolak', 'revisi'
        
        if not laporan_id or not tabel_laporan or not action:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        if tabel_laporan not in ['laporan_kemajuan_awal', 'laporan_kemajuan_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel laporan tidak valid!'})
        
        if action not in ['setuju', 'tolak', 'revisi']:
            return jsonify({'success': False, 'message': 'Aksi tidak valid!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Cek apakah laporan kemajuan milik mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute(f'''
            SELECT lk.*, p.dosen_pembimbing 
            FROM {tabel_laporan} lk
            JOIN proposal p ON lk.id_proposal = p.id
            WHERE lk.id = %s AND p.dosen_pembimbing = %s
        ''', (laporan_id, session['nama']))
        
        laporan = cursor.fetchone()
        if not laporan:
            cursor.close()
            return jsonify({'success': False, 'message': 'Laporan kemajuan tidak ditemukan atau Anda tidak memiliki akses!'})
        
        # Update status laporan kemajuan
        if action == 'setuju':
            new_status = 'disetujui'
        elif action == 'tolak':
            new_status = 'ditolak'
        elif action == 'revisi':
            new_status = 'revisi'
        
        # Ambil data lengkap untuk logging
        cursor.execute(f'''
            SELECT lk.*, p.judul_usaha, p.nim
            FROM {tabel_laporan} lk
            JOIN proposal p ON lk.id_proposal = p.id
            WHERE lk.id = %s
        ''', (laporan_id,))
        laporan_data = cursor.fetchone()
        
        cursor.execute(f'''
            UPDATE {tabel_laporan} 
            SET status = %s, tanggal_review = NOW()
            WHERE id = %s
        ''', (new_status, laporan_id))
        
        # Jika status diubah menjadi 'ditolak' atau 'revisi', hapus laporan akhir yang bersangkutan
        laporan_akhir_deleted = 0
        if action in ['tolak', 'revisi']:
            proposal_id = laporan['id_proposal']
            
            # Tentukan tabel laporan akhir berdasarkan tabel laporan kemajuan
            if tabel_laporan == 'laporan_kemajuan_awal':
                tabel_laporan_akhir = 'laporan_akhir_awal'
            else:
                tabel_laporan_akhir = 'laporan_akhir_bertumbuh'
            
            # Hapus data laporan akhir yang bersangkutan
            cursor.execute(f'''
                DELETE FROM {tabel_laporan_akhir} 
                WHERE id_proposal = %s AND kegiatan_utama = %s AND kegiatan = %s AND nama_barang = %s
            ''', (proposal_id, laporan['kegiatan_utama'], laporan['kegiatan'], laporan['nama_barang']))
            
            laporan_akhir_deleted = cursor.rowcount
            logger.debug(f"DEBUG: Menghapus {laporan_akhir_deleted} data laporan akhir yang bersangkutan")
            
            # Hapus file laporan akhir yang terkait (jika ada)
            if laporan_akhir_deleted > 0:
                try:
                    # Ambil data mahasiswa untuk path file
                    cursor.execute('SELECT nim FROM proposal WHERE id = %s', (proposal_id,))
                    proposal_data = cursor.fetchone()
                    if proposal_data:
                        app_funcs['hapus_file_laporan_akhir_terkait'](proposal_id, proposal_data['nim'], laporan['kegiatan_utama'], laporan['kegiatan'], laporan['nama_barang'])
                except Exception as e:
                    logger.error(f"DEBUG: Error saat menghapus file laporan akhir: {e}")
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and laporan_data:
            jenis_aktivitas = 'setuju' if action == 'setuju' else 'tolak' if action == 'tolak' else 'revisi'
            modul = 'laporan_kemajuan_awal' if 'awal' in tabel_laporan else 'laporan_kemajuan_bertumbuh'
            deskripsi = f'Mengubah status {modul} ID {laporan_id} menjadi {new_status} untuk proposal "{laporan_data["judul_usaha"]}"'
            
            # Ambil mahasiswa_id berdasarkan nim
            mahasiswa_id = None
            if laporan_data.get('nim'):
                cursor.execute('SELECT id FROM mahasiswa WHERE nim = %s', (laporan_data['nim'],))
                mahasiswa_result = cursor.fetchone()
                if mahasiswa_result:
                    mahasiswa_id = mahasiswa_result['id']
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                jenis_aktivitas,
                modul,
                f'{modul}_id_{laporan_id}',
                deskripsi,
                {'status': laporan_data.get('status', 'pending')},
                {'status': new_status},
                mahasiswa_id,
                laporan_data.get('id_proposal')
            )
        
        cursor.close()
        
        if action == 'setuju':
            action_text = 'disetujui'
            message = f'Laporan kemajuan berhasil {action_text}!'
        elif action == 'tolak':
            action_text = 'ditolak'
            message = f'Laporan kemajuan berhasil {action_text}!'
            if laporan_akhir_deleted > 0:
                message += f' {laporan_akhir_deleted} data laporan akhir yang bersangkutan juga dihapus beserta file-file terkait.'
        elif action == 'revisi':
            action_text = 'diminta revisi'
            message = f'Laporan kemajuan berhasil {action_text}!'
            if laporan_akhir_deleted > 0:
                message += f' {laporan_akhir_deleted} data laporan akhir yang bersangkutan juga dihapus beserta file-file terkait.'
        
        return jsonify({'success': True, 'message': message})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/laporan_kemajuan_awal_bertumbuh/<int:mahasiswa_id>')
def pembimbing_laporan_kemajuan_awal_bertumbuh(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_kemajuan_awal_bertumbuh.html', anggaran_data=[], mahasiswa_info=None, proposal_id=None, total_nilai_bantuan=0)
        
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.tahapan_usaha, p.status as status_proposal, p.id as proposal_id
            FROM mahasiswa m 
            LEFT JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_laporan_kemajuan'))
        
        # Tentukan jenis anggaran berdasarkan tahapan usaha
        tahapan_usaha = mahasiswa_info.get('tahapan_usaha', '').lower()
        if 'bertumbuh' in tahapan_usaha:
            tabel_laporan = 'laporan_kemajuan_bertumbuh'
        else:
            tabel_laporan = 'laporan_kemajuan_awal'
        
        proposal_id = mahasiswa_info.get('proposal_id')
        
        if not proposal_id:
            flash('Proposal tidak ditemukan!', 'danger')
            cursor.close()
            return render_template('pembimbing/laporan_kemajuan_awal_bertumbuh.html', 
                                 anggaran_data=[], mahasiswa_info=mahasiswa_info, proposal_id=None, total_nilai_bantuan=0)
        
        # Tentukan tabel anggaran berdasarkan tahapan usaha
        if 'bertumbuh' in tahapan_usaha:
            tabel_anggaran = 'anggaran_bertumbuh'
        else:
            tabel_anggaran = 'anggaran_awal'
        
        # Buat tabel laporan kemajuan jika belum ada
        if tabel_laporan == 'laporan_kemajuan_awal':
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS laporan_kemajuan_awal (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    id_proposal INT NOT NULL,
                    kegiatan_utama VARCHAR(255),
                    kegiatan VARCHAR(255) NOT NULL,
                    penanggung_jawab VARCHAR(100) NOT NULL,
                    target_capaian TEXT NOT NULL,
                    nama_barang VARCHAR(255) NOT NULL,
                    kuantitas INT NOT NULL,
                    satuan VARCHAR(50) NOT NULL,
                    harga_satuan DECIMAL(15,2) NOT NULL,
                    jumlah DECIMAL(15,2) NOT NULL,
                    keterangan TEXT,
                    nilai_bantuan DECIMAL(15,2) DEFAULT 0.00,
                    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    status ENUM('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
                    tanggal_review TIMESTAMP NULL,
                    FOREIGN KEY (id_proposal) REFERENCES proposal(id) ON DELETE CASCADE
                )
            ''')
        else:
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS laporan_kemajuan_bertumbuh (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    id_proposal INT NOT NULL,
                    kegiatan_utama VARCHAR(255) NOT NULL,
                    kegiatan VARCHAR(255) NOT NULL,
                    penanggung_jawab VARCHAR(100) NOT NULL,
                    target_capaian TEXT NOT NULL,
                    nama_barang VARCHAR(255) NOT NULL,
                    kuantitas INT NOT NULL,
                    satuan VARCHAR(50) NOT NULL,
                    harga_satuan DECIMAL(15,2) NOT NULL,
                    jumlah DECIMAL(15,2) NOT NULL,
                    keterangan TEXT,
                    nilai_bantuan DECIMAL(15,2) DEFAULT 0.00,
                    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    status ENUM('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
                    tanggal_review TIMESTAMP NULL,
                    FOREIGN KEY (id_proposal) REFERENCES proposal(id) ON DELETE CASCADE
                )
            ''')
        
        # Cek apakah sudah ada data laporan kemajuan untuk proposal ini
        cursor.execute(f'''
            SELECT COUNT(*) as count FROM {tabel_laporan} WHERE id_proposal = %s
        ''', (proposal_id,))
        existing_count = cursor.fetchone()['count']
        
        # Jika belum ada data laporan kemajuan, salin data dari anggaran yang disetujui
        if existing_count == 0:
            cursor.execute(f'''
                SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                       nama_barang, satuan, status, nilai_bantuan
                FROM {tabel_anggaran} 
                WHERE id_proposal = %s AND status = 'disetujui'
                ORDER BY kegiatan_utama, kegiatan, nama_barang
            ''', (proposal_id,))
            
            anggaran_data = cursor.fetchall()
            
            if anggaran_data:
                for anggaran in anggaran_data:
                    cursor.execute(f'''
                        INSERT INTO {tabel_laporan} (
                            id_proposal, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian,
                            nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status, nilai_bantuan
                        ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    ''', (
                        proposal_id, anggaran['kegiatan_utama'], anggaran['kegiatan'], 
                        anggaran['penanggung_jawab'], anggaran['target_capaian'], anggaran['nama_barang'],
                        0, anggaran['satuan'], 0, 
                        0, '', 'draf', anggaran.get('nilai_bantuan', 0)
                    ))
                
                app_funcs['mysql'].connection.commit()
        
        # Ambil data laporan kemajuan
        cursor.execute(f'''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status, nilai_bantuan
            FROM {tabel_laporan} 
            WHERE id_proposal = %s
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        laporan_data = cursor.fetchall()
        cursor.close()
        
        # Urutkan data sesuai urutan kegiatan utama
        if 'bertumbuh' in tahapan_usaha:
            urutan_kegiatan = [
                "Pengembangan Pasar dan Saluran Distribusi",
                "Pengembangan Produk/Riset",
                "Produksi",
                "Legalitas, perizinan, sertifikasi, dan standarisasi",
                "Belanja ATK dan Penunjang"
            ]
        else:
            urutan_kegiatan = [
                "Pengembangan Produk/Riset",
                "Produksi",
                "Legalitas, perizinan, sertifikasi, dan standarisasi",
                "Belanja ATK dan Penunjang"
            ]
        
        laporan_data = sorted(
            laporan_data,
            key=lambda x: urutan_kegiatan.index(x['kegiatan_utama']) if x['kegiatan_utama'] in urutan_kegiatan else 99
        )
        
        grouped_data = group_anggaran_data(laporan_data)
        laporan_data_flat = flatten_anggaran_data(laporan_data)
        
        # Hitung total nilai bantuan dari anggaran yang sudah direview
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(f'''
            SELECT SUM(nilai_bantuan) as total_nilai_bantuan
            FROM {tabel_anggaran} 
            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
        ''', (proposal_id,))
        
        nilai_bantuan_result = cursor.fetchone()
        total_nilai_bantuan = nilai_bantuan_result['total_nilai_bantuan'] or 0
        cursor.close()
        
        # Debug: Print jumlah data yang ditemukan
        logger.debug(f"Debug: Found {len(laporan_data)} laporan kemajuan records for proposal {proposal_id}")
        
        # Ambil data file laporan kemajuan
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('''
            SELECT * FROM file_laporan_kemajuan 
            WHERE id_proposal = %s 
            ORDER BY tanggal_upload DESC 
            LIMIT 1
        ''', (proposal_id,))
        file_laporan = cursor.fetchone()
        cursor.close()
        
        if laporan_data:
            logger.debug(f"Debug: Sample data - Status: {laporan_data[0].get('status', 'N/A')}")
            logger.debug(f"Debug: Sample data - Kegiatan: {laporan_data[0].get('kegiatan_utama', 'N/A')}")
        
        return render_template('pembimbing/laporan_kemajuan_awal_bertumbuh.html', 
                             anggaran_data=laporan_data, 
                             grouped_data=grouped_data,
                             anggaran_data_flat=laporan_data_flat,
                             mahasiswa_info=mahasiswa_info,
                             tabel_laporan=tabel_laporan,
                             proposal_id=proposal_id,
                             total_nilai_bantuan=total_nilai_bantuan,
                             file_laporan=file_laporan)
        
    except Exception as e:
        flash(f'Error saat mengambil data laporan kemajuan: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_kemajuan_awal_bertumbuh.html', 
                             anggaran_data=[], 
                             grouped_data=[],
                             anggaran_data_flat=[],
                             mahasiswa_info=None,
                             tabel_laporan='',
                             proposal_id=None,
                             total_nilai_bantuan=0,
                             file_laporan=None)


@pembimbing_bp.route('/pembimbing_laporan_akhir')
def pembimbing_laporan_akhir():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    if 'nama' not in session:
        flash('Data pembimbing tidak lengkap! Silakan login ulang.', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    
    # Log aktivitas pembimbing
    pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
    if pembimbing_info:
        app_funcs['log_pembimbing_activity'](
            pembimbing_info['id'],
            pembimbing_info['nip'],
            pembimbing_info['nama'],
            'view',
            'laporan_akhir',
            'daftar_laporan_akhir',
            'Melihat halaman daftar laporan akhir mahasiswa'
        )
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_akhir.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini beserta proposal dan tahapan_usaha
        cursor.execute('''
            SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, m.program_studi, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            INNER JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s AND p.status IN ('disetujui', 'selesai')
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        print(f"DEBUG LAPORAN AKHIR: Total mahasiswa yang dibimbing: {len(mahasiswa_all)}")
        print(f"DEBUG LAPORAN AKHIR: Session nama: {session.get('nama', 'N/A')}")
        print(f"DEBUG LAPORAN AKHIR: Session user_type: {session.get('user_type', 'N/A')}")
        
        if not mahasiswa_all:
            print("DEBUG LAPORAN AKHIR: Tidak ada mahasiswa yang dibimbing atau tidak ada proposal yang sesuai")
            
            # Coba query alternatif untuk debugging
            cursor.execute('''
                SELECT m.id, m.nama_ketua, m.nim, p.judul_usaha, m.program_studi, p.id as proposal_id, p.tahapan_usaha, p.status as proposal_status
                FROM mahasiswa m
                LEFT JOIN proposal p ON m.nim = p.nim
                WHERE p.dosen_pembimbing = %s
                ORDER BY m.nama_ketua
            ''', (session['nama'],))
            
            all_proposals = cursor.fetchall()
            print(f"DEBUG LAPORAN AKHIR: Total proposal dengan dosen_pembimbing = {session['nama']}: {len(all_proposals)}")
            for prop in all_proposals:
                print(f"DEBUG LAPORAN AKHIR: Proposal {prop['proposal_id']}: {prop['judul_usaha']} - Status: {prop.get('proposal_status', 'N/A')}")
            
            cursor.close()
            return render_template('pembimbing/laporan_akhir.html', mahasiswa_list=[])
        
        mahasiswa_list = []
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            tahapan = (mhs.get('tahapan_usaha') or '').lower()
            
            print(f"DEBUG LAPORAN AKHIR: Processing mahasiswa {mhs['nama_ketua']} (NIM: {mhs['nim']})")
            print(f"DEBUG LAPORAN AKHIR: Proposal ID: {proposal_id}, Tahapan: {tahapan}")
            
            if 'bertumbuh' in tahapan:
                tabel_laporan_akhir = 'laporan_akhir_bertumbuh'
                tabel_laporan_kemajuan = 'laporan_kemajuan_bertumbuh'
            else:
                tabel_laporan_akhir = 'laporan_akhir_awal'
                tabel_laporan_kemajuan = 'laporan_kemajuan_awal'
            
            # TRIGGER: Cek apakah sudah ada data laporan akhir untuk proposal ini
            cursor.execute(f"SELECT COUNT(*) as cnt FROM {tabel_laporan_akhir} WHERE id_proposal = %s", (proposal_id,))
            cnt = cursor.fetchone()['cnt']
            
            # Jika sudah ada data laporan akhir, tambahkan ke list
            if cnt > 0:
                print(f"DEBUG: Data laporan akhir sudah ada untuk proposal {proposal_id}")
                mahasiswa_list.append(mhs)
                continue
            
            # Jika belum ada data laporan akhir, buat dari laporan kemajuan yang disetujui
                print(f"DEBUG: Membuat laporan akhir untuk proposal {proposal_id}")
                print(f"DEBUG: Menggunakan tabel laporan kemajuan: {tabel_laporan_kemajuan}")
                
                # Tambahkan kolom nilai_bantuan jika belum ada
                try:
                    cursor.execute(f'ALTER TABLE {tabel_laporan_akhir} ADD COLUMN nilai_bantuan DECIMAL(15,2) DEFAULT 0.00')
                    app_funcs['mysql'].connection.commit()
                    print(f"DEBUG: Berhasil menambahkan kolom nilai_bantuan ke tabel {tabel_laporan_akhir}")
                except Exception as e:
                    if "Duplicate column name" in str(e):
                        print(f"DEBUG: Kolom nilai_bantuan sudah ada di tabel {tabel_laporan_akhir}")
                    else:
                        print(f"DEBUG: Error menambahkan kolom nilai_bantuan: {str(e)}")
                
                # Tambahkan kolom rekomendasi_pendanaan jika belum ada
                try:
                    cursor.execute('ALTER TABLE penilaian_laporan_kemajuan ADD COLUMN rekomendasi_pendanaan VARCHAR(50) DEFAULT NULL')
                    app_funcs['mysql'].connection.commit()
                    print("DEBUG: Berhasil menambahkan kolom rekomendasi_pendanaan ke tabel penilaian_laporan_kemajuan")
                except Exception as e:
                    if "Duplicate column name" in str(e):
                        print("DEBUG: Kolom rekomendasi_pendanaan sudah ada di tabel penilaian_laporan_kemajuan")
                    else:
                        print(f"DEBUG: Error menambahkan kolom rekomendasi_pendanaan: {str(e)}")
                
                # Cek status rekomendasi pendanaan dari penilaian laporan kemajuan
                cursor.execute('''
                    SELECT rekomendasi_pendanaan 
                    FROM penilaian_laporan_kemajuan 
                    WHERE id_proposal = %s AND rekomendasi_pendanaan IS NOT NULL
                    ORDER BY id DESC 
                    LIMIT 1
                ''', (proposal_id,))
                
                penilaian_result = cursor.fetchone()
                rekomendasi_pendanaan = penilaian_result['rekomendasi_pendanaan'] if penilaian_result else None
                
                print(f"DEBUG: Rekomendasi pendanaan untuk proposal {proposal_id}: {rekomendasi_pendanaan}")
                
                # Jika rekomendasi adalah 'berhenti pendanaan', tidak buat laporan akhir
                if rekomendasi_pendanaan == 'berhenti pendanaan':
                    print(f"DEBUG: Rekomendasi pendanaan 'berhenti pendanaan' untuk proposal {proposal_id}. Laporan akhir tidak dibuat.")
                    continue
                
                # Jika rekomendasi adalah 'lanjutkan pendanaan' atau belum ada penilaian, cek laporan kemajuan yang disetujui
                if rekomendasi_pendanaan == 'lanjutkan pendanaan' or rekomendasi_pendanaan is None:
                    cursor.execute(f'''
                        SELECT COUNT(*) as cnt_kemajuan 
                        FROM {tabel_laporan_kemajuan} 
                        WHERE id_proposal = %s AND status = 'disetujui'
                    ''', (proposal_id,))
                    cnt_kemajuan = cursor.fetchone()['cnt_kemajuan']
                    print(f"DEBUG: Ditemukan {cnt_kemajuan} data laporan kemajuan dengan status 'disetujui'")
                    
                    if cnt_kemajuan > 0:
                        print(f"DEBUG: Menyalin data dari laporan kemajuan ke laporan akhir dengan reset field tertentu")
                        try:
                            cursor.execute(f'''
                                SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                                       nama_barang, satuan, status, nilai_bantuan
                                FROM {tabel_laporan_kemajuan} 
                                WHERE id_proposal = %s AND status = 'disetujui'
                                ORDER BY kegiatan_utama, kegiatan, nama_barang
                            ''', (proposal_id,))
                            kemajuan_data = cursor.fetchall()
                            print(f"DEBUG: Berhasil mengambil {len(kemajuan_data)} data laporan kemajuan")
                            
                            if kemajuan_data:
                                print(f"DEBUG: Sample data - kegiatan_utama: {kemajuan_data[0].get('kegiatan_utama', 'N/A')}")
                                print(f"DEBUG: Sample data - nama_barang: {kemajuan_data[0].get('nama_barang', 'N/A')}")
                                
                                for kemajuan in kemajuan_data:
                                    try:
                                        cursor.execute(f'''
                                            INSERT INTO {tabel_laporan_akhir} (
                                                id_proposal, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian,
                                                nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status, nilai_bantuan
                                            ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                        ''', (
                                            proposal_id, kemajuan['kegiatan_utama'], kemajuan['kegiatan'], 
                                            kemajuan['penanggung_jawab'], kemajuan['target_capaian'], kemajuan['nama_barang'],
                                            0, kemajuan['satuan'], 0, 0, '', 'draf', kemajuan.get('nilai_bantuan', 0)
                                        ))
                                        print(f"DEBUG: Berhasil INSERT data untuk kegiatan: {kemajuan.get('kegiatan_utama', 'N/A')}")
                                    except Exception as insert_error:
                                        print(f"DEBUG: Error saat INSERT: {str(insert_error)}")
                                        print(f"DEBUG: Data yang gagal INSERT: {kemajuan}")
                                        raise insert_error
                                
                                app_funcs['mysql'].connection.commit()
                                print(f"DEBUG: Berhasil membuat {len(kemajuan_data)} data laporan akhir untuk proposal {proposal_id}")
                                print(f"DEBUG: Field yang disalin: kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, nama_barang, satuan, nilai_bantuan")
                                print(f"DEBUG: Field yang di-reset: kuantitas=0, harga_satuan=0, jumlah=0, keterangan=''")
                                
                                # Tambahkan mahasiswa ke list setelah berhasil membuat laporan akhir
                                mahasiswa_list.append(mhs)
                            else:
                                print(f"DEBUG: Tidak ada data laporan kemajuan yang disetujui untuk proposal {proposal_id}")
                        except Exception as e:
                            print(f"DEBUG: Error dalam proses pembuatan laporan akhir: {str(e)}")
                            app_funcs['mysql'].connection.rollback()
                else:
                    print(f"DEBUG: Tidak ada laporan kemajuan dengan status 'disetujui' untuk proposal {proposal_id}")
            else:
                print(f"DEBUG: Rekomendasi pendanaan bukan 'lanjutkan', tidak membuat laporan akhir")
        
        # Tambahkan mahasiswa ke list jika belum ada (untuk memastikan semua mahasiswa yang dibimbing ditampilkan)
        if mhs not in mahasiswa_list:
            print(f"DEBUG: Menambahkan mahasiswa {mhs['nama_ketua']} ke list meskipun belum ada laporan akhir")
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        print(f"DEBUG LAPORAN AKHIR: Final mahasiswa_list length: {len(mahasiswa_list)}")
        print(f"DEBUG LAPORAN AKHIR: Mahasiswa yang akan ditampilkan: {[m['nama_ketua'] for m in mahasiswa_list]}")
        
        return render_template('pembimbing/laporan_akhir.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_akhir.html', mahasiswa_list=[])

@pembimbing_bp.route('/laporan_akhir_awal_bertumbuh/<int:mahasiswa_id>')
def pembimbing_laporan_akhir_awal_bertumbuh(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_akhir_awal_bertumbuh.html', anggaran_data=[], mahasiswa_info=None, proposal_id=None, total_anggaran_disetujui=0, total_nilai_bantuan=0, total_laporan_kemajuan_disetujui=0)
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa dan proposal
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.tahapan_usaha, p.status as status_proposal, p.id as proposal_id
            FROM mahasiswa m 
            LEFT JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_laporan_akhir'))
        
        # Tentukan jenis laporan berdasarkan tahapan usaha
        tahapan_usaha = mahasiswa_info.get('tahapan_usaha', '').lower()
        if 'bertumbuh' in tahapan_usaha:
            tabel_laporan_akhir = 'laporan_akhir_bertumbuh'
        else:
            tabel_laporan_akhir = 'laporan_akhir_awal'
        
        proposal_id = mahasiswa_info.get('proposal_id')
        
        if not proposal_id:
            flash('Proposal tidak ditemukan!', 'danger')
            cursor.close()
            return render_template('pembimbing/laporan_akhir_awal_bertumbuh.html', 
                                 anggaran_data=[], mahasiswa_info=mahasiswa_info, proposal_id=None, total_anggaran_disetujui=0, total_nilai_bantuan=0, total_laporan_kemajuan_disetujui=0)
        
        
        
        # Tentukan tabel laporan kemajuan
        if 'bertumbuh' in tahapan_usaha:
            tabel_laporan_kemajuan = 'laporan_kemajuan_bertumbuh'
        else:
            tabel_laporan_kemajuan = 'laporan_kemajuan_awal'
        
        # Buat tabel laporan akhir jika belum ada
        if tabel_laporan_akhir == 'laporan_akhir_awal':
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS laporan_akhir_awal (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    id_proposal INT NOT NULL,
                    kegiatan_utama VARCHAR(255),
                    kegiatan VARCHAR(255) NOT NULL,
                    penanggung_jawab VARCHAR(100) NOT NULL,
                    target_capaian TEXT NOT NULL,
                    nama_barang VARCHAR(255) NOT NULL,
                    kuantitas INT NOT NULL,
                    satuan VARCHAR(50) NOT NULL,
                    harga_satuan DECIMAL(15,2) NOT NULL,
                    jumlah DECIMAL(15,2) NOT NULL,
                    keterangan TEXT,
                    nilai_bantuan DECIMAL(15,2) DEFAULT 0.00,
                    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    status ENUM('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
                    tanggal_review TIMESTAMP NULL,
                    FOREIGN KEY (id_proposal) REFERENCES proposal(id) ON DELETE CASCADE
                )
            ''')
        else:
            cursor.execute('''
                CREATE TABLE IF NOT EXISTS laporan_akhir_bertumbuh (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    id_proposal INT NOT NULL,
                    kegiatan_utama VARCHAR(255) NOT NULL,
                    kegiatan VARCHAR(255) NOT NULL,
                    penanggung_jawab VARCHAR(100) NOT NULL,
                    target_capaian TEXT NOT NULL,
                    nama_barang VARCHAR(255) NOT NULL,
                    kuantitas INT NOT NULL,
                    satuan VARCHAR(50) NOT NULL,
                    harga_satuan DECIMAL(15,2) NOT NULL,
                    jumlah DECIMAL(15,2) NOT NULL,
                    keterangan TEXT,
                    nilai_bantuan DECIMAL(15,2) DEFAULT 0.00,
                    tanggal_buat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    status ENUM('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
                    tanggal_review TIMESTAMP NULL,
                    FOREIGN KEY (id_proposal) REFERENCES proposal(id) ON DELETE CASCADE
                )
            ''')
       
        # Ambil data laporan akhir
        cursor.execute(f'''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status, nilai_bantuan
            FROM {tabel_laporan_akhir} 
            WHERE id_proposal = %s
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        laporan_data = cursor.fetchall()
        
        # Urutkan data sesuai urutan kegiatan utama
        if 'bertumbuh' in tahapan_usaha:
            urutan_kegiatan = [
                "Pengembangan Pasar dan Saluran Distribusi",
                "Pengembangan Produk/Riset",
                "Produksi",
                "Legalitas, perizinan, sertifikasi, dan standarisasi",
                "Belanja ATK dan Penunjang"
            ]
        else:
            urutan_kegiatan = [
                "Pengembangan Produk/Riset",
                "Produksi",
                "Legalitas, perizinan, sertifikasi, dan standarisasi",
                "Belanja ATK dan Penunjang"
            ]
        
        laporan_data = sorted(
            laporan_data,
            key=lambda x: urutan_kegiatan.index(x['kegiatan_utama']) if x['kegiatan_utama'] in urutan_kegiatan else 99
        )
        
        grouped_data = group_anggaran_data(laporan_data)
        laporan_data_flat = flatten_anggaran_data(laporan_data)
        
        # Hitung total nilai bantuan dari anggaran yang sudah direview
        if 'bertumbuh' in tahapan_usaha:
            tabel_anggaran = 'anggaran_bertumbuh'
        else:
            tabel_anggaran = 'anggaran_awal'
        
        cursor.execute(f'''
            SELECT SUM(nilai_bantuan) as total_nilai_bantuan
            FROM {tabel_anggaran} 
            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
        ''', (proposal_id,))
        
        nilai_bantuan_result = cursor.fetchone()
        total_nilai_bantuan = nilai_bantuan_result['total_nilai_bantuan'] or 0
        
        # Hitung total anggaran yang disetujui
        cursor.execute(f'''
            SELECT SUM(jumlah) as total_anggaran
            FROM {tabel_anggaran} 
            WHERE id_proposal = %s AND status = 'disetujui'
        ''', (proposal_id,))
        
        anggaran_result = cursor.fetchone()
        total_anggaran_disetujui = anggaran_result['total_anggaran'] or 0
        
        # Hitung total laporan kemajuan yang disetujui
        cursor.execute(f'''
            SELECT SUM(jumlah) as total_laporan_kemajuan
            FROM {tabel_laporan_kemajuan} 
            WHERE id_proposal = %s AND status = 'disetujui'
        ''', (proposal_id,))
        
        laporan_kemajuan_result = cursor.fetchone()
        total_laporan_kemajuan_disetujui = laporan_kemajuan_result['total_laporan_kemajuan'] or 0
        
        # Ambil data file laporan akhir
        cursor.execute('''
            SELECT * FROM file_laporan_akhir 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        file_laporan_akhir = cursor.fetchone()
        
        cursor.close()
        
        return render_template('pembimbing/laporan_akhir_awal_bertumbuh.html', 
                             anggaran_data=laporan_data, 
                             grouped_data=grouped_data,
                             anggaran_data_flat=laporan_data_flat,
                             mahasiswa_info=mahasiswa_info,
                             tabel_laporan=tabel_laporan_akhir,
                             proposal_id=proposal_id,
                             total_anggaran_disetujui=total_anggaran_disetujui,
                             total_nilai_bantuan=total_nilai_bantuan,
                             total_laporan_kemajuan_disetujui=total_laporan_kemajuan_disetujui,
                             file_laporan_akhir=file_laporan_akhir)
        
    except Exception as e:
        flash(f'Error saat mengambil data laporan akhir: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_akhir_awal_bertumbuh.html', 
                             anggaran_data=[], 
                             mahasiswa_info=None,
                             proposal_id=None,
                             total_anggaran_disetujui=0,
                             total_nilai_bantuan=0,
                             total_laporan_kemajuan_disetujui=0,
                             file_laporan_akhir=None)

@pembimbing_bp.route('/download_laporan_kemajuan/<int:proposal_id>')
def pembimbing_download_laporan_kemajuan(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('pembimbing_proposal'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return redirect(url_for('pembimbing_proposal'))
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data proposal dan laporan kemajuan
        cursor.execute('''
            SELECT p.*, m.nama_ketua 
            FROM proposal p 
            LEFT JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s AND p.dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        cursor.close()
        
        if not proposal:
            flash('Proposal tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        
        # Ambil path file laporan kemajuan dari struktur file, bukan dari kolom DB yang tidak ada
        # Gunakan helper yang sudah ada untuk menentukan lokasi file berdasarkan proposal
        # Jika tidak ditemukan, tampilkan pesan yang sama
        file_path = proposal.get('laporan_kemajuan_path')
        if not file_path:
            flash('Laporan kemajuan belum diupload oleh mahasiswa!', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        file_path = file_path.replace('\\', '/').replace('\\', '/')
        if not file_path.startswith('static/'):
            file_path = 'static/' + file_path.lstrip('/')
        if not os.path.exists(file_path):
            flash(f'File laporan kemajuan tidak ditemukan! ({file_path})', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        ext = os.path.splitext(file_path)[1].lower()
        if ext == '.pdf':
            return send_file(file_path, as_attachment=False, mimetype='application/pdf')
        else:
            import mimetypes
            mimetype = mimetypes.guess_type(file_path)[0] or 'application/octet-stream'
            return send_file(file_path, as_attachment=False, mimetype=mimetype)
    except Exception as e:
        flash(f'Error saat download laporan kemajuan: {str(e)}', 'danger')
        return redirect(url_for('pembimbing_proposal'))


@pembimbing_bp.route('/update_file_laporan_kemajuan_status', methods=['POST'])
def pembimbing_update_file_laporan_kemajuan_status():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    try:
        app_funcs = get_app_functions()
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        proposal_id = request.form.get('proposal_id')
        status = request.form.get('status')
        komentar = request.form.get('komentar', '').strip()
        
        if not proposal_id or not status:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        # Validasi status
        if status not in ['draf', 'diajukan', 'disetujui', 'revisi']:
            return jsonify({'success': False, 'message': 'Status tidak valid!'})
        
        # Cek apakah file laporan kemajuan ada
        cursor.execute('''
            SELECT * FROM file_laporan_kemajuan 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        file_data = cursor.fetchone()
        if not file_data:
            cursor.close()
            return jsonify({'success': False, 'message': 'File laporan kemajuan tidak ditemukan!'})
        
        # Update status dan komentar - hapus komentar jika status disetujui
        if status == 'disetujui':
            cursor.execute('''
                UPDATE file_laporan_kemajuan 
                SET status = %s, komentar_pembimbing = NULL, tanggal_update = CURRENT_TIMESTAMP
                WHERE id_proposal = %s
            ''', (status, proposal_id))
        else:
            cursor.execute('''
                UPDATE file_laporan_kemajuan 
                SET status = %s, komentar_pembimbing = %s, tanggal_update = CURRENT_TIMESTAMP
                WHERE id_proposal = %s
            ''', (status, komentar, proposal_id))
        
        app_funcs['mysql'].connection.commit()
        cursor.close()
        
        return jsonify({
            'success': True, 
            'message': f'Status file laporan kemajuan berhasil diupdate menjadi {status}!',
            'status': status
        })
        
    except Exception as e:
        print(f"Error update file laporan kemajuan status: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})


@pembimbing_bp.route('/view_file_laporan_kemajuan/<int:proposal_id>')
def pembimbing_view_file_laporan_kemajuan(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('pembimbing.pembimbing_laporan_kemajuan'))
    
    try:
        app_funcs = get_app_functions()
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        cursor.execute('''
            SELECT nama_file, file_path FROM file_laporan_kemajuan 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        file_data = cursor.fetchone()
        cursor.close()
        
        if not file_data:
            flash('File laporan kemajuan tidak ditemukan!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_laporan_kemajuan'))
        
        file_path = file_data['file_path']
        if not os.path.exists(file_path):
            flash('File tidak ditemukan di server!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_laporan_kemajuan'))
        
        # Tampilkan file PDF di browser
        return send_file(file_path, as_attachment=False, mimetype='application/pdf')
        
    except Exception as e:
        flash(f'Error saat menampilkan file: {str(e)}', 'danger')
        return redirect(url_for('pembimbing.pembimbing_laporan_kemajuan'))

@pembimbing_bp.route('/update_file_laporan_akhir_status', methods=['POST'])
def pembimbing_update_file_laporan_akhir_status():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    try:
        app_funcs = get_app_functions()
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        data = request.get_json()
        proposal_id = data.get('proposal_id')
        status = data.get('status')
        komentar = data.get('komentar', '').strip()
        
        if not proposal_id or not status:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        # Validasi status
        if status not in ['draf', 'diajukan', 'disetujui', 'revisi']:
            return jsonify({'success': False, 'message': 'Status tidak valid!'})
        
        # Cek apakah file laporan akhir ada
        cursor.execute('''
            SELECT * FROM file_laporan_akhir 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        file_data = cursor.fetchone()
        if not file_data:
            cursor.close()
            return jsonify({'success': False, 'message': 'File laporan akhir tidak ditemukan!'})
        
        # Update status dan komentar - hapus komentar jika status disetujui
        if status == 'disetujui':
            cursor.execute('''
                UPDATE file_laporan_akhir 
                SET status = %s, komentar_pembimbing = NULL, tanggal_update = CURRENT_TIMESTAMP
                WHERE id_proposal = %s
            ''', (status, proposal_id))
        else:
            cursor.execute('''
                UPDATE file_laporan_akhir 
                SET status = %s, komentar_pembimbing = %s, tanggal_update = CURRENT_TIMESTAMP
                WHERE id_proposal = %s
            ''', (status, komentar, proposal_id))
        
        app_funcs['mysql'].connection.commit()
        cursor.close()
        
        return jsonify({
            'success': True, 
            'message': f'Status file laporan akhir berhasil diupdate menjadi {status}!',
            'status': status
        })
        
    except Exception as e:
        print(f"Error update file laporan akhir status: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/pembimbing_view_file_laporan_akhir/<int:proposal_id>')
def pembimbing_view_file_laporan_akhir(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('pembimbing.pembimbing_laporan_akhir'))
    
    try:
        app_funcs = get_app_functions()
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        cursor.execute('''
            SELECT nama_file, file_path FROM file_laporan_akhir 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        
        file_data = cursor.fetchone()
        cursor.close()
        
        if not file_data:
            flash('File laporan akhir tidak ditemukan!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_laporan_akhir'))
        
        file_path = file_data['file_path']
        if not os.path.exists(file_path):
            flash('File tidak ditemukan di server!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_laporan_akhir'))
        
        # Tampilkan file PDF di browser
        return send_file(file_path, as_attachment=False, mimetype='application/pdf')
        
    except Exception as e:
        flash(f'Error saat menampilkan file: {str(e)}', 'danger')
        return redirect(url_for('pembimbing.pembimbing_laporan_akhir'))


@pembimbing_bp.route('/konfirmasi_proposal', methods=['POST'])
def pembimbing_konfirmasi_proposal():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('pembimbing_proposal'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return redirect(url_for('pembimbing_proposal'))
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data dari form
        proposal_id = request.form.get('proposal_id')
        action = request.form.get('action')
        catatan = request.form.get('catatan', '').strip()
        
        if not proposal_id or not action:
            flash('Data tidak lengkap!', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        
        # Validasi aksi
        if action not in ['setuju', 'tolak', 'revisi']:
            flash('Aksi tidak valid!', 'danger')
            return redirect(url_for('pembimbing_proposal'))
        
        # Cek apakah proposal ada dan dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT p.*, m.nama_ketua 
            FROM proposal p 
            LEFT JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s AND p.dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        proposal = cursor.fetchone()
        
        if not proposal:
            flash('Proposal tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing_proposal'))
        
        # Update status proposal berdasarkan aksi
        if action == 'setuju':
            status = 'disetujui'
        elif action == 'tolak':
            status = 'ditolak'
        elif action == 'revisi':
            status = 'revisi'
        
        # Update database
        if action == 'revisi':
            cursor.execute('''
                UPDATE proposal 
                SET status = %s, komentar_revisi = %s, 
                    tanggal_konfirmasi_pembimbing = CURRENT_TIMESTAMP
                WHERE id = %s
            ''', (status, catatan, proposal_id))
        else:
            cursor.execute('''
                UPDATE proposal 
                SET status = %s, catatan_pembimbing = %s, 
                    tanggal_konfirmasi_pembimbing = CURRENT_TIMESTAMP
                WHERE id = %s
            ''', (status, catatan, proposal_id))
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and proposal:
            jenis_aktivitas = 'setuju' if action == 'setuju' else 'tolak' if action == 'tolak' else 'revisi'
            deskripsi = f'Mengkonfirmasi proposal "{proposal["judul"]}" dengan status {status}'
            if catatan:
                deskripsi += f' dengan catatan: {catatan[:100]}...' if len(catatan) > 100 else f' dengan catatan: {catatan}'
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                jenis_aktivitas,
                'proposal',
                f'proposal_konfirmasi_id_{proposal_id}',
                deskripsi,
                {'status': proposal.get('status', 'pending')},
                {'status': status, 'catatan_pembimbing': catatan},
                proposal.get('mahasiswa_id'),
                proposal_id
            )
        
        cursor.close()
        
        flash(f'Proposal berhasil dikonfirmasi! Status: {status}', 'success')
        return redirect(url_for('pembimbing_proposal'))
        
    except Exception as e:
        flash(f'Error saat konfirmasi proposal: {str(e)}', 'danger')
        return redirect(url_for('pembimbing_proposal'))


@pembimbing_bp.route('/konfirmasi_laporan_akhir', methods=['POST'])
def pembimbing_konfirmasi_laporan_akhir():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        data = request.get_json()
        laporan_id = data.get('id')
        tabel_laporan = data.get('tabel_laporan')
        action = data.get('action')  # 'setuju', 'tolak', 'revisi'
        
        if not laporan_id or not tabel_laporan or not action:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        if tabel_laporan not in ['laporan_akhir_awal', 'laporan_akhir_bertumbuh']:
            return jsonify({'success': False, 'message': 'Tabel laporan tidak valid!'})
        
        if action not in ['setuju', 'tolak', 'revisi']:
            return jsonify({'success': False, 'message': 'Aksi tidak valid!'})
        
        # Tentukan status berdasarkan action
        status_map = {
            'setuju': 'disetujui',
            'tolak': 'ditolak',
            'revisi': 'revisi'
        }
        new_status = status_map[action]
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Cek apakah laporan akhir milik mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute(f'''
            SELECT la.*, p.dosen_pembimbing
            FROM {tabel_laporan} la
            JOIN proposal p ON la.id_proposal = p.id
            WHERE la.id = %s AND p.dosen_pembimbing = %s
        ''', (laporan_id, session['nama']))
        
        laporan = cursor.fetchone()
        if not laporan:
            cursor.close()
            return jsonify({'success': False, 'message': 'Laporan akhir tidak ditemukan atau Anda tidak memiliki akses!'})
        
        # Ambil data lengkap untuk logging
        cursor.execute(f'''
            SELECT la.*, p.judul_usaha, m.id as mahasiswa_id
            FROM {tabel_laporan} la
            JOIN proposal p ON la.id_proposal = p.id
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE la.id = %s
        ''', (laporan_id,))
        laporan_data = cursor.fetchone()
        
        # Update status laporan akhir
        cursor.execute(f'''
            UPDATE {tabel_laporan} 
            SET status = %s, tanggal_review = NOW()
            WHERE id = %s
        ''', (new_status, laporan_id))
        
        app_funcs['mysql'].connection.commit()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info and laporan_data:
            jenis_aktivitas = 'setuju' if action == 'setuju' else 'tolak' if action == 'tolak' else 'revisi'
            modul = 'laporan_akhir_awal' if 'awal' in tabel_laporan else 'laporan_akhir_bertumbuh'
            deskripsi = f'Mengubah status {modul} ID {laporan_id} menjadi {new_status} untuk proposal "{laporan_data["judul_usaha"]}"'
            
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                jenis_aktivitas,
                modul,
                f'{modul}_id_{laporan_id}',
                deskripsi,
                {'status': laporan_data.get('status', 'pending')},
                {'status': new_status},
                laporan_data.get('mahasiswa_id'),
                laporan_data.get('id_proposal')
            )
        
        cursor.close()
        
        return jsonify({'success': True, 'message': f'Status laporan akhir berhasil diubah menjadi {new_status}'})
        
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/get_pembimbing_list')
def pembimbing_get_pembimbing_list():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('''
            SELECT p.nama, p.nip, p.program_studi, p.kuota_mahasiswa,
                   COUNT(DISTINCT CASE WHEN pr.status != 'selesai' THEN pr.nim END) as jumlah_mahasiswa_bimbing
            FROM pembimbing p
            LEFT JOIN proposal pr ON p.nama = pr.dosen_pembimbing
            WHERE p.status = 'aktif'
            GROUP BY p.id, p.nama, p.nip, p.program_studi, p.kuota_mahasiswa
            ORDER BY p.nama
        ''')
        pembimbing_list = cursor.fetchall()
        for pembimbing in pembimbing_list:
            pembimbing['sisa_kuota'] = pembimbing['kuota_mahasiswa'] - pembimbing['jumlah_mahasiswa_bimbing']
            pembimbing['status_kuota'] = 'tersedia' if pembimbing['sisa_kuota'] > 0 else 'penuh'
        cursor.close()
        return jsonify({'success': True, 'pembimbing': pembimbing_list})
    except Exception as e:
        return jsonify({'success': False, 'message': f'Error saat mengambil data pembimbing: {str(e)}'})


    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Ambil data neraca dari tabel neraca
        cursor.execute('''
            SELECT * FROM neraca 
            WHERE proposal_id = %s 
            ORDER BY tanggal_neraca DESC 
            LIMIT 1
        ''', (proposal_id,))
        
        neraca_data = cursor.fetchone()
        
        if not neraca_data:
            # Jika tidak ada data neraca, buat data kosong dengan format yang benar
            neraca_data = {
                'kas_dan_setara_kas': 0,
                'piutang_usaha': 0,
                'persediaan': 0,
                'beban_dibayar_dimuka': 0,
                'total_aset_lancar': 0,
                'tanah': 0,
                'bangunan': 0,
                'kendaraan': 0,
                'peralatan_dan_mesin': 0,
                'akumulasi_penyusutan': 0,
                'total_aset_tetap_bersih': 0,
                'investasi_jangka_panjang': 0,
                'hak_paten_merek_dagang': 0,
                'total_aset_lain_lain': 0,
                'total_aset': 0,
                'utang_usaha': 0,
                'beban_harus_dibayar': 0,
                'utang_pajak': 0,
                'utang_jangka_pendek_lainnya': 0,
                'total_liabilitas_jangka_pendek': 0,
                'utang_bank': 0,
                'total_liabilitas_jangka_panjang': 0,
                'total_liabilitas': 0,
                'modal_disetor': 0,
                'laba_ditahan': 0,
                'total_ekuitas': 0,
                'total_liabilitas_dan_ekuitas': 0,
                'tanggal_neraca': datetime.now().strftime('%Y-%m-%d')
            }
        
        cursor.close()
        
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=mahasiswa_info,
                             neraca_data=neraca_data)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=None,
                             neraca_data={})

@pembimbing_bp.route('/monitoring_mahasiswa/laporan_neraca')
def pembimbing_monitoring_mahasiswa_laporan_neraca():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_laporan_neraca.html', mahasiswa_list=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil semua mahasiswa yang dibimbing oleh pembimbing ini
        # Coba dengan exact match terlebih dahulu
        cursor.execute('''
            SELECT m.id as mahasiswa_id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s
            ORDER BY m.nama_ketua
        ''', (session['nama'],))
        
        mahasiswa_all = cursor.fetchall()
        
        # Jika tidak ada hasil, coba dengan LIKE match
        if not mahasiswa_all:
            cursor.execute('''
                SELECT m.id as mahasiswa_id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
                FROM mahasiswa m
                JOIN proposal p ON m.nim = p.nim
                WHERE p.dosen_pembimbing LIKE %s
                ORDER BY m.nama_ketua
            ''', (f"%{session['nama']}%",))
            mahasiswa_all = cursor.fetchall()
        
        # Jika masih tidak ada, ambil semua mahasiswa yang memiliki dosen pembimbing
        if not mahasiswa_all:
            cursor.execute('''
                SELECT m.id as mahasiswa_id, m.nama_ketua, m.nim, p.judul_usaha, p.tahapan_usaha, m.program_studi, p.id as proposal_id
                FROM mahasiswa m
                JOIN proposal p ON m.nim = p.nim
                WHERE p.dosen_pembimbing IS NOT NULL AND p.dosen_pembimbing != ''
                ORDER BY m.nama_ketua
            ''')
            mahasiswa_all = cursor.fetchall()
        mahasiswa_list = []
        
        for mhs in mahasiswa_all:
            proposal_id = mhs['proposal_id']
            
            # Cek apakah ada data neraca
            try:
                cursor.execute('SELECT COUNT(*) as cnt FROM neraca WHERE proposal_id = %s', (proposal_id,))
                neraca_count = cursor.fetchone()['cnt']
            except:
                # Jika tabel tidak ada, cek dari data lain
                cursor.execute('SELECT COUNT(*) as cnt FROM penjualan WHERE proposal_id = %s', (proposal_id,))
                penjualan_count = cursor.fetchone()['cnt']
                cursor.execute('SELECT COUNT(*) as cnt FROM biaya_operasional WHERE proposal_id = %s', (proposal_id,))
                biaya_operasional_count = cursor.fetchone()['cnt']
                neraca_count = 1 if (penjualan_count > 0 or biaya_operasional_count > 0) else 0
            
            mhs['has_neraca'] = neraca_count > 0
            mahasiswa_list.append(mhs)
        
        cursor.close()
        
        return render_template('pembimbing/daftar_laporan_neraca.html', mahasiswa_list=mahasiswa_list)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/daftar_laporan_neraca.html', mahasiswa_list=[])


    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Hitung laporan neraca secara real-time dari data transaksi
        neraca_data = app_funcs['hitung_neraca_real_time'](proposal_id, cursor)
        
        cursor.close()
        
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=mahasiswa_info,
                             neraca_data=neraca_data)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=None,
                             neraca_data={})

@pembimbing_bp.route('/laporan_neraca/<int:mahasiswa_id>')
def pembimbing_laporan_neraca(mahasiswa_id):
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/laporan_neraca.html', mahasiswa_info=None, neraca_data={})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
        proposal_id = mahasiswa_info['proposal_id']
        
        # Hitung laporan neraca secara real-time dari data transaksi
        neraca_data = app_funcs['hitung_neraca_real_time'](proposal_id, cursor)
        
        cursor.close()
        
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=mahasiswa_info,
                             neraca_data=neraca_data)
        
    except Exception as e:
        flash(f'Error: {str(e)}', 'danger')
        return render_template('pembimbing/laporan_neraca.html', 
                             mahasiswa_info=None,
                             neraca_data={})

@pembimbing_bp.route('/download_neraca', methods=['POST'])
def download_neraca():
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
    
    try:
        format_type = request.form.get('format', 'excel')
        proposal_id = request.form.get('proposal_id')
        
        if not proposal_id:
            flash('ID proposal tidak ditemukan!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id, p.tahapan_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.id = %s AND p.dosen_pembimbing = %s
        ''', (proposal_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
        # Hitung laporan neraca secara real-time
        neraca_data = app_funcs['hitung_neraca_real_time'](proposal_id, cursor)
        
        cursor.close()
        
        # Generate file berdasarkan format
        if format_type == 'excel':
            file_buffer = app_funcs['generate_excel_neraca'](mahasiswa_info, neraca_data)
            if file_buffer:
                filename = f"Laporan_Neraca_{mahasiswa_info['nama_ketua']}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.xlsx"
                return send_file(
                    file_buffer,
                    as_attachment=True,
                    download_name=filename,
                    mimetype='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                )
            else:
                flash('Gagal membuat file Excel!', 'danger')
                return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        elif format_type == 'pdf':
            file_buffer = app_funcs['generate_pdf_neraca'](mahasiswa_info, neraca_data)
            if file_buffer:
                filename = f"Laporan_Neraca_{mahasiswa_info['nama_ketua']}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.pdf"
                return send_file(
                    file_buffer,
                    as_attachment=True,
                    download_name=filename,
                    mimetype='application/pdf'
                )
            else:
                flash('Gagal membuat file PDF!', 'danger')
                return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        elif format_type == 'word':
            file_buffer = app_funcs['generate_word_neraca'](mahasiswa_info, neraca_data)
            if file_buffer:
                filename = f"Laporan_Neraca_{mahasiswa_info['nama_ketua']}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.docx"
                return send_file(
                    file_buffer,
                    as_attachment=True,
                    download_name=filename,
                    mimetype='application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                )
            else:
                flash('Gagal membuat file Word!', 'danger')
                return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        else:
            flash('Format file tidak valid!', 'danger')
            return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))
        
    except Exception as e:
        flash(f'Error saat mengunduh file: {str(e)}', 'danger')
        return redirect(url_for('pembimbing.pembimbing_monitoring_mahasiswa_laporan_neraca'))

# ========================================
# ROUTE UNTUK PENILAIAN MAHASISWA
# ========================================

@pembimbing_bp.route('/daftar_penilaian_mahasiswa')
def daftar_penilaian_mahasiswa():
    """Halaman daftar mahasiswa yang bisa dinilai"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_penilaian_mahasiswa.html')
    
    try:
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'penilaian',
                'daftar_penilaian_mahasiswa',
                'Melihat daftar mahasiswa untuk penilaian'
            )
        
        return render_template('pembimbing/daftar_penilaian_mahasiswa.html')
        
    except Exception as e:
        logger.error(f"Error in daftar_penilaian_mahasiswa: {str(e)}")
        flash('Terjadi kesalahan saat memuat halaman!', 'danger')
        return render_template('pembimbing/daftar_penilaian_mahasiswa.html')

@pembimbing_bp.route('/penilaian_mahasiswa')
def penilaian_mahasiswa():
    """Halaman form penilaian mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        # Auto-simpan nilai 0 untuk pembimbing jika melewati jadwal selesai pembimbing_nilai_selesai dan belum ada penilaian
        try:
            cur = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur.execute('SELECT pembimbing_nilai_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1')
            row = cur.fetchone()
            if row and row.get('pembimbing_nilai_selesai'):
                from datetime import datetime
                if datetime.now() > row['pembimbing_nilai_selesai']:
                    # Ambil daftar proposal yang dibimbing oleh pembimbing ini dan belum ada penilaian
                    cur.execute('SELECT id FROM pembimbing WHERE nama=%s', (session['nama'],))
                    pemb = cur.fetchone()
                    if pemb:
                        id_pembimbing = pemb['id']
                        cur.execute('''
                            SELECT p.id as id_proposal
                            FROM proposal p
                            WHERE p.dosen_pembimbing=%s AND NOT EXISTS (
                                SELECT 1 FROM penilaian_mahasiswa pm WHERE pm.id_proposal=p.id AND pm.id_pembimbing=%s
                            )
                        ''', (session['nama'], id_pembimbing))
                        rows = cur.fetchall()
                        # Pertanyaan aktif
                        cur.execute('SELECT id, bobot, skor_maksimal FROM pertanyaan_penilaian_mahasiswa WHERE status="Aktif" ORDER BY created_at ASC')
                        pts = cur.fetchall()
                        for r in rows:
                            # insert header 0
                            cur.execute('''
                                INSERT INTO penilaian_mahasiswa (id_proposal, id_pembimbing, nilai_akhir, komentar_pembimbing, status)
                                VALUES (%s,%s,%s,%s,'Selesai')
                            ''', (r['id_proposal'], id_pembimbing, 0, ''))
                            pen_id = cur.lastrowid
                            for p in pts:
                                cur.execute('''
                                    INSERT INTO detail_penilaian_mahasiswa (id_penilaian_mahasiswa, id_pertanyaan, skor, nilai)
                                    VALUES (%s,%s,%s,%s)
                                ''', (pen_id, p['id'], 0, 0))
                        app_funcs['mysql'].connection.commit()
            cur.close()
        except Exception:
            try:
                cur.close()
            except Exception:
                pass

        return render_template('pembimbing/penilaian_mahasiswa.html')
    
    try:
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'view',
                'penilaian',
                'form_penilaian_mahasiswa',
                'Melihat form penilaian mahasiswa'
            )
        
        return render_template('pembimbing/penilaian_mahasiswa.html')
        
    except Exception as e:
        logger.error(f"Error in penilaian_mahasiswa: {str(e)}")
        flash('Terjadi kesalahan saat memuat halaman!', 'danger')
        return render_template('pembimbing/penilaian_mahasiswa.html')

@pembimbing_bp.route('/get_daftar_mahasiswa_penilaian')
def get_daftar_mahasiswa_penilaian():
    """API untuk mendapatkan daftar mahasiswa yang bisa dinilai"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing dengan nilai terbaru
        cursor.execute('''
            SELECT DISTINCT 
                m.nim as nim_mahasiswa,
                m.nama_ketua as nama_mahasiswa,
                p.judul_usaha,
                p.id as proposal_id,
                COALESCE(pm.nilai_akhir, 0) as nilai,
                COALESCE(pm.status, 'Belum Dinilai') as status_penilaian
            FROM mahasiswa m
            INNER JOIN proposal p ON m.nim = p.nim
            LEFT JOIN penilaian_mahasiswa pm ON p.id = pm.id_proposal 
                AND pm.id_pembimbing = (SELECT id FROM pembimbing WHERE nama = %s)
            WHERE p.dosen_pembimbing = %s 
            AND p.status IN ('disetujui', 'revisi')
            ORDER BY p.tanggal_buat DESC
        ''', (session['nama'], session['nama']))
        
        mahasiswa_list = cursor.fetchall()
        
        # Format data untuk response
        formatted_data = []
        for item in mahasiswa_list:
            formatted_data.append({
                'nim_mahasiswa': item['nim_mahasiswa'],
                'nama_mahasiswa': item['nama_mahasiswa'],
                'judul_usaha': item['judul_usaha'],
                'proposal_id': item['proposal_id'],
                'nilai': float(item['nilai']),
                'status_penilaian': item['status_penilaian']
            })
        
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': formatted_data
        })
        
    except Exception as e:
        logger.error(f"Error in get_daftar_mahasiswa_penilaian: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/get_info_mahasiswa')
def get_info_mahasiswa():
    """API untuk mendapatkan informasi mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        nim = request.args.get('nim')
        if not nim:
            return jsonify({'success': False, 'message': 'NIM mahasiswa tidak ditemukan!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil informasi mahasiswa
        cursor.execute('''
            SELECT m.nim, m.nama_ketua, m.program_studi, p.judul_usaha
            FROM mahasiswa m
            INNER JOIN proposal p ON m.nim = p.nim
            WHERE m.nim = %s AND p.dosen_pembimbing = %s
        ''', (nim, session['nama']))
        
        mahasiswa = cursor.fetchone()
        if not mahasiswa:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data mahasiswa tidak ditemukan!'})
        
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': {
                'nim': mahasiswa['nim'],
                'nama': mahasiswa['nama_ketua'],
                'program_studi': mahasiswa['program_studi'],
                'judul_usaha': mahasiswa['judul_usaha']
            }
        })
        
    except Exception as e:
        logger.error(f"Error in get_info_mahasiswa: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/get_pertanyaan_penilaian')
def get_pertanyaan_penilaian():
    """API untuk mendapatkan pertanyaan penilaian mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Buat tabel jika belum ada
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS pertanyaan_penilaian_mahasiswa (
                id INT AUTO_INCREMENT PRIMARY KEY,
                pertanyaan TEXT NOT NULL,
                bobot DECIMAL(5,2) NOT NULL COMMENT 'Bobot yang diinput admin (1-100)',
                skor_maksimal INT NOT NULL COMMENT 'Skor maksimal yang bisa diberikan (1-100)',
                status ENUM('Aktif', 'Nonaktif') DEFAULT 'Aktif',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        
        # Ambil pertanyaan yang aktif saja
        cursor.execute('''
            SELECT id, pertanyaan, bobot, skor_maksimal, status
            FROM pertanyaan_penilaian_mahasiswa
            WHERE status = 'Aktif'
            ORDER BY created_at ASC
        ''')
        
        pertanyaan_list = cursor.fetchall()
        cursor.close()
        
        # Log untuk debugging
        logger.info(f"Pertanyaan aktif yang dikirim: {len(pertanyaan_list)} pertanyaan")
        for pertanyaan in pertanyaan_list:
            logger.info(f"ID: {pertanyaan['id']}, Status: {pertanyaan['status']}, Pertanyaan: {pertanyaan['pertanyaan'][:50]}...")
        
        return jsonify({
            'success': True,
            'data': pertanyaan_list
        })
        
    except Exception as e:
        logger.error(f"Error in get_pertanyaan_penilaian: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/simpan_penilaian_mahasiswa', methods=['POST'])
def simpan_penilaian_mahasiswa():
    """API untuk menyimpan penilaian mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        # Ambil data minimal yang diperlukan lebih awal
        nim_form = request.form.get('nim_mahasiswa')

        # Guard jadwal penilaian pembimbing (server-side)
        try:
            cur_guard = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur_guard.execute('''
                CREATE TABLE IF NOT EXISTS pengaturan_jadwal (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    proposal_mulai DATETIME NULL,
                    proposal_selesai DATETIME NULL,
                    kemajuan_mulai DATETIME NULL,
                    kemajuan_selesai DATETIME NULL,
                    akhir_mulai DATETIME NULL,
                    akhir_selesai DATETIME NULL,
                    pembimbing_nilai_mulai DATETIME NULL,
                    pembimbing_nilai_selesai DATETIME NULL,
                    reviewer_proposal_mulai DATETIME NULL,
                    reviewer_proposal_selesai DATETIME NULL,
                    reviewer_kemajuan_mulai DATETIME NULL,
                    reviewer_kemajuan_selesai DATETIME NULL,
                    reviewer_akhir_mulai DATETIME NULL,
                    reviewer_akhir_selesai DATETIME NULL,
                    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                )
            ''')
            app_funcs['mysql'].connection.commit()
            cur_guard.execute('SELECT pembimbing_nilai_mulai, pembimbing_nilai_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1')
            row_guard = cur_guard.fetchone()
            cur_guard.close()
            if row_guard:
                from datetime import datetime
                now = datetime.now()
                mulai = row_guard.get('pembimbing_nilai_mulai')
                selesai = row_guard.get('pembimbing_nilai_selesai')
                if mulai and now < mulai:
                    return jsonify({'success': False, 'message': 'Penilaian belum dibuka. Menunggu jadwal mulai.'})
                if selesai and now > selesai:
                    # Jika melewati jadwal selesai: otomatis simpan penilaian 0 untuk mahasiswa ini bila belum ada
                    try:
                        cursor_auto = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
                        # Ambil id_pembimbing
                        cursor_auto.execute('SELECT id FROM pembimbing WHERE nama=%s', (session['nama'],))
                        pemb_row = cursor_auto.fetchone()
                        if not pemb_row:
                            cursor_auto.close()
                            return jsonify({'success': False, 'message': 'Data pembimbing tidak ditemukan!'})
                        id_pembimbing = pemb_row['id']
                        # Ambil id_proposal mahasiswa ini
                        cursor_auto.execute('SELECT id FROM proposal WHERE nim=%s AND dosen_pembimbing=%s', (nim_form, session['nama']))
                        prop_row = cursor_auto.fetchone()
                        if not prop_row:
                            cursor_auto.close()
                            return jsonify({'success': False, 'message': 'Proposal mahasiswa tidak ditemukan!'})
                        id_proposal = prop_row['id']
                        # Cek existing
                        cursor_auto.execute('SELECT id FROM penilaian_mahasiswa WHERE id_proposal=%s AND id_pembimbing=%s', (id_proposal, id_pembimbing))
                        exist_pen = cursor_auto.fetchone()
                        if not exist_pen:
                            # Buat header nilai 0
                            cursor_auto.execute('''
                                INSERT INTO penilaian_mahasiswa (id_proposal, id_pembimbing, nilai_akhir, komentar_pembimbing, status)
                                VALUES (%s,%s,%s,%s,'Selesai')
                            ''', (id_proposal, id_pembimbing, 0, ''))
                            id_pen = cursor_auto.lastrowid
                            # Detail 0 untuk semua pertanyaan aktif
                            cursor_auto.execute('SELECT id, bobot, skor_maksimal FROM pertanyaan_penilaian_mahasiswa WHERE status="Aktif" ORDER BY created_at ASC')
                            pts = cursor_auto.fetchall()
                            for p in pts:
                                cursor_auto.execute('''
                                    INSERT INTO detail_penilaian_mahasiswa (id_penilaian_mahasiswa, id_pertanyaan, skor, nilai)
                                    VALUES (%s,%s,%s,%s)
                                ''', (id_pen, p['id'], 0, 0))
                            if hasattr(app_funcs['mysql'], 'connection'):
                                app_funcs['mysql'].connection.commit()
                        cursor_auto.close()
                    except Exception:
                        try:
                            cursor_auto.close()
                        except Exception:
                            pass
                    return jsonify({'success': True, 'message': 'Masa penilaian telah berakhir. Sistem otomatis menyimpan nilai 0 untuk mahasiswa ini.'})
        except Exception:
            # Abaikan guard jika gagal, agar tidak memblokir semuanya tanpa alasan
            pass

        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data dari request
        nim = nim_form
        komentar_pembimbing = request.form.get('komentar_pembimbing', '')
        total_nilai = float(request.form.get('total_nilai', 0))
        detail_penilaian = request.form.get('detail_penilaian', '[]')
        
        # Validasi data
        if not nim:
            return jsonify({'success': False, 'message': 'Data tidak lengkap!'})
        
        # Ambil ID pembimbing
        cursor.execute('SELECT id FROM pembimbing WHERE nama = %s', (session['nama'],))
        pembimbing = cursor.fetchone()
        if not pembimbing:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data pembimbing tidak ditemukan!'})
        
        id_pembimbing = pembimbing['id']
        
        # Ambil ID proposal
        cursor.execute('''
            SELECT id FROM proposal 
            WHERE nim = %s AND dosen_pembimbing = %s
        ''', (nim, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data proposal tidak ditemukan!'})
        
        id_proposal = proposal['id']
        
        # Cek apakah sudah ada penilaian untuk mahasiswa ini
        cursor.execute('''
            SELECT id FROM penilaian_mahasiswa 
            WHERE id_proposal = %s AND id_pembimbing = %s
        ''', (id_proposal, id_pembimbing))
        
        existing_penilaian = cursor.fetchone()
        
        # Buat tabel jika belum ada
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS penilaian_mahasiswa (
                id INT AUTO_INCREMENT PRIMARY KEY,
                id_proposal INT NOT NULL,
                id_pembimbing INT NOT NULL,
                nilai_akhir DECIMAL(5,2) DEFAULT 0 COMMENT 'Total nilai akhir',
                komentar_pembimbing TEXT,
                status ENUM('Draft', 'Selesai') DEFAULT 'Draft',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                FOREIGN KEY (id_proposal) REFERENCES proposal(id) ON DELETE CASCADE,
                FOREIGN KEY (id_pembimbing) REFERENCES pembimbing(id) ON DELETE CASCADE,
                UNIQUE KEY unique_penilaian_mahasiswa (id_proposal, id_pembimbing)
            )
        ''')
        
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS detail_penilaian_mahasiswa (
                id INT AUTO_INCREMENT PRIMARY KEY,
                id_penilaian_mahasiswa INT NOT NULL,
                id_pertanyaan INT NOT NULL,
                skor INT NOT NULL COMMENT 'Skor yang diberikan pembimbing',
                nilai DECIMAL(5,2) NOT NULL COMMENT 'Nilai = (skor/skor_maksimal) * bobot',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (id_penilaian_mahasiswa) REFERENCES penilaian_mahasiswa(id) ON DELETE CASCADE,
                FOREIGN KEY (id_pertanyaan) REFERENCES pertanyaan_penilaian_mahasiswa(id) ON DELETE CASCADE,
                UNIQUE KEY unique_detail_penilaian_mahasiswa (id_penilaian_mahasiswa, id_pertanyaan)
            )
        ''')
        
        # Parse detail penilaian
        import json
        detail_list = json.loads(detail_penilaian)
        
        # Hitung nilai akhir seperti IPK
        total_bobot = 0
        total_nilai_calculated = 0
        
        for detail in detail_list:
            # Ambil bobot dari pertanyaan
            cursor.execute('SELECT bobot FROM pertanyaan_penilaian_mahasiswa WHERE id = %s', (detail['id_pertanyaan'],))
            pertanyaan = cursor.fetchone()
            if pertanyaan:
                bobot = float(pertanyaan['bobot'])
                total_bobot += bobot
                total_nilai_calculated += float(detail['nilai_terbobot'])
        
        # Hitung nilai akhir dalam persentase
        nilai_akhir = (total_nilai_calculated / total_bobot * 100) if total_bobot > 0 else 0
        
        if existing_penilaian:
            # Update penilaian yang sudah ada
            cursor.execute('''
                UPDATE penilaian_mahasiswa 
                SET nilai_akhir = %s, komentar_pembimbing = %s, status = 'Selesai',
                    updated_at = CURRENT_TIMESTAMP
                WHERE id = %s
            ''', (nilai_akhir, komentar_pembimbing, existing_penilaian['id']))
            
            id_penilaian = existing_penilaian['id']
            
            # Hapus detail lama
            cursor.execute('DELETE FROM detail_penilaian_mahasiswa WHERE id_penilaian_mahasiswa = %s', (id_penilaian,))
        else:
            # Insert penilaian baru
            cursor.execute('''
                INSERT INTO penilaian_mahasiswa 
                (id_proposal, id_pembimbing, nilai_akhir, komentar_pembimbing, status)
                VALUES (%s, %s, %s, %s, 'Selesai')
            ''', (id_proposal, id_pembimbing, nilai_akhir, komentar_pembimbing))
            
            id_penilaian = cursor.lastrowid
        
        # Insert detail penilaian
        for detail in detail_list:
            cursor.execute('''
                INSERT INTO detail_penilaian_mahasiswa 
                (id_penilaian_mahasiswa, id_pertanyaan, skor, nilai)
                VALUES (%s, %s, %s, %s)
            ''', (id_penilaian, detail['id_pertanyaan'], detail['skor_diberikan'], detail['nilai_terbobot']))
        
        app_funcs['mysql'].connection.commit()
        cursor.close()
        
        # Log aktivitas pembimbing
        pembimbing_info = app_funcs['get_pembimbing_info_from_session']()
        if pembimbing_info:
            app_funcs['log_pembimbing_activity'](
                pembimbing_info['id'],
                pembimbing_info['nip'],
                pembimbing_info['nama'],
                'create',
                'penilaian',
                f'penilaian_mahasiswa_{nim}',
                f'Menyimpan penilaian mahasiswa {nim}',
                None,
                None,
                None,
                total_nilai
            )
        
        return jsonify({
            'success': True,
            'message': 'Penilaian berhasil disimpan!'
        })
        
    except Exception as e:
        logger.error(f"Error in simpan_penilaian_mahasiswa: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/get_daftar_nilai_mahasiswa')
def get_daftar_nilai_mahasiswa():
    """API untuk mendapatkan daftar nilai mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing dengan nilai terbaru
        cursor.execute('''
            SELECT DISTINCT 
                m.nim as nim_mahasiswa,
                m.nama_ketua as nama_mahasiswa,
                p.judul_usaha,
                p.id as proposal_id,
                COALESCE(pm.nilai_akhir, 0) as nilai,
                COALESCE(pm.status, 'Belum Dinilai') as status_penilaian
            FROM mahasiswa m
            INNER JOIN proposal p ON m.nim = p.nim
            LEFT JOIN penilaian_mahasiswa pm ON p.id = pm.id_proposal 
                AND pm.id_pembimbing = (SELECT id FROM pembimbing WHERE nama = %s)
            WHERE p.dosen_pembimbing = %s 
            AND p.status IN ('disetujui', 'revisi')
            ORDER BY p.tanggal_buat DESC
        ''', (session['nama'], session['nama']))
        
        mahasiswa_list = cursor.fetchall()
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': mahasiswa_list
        })
        
    except Exception as e:
        print(f"Error get_daftar_nilai_mahasiswa: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

@pembimbing_bp.route('/get_skor_tersimpan')
def get_skor_tersimpan():
    """API untuk mengambil skor yang sudah tersimpan"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        nim = request.args.get('nim')
        
        if not nim:
            return jsonify({'success': False, 'message': 'NIM mahasiswa tidak ditemukan!'})
        
        # Ambil ID pembimbing
        cursor.execute('SELECT id FROM pembimbing WHERE nama = %s', (session['nama'],))
        pembimbing = cursor.fetchone()
        if not pembimbing:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data pembimbing tidak ditemukan!'})
        
        id_pembimbing = pembimbing['id']
        
        # Ambil ID proposal
        cursor.execute('''
            SELECT id FROM proposal 
            WHERE nim = %s AND dosen_pembimbing = %s
        ''', (nim, session['nama']))
        
        proposal = cursor.fetchone()
        if not proposal:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data proposal tidak ditemukan!'})
        
        id_proposal = proposal['id']
        
        # Ambil skor yang sudah tersimpan
        cursor.execute('''
            SELECT dp.id_pertanyaan, dp.skor, dp.nilai
            FROM detail_penilaian_mahasiswa dp
            INNER JOIN penilaian_mahasiswa pm ON dp.id_penilaian_mahasiswa = pm.id
            WHERE pm.id_proposal = %s AND pm.id_pembimbing = %s
        ''', (id_proposal, id_pembimbing))
        
        skor_data = cursor.fetchall()
        cursor.close()
        
        return jsonify({'success': True, 'data': skor_data})
        
    except Exception as e:
        logger.error(f"Error in get_skor_tersimpan: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})

# ========================================
# ROUTE UNTUK SISTEM BIMBINGAN PEMBIMBING
# ========================================

@pembimbing_bp.route('/daftar_bimbingan_mahasiswa')
def daftar_bimbingan_mahasiswa():
    """Halaman daftar mahasiswa bimbingan"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/daftar_bimbingan_mahasiswa.html', mahasiswa_bimbingan=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil daftar mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT DISTINCT m.id, m.nim, m.nama_ketua, m.program_studi, p.judul_usaha
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE p.dosen_pembimbing = %s AND p.status_admin = 'lolos'
            ORDER BY m.nama_ketua ASC
        ''', (session['nama'],))
        
        mahasiswa_bimbingan = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/daftar_bimbingan_mahasiswa.html', 
                             mahasiswa_bimbingan=mahasiswa_bimbingan)
        
    except Exception as e:
        logger.error(f"Error in daftar_bimbingan_mahasiswa: {str(e)}")
        flash('Terjadi kesalahan saat memuat halaman!', 'danger')
        return render_template('pembimbing/daftar_bimbingan_mahasiswa.html', mahasiswa_bimbingan=[])

@pembimbing_bp.route('/bimbingan_mahasiswa/<int:mahasiswa_id>')
def bimbingan_mahasiswa(mahasiswa_id):
    """Halaman hasil bimbingan mahasiswa"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        flash('Anda harus login sebagai pembimbing!', 'danger')
        return redirect(url_for('index'))
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        flash('Koneksi ke database gagal. Cek konfigurasi database!', 'danger')
        return render_template('pembimbing/bimbingan_mahasiswa.html', mahasiswa_info=None, riwayat_bimbingan=[])
    
    try:
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data mahasiswa yang dibimbing oleh pembimbing ini
        cursor.execute('''
            SELECT m.*, p.judul_usaha, p.id as proposal_id
            FROM mahasiswa m
            JOIN proposal p ON m.nim = p.nim
            WHERE m.id = %s AND p.dosen_pembimbing = %s AND p.status_admin = 'lolos'
        ''', (mahasiswa_id, session['nama']))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan atau Anda tidak memiliki akses!', 'danger')
            cursor.close()
            return redirect(url_for('pembimbing.daftar_bimbingan_mahasiswa'))
        
        # Ambil riwayat bimbingan mahasiswa
        cursor.execute('''
            SELECT b.*, p.judul_usaha, p.dosen_pembimbing
            FROM bimbingan b
            JOIN proposal p ON b.proposal_id = p.id
            WHERE b.nim = %s
            ORDER BY b.tanggal_buat DESC
        ''', (mahasiswa_info['nim'],))
        
        riwayat_bimbingan = cursor.fetchall()
        cursor.close()
        
        return render_template('pembimbing/bimbingan_mahasiswa.html', 
                             mahasiswa_info=mahasiswa_info,
                             riwayat_bimbingan=riwayat_bimbingan)
        
    except Exception as e:
        logger.error(f"Error in bimbingan_mahasiswa: {str(e)}")
        flash('Terjadi kesalahan saat memuat halaman!', 'danger')
        return render_template('pembimbing/bimbingan_mahasiswa.html', mahasiswa_info=None, riwayat_bimbingan=[])

@pembimbing_bp.route('/detail_bimbingan')
def detail_bimbingan():
    """API untuk mendapatkan detail bimbingan"""
    if 'user_type' not in session or session['user_type'] != 'pembimbing':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai pembimbing!'})
    
    app_funcs = get_app_functions()
    if not hasattr(app_funcs['mysql'], 'connection') or app_funcs['mysql'].connection is None:
        return jsonify({'success': False, 'message': 'Koneksi ke database gagal!'})
    
    try:
        bimbingan_id = request.args.get('id')
        if not bimbingan_id:
            return jsonify({'success': False, 'message': 'ID bimbingan tidak ditemukan!'})
        
        cursor = app_funcs['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil detail bimbingan dengan validasi pembimbing
        cursor.execute('''
            SELECT b.*, p.judul_usaha, p.dosen_pembimbing, m.nama_ketua, m.nim
            FROM bimbingan b
            JOIN proposal p ON b.proposal_id = p.id
            JOIN mahasiswa m ON b.nim = m.nim
            WHERE b.id = %s AND p.dosen_pembimbing = %s
        ''', (bimbingan_id, session['nama']))
        
        bimbingan = cursor.fetchone()
        if not bimbingan:
            cursor.close()
            return jsonify({'success': False, 'message': 'Data bimbingan tidak ditemukan!'})
        
        cursor.close()
        
        # Generate HTML untuk modal
        html = f'''
        <div class="row">
            <div class="col-12">
                <div class="mb-3">
                    <h6 class="text-primary">
                        <i class="bi bi-info-circle"></i>
                        Informasi Bimbingan:
                    </h6>
                    <div class="row">
                        <div class="col-md-6">
                            <p><strong>Mahasiswa:</strong> {bimbingan['nama_ketua']} ({bimbingan['nim']})</p>
                            <p><strong>Judul Usaha:</strong> {bimbingan['judul_usaha']}</p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Dosen Pembimbing:</strong> {bimbingan['dosen_pembimbing']}</p>
                            <p><strong>Tanggal Buat:</strong> {bimbingan['tanggal_buat'].strftime('%d/%m/%Y %H:%M') if bimbingan['tanggal_buat'] else '-'}</p>
                        </div>
                    </div>
                </div>
                
                <div class="mb-3">
                    <h6 class="text-primary">
                        <i class="bi bi-type-bold"></i>
                        Judul/Topik Bimbingan:
                    </h6>
                    <div class="hasil-bimbingan-content">
                        <strong>{bimbingan['judul_bimbingan']}</strong>
                    </div>
                </div>
                
                <div class="mb-3">
                    <h6 class="text-success">
                        <i class="bi bi-pencil-square"></i>
                        Hasil Bimbingan:
                    </h6>
                    <div class="hasil-bimbingan-content">
                        {bimbingan['hasil_bimbingan']}
                    </div>
                </div>
            </div>
        </div>
        '''
        
        return jsonify({
            'success': True,
            'html': html
        })
        
    except Exception as e:
        logger.error(f"Error in detail_bimbingan: {str(e)}")
        return jsonify({'success': False, 'message': f'Error: {str(e)}'})


