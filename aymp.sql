-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 24 Agu 2025 pada 17.02
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aymp`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `nip` varchar(30) NOT NULL,
  `program_studi` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `tanggal_dibuat` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `admin`
--

INSERT INTO `admin` (`id`, `nama`, `nip`, `program_studi`, `password`, `tanggal_dibuat`) VALUES
(3, 'admin', '12345', 'Sistem Informasi', 'scrypt:32768:8:1$u2uDQqvHsrXBH8Tj$9a2a6c1f88c9ed967e64d56a4661d7e019f81146bebac328ce155c7ed8c549213cfa5d153ba341d12faffb415bfe1bae0fad70a8801dc58d9ebc1366bdb46327', '2025-07-17 20:34:36');

-- --------------------------------------------------------

--
-- Struktur dari tabel `alat_produksi`
--

CREATE TABLE `alat_produksi` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `nama_alat` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `harga` decimal(15,2) NOT NULL,
  `harga_jual` decimal(15,2) DEFAULT 0.00,
  `total_alat_produksi` decimal(20,2) NOT NULL DEFAULT 0.00,
  `tanggal_beli` date NOT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `anggaran_awal`
--

CREATE TABLE `anggaran_awal` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) DEFAULT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00,
  `status_reviewer` enum('belum_direview','sudah_direview','tolak_bantuan') DEFAULT 'belum_direview',
  `tanggal_review_reviewer` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `anggaran_bertumbuh`
--

CREATE TABLE `anggaran_bertumbuh` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) NOT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00,
  `status_reviewer` enum('belum_direview','sudah_direview','tolak_bantuan') DEFAULT 'belum_direview',
  `tanggal_review_reviewer` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `anggota_tim`
--

CREATE TABLE `anggota_tim` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `perguruan_tinggi` varchar(100) NOT NULL,
  `program_studi` varchar(100) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `no_telp` varchar(20) NOT NULL,
  `tanggal_tambah` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `arus_kas`
--

CREATE TABLE `arus_kas` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `bulan_tahun` varchar(7) NOT NULL,
  `total_penjualan` decimal(15,2) DEFAULT 0.00,
  `total_biaya_produksi` decimal(15,2) DEFAULT 0.00,
  `total_biaya_operasional` decimal(15,2) DEFAULT 0.00,
  `total_biaya_non_operasional` decimal(15,2) DEFAULT 0.00,
  `kas_bersih_operasional` decimal(15,2) DEFAULT 0.00,
  `total_harga_jual_alat` decimal(15,2) DEFAULT 0.00,
  `total_harga_alat` decimal(15,2) DEFAULT 0.00,
  `kas_bersih_investasi` decimal(15,2) DEFAULT 0.00,
  `kas_bersih_pembiayaan` decimal(15,2) DEFAULT 0.00,
  `total_kas_bersih` decimal(15,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bahan_baku`
--

CREATE TABLE `bahan_baku` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `nama_bahan` varchar(255) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `total_harga` decimal(15,2) NOT NULL,
  `tanggal_beli` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `biaya_non_operasional`
--

CREATE TABLE `biaya_non_operasional` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `nama_biaya` varchar(255) NOT NULL,
  `quantity` int(11) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `total_harga` decimal(15,2) NOT NULL,
  `tanggal_transaksi` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `biaya_operasional`
--

CREATE TABLE `biaya_operasional` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `nama_biaya` varchar(255) NOT NULL,
  `estimasi_hari_habis` int(11) NOT NULL,
  `estimasi_aktif_digunakan` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `total_harga` decimal(15,2) NOT NULL,
  `tanggal_beli` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bimbingan`
--

CREATE TABLE `bimbingan` (
  `id` int(11) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `judul_bimbingan` varchar(255) NOT NULL,
  `hasil_bimbingan` text DEFAULT NULL,
  `tanggal_buat` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_penilaian_laporan_akhir`
--

