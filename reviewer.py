from flask import Blueprint, render_template, request, jsonify, session, flash, redirect, url_for, send_file, send_from_directory
import MySQLdb
import os
import logging
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta
import json
from utils import flatten_anggaran_data
import mimetypes
from werkzeug.utils import secure_filename
# Import app_functions akan dihandle di dalam fungsi get_app_functions()

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

reviewer_bp = Blueprint('reviewer', __name__)

def get_app_functions():
    from app import mysql
    return {'mysql': mysql}

def get_pertanyaan_proposal_snapshot(cursor):
    """
    Helper function untuk mendapatkan pertanyaan proposal berdasarkan snapshot jadwal
    
    Logic:
    1. Jika ada jadwal aktif, gunakan pertanyaan yang aktif pada saat jadwal mulai
    2. Jika jadwal sudah selesai, gunakan pertanyaan yang aktif pada saat jadwal mulai  
    3. Jika tidak ada jadwal, gunakan pertanyaan yang aktif saat ini
    4. Pertanyaan baru atau yang diedit setelah jadwal mulai tidak akan muncul sampai ada jadwal baru
    """
    try:
        # Cek apakah ada jadwal reviewer proposal
        cursor.execute('''
            SELECT reviewer_proposal_mulai, reviewer_proposal_selesai
            FROM pengaturan_jadwal 
            ORDER BY id DESC 
            LIMIT 1
        ''')
        
        jadwal = cursor.fetchone()
        
        if jadwal and jadwal['reviewer_proposal_mulai']:
            jadwal_mulai = jadwal['reviewer_proposal_mulai']
            
            # Cek apakah ada pertanyaan yang dibuat sebelum jadwal mulai
            cursor.execute('''
                SELECT COUNT(*) as count
                FROM pertanyaan_penilaian_proposal
                WHERE is_active = TRUE AND created_at <= %s
            ''', (jadwal_mulai,))
            
            count_result = cursor.fetchone()
            pertanyaan_sebelum_jadwal = count_result['count'] if count_result else 0
            
            if pertanyaan_sebelum_jadwal > 0:
                # Gunakan pertanyaan yang aktif pada saat jadwal mulai
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, is_active
                    FROM pertanyaan_penilaian_proposal
                    WHERE is_active = TRUE AND created_at <= %s
                    ORDER BY created_at ASC
                ''', (jadwal_mulai,))
                
                logger.info(f"Proposal: Menggunakan snapshot pertanyaan pada jadwal mulai: {jadwal_mulai}")
            else:
                # Fallback: gunakan pertanyaan aktif saat ini
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, is_active
                    FROM pertanyaan_penilaian_proposal
                    WHERE is_active = TRUE
                    ORDER BY created_at ASC
                ''')
                
                logger.info(f"Proposal: Tidak ada pertanyaan sebelum jadwal mulai ({jadwal_mulai}), menggunakan pertanyaan aktif saat ini")
        else:
            # Jika tidak ada jadwal, gunakan pertanyaan aktif saat ini
            cursor.execute('''
                SELECT id, pertanyaan, bobot, skor_maksimal, is_active
                FROM pertanyaan_penilaian_proposal
                WHERE is_active = TRUE
                ORDER BY created_at ASC
            ''')
            
            logger.info("Proposal: Tidak ada jadwal, menggunakan pertanyaan aktif saat ini")
        
        return cursor.fetchall()
        
    except Exception as e:
        logger.error(f"Error dalam get_pertanyaan_proposal_snapshot: {str(e)}")
        return []

def get_pertanyaan_laporan_kemajuan_snapshot(cursor):
    """
    Helper function untuk mendapatkan pertanyaan laporan kemajuan berdasarkan snapshot jadwal
    """
    try:
        # Cek apakah ada jadwal reviewer laporan kemajuan
        cursor.execute('''
            SELECT reviewer_kemajuan_mulai, reviewer_kemajuan_selesai
            FROM pengaturan_jadwal 
            ORDER BY id DESC 
            LIMIT 1
        ''')
        
        jadwal = cursor.fetchone()
        
        if jadwal and jadwal['reviewer_kemajuan_mulai']:
            jadwal_mulai = jadwal['reviewer_kemajuan_mulai']
            
            # Cek apakah ada pertanyaan yang dibuat sebelum jadwal mulai
            cursor.execute('''
                SELECT COUNT(*) as count
                FROM pertanyaan_penilaian_laporan_kemajuan
                WHERE status = 'Aktif' AND created_at <= %s
            ''', (jadwal_mulai,))
            
            count_result = cursor.fetchone()
            pertanyaan_sebelum_jadwal = count_result['count'] if count_result else 0
            
            if pertanyaan_sebelum_jadwal > 0:
                # Gunakan pertanyaan yang aktif pada saat jadwal mulai
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, status
                    FROM pertanyaan_penilaian_laporan_kemajuan
                    WHERE status = 'Aktif' AND created_at <= %s
                    ORDER BY created_at ASC
                ''', (jadwal_mulai,))
                
                logger.info(f"Laporan Kemajuan: Menggunakan snapshot pertanyaan pada jadwal mulai: {jadwal_mulai}")
            else:
                # Fallback: gunakan pertanyaan aktif saat ini
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, status
                    FROM pertanyaan_penilaian_laporan_kemajuan
                    WHERE status = 'Aktif'
                    ORDER BY created_at ASC
                ''')
                
                logger.info(f"Laporan Kemajuan: Tidak ada pertanyaan sebelum jadwal mulai ({jadwal_mulai}), menggunakan pertanyaan aktif saat ini")
        else:
            # Jika tidak ada jadwal, gunakan pertanyaan aktif saat ini
            cursor.execute('''
                SELECT id, pertanyaan, bobot, skor_maksimal, status
                FROM pertanyaan_penilaian_laporan_kemajuan
                WHERE status = 'Aktif'
                ORDER BY created_at ASC
            ''')
            
            logger.info("Laporan Kemajuan: Tidak ada jadwal, menggunakan pertanyaan aktif saat ini")
        
        return cursor.fetchall()
        
    except Exception as e:
        logger.error(f"Error dalam get_pertanyaan_laporan_kemajuan_snapshot: {str(e)}")
        return []