CREATE TABLE `detail_penilaian_laporan_akhir` (
  `id` int(11) NOT NULL,
  `id_penilaian_laporan_akhir` int(11) NOT NULL,
  `id_pertanyaan` int(11) NOT NULL,
  `skor_diberikan` int(11) NOT NULL DEFAULT 0,
  `bobot_pertanyaan` decimal(5,2) NOT NULL DEFAULT 0.00,
  `skor_maksimal` int(11) NOT NULL DEFAULT 100,
  `nilai_terbobot` decimal(8,2) NOT NULL DEFAULT 0.00,
  `skor` int(11) NOT NULL COMMENT 'Skor yang diberikan reviewer',
  `nilai` decimal(5,2) NOT NULL COMMENT 'Nilai = (skor/skor_maksimal) * bobot',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_penilaian_laporan_kemajuan`
--

CREATE TABLE `detail_penilaian_laporan_kemajuan` (
  `id` int(11) NOT NULL,
  `id_penilaian_laporan_kemajuan` int(11) NOT NULL,
  `id_pertanyaan` int(11) NOT NULL,
  `skor_diberikan` int(11) NOT NULL COMMENT 'Skor yang diberikan reviewer',
  `bobot_pertanyaan` decimal(5,2) NOT NULL COMMENT 'Bobot pertanyaan',
  `skor_maksimal` int(11) NOT NULL COMMENT 'Skor maksimal pertanyaan',
  `nilai_terbobot` decimal(5,2) NOT NULL COMMENT 'Nilai = (skor/skor_maksimal) * bobot',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_penilaian_mahasiswa`
--

CREATE TABLE `detail_penilaian_mahasiswa` (
  `id` int(11) NOT NULL,
  `id_penilaian_mahasiswa` int(11) NOT NULL,
  `id_pertanyaan` int(11) NOT NULL,
  `skor` int(11) NOT NULL COMMENT 'Skor yang diberikan pembimbing',
  `nilai` decimal(5,2) NOT NULL COMMENT 'Nilai = (skor/skor_maksimal) * bobot',
  `sesi_penilaian` int(11) NOT NULL DEFAULT 1 COMMENT 'Sesi penilaian ke-berapa (1,2,3,dst)',
  `is_locked` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Apakah skor sudah dikunci',
  `tanggal_input` datetime DEFAULT NULL COMMENT 'Tanggal skor diinput',
  `metadata_kolom_id` int(11) DEFAULT NULL COMMENT 'Referensi ke metadata kolom dari admin',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `detail_penilaian_proposal`
--

CREATE TABLE `detail_penilaian_proposal` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_reviewer` int(11) NOT NULL,
  `id_pertanyaan` int(11) NOT NULL,
  `skor` decimal(5,2) NOT NULL DEFAULT 0.00,
  `bobot` decimal(5,2) NOT NULL DEFAULT 0.00,
  `nilai` decimal(5,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `file_laporan_akhir`
--

CREATE TABLE `file_laporan_akhir` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `nama_file` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `status` enum('draf','diajukan','disetujui','revisi') DEFAULT 'draf',
  `komentar_pembimbing` text DEFAULT NULL,
  `tanggal_upload` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `file_laporan_kemajuan`
--

CREATE TABLE `file_laporan_kemajuan` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `nama_file` varchar(255) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `status` enum('draf','diajukan','disetujui','revisi') DEFAULT 'draf',
  `komentar_pembimbing` text DEFAULT NULL,
  `tanggal_upload` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_update` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laba_rugi`
--

CREATE TABLE `laba_rugi` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `tanggal_produksi` date NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `pendapatan` decimal(15,2) DEFAULT 0.00,
  `total_biaya_produksi` decimal(15,2) DEFAULT 0.00,
  `laba_rugi_kotor` decimal(15,2) DEFAULT 0.00,
  `biaya_operasional` decimal(15,2) DEFAULT 0.00,
  `laba_rugi_bersih` decimal(15,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_akhir_awal`
--

CREATE TABLE `laporan_akhir_awal` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) DEFAULT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_akhir_bertumbuh`
--

CREATE TABLE `laporan_akhir_bertumbuh` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) NOT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_kemajuan_awal`
--

CREATE TABLE `laporan_kemajuan_awal` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) DEFAULT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_kemajuan_bertumbuh`
--

CREATE TABLE `laporan_kemajuan_bertumbuh` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `kegiatan_utama` varchar(255) NOT NULL,
  `kegiatan` varchar(255) NOT NULL,
  `penanggung_jawab` varchar(100) NOT NULL,
  `target_capaian` text NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `kuantitas` int(11) NOT NULL,
  `satuan` varchar(50) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `jumlah` decimal(15,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('draf','diajukan','disetujui','ditolak','revisi') DEFAULT 'draf',
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `nilai_bantuan` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `laporan_neraca`
--

CREATE TABLE `laporan_neraca` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `tanggal_neraca` date NOT NULL,
  `kas_setara_kas` decimal(15,2) DEFAULT 0.00,
  `piutang_usaha` decimal(15,2) DEFAULT 0.00,
  `persediaan` decimal(15,2) DEFAULT 0.00,
  `beban_dibayar_dimuka` decimal(15,2) DEFAULT 0.00,
  `total_aset_lancar` decimal(15,2) DEFAULT 0.00,
  `tanah` decimal(15,2) DEFAULT 0.00,
  `bangunan` decimal(15,2) DEFAULT 0.00,
  `kendaraan` decimal(15,2) DEFAULT 0.00,
  `peralatan_mesin` decimal(15,2) DEFAULT 0.00,
  `akumulasi_penyusutan` decimal(15,2) DEFAULT 0.00,
  `total_aset_tetap` decimal(15,2) DEFAULT 0.00,
  `investasi_jangka_panjang` decimal(15,2) DEFAULT 0.00,
  `hak_paten_merek` decimal(15,2) DEFAULT 0.00,
  `total_aset_lain` decimal(15,2) DEFAULT 0.00,
  `total_aset_keseluruhan` decimal(15,2) DEFAULT 0.00,
  `utang_usaha` decimal(15,2) DEFAULT 0.00,
  `beban_harus_dibayar` decimal(15,2) DEFAULT 0.00,
  `utang_pajak` decimal(15,2) DEFAULT 0.00,
  `utang_jangka_pendek_lain` decimal(15,2) DEFAULT 0.00,
  `total_liabilitas_jangka_pendek` decimal(15,2) DEFAULT 0.00,
  `utang_bank` decimal(15,2) DEFAULT 0.00,
  `obligasi_diterbitkan` decimal(15,2) DEFAULT 0.00,
  `total_liabilitas_jangka_panjang` decimal(15,2) DEFAULT 0.00,
  `total_liabilitas` decimal(15,2) DEFAULT 0.00,
  `modal_saham` decimal(15,2) DEFAULT 0.00,
  `laba_ditahan` decimal(15,2) DEFAULT 0.00,
  `modal_disetor` decimal(15,2) DEFAULT 0.00,
  `total_ekuitas` decimal(15,2) DEFAULT 0.00,
  `total_liabilitas_ekuitas` decimal(15,2) DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_aktivitas_mahasiswa`
--

CREATE TABLE `log_aktivitas_mahasiswa` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) NOT NULL,
  `nim` varchar(30) NOT NULL,
  `nama_mahasiswa` varchar(100) NOT NULL,
  `jenis_aktivitas` enum('login','logout','tambah','edit','hapus','view','download') NOT NULL,
  `modul` varchar(50) NOT NULL,
  `detail_modul` varchar(100) DEFAULT NULL,
  `deskripsi` text NOT NULL,
  `data_lama` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_lama`)),
  `data_baru` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_baru`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_aktivitas_pembimbing`
--

CREATE TABLE `log_aktivitas_pembimbing` (
  `id` int(11) NOT NULL,
  `pembimbing_id` int(11) NOT NULL,
  `nip` varchar(30) NOT NULL,
  `nama_pembimbing` varchar(100) NOT NULL,
  `jenis_aktivitas` enum('login','logout','tambah','edit','hapus','view','konfirmasi','setuju','tolak','revisi') NOT NULL,
  `modul` varchar(50) NOT NULL,
  `detail_modul` varchar(100) DEFAULT NULL,
  `deskripsi` text NOT NULL,
  `data_lama` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_lama`)),
  `data_baru` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_baru`)),
  `target_mahasiswa_id` int(11) DEFAULT NULL,
  `target_proposal_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id` int(11) NOT NULL,
  `perguruan_tinggi` varchar(100) NOT NULL,
  `program_studi` varchar(100) NOT NULL,
  `nim` varchar(30) NOT NULL,
  `nama_ketua` varchar(100) NOT NULL,
  `no_telp` varchar(20) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `status` enum('aktif','proses','tolak','selesai') DEFAULT 'proses',
  `tanggal_daftar` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_verifikasi` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `metadata_kolom_penilaian`
--

CREATE TABLE `metadata_kolom_penilaian` (
  `id` int(11) NOT NULL,
  `jadwal_id` int(11) DEFAULT NULL,
  `interval_tipe` enum('setiap_jam','harian','mingguan','bulanan') NOT NULL,
  `interval_nilai` int(11) NOT NULL DEFAULT 1,
  `urutan_kolom` int(11) NOT NULL,
  `nama_kolom` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `periode_interval_id` int(11) DEFAULT 1,
  `tanggal_mulai` date DEFAULT NULL,
  `tanggal_selesai` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembimbing`
--

CREATE TABLE `pembimbing` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `nip` varchar(30) NOT NULL,
  `program_studi` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `tanggal_dibuat` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('aktif','nonaktif') NOT NULL DEFAULT 'nonaktif',
  `kuota_mahasiswa` int(11) DEFAULT 5
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaturan_anggaran`
--

CREATE TABLE `pengaturan_anggaran` (
  `id` int(11) NOT NULL,
  `min_total_awal` bigint(20) DEFAULT 0,
  `max_total_awal` bigint(20) DEFAULT 0,
  `min_total_bertumbuh` bigint(20) DEFAULT 0,
  `max_total_bertumbuh` bigint(20) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaturan_bimbingan`
--

CREATE TABLE `pengaturan_bimbingan` (
  `id` int(11) NOT NULL,
  `maksimal_bimbingan_per_hari` int(11) DEFAULT 3,
  `pesan_batasan` text DEFAULT 'Anda telah mencapai batas maksimal bimbingan hari ini. Silakan coba lagi besok.',
  `status_aktif` enum('aktif','nonaktif') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengaturan_jadwal`
--

CREATE TABLE `pengaturan_jadwal` (
  `id` int(11) NOT NULL,
  `proposal_mulai` datetime DEFAULT NULL,
  `proposal_selesai` datetime DEFAULT NULL,
  `kemajuan_mulai` datetime DEFAULT NULL,
  `kemajuan_selesai` datetime DEFAULT NULL,
  `akhir_mulai` datetime DEFAULT NULL,
  `akhir_selesai` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `pembimbing_nilai_mulai` datetime DEFAULT NULL,
  `pembimbing_nilai_selesai` datetime DEFAULT NULL,
  `pembimbing_interval_tipe` enum('harian','mingguan','bulanan','setiap_jam') DEFAULT 'harian' COMMENT 'Tipe interval penilaian pembimbing',
  `pembimbing_interval_nilai` int(11) DEFAULT 1 COMMENT 'Nilai interval (contoh: setiap 2 hari, setiap 3 minggu)',
  `pembimbing_jam_mulai` time DEFAULT '08:00:00' COMMENT 'Jam mulai boleh menilai setiap hari',
  `pembimbing_jam_selesai` time DEFAULT '17:00:00' COMMENT 'Jam selesai boleh menilai setiap hari',
  `pembimbing_hari_aktif` varchar(20) DEFAULT NULL COMMENT 'Hari aktif (1=Senin, 2=Selasa, dst. Comma separated)',
  `reviewer_proposal_mulai` datetime DEFAULT NULL,
  `reviewer_proposal_selesai` datetime DEFAULT NULL,
  `reviewer_kemajuan_mulai` datetime DEFAULT NULL,
  `reviewer_kemajuan_selesai` datetime DEFAULT NULL,
  `reviewer_akhir_mulai` datetime DEFAULT NULL,
  `reviewer_akhir_selesai` datetime DEFAULT NULL,
  `periode_metadata_aktif` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penilaian_laporan_akhir`
--

CREATE TABLE `penilaian_laporan_akhir` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_reviewer` int(11) NOT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT 0.00 COMMENT 'Nilai akhir dalam persentase (seperti IPK)',
  `komentar_reviewer` text DEFAULT NULL,
  `rekomendasi_kelulusan` enum('lulus sempurna','tidak lolos') DEFAULT NULL,
  `alasan_rekomendasi` text DEFAULT NULL,
  `tanggal_penilaian` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penilaian_laporan_kemajuan`
--

CREATE TABLE `penilaian_laporan_kemajuan` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_reviewer` int(11) NOT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT 0.00,
  `komentar_reviewer` text DEFAULT NULL COMMENT 'Catatan penilaian dari reviewer',
  `rekomendasi_pendanaan` enum('berhenti pendanaan','lanjutkan pendanaan') DEFAULT NULL,
  `alasan_rekomendasi` text DEFAULT NULL,
  `tanggal_penilaian` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penilaian_mahasiswa`
--

CREATE TABLE `penilaian_mahasiswa` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_pembimbing` int(11) NOT NULL,
  `nilai_akhir` decimal(5,2) DEFAULT 0.00 COMMENT 'Total nilai akhir',
  `komentar_pembimbing` text DEFAULT NULL,
  `status` enum('Draft','Selesai') DEFAULT 'Draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `jadwal_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penilaian_proposal`
--

CREATE TABLE `penilaian_proposal` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_reviewer` int(11) NOT NULL,
  `total_skor` decimal(5,2) NOT NULL DEFAULT 0.00,
  `total_nilai` decimal(5,2) NOT NULL DEFAULT 0.00,
  `nilai_akhir` decimal(5,2) NOT NULL DEFAULT 0.00 COMMENT 'Nilai akhir dalam persentase (seperti IPK)',
  `catatan` text DEFAULT NULL,
  `nilai_bantuan` decimal(15,2) NOT NULL DEFAULT 0.00,
  `persentase_bantuan` decimal(5,2) NOT NULL DEFAULT 0.00,
  `tanggal_penilaian` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `penjualan`
--

CREATE TABLE `penjualan` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `tanggal_penjualan` date NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `harga_jual` decimal(15,2) NOT NULL,
  `total` decimal(15,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pertanyaan_penilaian_laporan_akhir`
--

CREATE TABLE `pertanyaan_penilaian_laporan_akhir` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `bobot` decimal(5,2) NOT NULL COMMENT 'Bobot yang diinput admin (1-100)',
  `skor_maksimal` int(11) NOT NULL COMMENT 'Skor maksimal yang bisa diberikan (1-100)',
  `urutan` int(11) NOT NULL DEFAULT 0,
  `status` enum('Aktif','Nonaktif') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pertanyaan_penilaian_laporan_kemajuan`
--

CREATE TABLE `pertanyaan_penilaian_laporan_kemajuan` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `bobot` decimal(5,2) NOT NULL COMMENT 'Bobot yang diinput admin (1-100)',
  `skor_maksimal` int(11) NOT NULL COMMENT 'Skor maksimal yang bisa diberikan (1-100)',
  `status` enum('Aktif','Nonaktif') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pertanyaan_penilaian_mahasiswa`
--

CREATE TABLE `pertanyaan_penilaian_mahasiswa` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `bobot` decimal(5,2) NOT NULL,
  `skor_maksimal` int(11) NOT NULL,
  `kategori` varchar(100) NOT NULL DEFAULT 'Umum',
  `status` enum('Aktif','Nonaktif') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `pertanyaan_penilaian_proposal`
--

CREATE TABLE `pertanyaan_penilaian_proposal` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `bobot` decimal(5,2) NOT NULL DEFAULT 0.00,
  `skor_maksimal` int(11) NOT NULL DEFAULT 100 COMMENT 'Skor maksimal yang bisa diberikan reviewer (1-100)',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produksi`
--

CREATE TABLE `produksi` (
  `id` int(11) NOT NULL,
  `proposal_id` int(11) NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `jumlah_produk` int(11) NOT NULL,
  `harga_jual` decimal(15,2) NOT NULL,
  `persentase_laba` decimal(5,2) DEFAULT 0.00,
  `total_biaya` decimal(15,2) NOT NULL,
  `hpp` decimal(15,2) NOT NULL,
  `tanggal_produksi` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_bahan_baku`
--

CREATE TABLE `produk_bahan_baku` (
  `id` int(11) NOT NULL,
  `produksi_id` int(11) NOT NULL,
  `bahan_baku_id` int(11) NOT NULL,
  `quantity_digunakan` decimal(10,2) NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `program_studi`
--

CREATE TABLE `program_studi` (
  `id` int(11) NOT NULL,
  `nama_program_studi` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `program_studi`
--

INSERT INTO `program_studi` (`id`, `nama_program_studi`, `created_at`) VALUES
(1, 'Sistem Informasi', '2025-08-18 13:00:00'),
(7, 'Manajemen', '2025-08-18 13:00:00'),
(35, 'Farmasi', '2025-08-21 14:43:22'),
(36, 'Keperawatan', '2025-08-21 14:43:35'),
(37, 'Kebidanan', '2025-08-21 14:45:04'),
(38, 'Teknologi Bank Darah (TBD)', '2025-08-21 14:45:21'),
(39, 'Rekam Medis dan Informasi Kesehatan (RMIK)', '2025-08-21 14:45:41'),
(40, 'Teknologi Informasi', '2025-08-21 14:45:58'),
(41, 'Teknik Industri', '2025-08-21 14:46:12'),
(42, 'Informatika', '2025-08-21 14:46:26'),
(43, 'Psikologi', '2025-08-21 14:46:39'),
(44, 'Hukum', '2025-08-21 14:46:52'),
(45, 'Akuntansi', '2025-08-21 14:47:03');

-- --------------------------------------------------------

--
-- Struktur dari tabel `proposal`
--

CREATE TABLE `proposal` (
  `id` int(11) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `judul_usaha` varchar(255) NOT NULL,
  `kategori` varchar(100) NOT NULL,
  `tahapan_usaha` varchar(50) NOT NULL,
  `merk_produk` varchar(100) NOT NULL,
  `nib` varchar(50) DEFAULT NULL,
  `tahun_nib` int(11) DEFAULT NULL,
  `platform_penjualan` varchar(100) DEFAULT NULL,
  `dosen_pembimbing` varchar(100) NOT NULL,
  `nid_dosen` varchar(20) NOT NULL,
  `program_studi_dosen` varchar(100) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `status` enum('draf','diajukan','disetujui','ditolak','revisi','selesai') DEFAULT 'draf',
  `status_admin` enum('belum_ditinjau','lolos','tidak_lolos') DEFAULT 'belum_ditinjau',
  `tanggal_buat` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_kirim` timestamp NULL DEFAULT NULL,
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `tanggal_konfirmasi_pembimbing` timestamp NULL DEFAULT NULL,
  `tanggal_konfirmasi_admin` timestamp NULL DEFAULT NULL,
  `tanggal_revisi` timestamp NULL DEFAULT NULL,
  `id_reviewer` int(11) DEFAULT NULL,
  `komentar_pembimbing` text DEFAULT NULL COMMENT 'Komentar atau catatan dari pembimbing untuk mahasiswa',
  `komentar_revisi` text DEFAULT NULL,
  `tanggal_komentar_pembimbing` timestamp NULL DEFAULT NULL COMMENT 'Tanggal pembimbing memberikan komentar'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `proposal_reviewer`
--

CREATE TABLE `proposal_reviewer` (
  `id` int(11) NOT NULL,
  `id_proposal` int(11) NOT NULL,
  `id_reviewer` int(11) NOT NULL,
  `tanggal_assign` timestamp NOT NULL DEFAULT current_timestamp(),
  `status_review` enum('belum_direview','sedang_direview','selesai_review','sudah_dinilai') DEFAULT 'belum_direview',
  `komentar_reviewer` text DEFAULT NULL,
  `tanggal_review` timestamp NULL DEFAULT NULL,
  `tanggal_penilaian` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `reviewer`
--

CREATE TABLE `reviewer` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `kuota_review` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `session_mahasiswa`
--

CREATE TABLE `session_mahasiswa` (
  `id` int(11) NOT NULL,
  `mahasiswa_id` int(11) NOT NULL,
  `nim` varchar(30) NOT NULL,
  `nama_mahasiswa` varchar(100) NOT NULL,
  `session_id` varchar(255) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `logout_time` timestamp NULL DEFAULT NULL,
  `durasi_detik` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('active','ended') DEFAULT 'active',
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `session_pembimbing`
--

CREATE TABLE `session_pembimbing` (
  `id` int(11) NOT NULL,
  `pembimbing_id` int(11) NOT NULL,
  `nip` varchar(30) NOT NULL,
  `nama_pembimbing` varchar(100) NOT NULL,
  `session_id` varchar(255) NOT NULL,
  `login_time` timestamp NOT NULL DEFAULT current_timestamp(),
  `logout_time` timestamp NULL DEFAULT NULL,
  `durasi_detik` int(11) DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `status` enum('active','ended') DEFAULT 'active',
  `last_activity` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nip` (`nip`);

--
-- Indeks untuk tabel `alat_produksi`
--
ALTER TABLE `alat_produksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_alat_produksi_proposal_id` (`proposal_id`),
  ADD KEY `idx_alat_produksi_tanggal_beli` (`tanggal_beli`);

--
-- Indeks untuk tabel `anggaran_awal`
--
ALTER TABLE `anggaran_awal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_anggaran_awal_proposal` (`id_proposal`),
  ADD KEY `idx_anggaran_awal_status_reviewer` (`status_reviewer`),
  ADD KEY `idx_anggaran_awal_status_nilai` (`status`,`nilai_bantuan`);

--
-- Indeks untuk tabel `anggaran_bertumbuh`
--
ALTER TABLE `anggaran_bertumbuh`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_anggaran_bertumbuh_proposal` (`id_proposal`),
  ADD KEY `idx_anggaran_bertumbuh_status_reviewer` (`status_reviewer`),
  ADD KEY `idx_anggaran_bertumbuh_status_nilai` (`status`,`nilai_bantuan`);

--
-- Indeks untuk tabel `anggota_tim`
--
ALTER TABLE `anggota_tim`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_nim_email` (`nim`,`email`),
  ADD KEY `idx_anggota_tim_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_proposal_month` (`proposal_id`,`bulan_tahun`);

--
-- Indeks untuk tabel `bahan_baku`
--
ALTER TABLE `bahan_baku`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indeks untuk tabel `biaya_non_operasional`
--
ALTER TABLE `biaya_non_operasional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indeks untuk tabel `biaya_operasional`
--
ALTER TABLE `biaya_operasional`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indeks untuk tabel `bimbingan`
--
ALTER TABLE `bimbingan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nim` (`nim`),
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indeks untuk tabel `detail_penilaian_laporan_akhir`
--
ALTER TABLE `detail_penilaian_laporan_akhir`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_detail_penilaian_laporan_akhir` (`id_penilaian_laporan_akhir`,`id_pertanyaan`),
  ADD KEY `id_pertanyaan` (`id_pertanyaan`),
  ADD KEY `idx_detail_penilaian_laporan_akhir_penilaian` (`id_penilaian_laporan_akhir`);

--
-- Indeks untuk tabel `detail_penilaian_laporan_kemajuan`
--
ALTER TABLE `detail_penilaian_laporan_kemajuan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_detail_penilaian_laporan_kemajuan` (`id_penilaian_laporan_kemajuan`,`id_pertanyaan`),
  ADD KEY `id_pertanyaan` (`id_pertanyaan`);

--
-- Indeks untuk tabel `detail_penilaian_mahasiswa`
--
ALTER TABLE `detail_penilaian_mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_detail_penilaian_mahasiswa` (`id_penilaian_mahasiswa`,`id_pertanyaan`,`sesi_penilaian`),
  ADD KEY `id_pertanyaan` (`id_pertanyaan`);

--
-- Indeks untuk tabel `detail_penilaian_proposal`
--
ALTER TABLE `detail_penilaian_proposal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_proposal_reviewer_pertanyaan` (`id_proposal`,`id_reviewer`,`id_pertanyaan`),
  ADD KEY `id_pertanyaan` (`id_pertanyaan`),
  ADD KEY `idx_detail_penilaian_proposal_proposal` (`id_proposal`),
  ADD KEY `idx_detail_penilaian_proposal_reviewer` (`id_reviewer`);

--
-- Indeks untuk tabel `file_laporan_akhir`
--
ALTER TABLE `file_laporan_akhir`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `file_laporan_kemajuan`
--
ALTER TABLE `file_laporan_kemajuan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `laba_rugi`
--
ALTER TABLE `laba_rugi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_laba_rugi_proposal_id` (`proposal_id`),
  ADD KEY `idx_laba_rugi_tanggal` (`tanggal_produksi`),
  ADD KEY `idx_laba_rugi_nama_produk` (`nama_produk`);

--
-- Indeks untuk tabel `laporan_akhir_awal`
--
ALTER TABLE `laporan_akhir_awal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `laporan_akhir_bertumbuh`
--
ALTER TABLE `laporan_akhir_bertumbuh`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `laporan_kemajuan_awal`
--
ALTER TABLE `laporan_kemajuan_awal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `laporan_kemajuan_bertumbuh`
--
ALTER TABLE `laporan_kemajuan_bertumbuh`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `laporan_neraca`
--
ALTER TABLE `laporan_neraca`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_proposal_date` (`proposal_id`,`tanggal_neraca`);

--
-- Indeks untuk tabel `log_aktivitas_mahasiswa`
--
ALTER TABLE `log_aktivitas_mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `idx_nim` (`nim`),
  ADD KEY `idx_jenis_aktivitas` (`jenis_aktivitas`),
  ADD KEY `idx_modul` (`modul`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indeks untuk tabel `log_aktivitas_pembimbing`
--
ALTER TABLE `log_aktivitas_pembimbing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pembimbing_id` (`pembimbing_id`),
  ADD KEY `idx_nip` (`nip`),
  ADD KEY `idx_jenis_aktivitas` (`jenis_aktivitas`),
  ADD KEY `idx_modul` (`modul`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `idx_target_mahasiswa` (`target_mahasiswa_id`),
  ADD KEY `idx_target_proposal` (`target_proposal_id`);

--
-- Indeks untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nim` (`nim`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indeks untuk tabel `metadata_kolom_penilaian`
--
ALTER TABLE `metadata_kolom_penilaian`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_jadwal_id` (`jadwal_id`),
  ADD KEY `idx_periode_id` (`periode_interval_id`),
  ADD KEY `idx_urutan_kolom` (`urutan_kolom`);

--
-- Indeks untuk tabel `pembimbing`
--
ALTER TABLE `pembimbing`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nip` (`nip`);

--
-- Indeks untuk tabel `pengaturan_anggaran`
--
ALTER TABLE `pengaturan_anggaran`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pengaturan_bimbingan`
--
ALTER TABLE `pengaturan_bimbingan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pengaturan_jadwal`
--
ALTER TABLE `pengaturan_jadwal`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `penilaian_laporan_akhir`
--
ALTER TABLE `penilaian_laporan_akhir`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_penilaian_laporan_akhir` (`id_proposal`,`id_reviewer`),
  ADD KEY `id_reviewer` (`id_reviewer`),
  ADD KEY `idx_penilaian_laporan_akhir_proposal` (`id_proposal`);

--
-- Indeks untuk tabel `penilaian_laporan_kemajuan`
--
ALTER TABLE `penilaian_laporan_kemajuan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_penilaian_laporan_kemajuan` (`id_proposal`,`id_reviewer`);

--
-- Indeks untuk tabel `penilaian_mahasiswa`
--
ALTER TABLE `penilaian_mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_penilaian_mahasiswa` (`id_proposal`,`id_pembimbing`),
  ADD KEY `id_pembimbing` (`id_pembimbing`);

--
-- Indeks untuk tabel `penilaian_proposal`
--
ALTER TABLE `penilaian_proposal`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_proposal_reviewer` (`id_proposal`,`id_reviewer`),
  ADD KEY `idx_penilaian_proposal_proposal` (`id_proposal`),
  ADD KEY `idx_penilaian_proposal_reviewer` (`id_reviewer`);

--
-- Indeks untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_penjualan_proposal_id` (`proposal_id`),
  ADD KEY `idx_penjualan_tanggal` (`tanggal_penjualan`);

--
-- Indeks untuk tabel `pertanyaan_penilaian_laporan_akhir`
--
ALTER TABLE `pertanyaan_penilaian_laporan_akhir`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pertanyaan_laporan_akhir_status` (`status`);

--
-- Indeks untuk tabel `pertanyaan_penilaian_laporan_kemajuan`
--
ALTER TABLE `pertanyaan_penilaian_laporan_kemajuan`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `pertanyaan_penilaian_mahasiswa`
--
ALTER TABLE `pertanyaan_penilaian_mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pertanyaan_mahasiswa_status` (`status`);

--
-- Indeks untuk tabel `pertanyaan_penilaian_proposal`
--
ALTER TABLE `pertanyaan_penilaian_proposal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pertanyaan_proposal_active` (`is_active`,`created_at`);

--
-- Indeks untuk tabel `produksi`
--
ALTER TABLE `produksi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proposal_id` (`proposal_id`);

--
-- Indeks untuk tabel `produk_bahan_baku`
--
ALTER TABLE `produk_bahan_baku`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produksi_id` (`produksi_id`),
  ADD KEY `bahan_baku_id` (`bahan_baku_id`);

--
-- Indeks untuk tabel `program_studi`
--
ALTER TABLE `program_studi`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama_program_studi` (`nama_program_studi`);

--
-- Indeks untuk tabel `proposal`
--
ALTER TABLE `proposal`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_proposal_nim` (`nim`),
  ADD KEY `idx_proposal_status` (`status`),
  ADD KEY `idx_proposal_reviewer` (`id_reviewer`),
  ADD KEY `idx_proposal_status_revisi` (`status`);

--
-- Indeks untuk tabel `proposal_reviewer`
--
ALTER TABLE `proposal_reviewer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_proposal_reviewer` (`id_proposal`,`id_reviewer`),
  ADD KEY `id_reviewer` (`id_reviewer`),
  ADD KEY `idx_proposal_reviewer_status` (`status_review`),
  ADD KEY `idx_proposal_reviewer_tanggal` (`tanggal_assign`);

--
-- Indeks untuk tabel `reviewer`
--
ALTER TABLE `reviewer`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indeks untuk tabel `session_mahasiswa`
--
ALTER TABLE `session_mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_mahasiswa_id` (`mahasiswa_id`),
  ADD KEY `idx_nim` (`nim`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_login_time` (`login_time`);

--
-- Indeks untuk tabel `session_pembimbing`
--
ALTER TABLE `session_pembimbing`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_pembimbing_id` (`pembimbing_id`),
  ADD KEY `idx_nip` (`nip`),
  ADD KEY `idx_session_id` (`session_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_login_time` (`login_time`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `alat_produksi`
--
ALTER TABLE `alat_produksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `anggaran_awal`
--
ALTER TABLE `anggaran_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `anggaran_bertumbuh`
--
ALTER TABLE `anggaran_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `anggota_tim`
--
ALTER TABLE `anggota_tim`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `bahan_baku`
--
ALTER TABLE `bahan_baku`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `biaya_non_operasional`
--
ALTER TABLE `biaya_non_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `biaya_operasional`
--
ALTER TABLE `biaya_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `bimbingan`
--
ALTER TABLE `bimbingan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_laporan_akhir`
--
ALTER TABLE `detail_penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_laporan_kemajuan`
--
ALTER TABLE `detail_penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_mahasiswa`
--
ALTER TABLE `detail_penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_proposal`
--
ALTER TABLE `detail_penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `file_laporan_akhir`
--
ALTER TABLE `file_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `file_laporan_kemajuan`
--
ALTER TABLE `file_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laba_rugi`
--
ALTER TABLE `laba_rugi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laporan_akhir_awal`
--
ALTER TABLE `laporan_akhir_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laporan_akhir_bertumbuh`
--
ALTER TABLE `laporan_akhir_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laporan_kemajuan_awal`
--
ALTER TABLE `laporan_kemajuan_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laporan_kemajuan_bertumbuh`
--
ALTER TABLE `laporan_kemajuan_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `laporan_neraca`
--
ALTER TABLE `laporan_neraca`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `log_aktivitas_mahasiswa`
--
ALTER TABLE `log_aktivitas_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `log_aktivitas_pembimbing`
--
ALTER TABLE `log_aktivitas_pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `metadata_kolom_penilaian`
--
ALTER TABLE `metadata_kolom_penilaian`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pembimbing`
--
ALTER TABLE `pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_anggaran`
--
ALTER TABLE `pengaturan_anggaran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_bimbingan`
--
ALTER TABLE `pengaturan_bimbingan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_jadwal`
--
ALTER TABLE `pengaturan_jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penilaian_laporan_akhir`
--
ALTER TABLE `penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penilaian_laporan_kemajuan`
--
ALTER TABLE `penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penilaian_mahasiswa`
--
ALTER TABLE `penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penilaian_proposal`
--
ALTER TABLE `penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_laporan_akhir`
--
ALTER TABLE `pertanyaan_penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_laporan_kemajuan`
--
ALTER TABLE `pertanyaan_penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_mahasiswa`
--
ALTER TABLE `pertanyaan_penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_proposal`
--
ALTER TABLE `pertanyaan_penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `produksi`
--
ALTER TABLE `produksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `produk_bahan_baku`
--
ALTER TABLE `produk_bahan_baku`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `program_studi`
--
ALTER TABLE `program_studi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT untuk tabel `proposal`
--
ALTER TABLE `proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `proposal_reviewer`
--
ALTER TABLE `proposal_reviewer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `reviewer`
--
ALTER TABLE `reviewer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `session_mahasiswa`
--
ALTER TABLE `session_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `session_pembimbing`
--
ALTER TABLE `session_pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `alat_produksi`
--
ALTER TABLE `alat_produksi`
  ADD CONSTRAINT `alat_produksi_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `anggaran_awal`
--
ALTER TABLE `anggaran_awal`
  ADD CONSTRAINT `anggaran_awal_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `anggaran_bertumbuh`
--
ALTER TABLE `anggaran_bertumbuh`
  ADD CONSTRAINT `anggaran_bertumbuh_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `anggota_tim`
--
ALTER TABLE `anggota_tim`
  ADD CONSTRAINT `anggota_tim_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  ADD CONSTRAINT `arus_kas_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `bahan_baku`
--
ALTER TABLE `bahan_baku`
  ADD CONSTRAINT `bahan_baku_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `biaya_non_operasional`
--
ALTER TABLE `biaya_non_operasional`
  ADD CONSTRAINT `biaya_non_operasional_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `biaya_operasional`
--
ALTER TABLE `biaya_operasional`
  ADD CONSTRAINT `biaya_operasional_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `bimbingan`
--
ALTER TABLE `bimbingan`
  ADD CONSTRAINT `bimbingan_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE,
  ADD CONSTRAINT `bimbingan_ibfk_2` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_penilaian_laporan_akhir`
--
ALTER TABLE `detail_penilaian_laporan_akhir`
  ADD CONSTRAINT `detail_penilaian_laporan_akhir_ibfk_1` FOREIGN KEY (`id_penilaian_laporan_akhir`) REFERENCES `penilaian_laporan_akhir` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_penilaian_laporan_akhir_ibfk_2` FOREIGN KEY (`id_pertanyaan`) REFERENCES `pertanyaan_penilaian_laporan_akhir` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_penilaian_laporan_kemajuan`
--
ALTER TABLE `detail_penilaian_laporan_kemajuan`
  ADD CONSTRAINT `detail_penilaian_laporan_kemajuan_ibfk_1` FOREIGN KEY (`id_penilaian_laporan_kemajuan`) REFERENCES `penilaian_laporan_kemajuan` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_penilaian_laporan_kemajuan_ibfk_2` FOREIGN KEY (`id_pertanyaan`) REFERENCES `pertanyaan_penilaian_laporan_kemajuan` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_penilaian_mahasiswa`
--
ALTER TABLE `detail_penilaian_mahasiswa`
  ADD CONSTRAINT `detail_penilaian_mahasiswa_ibfk_1` FOREIGN KEY (`id_penilaian_mahasiswa`) REFERENCES `penilaian_mahasiswa` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_penilaian_mahasiswa_ibfk_2` FOREIGN KEY (`id_pertanyaan`) REFERENCES `pertanyaan_penilaian_mahasiswa` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `detail_penilaian_proposal`
--
ALTER TABLE `detail_penilaian_proposal`
  ADD CONSTRAINT `detail_penilaian_proposal_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_penilaian_proposal_ibfk_2` FOREIGN KEY (`id_reviewer`) REFERENCES `reviewer` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_penilaian_proposal_ibfk_3` FOREIGN KEY (`id_pertanyaan`) REFERENCES `pertanyaan_penilaian_proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `file_laporan_akhir`
--
ALTER TABLE `file_laporan_akhir`
  ADD CONSTRAINT `file_laporan_akhir_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `file_laporan_kemajuan`
--
ALTER TABLE `file_laporan_kemajuan`
  ADD CONSTRAINT `file_laporan_kemajuan_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laba_rugi`
--
ALTER TABLE `laba_rugi`
  ADD CONSTRAINT `laba_rugi_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_akhir_awal`
--
ALTER TABLE `laporan_akhir_awal`
  ADD CONSTRAINT `laporan_akhir_awal_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_akhir_bertumbuh`
--
ALTER TABLE `laporan_akhir_bertumbuh`
  ADD CONSTRAINT `laporan_akhir_bertumbuh_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_kemajuan_awal`
--
ALTER TABLE `laporan_kemajuan_awal`
  ADD CONSTRAINT `laporan_kemajuan_awal_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_kemajuan_bertumbuh`
--
ALTER TABLE `laporan_kemajuan_bertumbuh`
  ADD CONSTRAINT `laporan_kemajuan_bertumbuh_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `laporan_neraca`
--
ALTER TABLE `laporan_neraca`
  ADD CONSTRAINT `laporan_neraca_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `log_aktivitas_pembimbing`
--
ALTER TABLE `log_aktivitas_pembimbing`
  ADD CONSTRAINT `fk_log_pembimbing_id` FOREIGN KEY (`pembimbing_id`) REFERENCES `pembimbing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penilaian_laporan_akhir`
--
ALTER TABLE `penilaian_laporan_akhir`
  ADD CONSTRAINT `penilaian_laporan_akhir_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaian_laporan_akhir_ibfk_2` FOREIGN KEY (`id_reviewer`) REFERENCES `reviewer` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penilaian_mahasiswa`
--
ALTER TABLE `penilaian_mahasiswa`
  ADD CONSTRAINT `penilaian_mahasiswa_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaian_mahasiswa_ibfk_2` FOREIGN KEY (`id_pembimbing`) REFERENCES `pembimbing` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penilaian_proposal`
--
ALTER TABLE `penilaian_proposal`
  ADD CONSTRAINT `penilaian_proposal_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `penilaian_proposal_ibfk_2` FOREIGN KEY (`id_reviewer`) REFERENCES `reviewer` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  ADD CONSTRAINT `penjualan_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `produksi`
--
ALTER TABLE `produksi`
  ADD CONSTRAINT `produksi_ibfk_1` FOREIGN KEY (`proposal_id`) REFERENCES `proposal` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `produk_bahan_baku`
--
ALTER TABLE `produk_bahan_baku`
  ADD CONSTRAINT `produk_bahan_baku_ibfk_1` FOREIGN KEY (`produksi_id`) REFERENCES `produksi` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `produk_bahan_baku_ibfk_2` FOREIGN KEY (`bahan_baku_id`) REFERENCES `bahan_baku` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `proposal`
--
ALTER TABLE `proposal`
  ADD CONSTRAINT `fk_proposal_reviewer` FOREIGN KEY (`id_reviewer`) REFERENCES `reviewer` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `proposal_ibfk_1` FOREIGN KEY (`nim`) REFERENCES `mahasiswa` (`nim`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `proposal_reviewer`
--
ALTER TABLE `proposal_reviewer`
  ADD CONSTRAINT `proposal_reviewer_ibfk_1` FOREIGN KEY (`id_proposal`) REFERENCES `proposal` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `proposal_reviewer_ibfk_2` FOREIGN KEY (`id_reviewer`) REFERENCES `reviewer` (`id`) ON DELETE CASCADE;

--
-- Ketidakleluasaan untuk tabel `session_pembimbing`
--
ALTER TABLE `session_pembimbing`
  ADD CONSTRAINT `fk_session_pembimbing_id` FOREIGN KEY (`pembimbing_id`) REFERENCES `pembimbing` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

DELIMITER $$
--
-- Event
--
CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_kemajuan_awal` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 01:57:35' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE laporan_kemajuan_awal lk
  JOIN (SELECT kemajuan_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET lk.status = 'ditolak'
  WHERE lk.status IN ('draf','diajukan','revisi')
    AND j.kemajuan_selesai IS NOT NULL
    AND NOW() > j.kemajuan_selesai
    AND (lk.tanggal_review IS NULL OR lk.tanggal_review = '0000-00-00 00:00:00')$$

CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_kemajuan_bertumbuh` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 01:57:35' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE laporan_kemajuan_bertumbuh lk
  JOIN (SELECT kemajuan_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET lk.status = 'ditolak'
  WHERE lk.status IN ('draf','diajukan','revisi')
    AND j.kemajuan_selesai IS NOT NULL
    AND NOW() > j.kemajuan_selesai
    AND (lk.tanggal_review IS NULL OR lk.tanggal_review = '0000-00-00 00:00:00')$$

CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_file_kemajuan` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 02:49:02' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE file_laporan_kemajuan flk
  JOIN (SELECT kemajuan_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET flk.status = 'ditolak'
  WHERE flk.status IN ('draf','diajukan','revisi')
    AND j.kemajuan_selesai IS NOT NULL
    AND NOW() > j.kemajuan_selesai
    AND (flk.komentar_pembimbing IS NULL OR flk.komentar_pembimbing = '')$$

CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_akhir_awal` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 02:49:17' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE laporan_akhir_awal la
  JOIN (SELECT akhir_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET la.status = 'ditolak'
  WHERE la.status IN ('draf','diajukan','revisi')
    AND j.akhir_selesai IS NOT NULL
    AND NOW() > j.akhir_selesai
    AND (la.tanggal_review IS NULL OR la.tanggal_review = '0000-00-00 00:00:00')$$

CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_akhir_bertumbuh` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 02:49:17' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE laporan_akhir_bertumbuh la
  JOIN (SELECT akhir_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET la.status = 'ditolak'
  WHERE la.status IN ('draf','diajukan','revisi')
    AND j.akhir_selesai IS NOT NULL
    AND NOW() > j.akhir_selesai
    AND (la.tanggal_review IS NULL OR la.tanggal_review = '0000-00-00 00:00:00')$$

CREATE DEFINER=`root`@`localhost` EVENT `auto_reject_file_akhir` ON SCHEDULE EVERY 10 MINUTE STARTS '2025-08-10 02:49:17' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE file_laporan_akhir fla
  JOIN (SELECT akhir_selesai FROM pengaturan_jadwal ORDER BY id DESC LIMIT 1) j
    ON 1=1
  SET fla.status = 'ditolak'
  WHERE fla.status IN ('draf','diajukan','revisi')
    AND j.akhir_selesai IS NOT NULL
    AND NOW() > j.akhir_selesai
    AND (fla.komentar_pembimbing IS NULL OR fla.komentar_pembimbing = '')$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