def get_pertanyaan_laporan_akhir_snapshot(cursor):
    """
    Helper function untuk mendapatkan pertanyaan laporan akhir berdasarkan snapshot jadwal
    """
    try:
        # Cek apakah ada jadwal reviewer laporan akhir
        cursor.execute('''
            SELECT reviewer_akhir_mulai, reviewer_akhir_selesai
            FROM pengaturan_jadwal 
            ORDER BY id DESC 
            LIMIT 1
        ''')
        
        jadwal = cursor.fetchone()
        
        if jadwal and jadwal['reviewer_akhir_mulai']:
            jadwal_mulai = jadwal['reviewer_akhir_mulai']
            
            # Cek apakah ada pertanyaan yang dibuat sebelum jadwal mulai
            cursor.execute('''
                SELECT COUNT(*) as count
                FROM pertanyaan_penilaian_laporan_akhir
                WHERE status = 'Aktif' AND created_at <= %s
            ''', (jadwal_mulai,))
            
            count_result = cursor.fetchone()
            pertanyaan_sebelum_jadwal = count_result['count'] if count_result else 0
            
            if pertanyaan_sebelum_jadwal > 0:
                # Gunakan pertanyaan yang aktif pada saat jadwal mulai
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, urutan, status
                    FROM pertanyaan_penilaian_laporan_akhir
                    WHERE status = 'Aktif' AND created_at <= %s
                    ORDER BY urutan ASC, created_at ASC
                ''', (jadwal_mulai,))
                
                logger.info(f"Laporan Akhir: Menggunakan snapshot pertanyaan pada jadwal mulai: {jadwal_mulai}")
            else:
                # Fallback: gunakan pertanyaan aktif saat ini
                cursor.execute('''
                    SELECT id, pertanyaan, bobot, skor_maksimal, urutan, status
                    FROM pertanyaan_penilaian_laporan_akhir
                    WHERE status = 'Aktif'
                    ORDER BY urutan ASC, created_at ASC
                ''')
                
                logger.info(f"Laporan Akhir: Tidak ada pertanyaan sebelum jadwal mulai ({jadwal_mulai}), menggunakan pertanyaan aktif saat ini")
        else:
            # Jika tidak ada jadwal, gunakan pertanyaan aktif saat ini
            cursor.execute('''
                SELECT id, pertanyaan, bobot, skor_maksimal, urutan, status
                FROM pertanyaan_penilaian_laporan_akhir
                WHERE status = 'Aktif'
                ORDER BY urutan ASC, created_at ASC
            ''')
            
            logger.info("Laporan Akhir: Tidak ada jadwal, menggunakan pertanyaan aktif saat ini")
        
        return cursor.fetchall()
        
    except Exception as e:
        logger.error(f"Error dalam get_pertanyaan_laporan_akhir_snapshot: {str(e)}")
        return []

def get_jadwal_reviewer_status(jenis_review):
    """Mendapatkan status jadwal review berdasarkan jenis review"""
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil jadwal dari tabel pengaturan_jadwal
        cursor.execute('''
            SELECT 
                reviewer_proposal_mulai, reviewer_proposal_selesai,
                reviewer_kemajuan_mulai, reviewer_kemajuan_selesai,
                reviewer_akhir_mulai, reviewer_akhir_selesai
            FROM pengaturan_jadwal 
            ORDER BY id DESC 
            LIMIT 1
        ''')
        
        jadwal = cursor.fetchone()
        if not jadwal:
            return {
                'status': 'tidak ada jadwal',
                'pesan': 'Belum ada jadwal review yang diatur',
                'bisa_review': True  # Jika tidak ada jadwal, bisa review
            }
        
        now = datetime.now()
        
        if jenis_review == 'proposal':
            mulai = jadwal['reviewer_proposal_mulai']
            selesai = jadwal['reviewer_proposal_selesai']
        elif jenis_review == 'laporan_kemajuan':
            mulai = jadwal['reviewer_kemajuan_mulai']
            selesai = jadwal['reviewer_kemajuan_selesai']
        elif jenis_review == 'laporan_akhir':
            mulai = jadwal['reviewer_akhir_mulai']
            selesai = jadwal['reviewer_akhir_selesai']
        else:
            return {'status': 'error', 'pesan': 'Jenis review tidak valid', 'bisa_review': False}
        
        if not mulai or not selesai:
            return {
                'status': 'tidak ada jadwal',
                'pesan': f'Jadwal {jenis_review} belum diatur',
                'bisa_review': True
            }
        
        # Konversi ke datetime jika string
        if isinstance(mulai, str):
            mulai = datetime.strptime(mulai, '%Y-%m-%d %H:%M:%S')
        if isinstance(selesai, str):
            selesai = datetime.strptime(selesai, '%Y-%m-%d %H:%M:%S')
        
        if now < mulai:
            return {
                'status': 'belum_mulai',
                'pesan': f'Jadwal review {jenis_review} belum dimulai',
                'bisa_review': False,
                'jadwal_mulai': mulai,
                'jadwal_selesai': selesai
            }
        elif now > selesai:
            return {
                'status': 'sudah_selesai',
                'pesan': f'Jadwal review {jenis_review} sudah berakhir',
                'bisa_review': False,
                'jadwal_mulai': mulai,
                'jadwal_selesai': selesai
            }
        else:
            return {
                'status': 'aktif',
                'pesan': f'Jadwal review {jenis_review} sedang berlangsung',
                'bisa_review': True,
                'jadwal_mulai': mulai,
                'jadwal_selesai': selesai
            }
            
    except Exception as e:
        return {'status': 'error', 'pesan': str(e), 'bisa_review': False}
    finally:
        if 'cursor' in locals():
            cursor.close()

@reviewer_bp.route('/dashboard')
def dashboard():
    logger.info("Dashboard reviewer dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        logger.warning(f"Akses ditolak untuk dashboard reviewer: {session.get('user_type', 'None')}")
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data reviewer
        reviewer_id = session.get('user_id')
        
        # Hitung statistik berdasarkan status review anggaran
        cursor.execute('''
            SELECT 
                COUNT(DISTINCT pr.id_proposal) as total_proposal,
                COUNT(DISTINCT CASE 
                    WHEN (aa.status_reviewer = 'belum_direview' OR ab.status_reviewer = 'belum_direview' OR 
                          (aa.status_reviewer IS NULL AND ab.status_reviewer IS NULL))
                    THEN pr.id_proposal 
                END) as belum_direview,
                COUNT(DISTINCT CASE 
                    WHEN (aa.status_reviewer = 'sudah_direview' OR ab.status_reviewer = 'sudah_direview')
                    AND (aa.status_reviewer != 'selesai_review' AND ab.status_reviewer != 'selesai_review')
                    THEN pr.id_proposal 
                END) as sedang_direview,
                COUNT(DISTINCT CASE 
                    WHEN pr.status_review = 'selesai_review'
                    THEN pr.id_proposal 
                END) as selesai_review
            FROM proposal_reviewer pr
            LEFT JOIN anggaran_awal aa ON pr.id_proposal = aa.id_proposal
            LEFT JOIN anggaran_bertumbuh ab ON pr.id_proposal = ab.id_proposal
            WHERE pr.id_reviewer = %s
        ''', (reviewer_id,))
        
        stats = cursor.fetchone()
        
        # Ambil proposal terbaru dengan informasi lengkap
        cursor.execute('''
            SELECT pr.id_proposal, pr.status_review, pr.tanggal_assign,
                   p.judul_usaha, m.nama_ketua, p.nim, p.kategori, p.tahapan_usaha,
                   p.dosen_pembimbing,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'sudah_direview') as anggaran_awal_reviewed,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'sudah_direview') as anggaran_bertumbuh_reviewed,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal) as total_anggaran_awal,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal) as total_anggaran_bertumbuh,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'tolak_bantuan') as anggaran_awal_ditolak,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'tolak_bantuan') as anggaran_bertumbuh_ditolak
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE pr.id_reviewer = %s
            ORDER BY pr.tanggal_assign DESC
            LIMIT 5
        ''', (reviewer_id,))
        
        recent_proposals = cursor.fetchall()
        
        # Format tanggal untuk proposal terbaru
        for proposal in recent_proposals:
            if proposal['tanggal_assign']:
                proposal['tanggal_assign'] = proposal['tanggal_assign'].strftime('%d/%m/%Y %H:%M')
        
        cursor.close()
        
        return render_template('reviewer/index reviewer.html', 
                             stats=stats, 
                             recent_proposals=recent_proposals)
        
    except Exception as e:
        logger.error(f"Error saat mengambil data dashboard reviewer: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data dashboard!', 'danger')
        return render_template('reviewer/index reviewer.html', 
                             stats={'total_proposal': 0, 'belum_direview': 0, 'sedang_direview': 0, 'selesai_review': 0}, 
                             recent_proposals=[])

@reviewer_bp.route('/proposal')
def proposal():
    logger.info("Halaman proposal reviewer dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        logger.warning(f"Akses ditolak untuk halaman proposal reviewer: {session.get('user_type', 'None')}")
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Ambil data proposal yang ditugaskan ke reviewer ini
        reviewer_id = session.get('user_id')
        
        cursor.execute('''
            SELECT pr.id_proposal, pr.status_review, pr.tanggal_assign,
                   p.judul_usaha, m.nama_ketua, p.nim, p.kategori, p.tahapan_usaha,
                   m.program_studi, m.perguruan_tinggi, p.dosen_pembimbing,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'sudah_direview') as anggaran_awal_reviewed,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'sudah_direview') as anggaran_bertumbuh_reviewed,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal) as total_anggaran_awal,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal) as total_anggaran_bertumbuh,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status = 'revisi' AND (aa.status_reviewer IS NULL OR aa.status_reviewer NOT IN ('sudah_direview','tolak_bantuan'))) as anggaran_awal_revisi,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status = 'revisi' AND (ab.status_reviewer IS NULL OR ab.status_reviewer NOT IN ('sudah_direview','tolak_bantuan'))) as anggaran_bertumbuh_revisi,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'tolak_bantuan') as anggaran_awal_ditolak,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'tolak_bantuan') as anggaran_bertumbuh_ditolak,
                   (SELECT COUNT(*) FROM penilaian_proposal pp 
                    WHERE pp.id_proposal = pr.id_proposal AND pp.id_reviewer = pr.id_reviewer) as sudah_dinilai
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE pr.id_reviewer = %s
            ORDER BY pr.tanggal_assign DESC
        ''', (reviewer_id,))
        
        proposals = cursor.fetchall()
        
        # Update status proposal berdasarkan progress review anggaran untuk setiap proposal
        for proposal in proposals:
            # Update status untuk proposal ini
            update_proposal_status_based_on_anggaran_progress(cursor, proposal['id_proposal'], reviewer_id, None)
        
        # Ambil ulang data proposal setelah update status
        cursor.execute('''
            SELECT pr.id_proposal, pr.status_review, pr.tanggal_assign,
                   p.judul_usaha, m.nama_ketua, p.nim, p.kategori, p.tahapan_usaha,
                   m.program_studi, m.perguruan_tinggi, p.dosen_pembimbing,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'sudah_direview') as anggaran_awal_reviewed,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'sudah_direview') as anggaran_bertumbuh_reviewed,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal) as total_anggaran_awal,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal) as total_anggaran_bertumbuh,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status = 'revisi' AND (aa.status_reviewer IS NULL OR aa.status_reviewer NOT IN ('sudah_direview','tolak_bantuan'))) as anggaran_awal_revisi,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status = 'revisi' AND (ab.status_reviewer IS NULL OR ab.status_reviewer NOT IN ('sudah_direview','tolak_bantuan'))) as anggaran_bertumbuh_revisi,
                   (SELECT COUNT(*) FROM anggaran_awal aa 
                    WHERE aa.id_proposal = pr.id_proposal AND aa.status_reviewer = 'tolak_bantuan') as anggaran_awal_ditolak,
                   (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                    WHERE ab.id_proposal = pr.id_proposal AND ab.status_reviewer = 'tolak_bantuan') as anggaran_bertumbuh_ditolak,
                   (SELECT COUNT(*) FROM penilaian_proposal pp 
                    WHERE pp.id_proposal = pr.id_proposal AND pp.id_reviewer = pr.id_reviewer) as sudah_dinilai
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE pr.id_reviewer = %s
            ORDER BY pr.tanggal_assign DESC
        ''', (reviewer_id,))
        
        proposals = cursor.fetchall()
        
        # Commit perubahan status
        get_app_functions()['mysql'].connection.commit()
        
        # Format tanggal
        for proposal in proposals:
            if proposal['tanggal_assign']:
                proposal['tanggal_assign'] = proposal['tanggal_assign'].strftime('%d/%m/%Y %H:%M')
        
        cursor.close()
        
        # Tambahkan status jadwal untuk proposal
        jadwal_proposal = get_jadwal_reviewer_status('proposal')
        
        return render_template('reviewer/proposal.html', 
                             proposals=proposals,
                             jadwal_proposal=jadwal_proposal)
        
    except Exception as e:
        logger.error(f"Error saat mengambil data proposal reviewer: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data proposal!', 'danger')
        return render_template('reviewer/proposal.html', proposals=[])

@reviewer_bp.route('/proposal_detail/<int:proposal_id>')
def proposal_detail(proposal_id):
    logger.info(f"Detail proposal reviewer dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Ambil detail proposal
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.email, m.no_telp, m.program_studi, m.perguruan_tinggi,
                   m.nim, m.id as mahasiswa_id, p.status as status_proposal
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        proposal = cursor.fetchone()
        
        # Ambil anggota tim
        cursor.execute('''
            SELECT a.*, m.nama_ketua as nama, m.email, m.program_studi, m.perguruan_tinggi
            FROM anggota_tim a
            JOIN mahasiswa m ON a.nim = m.nim
            WHERE a.id_proposal = %s
        ''', (proposal_id,))
        
        anggota = cursor.fetchall()
        
        # Hitung anggaran
        cursor.execute('SELECT COUNT(*) as count FROM anggaran_awal WHERE id_proposal = %s', (proposal_id,))
        anggaran_awal_count = cursor.fetchone()['count']
        
        cursor.execute('SELECT COUNT(*) as count FROM anggaran_bertumbuh WHERE id_proposal = %s', (proposal_id,))
        anggaran_bertumbuh_count = cursor.fetchone()['count']
        
        cursor.close()
        
        # Redirect ke halaman proposal karena template proposal_detail.html tidak ada
        flash('Detail proposal akan ditampilkan di halaman proposal', 'info')
        return redirect(url_for('reviewer.proposal'))
        
    except Exception as e:
        logger.error(f"Error saat mengambil detail proposal: {str(e)}")
        flash('Terjadi kesalahan saat mengambil detail proposal!', 'danger')
        return redirect(url_for('reviewer.proposal'))

@reviewer_bp.route('/anggaran_awal/<int:proposal_id>')
def anggaran_awal(proposal_id):
    logger.info(f"Anggaran awal reviewer dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Debug: cek semua proposal yang ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT pr.id_proposal, pr.id_reviewer, p.judul_usaha, p.tahapan_usaha
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            WHERE pr.id_reviewer = %s
        ''', (reviewer_id,))
        all_assignments = cursor.fetchall()
        logger.info(f"Semua proposal yang ditugaskan ke reviewer {reviewer_id}: {len(all_assignments)}")
        for assignment in all_assignments:
            logger.info(f"Proposal ID: {assignment['id_proposal']}, Judul: {assignment['judul_usaha']}, Tahapan: {assignment['tahapan_usaha']}")
        
        # Cek apakah proposal ditugaskan ke reviewer ini dan ambil info proposal
        cursor.execute('''
            SELECT pr.*, p.judul_usaha, p.tahapan_usaha 
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            WHERE pr.id_proposal = %s AND pr.id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Log tahapan usaha proposal untuk debugging
        tahapan_usaha = assignment['tahapan_usaha']
        logger.info(f"Tahapan usaha proposal {proposal_id}: {tahapan_usaha}")
        
        # Untuk sementara, hapus validasi tahapan usaha agar data bisa ditampilkan
        # if 'awal' not in tahapan_usaha.lower():
        #     flash(f'Proposal ini adalah "{tahapan_usaha}", bukan Usaha Awal!', 'warning')
        #     return redirect(url_for('reviewer.proposal'))
        
        # Debug: cek semua data anggaran awal untuk proposal ini
        cursor.execute('''
            SELECT id, id_proposal, status, kegiatan_utama, kegiatan
            FROM anggaran_awal 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        all_anggaran = cursor.fetchall()
        logger.info(f"Semua data anggaran awal untuk proposal {proposal_id}: {len(all_anggaran)}")
        for anggaran in all_anggaran:
            logger.info(f"ID: {anggaran['id']}, Status: {anggaran['status']}, Kegiatan: {anggaran['kegiatan']}")
        
        # Ambil data anggaran awal dengan status disetujui
        cursor.execute('''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status,
                   nilai_bantuan, status_reviewer, tanggal_review_reviewer
            FROM anggaran_awal 
            WHERE id_proposal = %s AND status = 'disetujui'
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        anggaran_data = cursor.fetchall()
        logger.info(f"Jumlah data anggaran awal untuk proposal {proposal_id}: {len(anggaran_data)}")
        
        # Debug: log beberapa data anggaran
        if anggaran_data:
            for i, anggaran in enumerate(anggaran_data[:3]):  # Log 3 data pertama
                logger.info(f"Anggaran {i+1}: ID={anggaran['id']}, Status={anggaran['status']}, Kegiatan={anggaran['kegiatan']}")
        else:
            logger.warning(f"Tidak ada data anggaran awal untuk proposal {proposal_id}")
        
        # Urutkan data sesuai urutan kegiatan utama
        if 'bertumbuh' in tahapan_usaha.lower():
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
        
        # Sort data berdasarkan urutan kegiatan utama
        anggaran_data = sorted(
            anggaran_data,
            key=lambda x: urutan_kegiatan.index(x['kegiatan_utama']) if x['kegiatan_utama'] in urutan_kegiatan else 99
        )
        
        # Flatten data untuk tabel dengan rowspan
        if anggaran_data:
            anggaran_data_flat = flatten_anggaran_data(anggaran_data)
            logger.info(f"Data berhasil di-flatten menjadi {len(anggaran_data_flat)} baris")
            
            # Debug: Log detail data yang akan dikirim ke template
            logger.info("=== DETAIL DATA ANGGARAN AWAL FLAT ===")
            for i, row in enumerate(anggaran_data_flat):
                logger.info(f"Row {i+1}: kegiatan_utama='{row.get('kegiatan_utama', 'N/A')}', kegiatan='{row.get('kegiatan', 'N/A')}', nama_barang='{row.get('nama_barang', 'N/A')}', jumlah={row.get('jumlah', 'N/A')}, nilai_bantuan={row.get('nilai_bantuan', 'N/A')}")
            logger.info("=====================================")
        else:
            anggaran_data_flat = []
            logger.warning("Tidak ada data anggaran untuk di-flatten")
        
        # Hitung total nilai bantuan yang sudah direview
        total_nilai_bantuan = sum(row.get('nilai_bantuan', 0) for row in anggaran_data) if anggaran_data else 0
        logger.info(f"Total nilai bantuan anggaran awal: {total_nilai_bantuan}")
        
        # Info proposal sudah diambil dari query di atas
        proposal_info = {
            'judul_usaha': assignment['judul_usaha'],
            'tahapan_usaha': assignment['tahapan_usaha']
        }
        
        cursor.close()
        
        # Debug: log urutan kegiatan dan data yang diurutkan
        logger.info(f"Urutan kegiatan untuk {tahapan_usaha}: {urutan_kegiatan}")
        if anggaran_data:
            logger.info("Data anggaran setelah diurutkan:")
            for i, anggaran in enumerate(anggaran_data):
                logger.info(f"  {i+1}. {anggaran['kegiatan_utama']} - {anggaran['kegiatan']}")
        else:
            logger.info("Tidak ada data anggaran untuk diurutkan")
        
        # Summary log
        logger.info(f"=== SUMMARY ANGGARAN AWAL PROPOSAL {proposal_id} ===")
        logger.info(f"Total Nilai Bantuan: {total_nilai_bantuan}")
        logger.info(f"Jumlah Data Anggaran: {len(anggaran_data)}")
        logger.info(f"Jumlah Data Flat: {len(anggaran_data_flat)}")
        logger.info(f"================================================")
        
        logger.info(f"Rendering template anggaran awal dengan {len(anggaran_data_flat)} data")
        # Ambil batas untuk badge informatif seperti mahasiswa
        try:
            cur2 = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur2.execute('SELECT * FROM pengaturan_anggaran ORDER BY id DESC LIMIT 1')
            batas_row = cur2.fetchone() or {}
            batas_min_awal = int(batas_row.get('min_total_awal') or 0)
            batas_max_awal = int(batas_row.get('max_total_awal') or 0)
            cur2.close()
        except Exception:
            batas_min_awal = 0
            batas_max_awal = 0
        return render_template('reviewer/pengajuan anggaran awal.html',
                             anggaran_data_flat=anggaran_data_flat,
                             proposal_id=proposal_id,
                             proposal_info=proposal_info,
                             batas_min_awal=batas_min_awal,
                             batas_max_awal=batas_max_awal,
                             total_nilai_bantuan=total_nilai_bantuan)
        
    except Exception as e:
        logger.error(f"Error saat mengambil anggaran awal: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data anggaran!', 'danger')
        return redirect(url_for('reviewer.proposal'))

@reviewer_bp.route('/anggaran_bertumbuh/<int:proposal_id>')
def anggaran_bertumbuh(proposal_id):
    logger.info(f"Anggaran bertumbuh reviewer dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Debug: cek semua proposal yang ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT pr.id_proposal, pr.id_reviewer, p.judul_usaha, p.tahapan_usaha
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            WHERE pr.id_reviewer = %s
        ''', (reviewer_id,))
        all_assignments = cursor.fetchall()
        logger.info(f"Semua proposal yang ditugaskan ke reviewer {reviewer_id}: {len(all_assignments)}")
        for assignment in all_assignments:
            logger.info(f"Proposal ID: {assignment['id_proposal']}, Judul: {assignment['judul_usaha']}, Tahapan: {assignment['tahapan_usaha']}")
        
        # Cek apakah proposal ditugaskan ke reviewer ini dan ambil info proposal
        cursor.execute('''
            SELECT pr.*, p.judul_usaha, p.tahapan_usaha 
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            WHERE pr.id_proposal = %s AND pr.id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Log tahapan usaha proposal untuk debugging
        tahapan_usaha = assignment['tahapan_usaha']
        logger.info(f"Tahapan usaha proposal {proposal_id}: {tahapan_usaha}")
        
        # Untuk sementara, hapus validasi tahapan usaha agar data bisa ditampilkan
        # if 'bertumbuh' not in tahapan_usaha.lower():
        #     flash(f'Proposal ini adalah "{tahapan_usaha}", bukan Usaha Bertumbuh!', 'warning')
        #     return redirect(url_for('reviewer.proposal'))
        
        # Debug: cek semua data anggaran bertumbuh untuk proposal ini
        cursor.execute('''
            SELECT id, id_proposal, status, kegiatan_utama, kegiatan
            FROM anggaran_bertumbuh 
            WHERE id_proposal = %s
        ''', (proposal_id,))
        all_anggaran = cursor.fetchall()
        logger.info(f"Semua data anggaran bertumbuh untuk proposal {proposal_id}: {len(all_anggaran)}")
        for anggaran in all_anggaran:
            logger.info(f"ID: {anggaran['id']}, Status: {anggaran['status']}, Kegiatan: {anggaran['kegiatan']}")
        
        # Ambil data anggaran bertumbuh dengan status disetujui
        cursor.execute('''
            SELECT id, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian, 
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status,
                   nilai_bantuan, status_reviewer, tanggal_review_reviewer
            FROM anggaran_bertumbuh 
            WHERE id_proposal = %s AND status = 'disetujui'
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        anggaran_data = cursor.fetchall()
        logger.info(f"Jumlah data anggaran bertumbuh untuk proposal {proposal_id}: {len(anggaran_data)}")
        
        # Debug: log beberapa data anggaran
        if anggaran_data:
            for i, anggaran in enumerate(anggaran_data[:3]):  # Log 3 data pertama
                logger.info(f"Anggaran {i+1}: ID={anggaran['id']}, Status={anggaran['status']}, Kegiatan={anggaran['kegiatan']}")
        else:
            logger.warning(f"Tidak ada data anggaran bertumbuh untuk proposal {proposal_id}")
        
        # Urutkan data sesuai urutan kegiatan utama
        if 'bertumbuh' in tahapan_usaha.lower():
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
        
        # Sort data berdasarkan urutan kegiatan utama
        anggaran_data = sorted(
            anggaran_data,
            key=lambda x: urutan_kegiatan.index(x['kegiatan_utama']) if x['kegiatan_utama'] in urutan_kegiatan else 99
        )
        
        # Flatten data untuk tabel dengan rowspan
        if anggaran_data:
            anggaran_data_flat = flatten_anggaran_data(anggaran_data)
            logger.info(f"Data berhasil di-flatten menjadi {len(anggaran_data_flat)} baris")
            
            # Debug: Log detail data yang akan dikirim ke template
            logger.info("=== DETAIL DATA ANGGARAN BERTUMBUH FLAT ===")
            for i, row in enumerate(anggaran_data_flat):
                logger.info(f"Row {i+1}: kegiatan_utama='{row.get('kegiatan_utama', 'N/A')}', kegiatan='{row.get('kegiatan', 'N/A')}', nama_barang='{row.get('nama_barang', 'N/A')}', jumlah={row.get('jumlah', 'N/A')}, nilai_bantuan={row.get('nilai_bantuan', 'N/A')}")
            logger.info("=====================================")
        else:
            anggaran_data_flat = []
            logger.warning("Tidak ada data anggaran untuk di-flatten")
        
        # Hitung total nilai bantuan yang sudah direview
        total_nilai_bantuan = sum(row.get('nilai_bantuan', 0) for row in anggaran_data) if anggaran_data else 0
        logger.info(f"Total nilai bantuan anggaran bertumbuh: {total_nilai_bantuan}")
        
        # Info proposal sudah diambil dari query di atas
        proposal_info = {
            'judul_usaha': assignment['judul_usaha'],
            'tahapan_usaha': assignment['tahapan_usaha']
        }
        
        cursor.close()
        
        # Debug: log urutan kegiatan dan data yang diurutkan
        logger.info(f"Urutan kegiatan untuk {tahapan_usaha}: {urutan_kegiatan}")
        if anggaran_data:
            logger.info("Data anggaran setelah diurutkan:")
            for i, anggaran in enumerate(anggaran_data):
                logger.info(f"  {i+1}. {anggaran['kegiatan_utama']} - {anggaran['kegiatan']}")
        else:
            logger.info("Tidak ada data anggaran untuk diurutkan")
        
        # Summary log
        logger.info(f"=== SUMMARY ANGGARAN BERTUMBUH PROPOSAL {proposal_id} ===")
        logger.info(f"Total Nilai Bantuan: {total_nilai_bantuan}")
        logger.info(f"Jumlah Data Anggaran: {len(anggaran_data)}")
        logger.info(f"Jumlah Data Flat: {len(anggaran_data_flat)}")
        logger.info(f"================================================")
        
        logger.info(f"Rendering template anggaran bertumbuh dengan {len(anggaran_data_flat)} data")
        # Ambil batas untuk badge informatif seperti mahasiswa
        try:
            cur2 = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cur2.execute('SELECT * FROM pengaturan_anggaran ORDER BY id DESC LIMIT 1')
            batas_row = cur2.fetchone() or {}
            batas_min_bertumbuh = int(batas_row.get('min_total_bertumbuh') or 0)
            batas_max_bertumbuh = int(batas_row.get('max_total_bertumbuh') or 0)
            cur2.close()
        except Exception:
            batas_min_bertumbuh = 0
            batas_max_bertumbuh = 0

        return render_template('reviewer/pengajuan anggaran bertumbuh.html',
                             anggaran_data_flat=anggaran_data_flat,
                             proposal_id=proposal_id,
                             proposal_info=proposal_info,
                             batas_min_bertumbuh=batas_min_bertumbuh,
                             batas_max_bertumbuh=batas_max_bertumbuh,
                             total_nilai_bantuan=total_nilai_bantuan)
        
    except Exception as e:
        logger.error(f"Error saat mengambil anggaran bertumbuh: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data anggaran!', 'danger')
        return redirect(url_for('reviewer.proposal'))

@reviewer_bp.route('/update_review_status', methods=['POST'])
def update_review_status():
    logger.info("Update review status dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        data = request.get_json()
        proposal_id = data.get('proposal_id')
        status = data.get('status')
        komentar = data.get('komentar', '')
        
        if not proposal_id or not status:
            return jsonify({'success': False, 'message': 'ID proposal dan status harus diisi!'})
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!'})
        
        # Update status review
        cursor.execute('''
            UPDATE proposal_reviewer 
            SET status_review = %s, komentar_reviewer = %s, tanggal_review = NOW()
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (status, komentar, proposal_id, reviewer_id))
        
        get_app_functions()['mysql'].connection.commit()
        cursor.close()
        
        logger.info(f"Status review berhasil diupdate: {status}")
        return jsonify({
            'success': True, 
            'message': f'Status review berhasil diupdate menjadi {status}!'
        })
        
    except Exception as e:
        logger.error(f"Error saat update review status: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat update status review!'})

def update_proposal_status_based_on_anggaran_progress(cursor, proposal_id, reviewer_id, tipe_anggaran):
    """
    Update status proposal berdasarkan progress review anggaran
    - belum_direview: Belum ada anggaran yang diberi nilai bantuan
    - sedang_direview: Ada anggaran yang sudah diberi nilai bantuan, tapi masih ada yang belum
    - selesai_review: Semua anggaran sudah diberi nilai bantuan
    """
    logger.info(f"Mengecek progress review anggaran untuk proposal {proposal_id}, tipe {tipe_anggaran}")
    
    try:
        # Tentukan tabel berdasarkan tahapan usaha proposal
        cursor.execute('''
            SELECT tahapan_usaha FROM proposal WHERE id = %s
        ''', (proposal_id,))
        
        proposal_data = cursor.fetchone()
        if not proposal_data:
            logger.error(f"Proposal {proposal_id} tidak ditemukan")
            return
        
        tahapan_usaha = proposal_data['tahapan_usaha']
        logger.info(f"Tahapan usaha proposal: {tahapan_usaha}")
        
        # Tentukan tabel anggaran berdasarkan tahapan usaha
        if tahapan_usaha == 'Usaha Awal':
            tabel_anggaran = 'anggaran_awal'
        elif tahapan_usaha == 'Usaha Bertumbuh':
            tabel_anggaran = 'anggaran_bertumbuh'
        else:
            logger.warning(f"Tahapan usaha tidak dikenali: {tahapan_usaha}")
            return
        
        # Hitung total anggaran yang disetujui admin untuk proposal ini
        cursor.execute(f'''
            SELECT COUNT(*) as total_anggaran
            FROM {tabel_anggaran}
            WHERE id_proposal = %s AND status = 'disetujui'
        ''', (proposal_id,))
        
        total_anggaran = cursor.fetchone()['total_anggaran']
        logger.info(f"Total anggaran disetujui admin: {total_anggaran}")
        
        if total_anggaran == 0:
            logger.info("Tidak ada anggaran yang disetujui admin, tidak mengupdate status proposal")
            return
        
        # Hitung anggaran yang sudah direview (diberi nilai bantuan > 0 atau ditolak)
        cursor.execute(f'''
            SELECT COUNT(*) as sudah_review
            FROM {tabel_anggaran}
            WHERE id_proposal = %s 
            AND status = 'disetujui'
            AND status_reviewer IN ('sudah_direview', 'tolak_bantuan')
        ''', (proposal_id,))
        
        sudah_review = cursor.fetchone()['sudah_review']
        logger.info(f"Anggaran yang sudah direview: {sudah_review}")
        
        # Hitung anggaran yang belum direview
        belum_review = total_anggaran - sudah_review
        logger.info(f"Anggaran yang belum direview: {belum_review}")
        
        # Tentukan status proposal berdasarkan progress review
        status_baru = None
        
        if sudah_review == 0:
            # Belum ada yang direview
            status_baru = 'belum_direview'
            logger.info("Status baru: belum_direview (belum ada anggaran yang direview)")
        elif belum_review == 0:
            # Semua sudah direview
            status_baru = 'selesai_review'
            logger.info("Status baru: selesai_review (semua anggaran sudah direview)")
        else:
            # Sebagian sudah direview
            status_baru = 'sedang_direview'
            logger.info("Status baru: sedang_direview (sebagian anggaran sudah direview)")
        
        # Update status proposal jika ada perubahan
        if status_baru:
            cursor.execute('''
                SELECT status_review FROM proposal_reviewer 
                WHERE id_proposal = %s AND id_reviewer = %s
            ''', (proposal_id, reviewer_id))
            
            current_status = cursor.fetchone()
            if current_status:
                current_status_value = current_status['status_review']
                logger.info(f"Status saat ini: {current_status_value}, Status baru: {status_baru}")
                
                if current_status_value != status_baru:
                    cursor.execute('''
                        UPDATE proposal_reviewer 
                        SET status_review = %s, tanggal_review = NOW()
                        WHERE id_proposal = %s AND id_reviewer = %s
                    ''', (status_baru, proposal_id, reviewer_id))
                    
                    logger.info(f"Status proposal berhasil diupdate dari '{current_status_value}' ke '{status_baru}'")
                else:
                    logger.info(f"Status proposal sudah sesuai: {status_baru}")
            else:
                logger.error(f"Proposal reviewer tidak ditemukan untuk proposal {proposal_id} dan reviewer {reviewer_id}")
        
    except Exception as e:
        logger.error(f"Error saat update status proposal: {str(e)}")

@reviewer_bp.route('/update_nilai_bantuan', methods=['POST'])
def update_nilai_bantuan():
    logger.info("Update nilai bantuan dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        data = request.get_json()
        logger.info(f"Data JSON yang diterima: {data}")
        
        anggaran_id = data.get('anggaran_id')
        nilai_bantuan = data.get('nilai_bantuan')
        status_reviewer = data.get('status_reviewer')
        tipe_anggaran = data.get('tipe_anggaran')  # 'awal' atau 'bertumbuh'
        
        logger.info(f"Data yang diparse: anggaran_id={anggaran_id}, nilai_bantuan={nilai_bantuan}, status_reviewer={status_reviewer}, tipe_anggaran={tipe_anggaran}")
        
        if not anggaran_id or not tipe_anggaran:
            logger.error(f"Data tidak lengkap: anggaran_id={anggaran_id}, tipe_anggaran={tipe_anggaran}")
            return jsonify({'success': False, 'message': 'ID anggaran dan tipe anggaran harus diisi!'})
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Tentukan tabel berdasarkan tipe anggaran
        tabel_anggaran = 'anggaran_awal' if tipe_anggaran == 'awal' else 'anggaran_bertumbuh'
        
        # Cek apakah anggaran ada dan proposal ditugaskan ke reviewer ini
        cursor.execute(f'''
            SELECT aa.id_proposal, aa.jumlah, aa.status, aa.status_reviewer
            FROM {tabel_anggaran} aa
            JOIN proposal_reviewer pr ON aa.id_proposal = pr.id_proposal
            WHERE aa.id = %s AND pr.id_reviewer = %s
        ''', (anggaran_id, reviewer_id))
        
        result = cursor.fetchone()
        if not result:
            cursor.close()
            return jsonify({'success': False, 'message': 'Anggaran tidak ditemukan atau tidak ditugaskan kepada Anda!'})
        
        proposal_id = result['id_proposal']
        jumlah_anggaran = float(result['jumlah'] or 0)
        status_anggaran = result['status']
        status_reviewer_sekarang = result['status_reviewer']
        
        # Konversi nilai_bantuan ke float
        nilai_bantuan_float = float(nilai_bantuan or 0)
        
        # Inisialisasi variabel
        status_anggaran_baru = None
        status_reviewer_final = None
        message = ""
        
        # Logika utama berdasarkan nilai bantuan dan status yang dikirim
        if status_reviewer == 'tolak_bantuan' or nilai_bantuan_float == 0:
            # Tolak bantuan - set nilai_bantuan = 0 dan status_reviewer = 'tolak_bantuan'
            status_reviewer_final = 'tolak_bantuan'
            nilai_bantuan_final = 0
            # Status anggaran tidak berubah saat tolak bantuan
            status_anggaran_baru = status_anggaran
            message = "Bantuan berhasil ditolak!"
            
        elif nilai_bantuan_float > 0:
            # Setujui bantuan dengan nilai tertentu
            status_reviewer_final = 'sudah_direview'
            nilai_bantuan_final = nilai_bantuan_float
            
            # Tentukan status anggaran berdasarkan perbandingan jumlah vs nilai bantuan
            if nilai_bantuan_float >= jumlah_anggaran:
                # Nilai bantuan mencukupi atau lebih dari jumlah anggaran
                status_anggaran_baru = 'disetujui'
                message = f"Anggaran disetujui! Nilai bantuan: Rp {nilai_bantuan_float:,.0f}"
            else:
                # Nilai bantuan kurang dari jumlah anggaran - perlu revisi
                status_anggaran_baru = 'revisi'
                message = f"Anggaran perlu direvisi! Nilai bantuan (Rp {nilai_bantuan_float:,.0f}) kurang dari jumlah anggaran (Rp {jumlah_anggaran:,.0f})"
        
        else:
            # Fallback untuk kasus lain
            status_reviewer_final = status_reviewer or 'belum_direview'
            nilai_bantuan_final = 0
            status_anggaran_baru = status_anggaran
            message = f"Status review berhasil diupdate menjadi {status_reviewer_final}!"
        
        # Update database
        logger.info(f"Executing UPDATE query: tabel={tabel_anggaran}, anggaran_id={anggaran_id}")
        logger.info(f"Update values: nilai_bantuan_final={nilai_bantuan_final}, status_reviewer_final={status_reviewer_final}, status_anggaran_baru={status_anggaran_baru}")
        
        cursor.execute(f'''
            UPDATE {tabel_anggaran} 
            SET nilai_bantuan = %s, status_reviewer = %s, status = %s, tanggal_review_reviewer = NOW()
            WHERE id = %s
        ''', (nilai_bantuan_final, status_reviewer_final, status_anggaran_baru, anggaran_id))
        
        # Cek apakah update berhasil
        rows_affected = cursor.rowcount
        logger.info(f"Rows affected by UPDATE: {rows_affected}")
        
        if rows_affected == 0:
            logger.error(f"UPDATE tidak berhasil! Tidak ada baris yang diupdate untuk anggaran_id={anggaran_id}")
            cursor.close()
            return jsonify({'success': False, 'message': 'Gagal mengupdate data anggaran!'})
        
        # Update status proposal berdasarkan progress review anggaran
        update_proposal_status_based_on_anggaran_progress(cursor, proposal_id, reviewer_id, tipe_anggaran)
        
        get_app_functions()['mysql'].connection.commit()
        logger.info(f"Database commit berhasil")
        
        # Verifikasi data setelah update
        cursor.execute(f'''
            SELECT nilai_bantuan, status_reviewer, status 
            FROM {tabel_anggaran} 
            WHERE id = %s
        ''', (anggaran_id,))
        
        verification_result = cursor.fetchone()
        if verification_result:
            logger.info(f"Data setelah update: nilai_bantuan={verification_result['nilai_bantuan']}, status_reviewer={verification_result['status_reviewer']}, status={verification_result['status']}")
        else:
            logger.error(f"Tidak bisa memverifikasi data setelah update untuk anggaran_id={anggaran_id}")
        
        cursor.close()
        
        logger.info(f"Nilai bantuan berhasil diupdate: anggaran_id={anggaran_id}, status_reviewer={status_reviewer_final}, nilai_bantuan={nilai_bantuan_final}, status_anggaran={status_anggaran_baru}")
        
        return jsonify({
            'success': True, 
            'message': message,
            'status_anggaran': status_anggaran_baru,
            'status_reviewer': status_reviewer_final,
            'nilai_bantuan': nilai_bantuan_final
        })
        
    except Exception as e:
        logger.error(f"Error saat update nilai bantuan: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat update nilai bantuan!'})

@reviewer_bp.route('/get_proposal_detail/<int:proposal_id>')
def get_proposal_detail(proposal_id):
    logger.info(f"Get proposal detail reviewer dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!'})
        
        # Ambil detail proposal
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.email, m.no_telp, m.program_studi, m.perguruan_tinggi,
                   m.nim, m.id as mahasiswa_id, p.status as status_proposal
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        proposal = cursor.fetchone()
        
        # Ambil anggota tim - ambil semua field dari tabel anggota_tim
        cursor.execute('''
            SELECT a.id, a.id_proposal, a.perguruan_tinggi, a.program_studi, 
                   a.nim, a.nama, a.email, a.no_telp, a.tanggal_tambah
            FROM anggota_tim a
            WHERE a.id_proposal = %s
            ORDER BY a.id
        ''', (proposal_id,))
        
        anggota = cursor.fetchall()
        
        # Hitung anggaran
        cursor.execute('SELECT COUNT(*) as count FROM anggaran_awal WHERE id_proposal = %s', (proposal_id,))
        anggaran_awal_count = cursor.fetchone()['count']
        
        cursor.execute('SELECT COUNT(*) as count FROM anggaran_bertumbuh WHERE id_proposal = %s', (proposal_id,))
        anggaran_bertumbuh_count = cursor.fetchone()['count']
        
        cursor.close()
        
        # Debug: Log data untuk troubleshooting
        logger.info(f"Data proposal: {proposal}")
        logger.info(f"Data anggota: {anggota}")
        logger.info(f"Jumlah anggota: {len(anggota) if anggota else 0}")
        
        return jsonify({
            'success': True,
            'proposal': proposal,
            'anggota': anggota,
            'assignment': assignment,
            'anggaran_awal_count': anggaran_awal_count,
            'anggaran_bertumbuh_count': anggaran_bertumbuh_count
        })
        
    except Exception as e:
        logger.error(f"Error saat mengambil detail proposal: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengambil detail proposal!'})

@reviewer_bp.route('/download_proposal/<int:proposal_id>')
def download_proposal(proposal_id):
    logger.info(f"Download proposal reviewer dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Ambil path file proposal
        cursor.execute('''
            SELECT p.file_path, p.judul_usaha, m.nama_ketua
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        proposal = cursor.fetchone()
        cursor.close()
        
        if not proposal or not proposal['file_path']:
            flash('File proposal tidak ditemukan!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        file_path = proposal['file_path']
        
        if not os.path.exists(file_path):
            flash('File proposal tidak ditemukan di server!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Ambil nama file dari path
        filename = os.path.basename(file_path)
        
        # Deteksi ekstensi file dan mimetype
        ext = os.path.splitext(file_path)[1].lower()
        if ext == '.pdf':
            return send_file(file_path, as_attachment=False, mimetype='application/pdf')
        else:
            # Deteksi mimetype otomatis untuk file selain PDF
            import mimetypes
            mimetype = mimetypes.guess_type(file_path)[0] or 'application/octet-stream'
            return send_file(file_path, as_attachment=False, mimetype=mimetype)
        
    except Exception as e:
        logger.error(f"Error saat download proposal: {str(e)}")
        flash('Terjadi kesalahan saat download proposal!', 'danger')
        return redirect(url_for('reviewer.proposal'))

def ensure_proposal_review_status(proposal_id, reviewer_id):
    """
    Helper function to ensure proposal review status is properly set
    """
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Cek status review saat ini
        cursor.execute('''
            SELECT status_review, tanggal_review
            FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        result = cursor.fetchone()
        if result and (result['status_review'] == '' or result['status_review'] is None):
            # Jika status review kosong tapi ada tanggal review, set ke 'selesai_review'
            if result['tanggal_review']:
                logger.info(f"Memperbaiki status_review kosong untuk proposal {proposal_id}")
                cursor.execute('''
                    UPDATE proposal_reviewer 
                    SET status_review = 'selesai_review' 
                    WHERE id_proposal = %s AND id_reviewer = %s
                ''', (proposal_id, reviewer_id))
                get_app_functions()['mysql'].connection.commit()
                logger.info(f"Status review proposal {proposal_id} diperbaiki menjadi 'selesai_review'")
        
        cursor.close()
        return True
        
    except Exception as e:
        logger.error(f"Error dalam ensure_proposal_review_status: {str(e)}")
        return False

@reviewer_bp.route('/send_proposal_to_admin', methods=['POST'])
def send_proposal_to_admin():
    logger.info("Send proposal to admin dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        data = request.get_json()
        proposal_id = data.get('proposal_id')
        
        if not proposal_id:
            return jsonify({'success': False, 'message': 'ID proposal harus diisi!'})
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!'})
        
        # Cek apakah semua anggaran sudah direview ATAU ditolak_bantuan, dan tidak ada yang perlu revisi
        cursor.execute('''
            SELECT 
                (SELECT COUNT(*) FROM anggaran_awal aa 
                 WHERE aa.id_proposal = %s) as total_anggaran_awal,
                (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                 WHERE ab.id_proposal = %s) as total_anggaran_bertumbuh,
                (SELECT COUNT(*) FROM anggaran_awal aa 
                 WHERE aa.id_proposal = %s AND aa.status_reviewer IN ('sudah_direview','tolak_bantuan')) as reviewed_or_rejected_awal,
                (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                 WHERE ab.id_proposal = %s AND ab.status_reviewer IN ('sudah_direview','tolak_bantuan')) as reviewed_or_rejected_bertumbuh,
                (SELECT COUNT(*) FROM anggaran_awal aa 
                 WHERE aa.id_proposal = %s AND aa.status = 'revisi') as anggaran_awal_revisi,
                (SELECT COUNT(*) FROM anggaran_bertumbuh ab 
                 WHERE ab.id_proposal = %s AND ab.status = 'revisi') as anggaran_bertumbuh_revisi
        ''', (proposal_id, proposal_id, proposal_id, proposal_id, proposal_id, proposal_id))

        anggaran_status = cursor.fetchone()
        total_anggaran = (anggaran_status['total_anggaran_awal'] or 0) + (anggaran_status['total_anggaran_bertumbuh'] or 0)
        total_reviewed_like = (anggaran_status['reviewed_or_rejected_awal'] or 0) + (anggaran_status['reviewed_or_rejected_bertumbuh'] or 0)
        total_revisi = (anggaran_status['anggaran_awal_revisi'] or 0) + (anggaran_status['anggaran_bertumbuh_revisi'] or 0)
        total_diputuskan = total_reviewed_like + total_revisi

        # Cek apakah semua anggaran sudah memiliki keputusan reviewer (disetujui/tolak_bantuan/revisi)
        if total_anggaran > 0 and total_diputuskan < total_anggaran:
            cursor.close()
            return jsonify({
                'success': False,
                'message': f'Belum semua anggaran diberi keputusan! ({total_diputuskan}/{total_anggaran} disetujui/ditolak/revisi)'
            })

        
        # Update status review proposal menjadi sent_to_admin
        cursor.execute('''
            UPDATE proposal_reviewer 
            SET status_review = 'sent_to_admin', tanggal_review = NOW()
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        get_app_functions()['mysql'].connection.commit()
        cursor.close()
        
        logger.info(f"Proposal {proposal_id} berhasil dikirim ke admin oleh reviewer {reviewer_id}")
        return jsonify({
            'success': True, 
            'message': 'Proposal berhasil dikirim ke admin untuk konfirmasi pendanaan!'
        })
        
    except Exception as e:
        logger.error(f"Error saat mengirim proposal ke admin: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengirim proposal ke admin!'})

@reviewer_bp.route('/penilaian/<int:proposal_id>')
def penilaian(proposal_id):
    logger.info(f"Penilaian reviewer dipanggil untuk proposal ID: {proposal_id}")
    logger.info(f"Session user_type: {session.get('user_type')}, user_id: {session.get('user_id')}")
    
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        logger.warning(f"Redirect karena bukan reviewer - user_type: {session.get('user_type')}")
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini dan status review selesai
        cursor.execute('''
            SELECT pr.*, p.judul_usaha, p.tahapan_usaha
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            WHERE pr.id_proposal = %s AND pr.id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        logger.info(f"Assignment found: {assignment is not None}")
        if assignment:
            logger.info(f"Assignment status_review: '{assignment['status_review']}'")
        
        if not assignment:
            logger.warning(f"Proposal {proposal_id} tidak ditugaskan ke reviewer {reviewer_id}")
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.proposal'))
        
        # Perbaiki status review jika kosong
        if assignment['status_review'] == '' or assignment['status_review'] is None:
            logger.info(f"Status review kosong, mencoba memperbaiki untuk proposal {proposal_id}")
            ensure_proposal_review_status(proposal_id, reviewer_id)
            # Refresh assignment data
            cursor.execute('''
                SELECT pr.*, p.judul_usaha, p.tahapan_usaha
                FROM proposal_reviewer pr
                JOIN proposal p ON pr.id_proposal = p.id
                WHERE pr.id_proposal = %s AND pr.id_reviewer = %s
            ''', (proposal_id, reviewer_id))
            assignment = cursor.fetchone()
        
        if assignment['status_review'] != 'selesai_review':
            logger.warning(f"Proposal {proposal_id} status_review: '{assignment['status_review']}' != 'selesai_review'")
            flash('Proposal belum selesai direview!', 'warning')
            return redirect(url_for('reviewer.proposal'))
        
        # Jika sudah melewati jadwal selesai penilaian PROPOSAL, otomatis simpan nilai 0 jika belum ada
        try:
            cursor.execute('SELECT reviewer_proposal_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1')
            jadwal = cursor.fetchone()
            if jadwal and jadwal.get('reviewer_proposal_selesai'):
                from datetime import datetime
                if datetime.now() > jadwal['reviewer_proposal_selesai']:
                    # cek apakah sudah ada penilaian
                    cursor.execute('''
                        SELECT 1 FROM penilaian_proposal WHERE id_proposal = %s AND id_reviewer = %s
                    ''', (proposal_id, reviewer_id))
                    exists = cursor.fetchone()
                    if not exists:
                        # PERBAIKAN: Gunakan snapshot pertanyaan
                        pertanyaan_zero = get_pertanyaan_proposal_snapshot(cursor)
                        # buat header penilaian 0
                        cursor.execute('''
                            INSERT INTO penilaian_proposal 
                            (id_proposal, id_reviewer, total_skor, total_nilai, nilai_akhir, catatan, nilai_bantuan, persentase_bantuan, tanggal_penilaian)
                            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW())
                        ''', (proposal_id, reviewer_id, 0, 0, 0, '', 0, 0))
                        # detail 0 dengan rumus baru: bobot × skor = nilai
                        for p in pertanyaan_zero:
                            nilai_baru = p['bobot'] * 0  # bobot × 0 = 0
                            cursor.execute('''
                                INSERT INTO detail_penilaian_proposal (id_proposal, id_reviewer, id_pertanyaan, skor, bobot, nilai)
                                VALUES (%s, %s, %s, %s, %s, %s)
                                ON DUPLICATE KEY UPDATE skor=VALUES(skor), bobot=VALUES(bobot), nilai=VALUES(nilai)
                            ''', (proposal_id, reviewer_id, p['id'], 0, p['bobot'], nilai_baru))
                        # set status review dinilai
                        cursor.execute('''
                            UPDATE proposal_reviewer SET status_review='sudah_dinilai', tanggal_penilaian = NOW()
                            WHERE id_proposal=%s AND id_reviewer=%s
                        ''', (proposal_id, reviewer_id))
                        get_app_functions()['mysql'].connection.commit()
        except Exception:
            pass

        # Hitung total anggaran dari tabel anggaran_awal dan anggaran_bertumbuh
        cursor.execute('''
            SELECT 
                COALESCE(SUM(jumlah), 0) as total_anggaran_awal
            FROM anggaran_awal 
            WHERE id_proposal = %s AND status = 'disetujui'
        ''', (proposal_id,))
        
        total_anggaran_awal = cursor.fetchone()['total_anggaran_awal']
        
        cursor.execute('''
            SELECT 
                COALESCE(SUM(jumlah), 0) as total_anggaran_bertumbuh
            FROM anggaran_bertumbuh 
            WHERE id_proposal = %s AND status = 'disetujui'
        ''', (proposal_id,))
        
        total_anggaran_bertumbuh = cursor.fetchone()['total_anggaran_bertumbuh']
        
        # Hitung total nilai bantuan yang sudah direview
        cursor.execute('''
            SELECT 
                COALESCE(SUM(nilai_bantuan), 0) as total_nilai_bantuan_awal
            FROM anggaran_awal 
            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
        ''', (proposal_id,))
        
        total_nilai_bantuan_awal = cursor.fetchone()['total_nilai_bantuan_awal']
        
        cursor.execute('''
            SELECT 
                COALESCE(SUM(nilai_bantuan), 0) as total_nilai_bantuan_bertumbuh
            FROM anggaran_bertumbuh 
            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
        ''', (proposal_id,))
        
        total_nilai_bantuan_bertumbuh = cursor.fetchone()['total_nilai_bantuan_bertumbuh']
        
        # Tambahkan data anggaran ke assignment
        assignment['total_anggaran_awal'] = total_anggaran_awal
        assignment['total_anggaran_bertumbuh'] = total_anggaran_bertumbuh
        assignment['total_nilai_bantuan_awal'] = total_nilai_bantuan_awal
        assignment['total_nilai_bantuan_bertumbuh'] = total_nilai_bantuan_bertumbuh
        
        # PERBAIKAN: Ambil data pertanyaan penilaian berdasarkan snapshot
        pertanyaan_penilaian = get_pertanyaan_proposal_snapshot(cursor)
        
        # Cek apakah sudah ada penilaian untuk proposal ini
        cursor.execute('''
            SELECT * FROM penilaian_proposal
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        existing_penilaian = cursor.fetchone()
        
        # Jika sudah ada penilaian, ambil detail penilaian
        detail_penilaian = []
        if existing_penilaian:
            cursor.execute('''
                SELECT dp.*, pp.pertanyaan, pp.bobot as bobot_pertanyaan
                FROM detail_penilaian_proposal dp
                JOIN pertanyaan_penilaian_proposal pp ON dp.id_pertanyaan = pp.id
                WHERE dp.id_proposal = %s AND dp.id_reviewer = %s
                ORDER BY pp.created_at ASC
            ''', (proposal_id, reviewer_id))
            detail_penilaian = cursor.fetchall()
        
        cursor.close()
        
        # Cek status jadwal review proposal
        jadwal_status = get_jadwal_reviewer_status('proposal')
        
        return render_template('reviewer/penilaian.html', 
                             proposal=assignment,
                             pertanyaan_penilaian=pertanyaan_penilaian,
                             existing_penilaian=existing_penilaian,
                             detail_penilaian=detail_penilaian,
                             jadwal_status=jadwal_status)
        
    except Exception as e:
        logger.error(f"Error saat membuka halaman penilaian: {str(e)}")
        flash('Terjadi kesalahan saat membuka halaman penilaian!', 'danger')
        return redirect(url_for('reviewer.proposal'))

@reviewer_bp.route('/save_penilaian', methods=['POST'])
def save_penilaian():
    logger.info("Save penilaian dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        data = request.get_json()
        proposal_id = data.get('proposal_id')
        penilaian = data.get('penilaian')
        catatan = data.get('catatan')
        nilai_bantuan = data.get('nilai_bantuan')
        persentase_bantuan = data.get('persentase_bantuan')
        
        if not proposal_id or not penilaian or not catatan or not nilai_bantuan:
            return jsonify({'success': False, 'message': 'Semua data penilaian harus diisi!'})
        
        # Cek status jadwal review proposal
        jadwal_status = get_jadwal_reviewer_status('proposal')
        if not jadwal_status['bisa_review']:
            if jadwal_status['status'] == 'sudah_selesai':
                # Jika sudah melewati jadwal, skor otomatis 0
                return jsonify({'success': False, 'message': f"Tidak bisa melakukan penilaian: {jadwal_status['pesan']}. Skor otomatis 0."})
            else:
                return jsonify({'success': False, 'message': f"Tidak bisa melakukan penilaian: {jadwal_status['pesan']}"})
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini dan status review selesai
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s AND status_review = 'selesai_review'
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau belum selesai direview!'})
        
        # Cek apakah sudah ada penilaian
        cursor.execute('''
            SELECT * FROM penilaian_proposal
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        existing_penilaian = cursor.fetchone()
        
        # Hitung nilai akhir dengan rumus baru
        total_bobot = sum(detail['bobot'] for detail in penilaian['detail'])
        
        # PERBAIKAN: Cari skor maksimal tertinggi dari snapshot pertanyaan
        pertanyaan_snapshot = get_pertanyaan_proposal_snapshot(cursor)
        skor_maksimal_tertinggi = max([p['skor_maksimal'] for p in pertanyaan_snapshot]) if pertanyaan_snapshot else 100
        
        # RUMUS BARU: total nilai akhir = (total nilai / (total bobot × skor maksimal tertinggi)) × 100
        nilai_akhir = (penilaian['totalNilai'] / (total_bobot * skor_maksimal_tertinggi)) * 100 if (total_bobot > 0 and skor_maksimal_tertinggi > 0) else 0
        
        # Simpan penilaian ke database
        cursor.execute('''
            INSERT INTO penilaian_proposal 
            (id_proposal, id_reviewer, total_skor, total_nilai, nilai_akhir, catatan, nilai_bantuan, persentase_bantuan, tanggal_penilaian)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, NOW())
            ON DUPLICATE KEY UPDATE
            total_skor = VALUES(total_skor),
            total_nilai = VALUES(total_nilai),
            nilai_akhir = VALUES(nilai_akhir),
            catatan = VALUES(catatan),
            nilai_bantuan = VALUES(nilai_bantuan),
            persentase_bantuan = VALUES(persentase_bantuan),
            tanggal_penilaian = NOW()
        ''', (proposal_id, reviewer_id, penilaian['totalSkor'], penilaian['totalNilai'], nilai_akhir,
              catatan, nilai_bantuan, persentase_bantuan))
        
        # Simpan detail penilaian dengan rumus baru: bobot × skor = nilai
        for detail in penilaian['detail']:
            # RUMUS BARU: nilai = bobot × skor
            nilai_baru = detail['bobot'] * detail['skor']
            
            cursor.execute('''
                INSERT INTO detail_penilaian_proposal 
                (id_proposal, id_reviewer, id_pertanyaan, skor, bobot, nilai)
                VALUES (%s, %s, %s, %s, %s, %s)
                ON DUPLICATE KEY UPDATE
                skor = VALUES(skor),
                bobot = VALUES(bobot),
                nilai = VALUES(nilai)
            ''', (proposal_id, reviewer_id, detail['id'], detail['skor'], 
                  detail['bobot'], nilai_baru))
        
        # Update status proposal menjadi sudah dinilai
        cursor.execute('''
            UPDATE proposal_reviewer 
            SET status_review = 'sudah_dinilai', tanggal_penilaian = NOW()
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        get_app_functions()['mysql'].connection.commit()
        cursor.close()
        
        # Cek apakah ini update atau insert baru
        is_update = existing_penilaian is not None
        
        logger.info(f"Penilaian berhasil {'diperbarui' if is_update else 'disimpan'} untuk proposal {proposal_id} oleh reviewer {reviewer_id}")
        return jsonify({
            'success': True, 
            'message': 'Penilaian berhasil diperbarui!' if is_update else 'Penilaian berhasil disimpan!',
            'redirect_url': url_for('reviewer.proposal', penilaian_completed='true', proposal_id=proposal_id)
        })
        
    except Exception as e:
        logger.error(f"Error saat menyimpan penilaian: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat menyimpan penilaian!'})


# ========================================
# ROUTE UNTUK LAPORAN KEMAJUAN
# ========================================

@reviewer_bp.route('/daftar_mahasiswa_laporan_kemajuan')
def daftar_mahasiswa_laporan_kemajuan():
    logger.info("Halaman daftar mahasiswa laporan kemajuan dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Ambil data proposal yang ditugaskan ke reviewer ini dengan status penilaian laporan kemajuan
        cursor.execute('''
            SELECT pr.id_proposal, pr.status_review, pr.tanggal_assign,
                   p.judul_usaha, m.nama_ketua, p.nim, p.kategori, p.tahapan_usaha,
                   m.program_studi, m.perguruan_tinggi, p.dosen_pembimbing,
                   (SELECT COUNT(*) FROM penilaian_proposal pp 
                    WHERE pp.id_proposal = pr.id_proposal AND pp.id_reviewer = pr.id_reviewer) as sudah_dinilai_proposal,
                   (SELECT COUNT(*) FROM penilaian_laporan_kemajuan plk 
                    WHERE plk.id_proposal = pr.id_proposal AND plk.id_reviewer = pr.id_reviewer) as sudah_dinilai_laporan_kemajuan
            FROM proposal_reviewer pr
            JOIN proposal p ON pr.id_proposal = p.id
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE pr.id_reviewer = %s
            ORDER BY pr.tanggal_assign DESC
        ''', (reviewer_id,))
        
        proposals = cursor.fetchall()
        
        # Format tanggal dan tentukan status review untuk laporan kemajuan
        for proposal in proposals:
            if proposal['tanggal_assign']:
                proposal['tanggal_assign'] = proposal['tanggal_assign'].strftime('%d/%m/%Y %H:%M')
            
            # Tentukan status review untuk laporan kemajuan
            if proposal['sudah_dinilai_laporan_kemajuan'] > 0:
                proposal['status_review_laporan_kemajuan'] = 'sudah_dinilai'
            else:
                proposal['status_review_laporan_kemajuan'] = 'belum_dinilai'
        
        cursor.close()
        
        # Tambahkan status jadwal untuk laporan kemajuan
        jadwal_kemajuan = get_jadwal_reviewer_status('laporan_kemajuan')
        
        return render_template('reviewer/daftar_mahasiswa_laporan_kemajuan.html', 
                             proposals=proposals,
                             jadwal_kemajuan=jadwal_kemajuan)
        
    except Exception as e:
        logger.error(f"Error saat mengambil data proposal reviewer: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data proposal!', 'danger')
        return render_template('reviewer/daftar_mahasiswa_laporan_kemajuan.html', proposals=[])


@reviewer_bp.route('/laporan_kemajuan_awal_bertumbuh/<int:proposal_id>')
def laporan_kemajuan_awal_bertumbuh(proposal_id):
    logger.info(f"Laporan kemajuan awal/bertumbuh dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Ambil detail proposal dan mahasiswa
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.email, m.no_telp, m.program_studi, m.perguruan_tinggi,
                   m.nim, m.id as mahasiswa_id, p.status as status_proposal
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        mahasiswa_info = cursor.fetchone()
        if not mahasiswa_info:
            flash('Data mahasiswa tidak ditemukan!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Tentukan jenis laporan berdasarkan tahapan usaha
        tahapan_usaha = mahasiswa_info.get('tahapan_usaha', '').lower()
        if 'bertumbuh' in tahapan_usaha:
            tabel_laporan_kemajuan = 'laporan_kemajuan_bertumbuh'
        else:
            tabel_laporan_kemajuan = 'laporan_kemajuan_awal'
        
        # Ambil data laporan kemajuan dengan status disetujui
        cursor.execute(f'''
            SELECT id, id_proposal, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian,
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status
            FROM {tabel_laporan_kemajuan}
            WHERE id_proposal = %s AND status = 'disetujui'
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        anggaran_data = cursor.fetchall()
        logger.info(f"Jumlah data laporan kemajuan untuk proposal {proposal_id}: {len(anggaran_data)}")
        
        # Debug: Log detail setiap item laporan kemajuan
        if anggaran_data:
            for i, row in enumerate(anggaran_data):
                logger.info(f"Item {i+1}: {row.get('nama_barang', 'N/A')} - Qty: {row.get('kuantitas', 0)} - Harga: {row.get('harga_satuan', 0)} - Jumlah: {row.get('jumlah', 0)}")
        
        # Proses data untuk tampilan tabel dengan struktur yang benar
        anggaran_data_flat = []
        if anggaran_data:
            anggaran_data_flat = flatten_anggaran_data(anggaran_data)
            logger.info(f"Data berhasil di-flatten menjadi {len(anggaran_data_flat)} baris")
            
            # Debug: Log detail data yang akan dikirim ke template
            logger.info("=== DETAIL DATA ANGGARAN DATA FLAT ===")
            for i, row in enumerate(anggaran_data_flat):
                logger.info(f"Row {i+1}: kegiatan_utama='{row.get('kegiatan_utama', 'N/A')}', kegiatan='{row.get('kegiatan', 'N/A')}', nama_barang='{row.get('nama_barang', 'N/A')}', jumlah={row.get('jumlah', 'N/A')}")
            logger.info("=====================================")
        
        # Hitung total nilai bantuan dari anggaran yang sudah direview (bukan dari laporan kemajuan)
        if 'bertumbuh' in tahapan_usaha:
            tabel_anggaran = 'anggaran_bertumbuh'
        else:
            tabel_anggaran = 'anggaran_awal'
        
        cursor.execute(f'''
            SELECT COALESCE(SUM(nilai_bantuan), 0) as total_nilai_bantuan
            FROM {tabel_anggaran}
            WHERE id_proposal = %s AND status_reviewer = 'sudah_direview'
        ''', (proposal_id,))
        
        total_nilai_bantuan_result = cursor.fetchone()
        total_nilai_bantuan = total_nilai_bantuan_result.get('total_nilai_bantuan', 0) if total_nilai_bantuan_result else 0
        logger.info(f"Total nilai bantuan dari {tabel_anggaran}: {total_nilai_bantuan}")
        
        # Hitung total laporan kemajuan yang disetujui
        total_laporan_kemajuan_disetujui = sum(row.get('jumlah', 0) for row in anggaran_data) if anggaran_data else 0
        logger.info(f"Total laporan kemajuan yang disetujui: {total_laporan_kemajuan_disetujui}")
        
        # Ambil file laporan kemajuan jika ada
        cursor.execute('''
            SELECT * FROM file_laporan_kemajuan
            WHERE id_proposal = %s
            ORDER BY id DESC
            LIMIT 1
        ''', (proposal_id,))
        
        file_laporan = cursor.fetchone()
        cursor.close()
        
        # Summary log
        logger.info(f"=== SUMMARY LAPORAN KEMAJUAN PROPOSAL {proposal_id} ===")
        logger.info(f"Total Nilai Bantuan: {total_nilai_bantuan}")
        logger.info(f"Total Laporan Kemajuan Disetujui: {total_laporan_kemajuan_disetujui}")
        logger.info(f"================================================")
        
        logger.info(f"Rendering template dengan {len(anggaran_data_flat)} data anggaran")
        return render_template('reviewer/laporan_kemajuan_awal_bertumbuh.html', 
                             mahasiswa_info=mahasiswa_info,
                             anggaran_data_flat=anggaran_data_flat,
                             total_nilai_bantuan=total_nilai_bantuan,
                             total_laporan_kemajuan_disetujui=total_laporan_kemajuan_disetujui,
                             file_laporan=file_laporan,
                             proposal_id=proposal_id,
                             tabel_laporan=tabel_laporan_kemajuan)
        
    except Exception as e:
        logger.error(f"Error saat mengambil detail proposal: {str(e)}")
        flash('Terjadi kesalahan saat mengambil detail proposal!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))


@reviewer_bp.route('/penilaian_kemajuan/<int:proposal_id>')
def penilaian_kemajuan(proposal_id):
    logger.info(f"Penilaian kemajuan dipanggil untuk proposal ID: {proposal_id}")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Hapus auto-insert nilai 0. Status "sudah dinilai" kini hanya muncul jika reviewer benar-benar mengirim penilaian.
        # (Dulu: auto membuat penilaian nol setelah deadline sehingga status tampak "sudah dinilai" meskipun tidak ada data nyata.)

        cursor.close()
        return render_template('reviewer/penilaian_kemajuan.html', proposal_id=proposal_id)
        
    except Exception as e:
        logger.error(f"Error saat membuka penilaian kemajuan: {str(e)}")
        flash('Terjadi kesalahan saat membuka penilaian kemajuan!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))


@reviewer_bp.route('/get_pertanyaan_penilaian_laporan_kemajuan')
def get_pertanyaan_penilaian_laporan_kemajuan():
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # PERBAIKAN: Ambil pertanyaan berdasarkan snapshot
        pertanyaan = get_pertanyaan_laporan_kemajuan_snapshot(cursor)
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': pertanyaan
        })
        
    except Exception as e:
        logger.error(f"Error saat mengambil pertanyaan penilaian: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengambil pertanyaan penilaian!'})


@reviewer_bp.route('/get_skor_tersimpan_laporan_kemajuan')
def get_skor_tersimpan_laporan_kemajuan():
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        proposal_id = request.args.get('proposal_id')
        reviewer_id = session.get('user_id')
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        cursor.execute('''
            SELECT dp.* FROM detail_penilaian_laporan_kemajuan dp
            JOIN penilaian_laporan_kemajuan plk ON dp.id_penilaian_laporan_kemajuan = plk.id
            WHERE plk.id_proposal = %s AND plk.id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        skor_tersimpan = cursor.fetchall()
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': skor_tersimpan
        })
        
    except Exception as e:
        logger.error(f"Error saat mengambil skor tersimpan: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengambil skor tersimpan!'})


@reviewer_bp.route('/view_file_laporan_kemajuan/<int:proposal_id>')
def view_file_laporan_kemajuan(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Ambil file laporan kemajuan
        cursor.execute('''
            SELECT * FROM file_laporan_kemajuan
            WHERE id_proposal = %s
            ORDER BY id DESC
            LIMIT 1
        ''', (proposal_id,))
        
        file_laporan_kemajuan = cursor.fetchone()
        cursor.close()
        
        if not file_laporan_kemajuan or not file_laporan_kemajuan.get('file_path'):
            flash('File laporan kemajuan tidak ditemukan!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Buka file di tab baru
        file_path = file_laporan_kemajuan.get('file_path')
        
        # Handle different file path formats
        if file_path.startswith('static/'):
            # If path starts with static/, remove it for send_from_directory
            filename = file_path.replace('static/', '')
            directory = 'static'
        elif file_path.startswith('/'):
            # If path is absolute, use the full path
            filename = os.path.basename(file_path)
            directory = os.path.dirname(file_path)
        else:
            # If path is relative, assume it's relative to static/uploads
            filename = file_path
            directory = 'static/uploads'
        
        # Check if file exists
        full_path = os.path.join(directory, filename) if directory != 'static' else os.path.join(directory, filename)
        if not os.path.exists(full_path):
            # Try alternative paths
            alt_paths = [
                file_path,
                os.path.join('static', file_path),
                os.path.join('static/uploads', file_path),
                os.path.join(os.getcwd(), file_path),
                os.path.join(os.getcwd(), 'static', file_path)
            ]
            
            file_found = False
            for alt_path in alt_paths:
                if os.path.exists(alt_path):
                    full_path = alt_path
                    directory = os.path.dirname(alt_path)
                    filename = os.path.basename(alt_path)
                    file_found = True
                    break
            
            if not file_found:
                flash(f'File tidak ditemukan di server! Path: {file_path}', 'danger')
                return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))
        
        # Determine MIME type
        mime_type, _ = mimetypes.guess_type(filename)
        if mime_type is None:
            mime_type = 'application/octet-stream'
        
        # Use send_from_directory for better security
        try:
            return send_from_directory(directory, filename, as_attachment=False, mimetype=mime_type)
        except Exception as e:
            logger.error(f"Error sending file: {str(e)}")
            # Fallback to send_file
            return send_file(full_path, as_attachment=False, mimetype=mime_type)
        
    except Exception as e:
        logger.error(f"Error saat membuka file laporan kemajuan: {str(e)}")
        flash('Terjadi kesalahan saat membuka file laporan kemajuan!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_kemajuan'))

@reviewer_bp.route('/view_file_laporan_akhir/<int:proposal_id>')
def view_file_laporan_akhir(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            flash('Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Ambil file laporan akhir
        cursor.execute('''
            SELECT * FROM file_laporan_akhir
            WHERE id_proposal = %s
            ORDER BY id DESC
            LIMIT 1
        ''', (proposal_id,))
        
        file_laporan_akhir = cursor.fetchone()
        cursor.close()
        
        if not file_laporan_akhir or not file_laporan_akhir.get('file_path'):
            flash('File laporan akhir tidak ditemukan!', 'danger')
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Buka file di tab baru
        file_path = file_laporan_akhir.get('file_path')
        
        # Handle different file path formats
        if file_path.startswith('static/'):
            # If path starts with static/, remove it for send_from_directory
            filename = file_path.replace('static/', '')
            directory = 'static'
        elif file_path.startswith('/'):
            # If path is absolute, use the full path
            filename = os.path.basename(file_path)
            directory = os.path.dirname(file_path)
        else:
            # If path is relative, assume it's relative to static/uploads
            filename = file_path
            directory = 'static/uploads'
        
        # Check if file exists
        full_path = os.path.join(directory, filename) if directory != 'static' else os.path.join(directory, filename)
        if not os.path.exists(full_path):
            # Try alternative paths
            alt_paths = [
                file_path,
                os.path.join('static', file_path),
                os.path.join('static/uploads', file_path),
                os.path.join(os.getcwd(), file_path),
                os.path.join(os.getcwd(), 'static', file_path)
            ]
            
            file_found = False
            for alt_path in alt_paths:
                if os.path.exists(alt_path):
                    full_path = alt_path
                    directory = os.path.dirname(alt_path)
                    filename = os.path.basename(alt_path)
                    file_found = True
                    break
            
            if not file_found:
                flash(f'File tidak ditemukan di server! Path: {file_path}', 'danger')
                return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Determine MIME type
        mime_type, _ = mimetypes.guess_type(filename)
        if mime_type is None:
            mime_type = 'application/octet-stream'
        
        # Use send_from_directory for better security
        try:
            return send_from_directory(directory, filename, as_attachment=False, mimetype=mime_type)
        except Exception as e:
            logger.error(f"Error sending file: {str(e)}")
            # Fallback to send_file
            return send_file(full_path, as_attachment=False, mimetype=mime_type)
        
    except Exception as e:
        logger.error(f"Error saat membuka file laporan akhir: {str(e)}")
        flash('Terjadi kesalahan saat membuka file laporan akhir!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))

@reviewer_bp.route('/simpan_penilaian_laporan_kemajuan', methods=['POST'])
def simpan_penilaian_laporan_kemajuan():
    logger.info("Simpan penilaian laporan kemajuan dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        proposal_id = request.form.get('proposal_id')
        komentar_reviewer = request.form.get('komentar_reviewer')
        rekomendasi_pendanaan = request.form.get('rekomendasi_pendanaan')
        alasan_rekomendasi = request.form.get('alasan_rekomendasi')
        detail_penilaian = json.loads(request.form.get('detail_penilaian'))
        
        # Debug: Log data yang diterima
        logger.info(f"DEBUG: Data yang diterima dari frontend:")
        logger.info(f"proposal_id: {proposal_id}")
        logger.info(f"komentar_reviewer: {komentar_reviewer}")
        logger.info(f"rekomendasi_pendanaan: '{rekomendasi_pendanaan}' (type: {type(rekomendasi_pendanaan)})")
        logger.info(f"alasan_rekomendasi: '{alasan_rekomendasi}' (type: {type(alasan_rekomendasi)})")
        logger.info(f"detail_penilaian count: {len(detail_penilaian) if detail_penilaian else 0}")
        
        # Validasi data yang dikirim
        if not proposal_id or not komentar_reviewer or not rekomendasi_pendanaan or not alasan_rekomendasi or not detail_penilaian:
            return jsonify({'success': False, 'message': 'Semua data penilaian harus diisi!'})
        
        reviewer_id = session.get('user_id')
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # Tambahkan kolom rekomendasi_pendanaan jika belum ada
        try:
            cursor.execute('ALTER TABLE penilaian_laporan_kemajuan ADD COLUMN rekomendasi_pendanaan VARCHAR(50) DEFAULT NULL')
            get_app_functions()['mysql'].connection.commit()
            print("DEBUG: Berhasil menambahkan kolom rekomendasi_pendanaan ke tabel penilaian_laporan_kemajuan")
        except Exception as e:
            if "Duplicate column name" in str(e):
                print("DEBUG: Kolom rekomendasi_pendanaan sudah ada di tabel penilaian_laporan_kemajuan")
            else:
                print(f"DEBUG: Error menambahkan kolom rekomendasi_pendanaan: {str(e)}")
        
        # Tambahkan kolom alasan_rekomendasi jika belum ada
        try:
            cursor.execute('ALTER TABLE penilaian_laporan_kemajuan ADD COLUMN alasan_rekomendasi TEXT DEFAULT NULL')
            get_app_functions()['mysql'].connection.commit()
            print("DEBUG: Berhasil menambahkan kolom alasan_rekomendasi ke tabel penilaian_laporan_kemajuan")
        except Exception as e:
            if "Duplicate column name" in str(e):
                print("DEBUG: Kolom alasan_rekomendasi sudah ada di tabel penilaian_laporan_kemajuan")
            else:
                print(f"DEBUG: Error menambahkan kolom alasan_rekomendasi: {str(e)}")
        
        # Tambahkan kolom tanggal_penilaian jika belum ada
        try:
            cursor.execute('ALTER TABLE penilaian_laporan_kemajuan ADD COLUMN tanggal_penilaian TIMESTAMP DEFAULT CURRENT_TIMESTAMP')
            get_app_functions()['mysql'].connection.commit()
            print("DEBUG: Berhasil menambahkan kolom tanggal_penilaian ke tabel penilaian_laporan_kemajuan")
        except Exception as e:
            if "Duplicate column name" in str(e):
                print("DEBUG: Kolom tanggal_penilaian sudah ada di tabel penilaian_laporan_kemajuan")
            else:
                print(f"DEBUG: Error menambahkan kolom tanggal_penilaian: {str(e)}")
        
        # Cek apakah proposal ditugaskan ke reviewer ini
        cursor.execute('''
            SELECT * FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        assignment = cursor.fetchone()
        if not assignment:
            cursor.close()
            return jsonify({'success': False, 'message': 'Proposal tidak ditemukan atau tidak ditugaskan kepada Anda!'})
        
        # Hitung nilai akhir dengan rumus baru
        total_bobot = sum(float(detail['bobot_pertanyaan']) for detail in detail_penilaian)
        total_nilai = sum(float(detail['nilai_terbobot']) for detail in detail_penilaian)
        
        # PERBAIKAN: Cari skor maksimal tertinggi dari snapshot pertanyaan laporan kemajuan
        pertanyaan_snapshot = get_pertanyaan_laporan_kemajuan_snapshot(cursor)
        skor_maksimal_tertinggi = max([p['skor_maksimal'] for p in pertanyaan_snapshot]) if pertanyaan_snapshot else 100
        
        # RUMUS BARU: total nilai akhir = (total nilai / (total bobot × skor maksimal tertinggi)) × 100
        nilai_akhir = (total_nilai / (total_bobot * skor_maksimal_tertinggi)) * 100 if (total_bobot > 0 and skor_maksimal_tertinggi > 0) else 0
        
        # Cek apakah sudah ada penilaian
        cursor.execute('''
            SELECT * FROM penilaian_laporan_kemajuan
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        existing_penilaian = cursor.fetchone()
        
        if existing_penilaian:
            # Update penilaian yang sudah ada
            logger.info(f"DEBUG: Update penilaian existing dengan ID: {existing_penilaian['id']}")
            logger.info(f"DEBUG: Data yang akan diupdate: nilai_akhir={nilai_akhir}, rekomendasi='{rekomendasi_pendanaan}', alasan='{alasan_rekomendasi}'")
            
            cursor.execute('''
                UPDATE penilaian_laporan_kemajuan 
                SET nilai_akhir = %s, komentar_reviewer = %s, rekomendasi_pendanaan = %s, alasan_rekomendasi = %s, tanggal_penilaian = NOW()
                WHERE id_proposal = %s AND id_reviewer = %s
            ''', (nilai_akhir, komentar_reviewer, rekomendasi_pendanaan, alasan_rekomendasi, proposal_id, reviewer_id))
            
            penilaian_id = existing_penilaian['id']
            logger.info(f"DEBUG: Update berhasil untuk penilaian ID: {penilaian_id}")
        else:
            # Insert penilaian baru
            logger.info(f"DEBUG: Insert penilaian baru")
            logger.info(f"DEBUG: Data yang akan diinsert: proposal_id={proposal_id}, reviewer_id={reviewer_id}, nilai_akhir={nilai_akhir}, rekomendasi='{rekomendasi_pendanaan}', alasan='{alasan_rekomendasi}'")
            
            cursor.execute('''
                INSERT INTO penilaian_laporan_kemajuan 
                (id_proposal, id_reviewer, nilai_akhir, komentar_reviewer, rekomendasi_pendanaan, alasan_rekomendasi, tanggal_penilaian)
                VALUES (%s, %s, %s, %s, %s, %s, NOW())
            ''', (proposal_id, reviewer_id, nilai_akhir, komentar_reviewer, rekomendasi_pendanaan, alasan_rekomendasi))
            
            penilaian_id = cursor.lastrowid
            logger.info(f"DEBUG: Insert berhasil dengan ID: {penilaian_id}")
        
        # Hapus detail penilaian lama jika ada
        cursor.execute('''
            DELETE FROM detail_penilaian_laporan_kemajuan 
            WHERE id_penilaian_laporan_kemajuan = %s
        ''', (penilaian_id,))
        
        # Simpan detail penilaian baru dengan rumus baru: bobot × skor = nilai
        logger.info(f"DEBUG: Mulai menyimpan {len(detail_penilaian)} detail penilaian")
        for i, detail in enumerate(detail_penilaian):
            # Konversi tipe data untuk memastikan kompatibilitas dengan database
            skor_diberikan = int(detail['skor_diberikan'])
            bobot_pertanyaan = float(detail['bobot_pertanyaan'])
            skor_maksimal = int(detail['skor_maksimal'])
            
            # RUMUS BARU: nilai_terbobot = bobot × skor
            nilai_terbobot = bobot_pertanyaan * skor_diberikan
            
            logger.info(f"DEBUG: Detail {i+1}: id_pertanyaan={detail['id_pertanyaan']}, skor={skor_diberikan}, bobot={bobot_pertanyaan}, maksimal={skor_maksimal}, nilai={nilai_terbobot}")
            
            cursor.execute('''
                INSERT INTO detail_penilaian_laporan_kemajuan 
                (id_penilaian_laporan_kemajuan, id_pertanyaan, skor_diberikan, bobot_pertanyaan, skor_maksimal, nilai_terbobot)
                VALUES (%s, %s, %s, %s, %s, %s)
            ''', (penilaian_id, detail['id_pertanyaan'], skor_diberikan, 
                  bobot_pertanyaan, skor_maksimal, nilai_terbobot))
        
        get_app_functions()['mysql'].connection.commit()
        logger.info(f"DEBUG: Commit berhasil untuk penilaian ID: {penilaian_id}")
        cursor.close()
        
        is_update = existing_penilaian is not None
        
        logger.info(f"Penilaian laporan kemajuan berhasil {'diperbarui' if is_update else 'disimpan'} untuk proposal {proposal_id} oleh reviewer {reviewer_id}")
        return jsonify({
            'success': True, 
            'message': 'Penilaian laporan kemajuan berhasil diperbarui!' if is_update else 'Penilaian laporan kemajuan berhasil disimpan!'
        })
        
    except Exception as e:
        logger.error(f"Error saat menyimpan penilaian laporan kemajuan: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat menyimpan penilaian laporan kemajuan!'})


@reviewer_bp.route('/daftar_mahasiswa_laporan_akhir')
def daftar_mahasiswa_laporan_akhir():
    logger.info("Halaman daftar mahasiswa laporan akhir dipanggil")
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Ambil daftar proposal yang ditugaskan ke reviewer ini dan memiliki laporan akhir
        cursor.execute('''
            SELECT DISTINCT p.id as id_proposal, p.judul_usaha, p.tahapan_usaha, p.kategori,
                   m.nama_ketua, m.nim, m.program_studi, m.perguruan_tinggi,
                   p.dosen_pembimbing, p.status as status_proposal,
                   CASE 
                       WHEN pla.id IS NOT NULL THEN 'sudah_dinilai'
                       ELSE 'belum_dinilai'
                   END as status_review_laporan_akhir
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            JOIN proposal_reviewer pr ON p.id = pr.id_proposal
            LEFT JOIN penilaian_laporan_akhir pla ON p.id = pla.id_proposal AND pla.id_reviewer = %s
            WHERE pr.id_reviewer = %s
            AND EXISTS (
                SELECT 1 FROM laporan_akhir_awal laa WHERE laa.id_proposal = p.id
                UNION
                SELECT 1 FROM laporan_akhir_bertumbuh lab WHERE lab.id_proposal = p.id
            )
            ORDER BY p.id DESC
        ''', (reviewer_id, reviewer_id))
        
        proposals = cursor.fetchall()
        cursor.close()
        
        # Tambahkan status jadwal untuk laporan akhir
        jadwal_akhir = get_jadwal_reviewer_status('laporan_akhir')
        
        return render_template('reviewer/daftar_mahasiswa_laporan_akhir.html', 
                             proposals=proposals,
                             jadwal_akhir=jadwal_akhir)
        
    except Exception as e:
        logger.error(f"Error saat mengambil daftar mahasiswa laporan akhir: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data!', 'danger')
        return redirect(url_for('reviewer.dashboard'))


@reviewer_bp.route('/laporan_akhir_awal_bertumbuh/<int:proposal_id>')
def laporan_akhir_awal_bertumbuh(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah reviewer memiliki akses ke proposal ini
        cursor.execute('''
            SELECT 1 FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        if not cursor.fetchone():
            flash('Anda tidak memiliki akses ke proposal ini!', 'danger')
            cursor.close()
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Ambil data proposal dan mahasiswa
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.nim, m.program_studi, m.perguruan_tinggi
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        proposal = cursor.fetchone()
        if not proposal:
            flash('Proposal tidak ditemukan!', 'danger')
            cursor.close()
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Tentukan tabel laporan akhir berdasarkan tahapan usaha
        tahapan_usaha = proposal.get('tahapan_usaha', '').lower()
        if 'bertumbuh' in tahapan_usaha:
            tabel_laporan = 'laporan_akhir_bertumbuh'
        else:
            tabel_laporan = 'laporan_akhir_awal'
        
        # Ambil data laporan akhir (semua status untuk review)
        cursor.execute(f'''
            SELECT id, id_proposal, kegiatan_utama, kegiatan, penanggung_jawab, target_capaian,
                   nama_barang, kuantitas, satuan, harga_satuan, jumlah, keterangan, status
            FROM {tabel_laporan}
            WHERE id_proposal = %s
            ORDER BY kegiatan_utama, kegiatan, nama_barang
        ''', (proposal_id,))
        
        anggaran_data = cursor.fetchall()
        logger.info(f"Jumlah data laporan akhir untuk proposal {proposal_id}: {len(anggaran_data)}")
        
        # Debug: Log detail setiap item laporan akhir
        if anggaran_data:
            for i, row in enumerate(anggaran_data):
                logger.info(f"Item {i+1}: {row.get('nama_barang', 'N/A')} - Qty: {row.get('kuantitas', 0)} - Harga: {row.get('harga_satuan', 0)} - Jumlah: {row.get('jumlah', 0)}")
        
        # Proses data untuk tampilan tabel dengan struktur yang benar
        anggaran_data_flat = []
        if anggaran_data:
            anggaran_data_flat = flatten_anggaran_data(anggaran_data)
            logger.info(f"Data berhasil di-flatten menjadi {len(anggaran_data_flat)} baris")
            
            # Debug: Log detail data yang akan dikirim ke template
            logger.info("=== DETAIL DATA ANGGARAN DATA FLAT ===")
            for i, row in enumerate(anggaran_data_flat):
                logger.info(f"Row {i+1}: kegiatan_utama='{row.get('kegiatan_utama', 'N/A')}', kegiatan='{row.get('kegiatan', 'N/A')}', nama_barang='{row.get('nama_barang', 'N/A')}', jumlah={row.get('jumlah', 'N/A')}")
            logger.info("=====================================")
        
        # Hitung total laporan akhir dengan validasi data
        total_laporan_akhir = 0
        if anggaran_data:
            for row in anggaran_data:
                jumlah = row.get('jumlah', 0)
                if jumlah is not None and jumlah != '':
                    try:
                        total_laporan_akhir += float(jumlah)
                    except (ValueError, TypeError):
                        logger.warning(f"Invalid jumlah value: {jumlah} for item {row.get('nama_barang', 'N/A')}")
                        total_laporan_akhir += 0
                else:
                    logger.warning(f"Missing jumlah value for item {row.get('nama_barang', 'N/A')}")
        
        logger.info(f"Total laporan akhir dihitung: {total_laporan_akhir}")
        
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
        
        total_nilai_bantuan_result = cursor.fetchone()
        total_nilai_bantuan = total_nilai_bantuan_result.get('total_nilai_bantuan', 0) if total_nilai_bantuan_result else 0
        logger.info(f"Total nilai bantuan dari {tabel_anggaran}: {total_nilai_bantuan}")
        
        # Hitung total laporan kemajuan yang disetujui untuk perhitungan sisa
        cursor.execute('''
            SELECT 
                (COALESCE((SELECT SUM(jumlah) FROM laporan_kemajuan_awal WHERE id_proposal = %s AND status = 'disetujui'), 0) +
                 COALESCE((SELECT SUM(jumlah) FROM laporan_kemajuan_bertumbuh WHERE id_proposal = %s AND status = 'disetujui'), 0)) as total_laporan_kemajuan_disetujui
        ''', (proposal_id, proposal_id))
        
        total_laporan_kemajuan_result = cursor.fetchone()
        total_laporan_kemajuan_disetujui = total_laporan_kemajuan_result.get('total_laporan_kemajuan_disetujui', 0) if total_laporan_kemajuan_result else 0
        logger.info(f"Total laporan kemajuan yang disetujui: {total_laporan_kemajuan_disetujui}")
        
        # Ambil data file laporan akhir
        cursor.execute('''
            SELECT id, nama_file, file_path, status, komentar_pembimbing, tanggal_upload, tanggal_update
            FROM file_laporan_akhir 
            WHERE id_proposal = %s
            ORDER BY id DESC
            LIMIT 1
        ''', (proposal_id,))
        
        file_laporan_akhir = cursor.fetchone()
        cursor.close()
        
        # Buat mahasiswa_info dari data proposal untuk konsistensi dengan template
        mahasiswa_info = {
            'nama_ketua': proposal.get('nama_ketua'),
            'nim': proposal.get('nim'),
            'program_studi': proposal.get('program_studi'),
            'perguruan_tinggi': proposal.get('perguruan_tinggi'),
            'judul_usaha': proposal.get('judul_usaha'),
            'tahapan_usaha': proposal.get('tahapan_usaha'),
            'status_proposal': proposal.get('status')
        }
        
        # Hitung dan log sisa
        sisa = total_nilai_bantuan - total_laporan_kemajuan_disetujui
        logger.info(f"Perhitungan SISA: {total_nilai_bantuan} - {total_laporan_kemajuan_disetujui} = {sisa}")
        
        # Summary log
        logger.info(f"=== SUMMARY LAPORAN AKHIR PROPOSAL {proposal_id} ===")
        logger.info(f"Total Laporan Akhir: {total_laporan_akhir}")
        logger.info(f"Total Nilai Bantuan: {total_nilai_bantuan}")
        logger.info(f"Total Laporan Kemajuan Disetujui: {total_laporan_kemajuan_disetujui}")
        logger.info(f"SISA: {sisa}")
        logger.info(f"================================================")
        
        logger.info(f"Rendering template dengan {len(anggaran_data_flat)} data anggaran")
        return render_template('reviewer/laporan_akhir_awal_bertumbuh.html', 
                             proposal=proposal,
                             mahasiswa_info=mahasiswa_info,
                             anggaran_data_flat=anggaran_data_flat,
                             file_laporan_akhir=file_laporan_akhir,
                             proposal_id=proposal_id,
                             total_nilai_bantuan=total_nilai_bantuan,
                             total_laporan_kemajuan_disetujui=total_laporan_kemajuan_disetujui,
                             total_laporan_akhir=total_laporan_akhir)
        
    except Exception as e:
        logger.error(f"Error saat mengambil laporan akhir: {str(e)}")
        flash('Terjadi kesalahan saat mengambil data!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))


@reviewer_bp.route('/penilaian_akhir/<int:proposal_id>')
def penilaian_akhir(proposal_id):
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        flash('Anda harus login sebagai reviewer!', 'danger')
        return redirect(url_for('index'))
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Cek apakah reviewer memiliki akses ke proposal ini
        cursor.execute('''
            SELECT 1 FROM proposal_reviewer 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        if not cursor.fetchone():
            flash('Anda tidak memiliki akses ke proposal ini!', 'danger')
            cursor.close()
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Ambil data proposal
        cursor.execute('''
            SELECT p.*, m.nama_ketua, m.nim, m.program_studi
            FROM proposal p
            JOIN mahasiswa m ON p.nim = m.nim
            WHERE p.id = %s
        ''', (proposal_id,))
        
        proposal = cursor.fetchone()
        if not proposal:
            flash('Proposal tidak ditemukan!', 'danger')
            cursor.close()
            return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))
        
        # Jika sudah melewati jadwal selesai penilaian AKHIR, otomatis simpan nilai 0 jika belum ada
        try:
            cursor2 = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
            cursor2.execute('SELECT reviewer_akhir_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1')
            jadwal = cursor2.fetchone()
            if jadwal and jadwal.get('reviewer_akhir_selesai'):
                from datetime import datetime
                if datetime.now() > jadwal['reviewer_akhir_selesai']:
                    cursor2.execute('SELECT id FROM penilaian_laporan_akhir WHERE id_proposal=%s AND id_reviewer=%s', (proposal_id, reviewer_id))
                    ex = cursor2.fetchone()
                    if not ex:
                        # header 0: rekomendasi 'tidak lolos'
                        cursor2.execute('''
                            INSERT INTO penilaian_laporan_akhir (id_proposal, id_reviewer, nilai_akhir, komentar_reviewer, rekomendasi_kelulusan, alasan_rekomendasi, tanggal_penilaian)
                            VALUES (%s,%s,%s,%s,%s,%s,NOW())
                        ''', (proposal_id, reviewer_id, 0, '', 'tidak lolos', ''))
                        pen_id = cursor2.lastrowid
                        # PERBAIKAN: Gunakan snapshot pertanyaan
                        pts = get_pertanyaan_laporan_akhir_snapshot(cursor2)
                        for p in pts:
                            nilai_baru = p['bobot'] * 0  # bobot × 0 = 0
                            cursor2.execute('''
                                INSERT INTO detail_penilaian_laporan_akhir (id_penilaian_laporan_akhir, id_pertanyaan, skor_diberikan, bobot_pertanyaan, skor_maksimal, nilai_terbobot)
                                VALUES (%s,%s,%s,%s,%s,%s)
                            ''', (pen_id, p['id'], 0, p['bobot'], p['skor_maksimal'], nilai_baru))
                        get_app_functions()['mysql'].connection.commit()
            cursor2.close()
        except Exception:
            try:
                cursor2.close()
            except Exception:
                pass

        cursor.close()
        return render_template('reviewer/penilaian_akhir.html', proposal=proposal)
        
    except Exception as e:
        logger.error(f"Error saat membuka halaman penilaian akhir: {str(e)}")
        flash('Terjadi kesalahan saat membuka halaman penilaian!', 'danger')
        return redirect(url_for('reviewer.daftar_mahasiswa_laporan_akhir'))


@reviewer_bp.route('/get_pertanyaan_penilaian_laporan_akhir')
def get_pertanyaan_penilaian_laporan_akhir():
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Akses ditolak!'})
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        
        # PERBAIKAN: Ambil pertanyaan berdasarkan snapshot
        pertanyaan = get_pertanyaan_laporan_akhir_snapshot(cursor)
        cursor.close()
        
        return jsonify({
            'success': True,
            'data': pertanyaan
        })
        
    except Exception as e:
        logger.error(f"Error saat mengambil pertanyaan penilaian: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengambil pertanyaan penilaian!'})


@reviewer_bp.route('/get_skor_tersimpan_laporan_akhir')
def get_skor_tersimpan_laporan_akhir():
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai reviewer!'})
    
    proposal_id = request.args.get('proposal_id', type=int)
    if not proposal_id:
        return jsonify({'success': False, 'message': 'ID proposal tidak valid!'})
    
    try:
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # Ambil data penilaian yang sudah tersimpan
        cursor.execute('''
            SELECT pla.*, dpla.id_pertanyaan, dpla.skor_diberikan, dpla.bobot_pertanyaan, 
                   dpla.skor_maksimal, dpla.nilai_terbobot
            FROM penilaian_laporan_akhir pla
            LEFT JOIN detail_penilaian_laporan_akhir dpla ON pla.id = dpla.id_penilaian_laporan_akhir
            WHERE pla.id_proposal = %s AND pla.id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        penilaian_data = cursor.fetchall()
        cursor.close()
        
        if penilaian_data:
            # Format data untuk frontend
            detail_penilaian = []
            for row in penilaian_data:
                if row['id_pertanyaan']:
                    detail_penilaian.append({
                        'id_pertanyaan': row['id_pertanyaan'],
                        'skor_diberikan': row['skor_diberikan'],
                        'bobot_pertanyaan': row['bobot_pertanyaan'],
                        'skor_maksimal': row['skor_maksimal'],
                        'nilai_terbobot': row['nilai_terbobot']
                    })
            
            return jsonify({
                'success': True,
                'data': {
                    'nilai_akhir': penilaian_data[0].get('nilai_akhir', 0),
                    'komentar_reviewer': penilaian_data[0].get('komentar_reviewer', ''),
                    'rekomendasi_kelulusan': penilaian_data[0].get('rekomendasi_kelulusan', ''),
                    'alasan_rekomendasi': penilaian_data[0].get('alasan_rekomendasi', ''),
                    'detail_penilaian': detail_penilaian
                }
            })
        else:
            return jsonify({'success': True, 'data': None})
        
    except Exception as e:
        logger.error(f"Error saat mengambil skor tersimpan laporan akhir: {str(e)}")
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat mengambil data!'})


@reviewer_bp.route('/simpan_penilaian_laporan_akhir', methods=['POST'])
def simpan_penilaian_laporan_akhir():
    if 'user_type' not in session or session['user_type'] != 'reviewer':
        return jsonify({'success': False, 'message': 'Anda harus login sebagai reviewer!'})
    
    try:
        proposal_id = request.form.get('proposal_id')
        komentar_reviewer = request.form.get('komentar_reviewer', '')
        rekomendasi_kelulusan = request.form.get('rekomendasi_kelulusan', '')
        alasan_rekomendasi = request.form.get('alasan_rekomendasi', '')
        detail_penilaian_json = request.form.get('detail_penilaian', '[]')
        
        if not proposal_id:
            return jsonify({'success': False, 'message': 'ID proposal tidak ditemukan!'})
        
        # Parse detail penilaian dari JSON
        try:
            detail_penilaian = json.loads(detail_penilaian_json)
        except json.JSONDecodeError:
            return jsonify({'success': False, 'message': 'Format data detail penilaian tidak valid!'})
        
        if not detail_penilaian:
            return jsonify({'success': False, 'message': 'Data detail penilaian tidak boleh kosong!'})
        
        # Validasi rekomendasi kelulusan
        if rekomendasi_kelulusan not in ['lulus sempurna', 'tidak lolos']:
            return jsonify({'success': False, 'message': 'Rekomendasi kelulusan tidak valid!'})
        
        # Hitung nilai akhir dengan rumus baru
        total_nilai = sum(float(detail['nilai_terbobot']) for detail in detail_penilaian)
        total_bobot = sum(float(detail['bobot_pertanyaan']) for detail in detail_penilaian)
        
        cursor = get_app_functions()['mysql'].connection.cursor(MySQLdb.cursors.DictCursor)
        reviewer_id = session.get('user_id')
        
        # PERBAIKAN: Cari skor maksimal tertinggi dari snapshot pertanyaan laporan akhir
        pertanyaan_snapshot = get_pertanyaan_laporan_akhir_snapshot(cursor)
        skor_maksimal_tertinggi = max([p['skor_maksimal'] for p in pertanyaan_snapshot]) if pertanyaan_snapshot else 100
        
        # RUMUS BARU: total nilai akhir = (total nilai / (total bobot × skor maksimal tertinggi)) × 100
        nilai_akhir = (total_nilai / (total_bobot * skor_maksimal_tertinggi)) * 100 if (total_bobot > 0 and skor_maksimal_tertinggi > 0) else 0
        
        # Cek apakah sudah ada penilaian
        cursor.execute('''
            SELECT id FROM penilaian_laporan_akhir 
            WHERE id_proposal = %s AND id_reviewer = %s
        ''', (proposal_id, reviewer_id))
        
        existing_penilaian = cursor.fetchone()
        
        if existing_penilaian:
            # Update penilaian yang ada
            cursor.execute('''
                UPDATE penilaian_laporan_akhir 
                SET nilai_akhir = %s, komentar_reviewer = %s, rekomendasi_kelulusan = %s, alasan_rekomendasi = %s, tanggal_penilaian = NOW()
                WHERE id_proposal = %s AND id_reviewer = %s
            ''', (nilai_akhir, komentar_reviewer, rekomendasi_kelulusan, alasan_rekomendasi, proposal_id, reviewer_id))
            
            penilaian_id = existing_penilaian['id']
        else:
            # Insert penilaian baru
            cursor.execute('''
                INSERT INTO penilaian_laporan_akhir 
                (id_proposal, id_reviewer, nilai_akhir, komentar_reviewer, rekomendasi_kelulusan, alasan_rekomendasi, tanggal_penilaian)
                VALUES (%s, %s, %s, %s, %s, %s, NOW())
            ''', (proposal_id, reviewer_id, nilai_akhir, komentar_reviewer, rekomendasi_kelulusan, alasan_rekomendasi))
            
            penilaian_id = cursor.lastrowid
        
        # Hapus detail penilaian lama jika ada
        cursor.execute('''
            DELETE FROM detail_penilaian_laporan_akhir 
            WHERE id_penilaian_laporan_akhir = %s
        ''', (penilaian_id,))
        
        # Simpan detail penilaian baru dengan rumus baru: bobot × skor = nilai
        for detail in detail_penilaian:
            # RUMUS BARU: nilai_terbobot = bobot × skor
            nilai_terbobot = float(detail['bobot_pertanyaan']) * float(detail['skor_diberikan'])
            
            cursor.execute('''
                INSERT INTO detail_penilaian_laporan_akhir 
                (id_penilaian_laporan_akhir, id_pertanyaan, skor_diberikan, bobot_pertanyaan, skor_maksimal, nilai_terbobot)
                VALUES (%s, %s, %s, %s, %s, %s)
            ''', (penilaian_id, detail['id_pertanyaan'], detail['skor_diberikan'], 
                  detail['bobot_pertanyaan'], detail['skor_maksimal'], nilai_terbobot))
        
        get_app_functions()['mysql'].connection.commit()
        cursor.close()
        
        is_update = existing_penilaian is not None
        
        return jsonify({
            'success': True, 
            'message': 'Penilaian laporan akhir berhasil diperbarui!' if is_update else 'Penilaian laporan akhir berhasil disimpan!'
        })
        
    except Exception as e:
        logger.error(f"Error saat menyimpan penilaian laporan akhir: {str(e)}")
        if 'cursor' in locals():
            cursor.close()
        return jsonify({'success': False, 'message': 'Terjadi kesalahan saat menyimpan penilaian laporan akhir!'})

