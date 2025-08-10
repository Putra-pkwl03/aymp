-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Agu 2025 pada 18.45
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.0.30

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
  `jenis_aktivitas` enum('login','logout','tambah','edit','hapus','view') NOT NULL,
  `modul` varchar(50) NOT NULL,
  `detail_modul` varchar(100) DEFAULT NULL,
  `deskripsi` text NOT NULL,
  `data_lama` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_lama`)),
  `data_baru` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`data_baru`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `log_aktivitas_mahasiswa`
--

INSERT INTO `log_aktivitas_mahasiswa` (`id`, `mahasiswa_id`, `nim`, `nama_mahasiswa`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `ip_address`, `user_agent`, `created_at`) VALUES
(329, 31, '2221103030', '082136799628', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-10 16:40:17'),
(330, 31, '2221103030', '082136799628', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-10 16:40:30'),
(331, 31, '2221103030', '082136799628', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-10 16:41:06'),
(332, 31, '2221103030', '082136799628', 'tambah', 'proposal', 'id_33', 'Menambahkan proposal: Apa', NULL, '{\"id\": 33, \"judul_usaha\": \"Apa\", \"kategori\": \"Budidaya\", \"tahapan_usaha\": \"Usaha Awal\", \"merk_produk\": \"Bebas\", \"dosen_pembimbing\": \"Ara\", \"file_path\": \"static\\\\uploads\\\\Proposal\\\\Apa\\\\Proposal_Apa_082136799628.pdf\", \"status\": \"draf\"}', '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-10 16:41:56');

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

--
-- Dumping data untuk tabel `log_aktivitas_pembimbing`
--

INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:22'),
(2, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:23'),
(3, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:24'),
(4, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:25'),
(5, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:25'),
(6, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:26'),
(7, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 00:46:27'),
(8, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:42:29'),
(9, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:42:34'),
(10, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:47:52'),
(11, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:48:38'),
(12, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:50:06'),
(13, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 06:51:33'),
(14, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 08:14:21'),
(15, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 08:19:15'),
(16, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 08:20:28'),
(17, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 08:20:29'),
(18, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 16:12:25'),
(19, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 16:12:27'),
(20, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 16:13:37'),
(21, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:05:41'),
(22, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:05:43'),
(23, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:07:04'),
(24, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:10:46'),
(25, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:16:25'),
(26, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:16:33'),
(27, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:18'),
(28, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:20'),
(29, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:21'),
(30, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:22'),
(31, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:24'),
(32, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:25'),
(33, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:25'),
(34, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:26'),
(35, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:27'),
(36, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 17:53:31'),
(37, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:14'),
(38, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:15'),
(39, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:17'),
(40, 1, '123', 'ara', 'setuju', 'proposal', 'proposal_id_22', 'Mengubah status proposal \"Bakso\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:20'),
(41, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:21'),
(42, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_22', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:55:23'),
(43, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:56:25'),
(44, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:56:29'),
(45, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:56:40'),
(46, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:57:35'),
(47, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:57:45'),
(48, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:57:49'),
(49, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:59:35'),
(50, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:59:37'),
(51, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 18:59:41'),
(52, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:00:54'),
(53, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:05:30'),
(54, 1, '123', 'ara', 'revisi', 'proposal', 'proposal_id_22', 'Mengubah status proposal \"Bakso\" dari diajukan menjadi revisi', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:06:44'),
(55, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:06:45'),
(56, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:07:51'),
(57, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:09:11'),
(58, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:09:13'),
(59, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:10:27'),
(60, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:20:25'),
(61, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:20:27'),
(62, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:20:50'),
(63, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:22:55'),
(64, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:23:26'),
(65, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:27:07'),
(66, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:27:10'),
(67, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:31:12'),
(68, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-28 19:31:15'),
(69, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:17:45'),
(70, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:17:46'),
(71, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:17:47'),
(72, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:17:52'),
(73, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:18:42'),
(74, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:21:05'),
(75, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:21:07'),
(76, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:21:13'),
(77, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:21:25'),
(78, 1, '123', 'ara', 'revisi', 'proposal', 'proposal_id_22', 'Mengubah status proposal \"Bakso\" dari diajukan menjadi revisi', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:22:02'),
(79, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:22:04'),
(80, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:22:09'),
(81, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:22:45'),
(82, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:22:47'),
(83, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:23:29'),
(84, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:23:31'),
(85, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:23:35'),
(86, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:23:38'),
(87, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:13'),
(88, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:16'),
(89, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_22', 'Melihat detail proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:19'),
(90, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:40'),
(91, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:41'),
(92, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:43'),
(93, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:24:48'),
(94, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:25:35'),
(95, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:25:39'),
(96, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:28:55'),
(97, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:29:52'),
(98, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:29:58'),
(99, 1, '123', 'ara', 'revisi', 'proposal', 'proposal_id_22', 'Mengubah status proposal \"Bakso\" dari diajukan menjadi revisi dengan catatan: proposal salah', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\", \"komentar_pembimbing\": \"proposal salah\"}', NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:14'),
(100, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:17'),
(101, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:22'),
(102, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:44'),
(103, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:45'),
(104, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:30:46'),
(105, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:31:30'),
(106, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 11:31:33'),
(107, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 16:29:35'),
(108, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 16:29:36'),
(109, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 16:50:10'),
(110, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 17:53:10'),
(111, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:29'),
(112, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:30'),
(113, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:36'),
(114, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:37'),
(115, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:37'),
(116, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:01:38'),
(117, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-29 18:02:17'),
(118, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:23:16'),
(119, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:23:18'),
(120, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:23:21'),
(121, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:23:30'),
(122, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:25:22'),
(123, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:25:58'),
(124, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:26:48'),
(125, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_22', 'Mendownload file proposal ID 22', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:26:53'),
(126, 1, '123', 'ara', 'setuju', 'proposal', 'proposal_id_22', 'Mengubah status proposal \"Bakso\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:27:23'),
(127, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:27:23'),
(128, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-30 00:27:28'),
(129, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 12:42:18'),
(130, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 12:42:19'),
(131, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 12:42:47'),
(132, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 12:49:40'),
(133, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 12:49:41'),
(134, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:32'),
(135, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:36'),
(136, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:37'),
(137, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:38'),
(138, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:39'),
(139, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:40'),
(140, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:41'),
(141, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:43'),
(142, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:43'),
(143, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:44'),
(144, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:48'),
(145, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:49'),
(146, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:18:50'),
(147, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:22:36'),
(148, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:24:19'),
(149, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:24:20'),
(150, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:24:23'),
(151, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:24:25'),
(152, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:24:26'),
(153, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:01'),
(154, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:02'),
(155, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:03'),
(156, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:03'),
(157, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:04'),
(158, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:04'),
(159, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:25:05'),
(160, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:31'),
(161, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:34'),
(162, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:34'),
(163, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:39'),
(164, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:40'),
(165, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:44'),
(166, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:48'),
(167, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:51'),
(168, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:28:54'),
(169, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:30:43'),
(170, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:30:44'),
(171, 1, '123', 'ara', 'view', 'monitoring', 'bahan_baku_mahasiswa_id_18', 'Melihat detail bahan baku mahasiswa ID 18', NULL, NULL, 18, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:30:46'),
(172, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:34:36'),
(173, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:47:28'),
(174, 1, '123', 'ara', 'view', 'monitoring', 'bahan_baku_mahasiswa_id_18', 'Melihat detail bahan baku mahasiswa ID 18', NULL, NULL, 18, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:47:30'),
(175, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:47:34');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(176, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:47:36'),
(177, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:48:57'),
(178, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:48:58'),
(179, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:49:01'),
(180, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:49:01'),
(181, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 13:49:04'),
(182, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 18:04:37'),
(183, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-07-31 18:04:38'),
(184, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 01:29:26'),
(185, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 01:29:28'),
(186, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 01:29:49'),
(187, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:24'),
(188, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:24'),
(189, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:27'),
(190, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:28'),
(191, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:29'),
(192, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:24:31'),
(193, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:27:02'),
(194, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:27:05'),
(195, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:27:09'),
(196, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:05'),
(197, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:06'),
(198, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:09'),
(199, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:23'),
(200, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:33'),
(201, 1, '123', 'ara', 'view', 'monitoring', 'bahan_baku_mahasiswa_id_18', 'Melihat detail bahan baku mahasiswa ID 18', NULL, NULL, 18, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:34'),
(202, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:38'),
(203, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:43'),
(204, 1, '123', 'ara', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:46'),
(205, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:49'),
(206, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:53'),
(207, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 03:33:56'),
(208, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 04:25:26'),
(209, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 04:52:21'),
(210, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 04:52:22'),
(211, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 05:39:16'),
(212, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 05:39:18'),
(213, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 15:56:48'),
(214, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 15:56:48'),
(215, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-01 15:57:50'),
(216, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:36:32'),
(217, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:36:34'),
(218, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:36:36'),
(219, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:36:37'),
(220, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_22', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:36:39'),
(221, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:41:52'),
(222, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:42:10'),
(223, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:42:11'),
(224, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-02 13:46:19'),
(225, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:38:10'),
(226, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:38:12'),
(227, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:39:23'),
(228, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:56:18'),
(229, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:56:19'),
(230, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:56:21'),
(231, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_22', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 07:56:22'),
(232, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_22', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 08:47:28'),
(233, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_22', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 22, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 08:47:29'),
(234, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 08:47:31'),
(235, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 08:47:31'),
(236, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:51:46'),
(237, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:51:48'),
(238, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:51:49'),
(239, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:51:51'),
(240, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_1', 'Mengubah status anggaran_bertumbuh ID 1 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:57:19'),
(241, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 15:57:35'),
(242, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:00:52'),
(243, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengubah status anggaran_bertumbuh ID 4 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:00:58'),
(244, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:02:32'),
(245, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:05:54'),
(246, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_5', 'Mengubah status anggaran_bertumbuh ID 5 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:06:00'),
(247, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:08:29'),
(248, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_5', 'Mengubah status anggaran_bertumbuh ID 5 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:08:33'),
(249, 1, '123', 'ara', 'revisi', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengubah status anggaran_bertumbuh ID 4 menjadi revisi untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:08:40'),
(250, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengubah status anggaran_bertumbuh ID 3 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:11:04'),
(251, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengedit anggaran_bertumbuh ID 2 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"A\", \"nama_barang\": \"B\", \"kuantitas\": 30, \"harga_satuan\": 65000.0, \"jumlah\": 1950000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"Aa\", \"nama_barang\": \"B\", \"kuantitas\": 30, \"harga_satuan\": 65000.0, \"jumlah\": 1950000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:11:17'),
(252, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengubah status anggaran_bertumbuh ID 2 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:11:22'),
(253, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengubah status anggaran_bertumbuh ID 2 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"disetujui\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:11:31'),
(254, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:12:17'),
(255, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:12:40'),
(256, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:13:01'),
(257, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:13:05'),
(258, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:13:43'),
(259, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:14:01'),
(260, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:14:09'),
(261, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:17:30'),
(262, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:18:02'),
(263, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:18:10'),
(264, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:18:29'),
(265, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:18:36'),
(266, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:19:21'),
(267, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:21:51'),
(268, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:22:01'),
(269, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:36:35'),
(270, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:36:42'),
(271, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:37:05'),
(272, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:39:09'),
(273, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_5', 'Mengedit anggaran_bertumbuh ID 5 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:39:16'),
(274, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:39:18'),
(275, 1, '123', 'ara', 'revisi', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengubah status anggaran_bertumbuh ID 2 menjadi revisi untuk proposal \"Bakso\"', '{\"status\": \"disetujui\"}', '{\"status\": \"revisi\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:39:47'),
(276, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:41:25'),
(277, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:41:38'),
(278, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:41:40'),
(279, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:42:08'),
(280, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:43:17'),
(281, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:43:24'),
(282, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:44:38'),
(283, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:45:47'),
(284, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:46:41'),
(285, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:46:41'),
(286, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:46:43'),
(287, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:46:44'),
(288, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:46:46'),
(289, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:51:29'),
(290, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:51:45'),
(291, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:51:53'),
(292, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_3', 'Mengedit anggaran_bertumbuh ID 3 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"C\", \"kuantitas\": 25, \"harga_satuan\": 20000.0, \"jumlah\": 500000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:51:59'),
(293, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:52:02'),
(294, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:54:46'),
(295, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:55:30'),
(296, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:55:32'),
(297, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:55:35'),
(298, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:55:36'),
(299, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:55:48'),
(300, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:56:12'),
(301, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:56:27'),
(302, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:56:43'),
(303, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:57:22'),
(304, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:58:58'),
(305, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:02'),
(306, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:12'),
(307, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:15'),
(308, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:16'),
(309, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:18'),
(310, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:20'),
(311, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengubah status anggaran_bertumbuh ID 2 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"revisi\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:26'),
(312, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengubah status anggaran_bertumbuh ID 4 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"revisi\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 16:59:31'),
(313, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:00:27'),
(314, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:01:55'),
(315, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:02:47'),
(316, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:04:08'),
(317, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:05:43'),
(318, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:05:56'),
(319, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:07:35'),
(320, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:08:14'),
(321, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:09:44'),
(322, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:09:47'),
(323, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 17:09:51'),
(324, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 18:20:14');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(325, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 18:20:16'),
(326, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 18:20:18'),
(327, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 18:21:04'),
(328, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-03 18:21:07'),
(329, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 05:59:04'),
(330, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 05:59:05'),
(331, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 05:59:06'),
(332, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 05:59:08'),
(333, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_2', 'Mengubah status anggaran_bertumbuh ID 2 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 05:59:12'),
(334, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:17:16'),
(335, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:22:39'),
(336, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:22:59'),
(337, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_1', 'Mengubah status anggaran_bertumbuh ID 1 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:23:08'),
(338, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:26:16'),
(339, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:26:48'),
(340, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:27:06'),
(341, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_5', 'Mengedit anggaran_bertumbuh ID 5 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 25000.0, \"jumlah\": 100000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:28:36'),
(342, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_5', 'Mengubah status anggaran_bertumbuh ID 5 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"revisi\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:28:42'),
(343, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengedit anggaran_bertumbuh ID 4 untuk proposal \"Bakso\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 150000.0, \"jumlah\": 600000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"C\", \"nama_barang\": \"D\", \"kuantitas\": 4, \"harga_satuan\": 120000.0, \"jumlah\": 480000.0}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:28:53'),
(344, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_4', 'Mengubah status anggaran_bertumbuh ID 4 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"revisi\"}', '{\"status\": \"disetujui\"}', NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:28:58'),
(345, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:29:05'),
(346, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:29:15'),
(347, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:52:38'),
(348, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:52:38'),
(349, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:52:41'),
(350, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:53:34'),
(351, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 06:53:38'),
(352, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:15'),
(353, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:16'),
(354, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:18'),
(355, 1, '123', 'ara', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_1', 'Mengubah status laporan_kemajuan_bertumbuh ID 1 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 19, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:22'),
(356, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:25'),
(357, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:28'),
(358, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:29'),
(359, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:31'),
(360, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:41'),
(361, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:45'),
(362, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:46'),
(363, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:50'),
(364, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:55'),
(365, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:01:56'),
(366, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:02:48'),
(367, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:04:54'),
(368, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:05:17'),
(369, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:05:17'),
(370, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:05:19'),
(371, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:06:32'),
(372, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:06:43'),
(373, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:06:44'),
(374, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:06:45'),
(375, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:06:47'),
(376, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:32'),
(377, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:33'),
(378, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:35'),
(379, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:36'),
(380, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:38'),
(381, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:39'),
(382, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:19:56'),
(383, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:20:04'),
(384, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:20:07'),
(385, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:20:08'),
(386, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:20:10'),
(387, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:21:31'),
(388, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:21:31'),
(389, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:21:34'),
(390, 1, '123', 'ara', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_6', 'Mengubah status laporan_kemajuan_bertumbuh ID 6 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 19, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:21:39'),
(391, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:21:40'),
(392, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:22:47'),
(393, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:24:02'),
(394, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:26:52'),
(395, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:27:29'),
(396, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:27:35'),
(397, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:27:38'),
(398, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:28:41'),
(399, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:37:56'),
(400, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 16:41:54'),
(401, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 17:55:39'),
(402, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 17:55:39'),
(403, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 17:55:41'),
(404, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 17:55:46'),
(405, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-04 17:56:36'),
(406, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:31:35'),
(407, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:31:37'),
(408, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:31:46'),
(409, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:31:47'),
(410, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:36:56'),
(411, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:36:57'),
(412, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:37:00'),
(413, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:41:10'),
(414, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:41:11'),
(415, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:41:13'),
(416, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:42:04'),
(417, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:42:07'),
(418, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 07:42:18'),
(419, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 08:35:18'),
(420, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 08:35:19'),
(421, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 08:35:22'),
(422, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 08:48:31'),
(423, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:07:14'),
(424, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:07:16'),
(425, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:07:18'),
(426, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:09:05'),
(427, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:10:07'),
(428, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:10:08'),
(429, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:10:10'),
(430, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:10:20'),
(431, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:11:30'),
(432, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:11:30'),
(433, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:11:33'),
(434, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:12:47'),
(435, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:39:23'),
(436, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:39:23'),
(437, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:39:25'),
(438, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:41:48'),
(439, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:42:50'),
(440, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:42:50'),
(441, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:42:51'),
(442, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:43:49'),
(443, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:44:03'),
(444, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:44:05'),
(445, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-05 09:44:07'),
(446, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:11:46'),
(447, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:11:47'),
(448, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:11:48'),
(449, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:11:49'),
(450, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:12:44'),
(451, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:13:22'),
(452, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:13:22'),
(453, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:13:24'),
(454, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:17:59'),
(455, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:18:43'),
(456, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:18:43'),
(457, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:18:45'),
(458, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 11:53:11'),
(459, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:39:01'),
(460, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:39:02'),
(461, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:39:25'),
(462, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:57:17'),
(463, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:57:20'),
(464, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 16:57:22'),
(465, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:08:06'),
(466, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:08:21'),
(467, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:29:42'),
(468, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:29:42'),
(469, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:29:53'),
(470, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:30:16'),
(471, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:34:31'),
(472, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:36:07'),
(473, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:36:10'),
(474, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:38:22'),
(475, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:39:11'),
(476, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:39:51'),
(477, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:40:25'),
(478, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:41:23'),
(479, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 17:41:29'),
(480, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:14:29'),
(481, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:14:29'),
(482, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:14:31'),
(483, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:14:33'),
(484, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:15:27'),
(485, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:15:28'),
(486, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:15:30'),
(487, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:15:39'),
(488, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:18:09'),
(489, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:19:28'),
(490, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:19:57'),
(491, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:20:28'),
(492, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:21:45'),
(493, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:22:09'),
(494, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:22:28'),
(495, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:24:20'),
(496, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:24:40');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(497, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:24:58'),
(498, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:26:00'),
(499, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:28:04'),
(500, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:30:58'),
(501, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:08'),
(502, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:13'),
(503, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:16'),
(504, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:21'),
(505, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:29'),
(506, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:32:31'),
(507, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:37:35'),
(508, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:37:37'),
(509, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:39:08'),
(510, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:39:11'),
(511, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:39:40'),
(512, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:40:31'),
(513, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:42:07'),
(514, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:43:06'),
(515, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:04'),
(516, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:11'),
(517, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:13'),
(518, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:29'),
(519, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:30'),
(520, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:45:31'),
(521, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:02'),
(522, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:07'),
(523, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:15'),
(524, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:48'),
(525, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:53'),
(526, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:53'),
(527, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:47:55'),
(528, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:48:22'),
(529, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:51:34'),
(530, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:53:32'),
(531, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:55:39'),
(532, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-06 18:56:52'),
(533, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:39:37'),
(534, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:39:37'),
(535, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:39:39'),
(536, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:39:41'),
(537, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:48:50'),
(538, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:48:52'),
(539, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 01:48:53'),
(540, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:32:36'),
(541, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:32:37'),
(542, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:32:39'),
(543, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:32:44'),
(544, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:49:51'),
(545, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:49:52'),
(546, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:49:54'),
(547, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:49:56'),
(548, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 06:50:37'),
(549, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:20:59'),
(550, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:21:00'),
(551, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:21:03'),
(552, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:24:19'),
(553, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:24:22'),
(554, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:53:51'),
(555, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:53:51'),
(556, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:53:53'),
(557, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:53:55'),
(558, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 75, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:54:05'),
(559, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:54:06'),
(560, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 07:54:08'),
(561, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:19:08'),
(562, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:19:27'),
(563, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:19:29'),
(564, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:19:48'),
(565, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:20:35'),
(566, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 75, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:20:45'),
(567, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:20:45'),
(568, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:21:09'),
(569, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:30:55'),
(570, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:30:55'),
(571, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:30:57'),
(572, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:30:59'),
(573, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:31:13'),
(574, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:31:27'),
(575, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:32:22'),
(576, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:33:42'),
(577, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:33:44'),
(578, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:34:09'),
(579, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:35:13'),
(580, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 100, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:35:17'),
(581, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:35:19'),
(582, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 08:36:10'),
(583, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:03:45'),
(584, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:03:46'),
(585, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:03:48'),
(586, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:03:51'),
(587, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:07:19'),
(588, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:07:20'),
(589, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:07:22'),
(590, 1, '123', 'ara', 'setuju', 'laporan_akhir_bertumbuh', 'laporan_akhir_bertumbuh_id_17', 'Mengubah status laporan_akhir_bertumbuh ID 17 menjadi disetujui untuk proposal \"Bakso\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 19, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:08:37'),
(591, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-07 16:08:41'),
(592, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:23:21'),
(593, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:23:23'),
(594, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:30:13'),
(595, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:30:15'),
(596, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:30:19'),
(597, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:30:21'),
(598, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:31:49'),
(599, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:36:10'),
(600, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:36:20'),
(601, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:36:25'),
(602, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:39:37'),
(603, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:42:31'),
(604, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:42:35'),
(605, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:37'),
(606, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:38'),
(607, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:40'),
(608, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 100, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:45'),
(609, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:46'),
(610, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:43:46'),
(611, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:46:22'),
(612, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 01:46:30'),
(613, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:40:55'),
(614, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:40:57'),
(615, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:40:59'),
(616, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:45:18'),
(617, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:45:21'),
(618, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:46:33'),
(619, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:53:02'),
(620, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:57:30'),
(621, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 03:58:30'),
(622, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:00:48'),
(623, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:02:33'),
(624, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:02:43'),
(625, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:02:52'),
(626, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:02:54'),
(627, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:02:58'),
(628, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:03:02'),
(629, 1, '123', 'ara', 'view', 'penilaian', 'daftar_nilai_mahasiswa', 'Melihat daftar nilai mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:03:43'),
(630, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 04:27:45'),
(631, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:19:31'),
(632, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:19:31'),
(633, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:23:08'),
(634, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:23:13'),
(635, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:23:14'),
(636, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:24:27'),
(637, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:24:28'),
(638, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:43:59'),
(639, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 09:43:59'),
(640, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:27:55'),
(641, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:27:56'),
(642, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:28:00'),
(643, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:28:49'),
(644, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:28:53'),
(645, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:28:54'),
(646, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:28:56'),
(647, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:31:09'),
(648, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:32:24'),
(649, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:32:25'),
(650, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:32:27'),
(651, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:32:36'),
(652, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:35:27'),
(653, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:36:49'),
(654, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:36:50'),
(655, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:36:53'),
(656, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:37:11'),
(657, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:37:16'),
(658, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:37:19'),
(659, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:47:50'),
(660, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:47:51'),
(661, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:47:53'),
(662, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:48:01'),
(663, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:48:05'),
(664, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:54:33'),
(665, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:54:35'),
(666, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 15:55:43'),
(667, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 16:02:19'),
(668, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 16:02:19'),
(669, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 16:02:21'),
(670, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 16:02:31'),
(671, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 16:02:35'),
(672, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 17:59:32'),
(673, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 17:59:33');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(674, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:00:01'),
(675, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:00:07'),
(676, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:00:22'),
(677, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:02:18'),
(678, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:02:18'),
(679, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:03:55'),
(680, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:04:47'),
(681, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:04:47'),
(682, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:05:12'),
(683, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:05:55'),
(684, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:05:57'),
(685, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:08:15'),
(686, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:09:56'),
(687, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:09:57'),
(688, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:19:51'),
(689, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:22:33'),
(690, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:22:33'),
(691, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-08 18:48:09'),
(692, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:19:55'),
(693, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:19:55'),
(694, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:19:56'),
(695, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:19:59'),
(696, 1, '123', 'ara', 'setuju', 'anggaran_awal', 'anggaran_awal_id_1', 'Mengubah status anggaran_awal ID 1 menjadi disetujui untuk proposal \"Jasa Layanan Web\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:02'),
(697, 1, '123', 'ara', 'setuju', 'anggaran_awal', 'anggaran_awal_id_3', 'Mengubah status anggaran_awal ID 3 menjadi disetujui untuk proposal \"Jasa Layanan Web\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:06'),
(698, 1, '123', 'ara', 'revisi', 'anggaran_awal', 'anggaran_awal_id_2', 'Mengubah status anggaran_awal ID 2 menjadi revisi untuk proposal \"Jasa Layanan Web\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:11'),
(699, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:12'),
(700, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:14'),
(701, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:15'),
(702, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:15'),
(703, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_25', 'Mendownload file proposal ID 25', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:19'),
(704, 1, '123', 'ara', 'setuju', 'proposal', 'proposal_id_25', 'Mengubah status proposal \"Jasa Layanan Web\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:27'),
(705, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:29'),
(706, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:31'),
(707, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:35'),
(708, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:37'),
(709, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:38'),
(710, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:20:40'),
(711, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:47:20'),
(712, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:47:20'),
(713, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:47:21'),
(714, 1, '123', 'ara', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_6', 'Mengubah status laporan_kemajuan_awal ID 6 menjadi disetujui untuk proposal \"Jasa Layanan Web\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 20, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:47:29'),
(715, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:48:36'),
(716, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:49:05'),
(717, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:49:05'),
(718, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:49:06'),
(719, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 06:49:13'),
(720, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:06:43'),
(721, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:06:44'),
(722, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:06:45'),
(723, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:06:46'),
(724, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:12:27'),
(725, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:12:35'),
(726, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:12:50'),
(727, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:44'),
(728, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:44'),
(729, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:45'),
(730, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:47'),
(731, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:50'),
(732, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:28:55'),
(733, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:29:05'),
(734, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:29:07'),
(735, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:29:12'),
(736, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:32:22'),
(737, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:32:23'),
(738, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:32:25'),
(739, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:32:26'),
(740, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:32:28'),
(741, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:38:29'),
(742, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:38:35'),
(743, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:38:36'),
(744, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:38:41'),
(745, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:43:54'),
(746, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:43:55'),
(747, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:43:57'),
(748, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:43:58'),
(749, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:44:03'),
(750, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:44:04'),
(751, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:44:07'),
(752, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:45:28'),
(753, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:45:32'),
(754, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:45:34'),
(755, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 07:45:37'),
(756, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:48:47'),
(757, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:48:49'),
(758, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:48:52'),
(759, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:48:54'),
(760, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:48:59'),
(761, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:53:44'),
(762, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:08'),
(763, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:11'),
(764, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:15'),
(765, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:17'),
(766, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:21'),
(767, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:22'),
(768, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:54:39'),
(769, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:58:30'),
(770, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:58:30'),
(771, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:58:32'),
(772, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:58:33'),
(773, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:58:35'),
(774, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:59:53'),
(775, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:59:56'),
(776, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:59:56'),
(777, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 08:59:58'),
(778, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:00'),
(779, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:01'),
(780, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:06'),
(781, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:07'),
(782, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:08'),
(783, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:14'),
(784, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:42'),
(785, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:00:44'),
(786, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:02:00'),
(787, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:03:16'),
(788, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_23', 'Melihat anggaran bertumbuh proposal \"Bakso\"', NULL, NULL, NULL, 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:03:19'),
(789, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 09:05:49'),
(790, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:04'),
(791, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:04'),
(792, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:08'),
(793, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:10'),
(794, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:12'),
(795, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:36'),
(796, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:41'),
(797, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:42'),
(798, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:01:43'),
(799, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:07'),
(800, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:07'),
(801, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:10'),
(802, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:12'),
(803, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:14'),
(804, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:17'),
(805, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:17'),
(806, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:18'),
(807, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:19'),
(808, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:22'),
(809, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:23'),
(810, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:24'),
(811, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:27'),
(812, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:28'),
(813, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:33'),
(814, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:38'),
(815, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:04:49'),
(816, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:05:07'),
(817, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:05:09'),
(818, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:05:21'),
(819, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:05:28'),
(820, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:06:18'),
(821, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:06:18'),
(822, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:06:22'),
(823, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:06:24'),
(824, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:07:09'),
(825, 1, '123', 'ara', '', 'penilaian', 'penilaian_mahasiswa_2', 'Menyimpan penilaian mahasiswa 2', NULL, NULL, NULL, 100, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:07:13'),
(826, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:07:14'),
(827, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:07:16'),
(828, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:07:17'),
(829, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:37:39'),
(830, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:37:41'),
(831, 1, '123', 'ara', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:37:51'),
(832, 1, '123', 'ara', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:37:53'),
(833, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:39:34'),
(834, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:39:43'),
(835, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:39:44'),
(836, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:39:45'),
(837, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:39:47'),
(838, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:42:11'),
(839, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 10:44:16'),
(840, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 11:08:29'),
(841, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:43:32'),
(842, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:43:34'),
(843, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:43:37'),
(844, 1, '123', 'ara', 'setuju', 'proposal', 'proposal_id_28', 'Mengubah status proposal \"Lakukat\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:43:50'),
(845, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:43:52'),
(846, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_28', 'Melihat anggaran bertumbuh proposal \"Lakukat\"', NULL, NULL, NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:44:00'),
(847, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_8', 'Mengubah status anggaran_bertumbuh ID 8 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:44:12'),
(848, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_9', 'Mengubah status anggaran_bertumbuh ID 9 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:44:16');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(849, 1, '123', 'ara', 'revisi', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_10', 'Mengubah status anggaran_bertumbuh ID 10 menjadi revisi untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:44:29'),
(850, 1, '123', 'ara', 'edit', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_10', 'Mengedit anggaran_bertumbuh ID 10 untuk proposal \"Lakukat\"', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"Uji Coba Resep Varian Alpukat Kocok Baru\", \"nama_barang\": \"Mangga\", \"kuantitas\": 3, \"harga_satuan\": 20000.0, \"jumlah\": 60000.0}', '{\"kegiatan_utama\": \"Pengembangan Pasar Dan Saluran Distribusi\", \"kegiatan\": \"Uji Coba Resep Varian Alpukat Kocok Baru\", \"nama_barang\": \"Mangga\", \"kuantitas\": 2, \"harga_satuan\": 20000.0, \"jumlah\": 40000.0}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:44:43'),
(851, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_12', 'Mengubah status anggaran_bertumbuh ID 12 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:02'),
(852, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_14', 'Mengubah status anggaran_bertumbuh ID 14 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:12'),
(853, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_13', 'Mengubah status anggaran_bertumbuh ID 13 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:18'),
(854, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_11', 'Mengubah status anggaran_bertumbuh ID 11 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:27'),
(855, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_15', 'Mengubah status anggaran_bertumbuh ID 15 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:31'),
(856, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_16', 'Mengubah status anggaran_bertumbuh ID 16 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:38'),
(857, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_17', 'Mengubah status anggaran_bertumbuh ID 17 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:43'),
(858, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_18', 'Mengubah status anggaran_bertumbuh ID 18 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:48'),
(859, 1, '123', 'ara', 'tolak', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_19', 'Mengubah status anggaran_bertumbuh ID 19 menjadi ditolak untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"ditolak\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:55'),
(860, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_20', 'Mengubah status anggaran_bertumbuh ID 20 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:45:59'),
(861, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_21', 'Mengubah status anggaran_bertumbuh ID 21 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:04'),
(862, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_22', 'Mengubah status anggaran_bertumbuh ID 22 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:09'),
(863, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_23', 'Mengubah status anggaran_bertumbuh ID 23 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:14'),
(864, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:19'),
(865, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_28', 'Mendownload file proposal ID 28', NULL, NULL, NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:20'),
(866, 1, '123', 'ara', 'view', 'proposal', 'download_proposal_id_28', 'Mendownload file proposal ID 28', NULL, NULL, NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:21'),
(867, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 11:46:32'),
(868, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:00:53'),
(869, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:00:54'),
(870, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:00:56'),
(871, 1, '123', 'ara', 'view', 'proposal', 'proposal_detail_id_28', 'Melihat detail proposal \"Lakukat\"', NULL, NULL, NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:00:58'),
(872, 1, '123', 'ara', 'view', 'anggaran_bertumbuh', 'proposal_id_28', 'Melihat anggaran bertumbuh proposal \"Lakukat\"', NULL, NULL, NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:01:00'),
(873, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_11', 'Mengubah status anggaran_bertumbuh ID 11 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:01:06'),
(874, 1, '123', 'ara', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_14', 'Mengubah status anggaran_bertumbuh ID 14 menjadi disetujui untuk proposal \"Lakukat\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 28, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:01:10'),
(875, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:01:12'),
(876, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:04:22'),
(877, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:04:24'),
(878, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:04:27'),
(879, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:04:49'),
(880, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:06:00'),
(881, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:06:02'),
(882, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:06:33'),
(883, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:06:45'),
(884, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:06:47'),
(885, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:07:09'),
(886, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:20'),
(887, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:21'),
(888, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:25'),
(889, 4, '212103024', 'Avril', 'setuju', 'proposal', 'proposal_id_29', 'Mengubah status proposal \"Packaging\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:37'),
(890, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:38'),
(891, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_29', 'Melihat anggaran awal proposal \"Packaging\"', NULL, NULL, NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:40'),
(892, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_4', 'Mengubah status anggaran_awal ID 4 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:45'),
(893, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_5', 'Mengubah status anggaran_awal ID 5 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:49'),
(894, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_6', 'Mengubah status anggaran_awal ID 6 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:21:58'),
(895, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_8', 'Mengubah status anggaran_awal ID 8 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:22:07'),
(896, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_7', 'Mengubah status anggaran_awal ID 7 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:22:11'),
(897, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:22:13'),
(898, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:41'),
(899, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:42'),
(900, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:44'),
(901, 4, '212103024', 'Avril', 'setuju', 'proposal', 'proposal_id_29', 'Mengubah status proposal \"Packaging\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:50'),
(902, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:52'),
(903, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_29', 'Melihat anggaran awal proposal \"Packaging\"', NULL, NULL, NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:26:54'),
(904, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_4', 'Mengubah status anggaran_awal ID 4 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:01'),
(905, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_5', 'Mengubah status anggaran_awal ID 5 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:14'),
(906, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_6', 'Mengubah status anggaran_awal ID 6 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:19'),
(907, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_8', 'Mengubah status anggaran_awal ID 8 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:25'),
(908, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_7', 'Mengubah status anggaran_awal ID 7 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:29'),
(909, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:32'),
(910, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:35'),
(911, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 12:27:44'),
(912, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:54:34'),
(913, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:54:35'),
(914, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:54:38'),
(915, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 12:54:51'),
(916, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:33'),
(917, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:33'),
(918, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:35'),
(919, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_29', 'Melihat anggaran awal proposal \"Packaging\"', NULL, NULL, NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:37'),
(920, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_9', 'Mengubah status anggaran_awal ID 9 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:44'),
(921, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_11', 'Mengubah status anggaran_awal ID 11 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:48'),
(922, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_10', 'Mengubah status anggaran_awal ID 10 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:52'),
(923, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:54'),
(924, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:32:59'),
(925, 4, '212103024', 'Avril', 'view', 'proposal', 'proposal_detail_id_29', 'Melihat detail proposal \"Packaging\"', NULL, NULL, NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:33:00'),
(926, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:33:06'),
(927, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:34:57'),
(928, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:34:57'),
(929, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:34:59'),
(930, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_29', 'Melihat anggaran awal proposal \"Packaging\"', NULL, NULL, NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:35:02'),
(931, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_10', 'Mengubah status anggaran_awal ID 10 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:35:06'),
(932, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:35:08'),
(933, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:26'),
(934, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:27'),
(935, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:31'),
(936, 4, '212103024', 'Avril', 'setuju', 'proposal', 'proposal_id_30', 'Mengubah status proposal \"Barangbekasmurah\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:38'),
(937, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:40'),
(938, 4, '212103024', 'Avril', 'view', 'proposal', 'proposal_detail_id_30', 'Melihat detail proposal \"Barangbekasmurah\"', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:41'),
(939, 4, '212103024', 'Avril', 'view', 'anggaran_bertumbuh', 'proposal_id_30', 'Melihat anggaran bertumbuh proposal \"Barangbekasmurah\"', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:44'),
(940, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_24', 'Mengubah status anggaran_bertumbuh ID 24 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:48'),
(941, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_25', 'Mengubah status anggaran_bertumbuh ID 25 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:52'),
(942, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_32', 'Mengubah status anggaran_bertumbuh ID 32 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:48:57'),
(943, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_33', 'Mengubah status anggaran_bertumbuh ID 33 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:01'),
(944, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_31', 'Mengubah status anggaran_bertumbuh ID 31 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:06'),
(945, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_26', 'Mengubah status anggaran_bertumbuh ID 26 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:11'),
(946, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:14'),
(947, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:14'),
(948, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_28', 'Mengubah status anggaran_bertumbuh ID 28 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:15'),
(949, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:17'),
(950, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_27', 'Melihat anggaran awal proposal \"Sego\"', NULL, NULL, NULL, 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:19'),
(951, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_27', 'Mengubah status anggaran_bertumbuh ID 27 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:19'),
(952, 1, '123', 'ara', 'setuju', 'anggaran_awal', 'anggaran_awal_id_13', 'Mengubah status anggaran_awal ID 13 menjadi disetujui untuk proposal \"Sego\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:22'),
(953, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_29', 'Mengubah status anggaran_bertumbuh ID 29 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:25'),
(954, 1, '123', 'ara', 'setuju', 'anggaran_awal', 'anggaran_awal_id_12', 'Mengubah status anggaran_awal ID 12 menjadi disetujui untuk proposal \"Sego\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:27'),
(955, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:31'),
(956, 1, '123', 'ara', 'tolak', 'anggaran_awal', 'anggaran_awal_id_14', 'Mengubah status anggaran_awal ID 14 menjadi ditolak untuk proposal \"Sego\"', '{\"status\": \"diajukan\"}', '{\"status\": \"ditolak\"}', NULL, 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:32'),
(957, 4, '212103024', 'Avril', 'view', 'proposal', 'download_proposal_id_30', 'Mendownload file proposal ID 30', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:34'),
(958, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:34'),
(959, 4, '212103024', 'Avril', 'view', 'proposal', 'download_proposal_id_30', 'Mendownload file proposal ID 30', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:34'),
(960, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:49:38'),
(961, 1, '123', 'ara', 'setuju', 'proposal', 'proposal_id_27', 'Mengubah status proposal \"Sego\" dari diajukan menjadi disetujui dengan catatan: okeyy', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"okeyy\"}', NULL, 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:45'),
(962, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:49:47'),
(963, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:50:00'),
(964, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:50:01'),
(965, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 13:50:03'),
(966, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:13'),
(967, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:15'),
(968, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:17'),
(969, 4, '212103024', 'Avril', 'view', 'anggaran_bertumbuh', 'proposal_id_30', 'Melihat anggaran bertumbuh proposal \"Barangbekasmurah\"', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:20'),
(970, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_28', 'Mengubah status anggaran_bertumbuh ID 28 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:26'),
(971, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_27', 'Mengubah status anggaran_bertumbuh ID 27 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:31'),
(972, 4, '212103024', 'Avril', 'setuju', 'anggaran_bertumbuh', 'anggaran_bertumbuh_id_30', 'Mengubah status anggaran_bertumbuh ID 30 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:36'),
(973, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 13:53:39'),
(974, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:23'),
(975, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:24'),
(976, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:26'),
(977, 4, '212103024', 'Avril', 'view', 'anggaran_bertumbuh', 'proposal_id_30', 'Melihat anggaran bertumbuh proposal \"Barangbekasmurah\"', NULL, NULL, NULL, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:29'),
(978, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:32'),
(979, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_225', 'Mengubah status laporan_kemajuan_bertumbuh ID 225 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:38'),
(980, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_226', 'Mengubah status laporan_kemajuan_bertumbuh ID 226 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:42'),
(981, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:16:44'),
(982, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:17:05'),
(983, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_43', 'Mengubah status laporan_kemajuan_awal ID 43 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 25, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:17:10'),
(984, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_44', 'Mengubah status laporan_kemajuan_awal ID 44 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 25, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:17:13'),
(985, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_45', 'Mengubah status laporan_kemajuan_awal ID 45 menjadi disetujui untuk proposal \"Packaging\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 25, 29, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:17:17'),
(986, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:17:24'),
(987, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:18:23'),
(988, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:26:48'),
(989, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:26:48'),
(990, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:26:50'),
(991, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_227', 'Mengubah status laporan_kemajuan_bertumbuh ID 227 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:26:57'),
(992, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_224', 'Mengubah status laporan_kemajuan_bertumbuh ID 224 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:06'),
(993, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_228', 'Mengubah status laporan_kemajuan_bertumbuh ID 228 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:10'),
(994, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_229', 'Mengubah status laporan_kemajuan_bertumbuh ID 229 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:15');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(995, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_230', 'Mengubah status laporan_kemajuan_bertumbuh ID 230 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:20'),
(996, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_231', 'Mengubah status laporan_kemajuan_bertumbuh ID 231 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:23'),
(997, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_223', 'Mengubah status laporan_kemajuan_bertumbuh ID 223 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:27'),
(998, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_bertumbuh', 'laporan_kemajuan_bertumbuh_id_222', 'Mengubah status laporan_kemajuan_bertumbuh ID 222 menjadi disetujui untuk proposal \"Barangbekasmurah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 27, 30, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:32'),
(999, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:27:43'),
(1000, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:12'),
(1001, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:12'),
(1002, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:15'),
(1003, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:17'),
(1004, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:19'),
(1005, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:20'),
(1006, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 14:46:30'),
(1007, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:45'),
(1008, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:47'),
(1009, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:50'),
(1010, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:53'),
(1011, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:54'),
(1012, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:55'),
(1013, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 14:49:58'),
(1014, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 15:15:07'),
(1015, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 15:15:07'),
(1016, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 15:15:16'),
(1017, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 15:15:20'),
(1018, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:23:54'),
(1019, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:23:56'),
(1020, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:05'),
(1021, 4, '212103024', 'Avril', 'view', 'anggaran_bertumbuh', 'proposal_id_30', 'Melihat anggaran bertumbuh proposal \"Barangbekasmurah\"', NULL, NULL, NULL, 30, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:08'),
(1022, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:12'),
(1023, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:13'),
(1024, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:20'),
(1025, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:25'),
(1026, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:24:28'),
(1027, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:32:40'),
(1028, 4, '212103024', 'Avril', '', 'penilaian', 'penilaian_mahasiswa_1', 'Menyimpan penilaian mahasiswa 1', NULL, NULL, NULL, 100, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:32:58'),
(1029, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:33:00'),
(1030, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:33:15'),
(1031, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 15:33:25'),
(1032, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:05:37'),
(1033, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:05:39'),
(1034, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:05:49'),
(1035, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:06:00'),
(1036, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:43'),
(1037, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:44'),
(1038, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:46'),
(1039, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:46'),
(1040, 4, '212103024', 'Avril', 'setuju', 'proposal', 'proposal_id_32', 'Mengubah status proposal \"Gerabah\" dari diajukan menjadi disetujui', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\", \"komentar_pembimbing\": \"\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:52'),
(1041, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:53'),
(1042, 4, '212103024', 'Avril', 'view', 'proposal', 'proposal_detail_id_32', 'Melihat detail proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:55'),
(1043, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:45:58'),
(1044, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_17', 'Mengubah status anggaran_awal ID 17 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:46:03'),
(1045, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_16', 'Mengubah status anggaran_awal ID 16 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:46:09'),
(1046, 4, '212103024', 'Avril', 'edit', 'anggaran_awal', 'anggaran_awal_id_20', 'Mengedit anggaran_awal ID 20 untuk proposal \"Gerabah\"', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Bahan Bakar Tungku\", \"kuantitas\": 1, \"harga_satuan\": 200000.0, \"jumlah\": 200000.0}', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Bahan Bakar Tungku\", \"kuantitas\": 1, \"harga_satuan\": 180000.0, \"jumlah\": 180000.0}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:46:32'),
(1047, 4, '212103024', 'Avril', 'revisi', 'anggaran_awal', 'anggaran_awal_id_20', 'Mengubah status anggaran_awal ID 20 menjadi revisi untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:46:42'),
(1048, 4, '212103024', 'Avril', 'revisi', 'anggaran_awal', 'anggaran_awal_id_19', 'Mengubah status anggaran_awal ID 19 menjadi revisi untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:46:51'),
(1049, 4, '212103024', 'Avril', 'edit', 'anggaran_awal', 'anggaran_awal_id_19', 'Mengedit anggaran_awal ID 19 untuk proposal \"Gerabah\"', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 50000.0, \"jumlah\": 250000.0}', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 200000.0, \"jumlah\": 1000000.0}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:04'),
(1050, 4, '212103024', 'Avril', 'edit', 'anggaran_awal', 'anggaran_awal_id_19', 'Mengedit anggaran_awal ID 19 untuk proposal \"Gerabah\"', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 200000.0, \"jumlah\": 1000000.0}', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 25000.0, \"jumlah\": 125000.0}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:19'),
(1051, 4, '212103024', 'Avril', 'edit', 'anggaran_awal', 'anggaran_awal_id_19', 'Mengedit anggaran_awal ID 19 untuk proposal \"Gerabah\"', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 25000.0, \"jumlah\": 125000.0}', '{\"kegiatan_utama\": \"Produksi\", \"kegiatan\": \"Produksi Batch Pertama Set Piring Dan Mangkuk\", \"nama_barang\": \"Glasir (Pewarna Keramik)\", \"kuantitas\": 5, \"harga_satuan\": 30000.0, \"jumlah\": 150000.0}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:34'),
(1052, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_18', 'Mengubah status anggaran_awal ID 18 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:44'),
(1053, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_24', 'Mengubah status anggaran_awal ID 24 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:50'),
(1054, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_23', 'Mengubah status anggaran_awal ID 23 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:55'),
(1055, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_22', 'Mengubah status anggaran_awal ID 22 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:47:59'),
(1056, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_21', 'Mengubah status anggaran_awal ID 21 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:48:03'),
(1057, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:48:08'),
(1058, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:21'),
(1059, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:22'),
(1060, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:24'),
(1061, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:28'),
(1062, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_20', 'Mengubah status anggaran_awal ID 20 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:34'),
(1063, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_19', 'Mengubah status anggaran_awal ID 19 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:40'),
(1064, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:49:45'),
(1065, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:54:55'),
(1066, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:54:57'),
(1067, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:54:58'),
(1068, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:01'),
(1069, 4, '212103024', 'Avril', 'setuju', 'anggaran_awal', 'anggaran_awal_id_16', 'Mengubah status anggaran_awal ID 16 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:04'),
(1070, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:10'),
(1071, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:31'),
(1072, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:33'),
(1073, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:34'),
(1074, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:37'),
(1075, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:55:40'),
(1076, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:56:59'),
(1077, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:57:00'),
(1078, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:57:02'),
(1079, 4, '212103024', 'Avril', 'view', 'proposal', 'proposal_detail_id_32', 'Melihat detail proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:57:05'),
(1080, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 16:57:08'),
(1081, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:02:59'),
(1082, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:03:01'),
(1083, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:03:33'),
(1084, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:03:50'),
(1085, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:04:41'),
(1086, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:04:43'),
(1087, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:04:46'),
(1088, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:04:48'),
(1089, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:16'),
(1090, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:28'),
(1091, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:40'),
(1092, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:55'),
(1093, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:56'),
(1094, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:05:56'),
(1095, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:06'),
(1096, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:08'),
(1097, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:09'),
(1098, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:10'),
(1099, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:14'),
(1100, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:14'),
(1101, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:15'),
(1102, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:16'),
(1103, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:17'),
(1104, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:19'),
(1105, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:06:20'),
(1106, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:21'),
(1107, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:22'),
(1108, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:06:26'),
(1109, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:07:50'),
(1110, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:07:52'),
(1111, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:07:54'),
(1112, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:07:56'),
(1113, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:08:03'),
(1114, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:08:48'),
(1115, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:08:58'),
(1116, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:28'),
(1117, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:30'),
(1118, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:33'),
(1119, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:09:34'),
(1120, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:34'),
(1121, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:38'),
(1122, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:09:58'),
(1123, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:10:00'),
(1124, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:10:03'),
(1125, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:10:06'),
(1126, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:10:08'),
(1127, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:11:47'),
(1128, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:12:43'),
(1129, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:12:43'),
(1130, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:12:47'),
(1131, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:12:49'),
(1132, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:12:51'),
(1133, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:13:01'),
(1134, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:13:09'),
(1135, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:14:14'),
(1136, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:14:34'),
(1137, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:15:06'),
(1138, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:19:22'),
(1139, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:19:23'),
(1140, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:19:39'),
(1141, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:19:40'),
(1142, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:19:41'),
(1143, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:10'),
(1144, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:30'),
(1145, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:31'),
(1146, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:36'),
(1147, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:38'),
(1148, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:39'),
(1149, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:41'),
(1150, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:44'),
(1151, 4, '212103024', 'Avril', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:49'),
(1152, 4, '212103024', 'Avril', 'view', 'anggaran_awal', 'proposal_id_32', 'Melihat anggaran awal proposal \"Gerabah\"', NULL, NULL, NULL, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:20:54');
INSERT INTO `log_aktivitas_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `jenis_aktivitas`, `modul`, `detail_modul`, `deskripsi`, `data_lama`, `data_baru`, `target_mahasiswa_id`, `target_proposal_id`, `ip_address`, `user_agent`, `created_at`) VALUES
(1153, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:21:00'),
(1154, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:21:03'),
(1155, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:21:39'),
(1156, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:21:42'),
(1157, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:22:34'),
(1158, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:22:34'),
(1159, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:22:36'),
(1160, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:22:38'),
(1161, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:23:49'),
(1162, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:24:48'),
(1163, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:24:52'),
(1164, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:26:19'),
(1165, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:26:21'),
(1166, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:27:24'),
(1167, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:27:48'),
(1168, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:28:04'),
(1169, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:28:26'),
(1170, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:28:28'),
(1171, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:28:32'),
(1172, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:28:34'),
(1173, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:30:43'),
(1174, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:32:01'),
(1175, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:32:42'),
(1176, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:12'),
(1177, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:12'),
(1178, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:14'),
(1179, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:16'),
(1180, 4, '212103024', 'Avril', '', 'penilaian', 'penilaian_mahasiswa_212103028', 'Menyimpan penilaian mahasiswa 212103028', NULL, NULL, NULL, 100, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:20'),
(1181, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:47'),
(1182, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:33:55'),
(1183, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:33:55'),
(1184, 4, '212103024', 'Avril', 'view', 'penilaian', 'form_penilaian_mahasiswa', 'Melihat form penilaian mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:33:57'),
(1185, 4, '212103024', 'Avril', '', 'penilaian', 'penilaian_mahasiswa_212103030', 'Menyimpan penilaian mahasiswa 212103030', NULL, NULL, NULL, 100, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:34:03'),
(1186, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:34:12'),
(1187, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:34:15'),
(1188, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:34:21'),
(1189, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:34:24'),
(1190, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:35:50'),
(1191, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 17:36:12'),
(1192, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:46:03'),
(1193, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:46:05'),
(1194, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:46:06'),
(1195, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:46:11'),
(1196, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 17:46:16'),
(1197, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:19'),
(1198, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:20'),
(1199, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:24'),
(1200, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_58', 'Mengubah status laporan_kemajuan_awal ID 58 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:32'),
(1201, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_59', 'Mengubah status laporan_kemajuan_awal ID 59 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:37'),
(1202, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_60', 'Mengubah status laporan_kemajuan_awal ID 60 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:50'),
(1203, 4, '212103024', 'Avril', 'revisi', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_61', 'Mengubah status laporan_kemajuan_awal ID 61 menjadi revisi untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"revisi\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:48:57'),
(1204, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_62', 'Mengubah status laporan_kemajuan_awal ID 62 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:02'),
(1205, 4, '212103024', 'Avril', 'tolak', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_54', 'Mengubah status laporan_kemajuan_awal ID 54 menjadi ditolak untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"ditolak\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:12'),
(1206, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_55', 'Mengubah status laporan_kemajuan_awal ID 55 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:17'),
(1207, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_56', 'Mengubah status laporan_kemajuan_awal ID 56 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:25'),
(1208, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_57', 'Mengubah status laporan_kemajuan_awal ID 57 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:31'),
(1209, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:49:34'),
(1210, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:50:17'),
(1211, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:50:18'),
(1212, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:50:21'),
(1213, 4, '212103024', 'Avril', 'setuju', 'laporan_kemajuan_awal', 'laporan_kemajuan_awal_id_61', 'Mengubah status laporan_kemajuan_awal ID 61 menjadi disetujui untuk proposal \"Gerabah\"', '{\"status\": \"diajukan\"}', '{\"status\": \"disetujui\"}', 30, 32, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:50:30'),
(1214, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 18:50:34'),
(1215, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:17'),
(1216, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:19'),
(1217, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:21'),
(1218, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:26'),
(1219, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:32'),
(1220, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:36'),
(1221, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:45'),
(1222, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:14:54'),
(1223, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:02'),
(1224, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:02'),
(1225, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:10'),
(1226, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:14'),
(1227, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:17'),
(1228, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:19'),
(1229, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:21'),
(1230, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:53'),
(1231, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:55'),
(1232, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:15:58'),
(1233, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:16:02'),
(1234, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:16:09'),
(1235, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:22:50'),
(1236, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:22:51'),
(1237, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:22:59'),
(1238, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:23:01'),
(1239, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:23:15'),
(1240, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:23:23'),
(1241, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:23:27'),
(1242, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:23:29'),
(1243, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', '2025-08-09 19:25:52'),
(1244, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '114.125.79.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36', '2025-08-09 20:23:34'),
(1245, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '114.125.79.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36', '2025-08-09 20:23:36'),
(1246, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '114.125.79.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36', '2025-08-09 20:23:45'),
(1247, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '114.125.79.236', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '2025-08-09 20:23:56'),
(1248, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '114.125.79.236', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36', '2025-08-09 20:24:13'),
(1249, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:24'),
(1250, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:25'),
(1251, 1, '123', 'ara', 'view', 'proposal', 'daftar_proposal', 'Melihat daftar proposal mahasiswa bimbingan', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:29'),
(1252, 1, '123', 'ara', 'view', 'anggaran_awal', 'proposal_id_25', 'Melihat anggaran awal proposal \"Jasa Layanan Web\"', NULL, NULL, NULL, 25, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:30'),
(1253, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:34'),
(1254, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 20:58:39'),
(1255, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:01:24'),
(1256, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:01:45'),
(1257, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:02:55'),
(1258, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:04:15'),
(1259, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:04:24'),
(1260, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:04:50'),
(1261, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:04:56'),
(1262, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:04:59'),
(1263, 1, '123', 'ara', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:01'),
(1264, 1, '123', 'ara', 'view', 'monitoring', 'biaya_non_operasional_mahasiswa', 'Melihat halaman monitoring biaya non operasional mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:03'),
(1265, 1, '123', 'ara', 'view', 'monitoring', 'penjualan_produk_mahasiswa', 'Melihat halaman monitoring penjualan produk mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:05'),
(1266, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:07'),
(1267, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:16'),
(1268, 1, '123', 'ara', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:21'),
(1269, 1, '123', 'ara', 'view', 'monitoring', 'laporan_laba_rugi_mahasiswa', 'Melihat halaman monitoring laporan laba rugi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:26'),
(1270, 1, '123', 'ara', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:31'),
(1271, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:33'),
(1272, 1, '123', 'ara', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:40'),
(1273, 4, '212103024', 'Avril', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:45'),
(1274, 4, '212103024', 'Avril', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:45'),
(1275, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:05:49'),
(1276, 4, '212103024', 'Avril', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:06'),
(1277, 4, '212103024', 'Avril', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:09'),
(1278, 4, '212103024', 'Avril', 'view', 'monitoring', 'produksi_mahasiswa', 'Melihat halaman monitoring produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:12'),
(1279, 4, '212103024', 'Avril', 'view', 'monitoring', 'bahan_baku_mahasiswa_id_27', 'Melihat detail bahan baku mahasiswa ID 27', NULL, NULL, 27, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:14'),
(1280, 4, '212103024', 'Avril', 'view', 'monitoring', 'bahan_baku_mahasiswa_id_30', 'Melihat detail bahan baku mahasiswa ID 30', NULL, NULL, 30, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:20'),
(1281, 4, '212103024', 'Avril', 'view', 'monitoring', 'alat_produksi_mahasiswa', 'Melihat halaman monitoring alat produksi mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:23'),
(1282, 4, '212103024', 'Avril', 'view', 'monitoring', 'biaya_operasional_mahasiswa', 'Melihat halaman monitoring biaya operasional mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:33'),
(1283, 4, '212103024', 'Avril', 'view', 'laporan_kemajuan', 'daftar_laporan_kemajuan', 'Melihat halaman daftar laporan kemajuan mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:43'),
(1284, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:44'),
(1285, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:06:47'),
(1286, 4, '212103024', 'Avril', 'view', 'penilaian', 'daftar_penilaian_mahasiswa', 'Melihat daftar mahasiswa untuk penilaian', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:07:15'),
(1287, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:04'),
(1288, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:21'),
(1289, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:24'),
(1290, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:24'),
(1291, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:25'),
(1292, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:44'),
(1293, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:09:52'),
(1294, 4, '212103024', 'Avril', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:10:09'),
(1295, 4, '212103024', 'Avril', 'logout', 'sistem', 'authentication', 'Logout dari sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:10:14'),
(1296, 1, '123', 'ara', 'login', 'sistem', 'authentication', 'Login ke sistem AYMP', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:10:26'),
(1297, 1, '123', 'ara', 'view', 'dashboard', 'das_pembimbing', 'Mengakses dashboard pembimbing', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:10:27'),
(1298, 1, '123', 'ara', 'view', 'laporan_akhir', 'daftar_laporan_akhir', 'Melihat halaman daftar laporan akhir mahasiswa', NULL, NULL, NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', '2025-08-09 21:10:29');

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

--
-- Dumping data untuk tabel `mahasiswa`
--

INSERT INTO `mahasiswa` (`id`, `perguruan_tinggi`, `program_studi`, `nim`, `nama_ketua`, `no_telp`, `email`, `password`, `status`, `tanggal_daftar`, `tanggal_verifikasi`) VALUES
(31, 'Universitas Jenderal Achmad Yani Yogyakarta', 'Akuntansi', '2221103030', '082136799628', '082136799628', 'putrapongkowulu@gmail.com', 'scrypt:32768:8:1$toSjlhrvfYnBNFnj$fefaceb036171df6460674cf6f3c0d24e6d63560c44ff69f11095277e5c3b20a4d16a6f828c57131302bbdf375882187755e8179a996f604c5cdd02b47334efa', 'aktif', '2025-08-10 16:40:06', '2025-08-10 16:40:48');

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

--
-- Dumping data untuk tabel `pembimbing`
--

INSERT INTO `pembimbing` (`id`, `nama`, `nip`, `program_studi`, `password`, `tanggal_dibuat`, `status`, `kuota_mahasiswa`) VALUES
(1, 'ara', '123', 'Akuntasi', 'scrypt:32768:8:1$rr7ljbxYEha1AncL$e94a5c277e48855381e78b63f58b7f15bd846e241908a4892f8189639c714f8ca7ad7ec61303bf1338cbb716b5fc48113b27519ee1e8142cab9dfaed583ee5c8', '2025-07-22 10:34:31', 'aktif', 5),
(4, 'Avril', '212103024', 'Sistem Informasi', 'scrypt:32768:8:1$9ZfOnG0r8o1w4P1I$efb496b2c7a5ae2042a1c81f86ed1cdca9da7a044860d8c5cbd59f880581e3bde0dacec9dfdc15dab1100bc6cc61fc4cb1b284cfde8855fc39c76c898e80e04c', '2025-08-09 11:46:31', 'aktif', 4);

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

--
-- Dumping data untuk tabel `pengaturan_anggaran`
--

INSERT INTO `pengaturan_anggaran` (`id`, `min_total_awal`, `max_total_awal`, `min_total_bertumbuh`, `max_total_bertumbuh`, `created_at`, `updated_at`) VALUES
(1, 100000, 3500000, 500000, 3500000, '2025-08-09 08:23:30', '2025-08-09 16:34:38');

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

--
-- Dumping data untuk tabel `pengaturan_bimbingan`
--

INSERT INTO `pengaturan_bimbingan` (`id`, `maksimal_bimbingan_per_hari`, `pesan_batasan`, `status_aktif`, `created_at`, `updated_at`) VALUES
(1, 2, 'Anda telah mencapai batas maksimal bimbingan hari ini. Maksimal 2 kali per hari. Silakan coba lagi besok.', 'aktif', '2025-08-09 02:50:08', '2025-08-09 16:19:00');

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
  `reviewer_proposal_mulai` datetime DEFAULT NULL,
  `reviewer_proposal_selesai` datetime DEFAULT NULL,
  `reviewer_kemajuan_mulai` datetime DEFAULT NULL,
  `reviewer_kemajuan_selesai` datetime DEFAULT NULL,
  `reviewer_akhir_mulai` datetime DEFAULT NULL,
  `reviewer_akhir_selesai` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pengaturan_jadwal`
--

INSERT INTO `pengaturan_jadwal` (`id`, `proposal_mulai`, `proposal_selesai`, `kemajuan_mulai`, `kemajuan_selesai`, `akhir_mulai`, `akhir_selesai`, `created_at`, `updated_at`, `pembimbing_nilai_mulai`, `pembimbing_nilai_selesai`, `reviewer_proposal_mulai`, `reviewer_proposal_selesai`, `reviewer_kemajuan_mulai`, `reviewer_kemajuan_selesai`, `reviewer_akhir_mulai`, `reviewer_akhir_selesai`) VALUES
(1, NULL, NULL, NULL, NULL, NULL, NULL, '2025-08-09 03:13:44', '2025-08-10 14:33:54', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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
  `nilai_akhir` decimal(5,2) DEFAULT 0.00 COMMENT 'Nilai akhir dalam persentase (seperti IPK)',
  `komentar_pembimbing` text DEFAULT NULL,
  `status` enum('Draft','Selesai') DEFAULT 'Draft',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
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

--
-- Dumping data untuk tabel `pertanyaan_penilaian_laporan_akhir`
--

INSERT INTO `pertanyaan_penilaian_laporan_akhir` (`id`, `pertanyaan`, `bobot`, `skor_maksimal`, `urutan`, `status`, `created_at`) VALUES
(7, 'Kemajuan pelaksanaan kegiatan sesuai dengan timeline yang direncanakan', 25.00, 4, 1, 'Aktif', '2025-08-07 18:21:59'),
(8, 'Pencapaian target output yang telah ditetapkan', 25.00, 4, 2, 'Aktif', '2025-08-07 18:21:59'),
(9, 'Penggunaan dana secara efektif dan efisien', 20.00, 4, 3, 'Aktif', '2025-08-07 18:21:59'),
(10, 'Kualitas laporan akhir yang disusun', 15.00, 4, 4, 'Aktif', '2025-08-07 18:21:59'),
(11, 'Kemampuan mengatasi kendala dan hambatan', 15.00, 4, 5, 'Aktif', '2025-08-07 18:21:59');

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

--
-- Dumping data untuk tabel `pertanyaan_penilaian_laporan_kemajuan`
--

INSERT INTO `pertanyaan_penilaian_laporan_kemajuan` (`id`, `pertanyaan`, `bobot`, `skor_maksimal`, `status`, `created_at`) VALUES
(1, 'Kemajuan pelaksanaan kegiatan sesuai dengan timeline yang direncanakan', 25.00, 4, 'Aktif', '2025-08-07 15:34:57'),
(2, 'Pencapaian target output yang telah ditetapkan', 25.00, 4, 'Aktif', '2025-08-07 15:34:57'),
(3, 'Penggunaan dana secara efektif dan efisien', 20.00, 4, 'Aktif', '2025-08-07 15:34:57'),
(4, 'Kualitas laporan kemajuan yang disampaikan', 15.00, 4, 'Aktif', '2025-08-07 15:34:57'),
(5, 'Kemampuan mengatasi kendala dan hambatan', 15.00, 4, 'Aktif', '2025-08-07 15:34:57');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pertanyaan_penilaian_mahasiswa`
--

CREATE TABLE `pertanyaan_penilaian_mahasiswa` (
  `id` int(11) NOT NULL,
  `pertanyaan` text NOT NULL,
  `bobot` decimal(5,2) NOT NULL COMMENT 'Bobot yang diinput admin (1-100)',
  `skor_maksimal` int(11) NOT NULL COMMENT 'Skor maksimal yang bisa diberikan (1-100)',
  `status` enum('Aktif','Nonaktif') DEFAULT 'Aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `pertanyaan_penilaian_mahasiswa`
--

INSERT INTO `pertanyaan_penilaian_mahasiswa` (`id`, `pertanyaan`, `bobot`, `skor_maksimal`, `status`, `created_at`) VALUES
(1, 'keaktifan mahasiswa', 20.00, 4, 'Aktif', '2025-08-07 07:24:52');

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

--
-- Dumping data untuk tabel `pertanyaan_penilaian_proposal`
--

INSERT INTO `pertanyaan_penilaian_proposal` (`id`, `pertanyaan`, `bobot`, `skor_maksimal`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'keaktifan mahasiswa?\r\n', 30.00, 4, 1, '2025-08-07 07:34:21', '2025-08-07 07:34:21');

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
(1, 'Farmasi', '2025-07-23 04:58:28'),
(2, 'Keperawatan', '2025-07-23 04:58:28'),
(3, 'Kebidanan', '2025-07-23 04:58:28'),
(4, 'TBD', '2025-07-23 04:58:28'),
(5, 'RMIK', '2025-07-23 04:58:28'),
(6, 'Teknologi Informasi', '2025-07-23 04:58:28'),
(7, 'Teknologi Industri', '2025-07-23 04:58:28'),
(8, 'Sistem Informasi', '2025-07-23 04:58:28'),
(9, 'Informatika', '2025-07-23 04:58:28'),
(10, 'Psikologi', '2025-07-23 04:58:28'),
(11, 'Manajemen', '2025-07-23 04:58:28'),
(12, 'Hukum', '2025-07-23 04:58:28'),
(13, 'Akuntansi', '2025-07-23 04:58:28'),
(34, 'RPL', '2025-08-02 13:28:52');

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
  `nib` varchar(50) NOT NULL,
  `tahun_nib` int(11) NOT NULL,
  `platform_penjualan` varchar(100) NOT NULL,
  `dosen_pembimbing` varchar(100) NOT NULL,
  `nid_dosen` varchar(20) NOT NULL,
  `program_studi_dosen` varchar(100) NOT NULL,
  `file_path` varchar(500) NOT NULL,
  `status` enum('draf','diajukan','disetujui','ditolak','revisi','selesai') DEFAULT 'draf',
  `status_admin` enum('belum_ditinjau','lolos','tidak_lolos') DEFAULT 'belum_ditinjau',
  `tahun` int(11) NOT NULL,
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

--
-- Dumping data untuk tabel `proposal`
--

INSERT INTO `proposal` (`id`, `nim`, `judul_usaha`, `kategori`, `tahapan_usaha`, `merk_produk`, `nib`, `tahun_nib`, `platform_penjualan`, `dosen_pembimbing`, `nid_dosen`, `program_studi_dosen`, `file_path`, `status`, `status_admin`, `tahun`, `tanggal_buat`, `tanggal_kirim`, `tanggal_review`, `tanggal_konfirmasi_pembimbing`, `tanggal_konfirmasi_admin`, `tanggal_revisi`, `id_reviewer`, `komentar_pembimbing`, `komentar_revisi`, `tanggal_komentar_pembimbing`) VALUES
(33, '2221103030', 'Apa', 'Budidaya', 'Usaha Awal', 'Bebas', '', 0, '', 'Ara', '123', 'Akuntasi', 'static\\uploads\\Proposal\\Apa\\Proposal_Apa_082136799628.pdf', 'draf', 'belum_ditinjau', 2024, '2025-08-10 16:41:56', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

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

--
-- Dumping data untuk tabel `reviewer`
--

INSERT INTO `reviewer` (`id`, `nama`, `username`, `password`, `kuota_review`, `created_at`, `updated_at`) VALUES
(1, 'Avril Putra Mahardika', 'v', 'scrypt:32768:8:1$btfAmp3dx3xG1Ql7$1d814bfa70d06c985d3b377f6adef002bac50383f676b2971e83aeb6ebf0d694201d9c751b7fff0f139bf85fdca670b738bf1c0fbee0bcf4beaf93d4d940538f', 7, '2025-08-02 16:05:00', '2025-08-09 13:50:40'),
(2, 'Ulfi Saidata Aesy', 'ulfi', 'scrypt:32768:8:1$dRzcoyzQz42zgUQz$e8c44fadcd38bb4c182c8890b66195f35c9d5e0e2b3144713e08214ea362e0d04759b56cefcfabfc9dd50647bedae3ec4ae06c2f12390857a806b20a37341d5f', 2, '2025-08-09 11:12:57', '2025-08-09 11:12:57');

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

--
-- Dumping data untuk tabel `session_mahasiswa`
--

INSERT INTO `session_mahasiswa` (`id`, `mahasiswa_id`, `nim`, `nama_mahasiswa`, `session_id`, `login_time`, `logout_time`, `durasi_detik`, `ip_address`, `user_agent`, `status`, `last_activity`) VALUES
(236, 31, '2221103030', '082136799628', '1ab14fab-db7d-4e84-8d4f-de163f6a7f57', '2025-08-10 16:40:17', '2025-08-10 16:40:30', 13, '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-10 16:40:30'),
(237, 31, '2221103030', '082136799628', 'd6722019-eb0f-4c46-bf8b-394ff98b71ec', '2025-08-10 16:41:06', NULL, NULL, '182.8.227.130', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'active', '2025-08-10 16:41:06');

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
-- Dumping data untuk tabel `session_pembimbing`
--

INSERT INTO `session_pembimbing` (`id`, `pembimbing_id`, `nip`, `nama_pembimbing`, `session_id`, `login_time`, `logout_time`, `durasi_detik`, `ip_address`, `user_agent`, `status`, `last_activity`) VALUES
(34, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:42:29', '2025-07-28 06:42:34', 5, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 06:42:34'),
(35, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:42:34', '2025-07-28 06:47:52', 318, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 06:47:52'),
(36, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:47:52', '2025-07-28 06:48:38', 46, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 06:48:38'),
(37, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:48:38', '2025-07-28 06:50:06', 88, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 06:50:06'),
(38, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:50:06', '2025-07-28 06:51:33', 87, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 06:51:33'),
(39, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 06:51:33', '2025-07-28 08:14:21', 4968, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 08:14:21'),
(40, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 08:14:21', '2025-07-28 08:19:15', 294, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 08:19:15'),
(41, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 08:19:15', '2025-07-28 08:20:28', 73, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 08:20:28'),
(42, 1, '123', 'ara', '715e83dc-1943-4a75-b083-646aa4c971fa', '2025-07-28 08:20:28', '2025-07-28 16:12:25', 28317, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 16:12:25'),
(43, 1, '123', 'ara', '20fa792a-dc8d-4322-9cd4-44827142de95', '2025-07-28 16:12:25', '2025-07-28 17:05:41', 3196, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 17:05:41'),
(44, 1, '123', 'ara', '20fa792a-dc8d-4322-9cd4-44827142de95', '2025-07-28 17:05:41', '2025-07-28 17:53:31', 2870, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 17:53:31'),
(45, 1, '123', 'ara', '5900796e-a450-478c-9808-a36c75ef6865', '2025-07-28 18:55:14', '2025-07-28 18:57:49', 155, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 18:57:49'),
(46, 1, '123', 'ara', 'e951031b-db8e-406a-9050-504df9a9b730', '2025-07-28 18:59:35', '2025-07-28 19:07:51', 496, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-28 19:07:51'),
(47, 1, '123', 'ara', '00132d27-7849-400d-ac5e-33120d4dcb55', '2025-07-28 19:09:11', '2025-07-29 11:17:45', 58114, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 11:17:45'),
(48, 1, '123', 'ara', '7e9814be-aafc-4003-b503-91a819686072', '2025-07-29 11:17:45', '2025-07-29 11:22:47', 302, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 11:22:47'),
(49, 1, '123', 'ara', 'da428512-7984-4099-84c1-1146d44f3665', '2025-07-29 11:23:29', '2025-07-29 11:30:22', 413, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 11:30:22'),
(50, 1, '123', 'ara', '1edce325-6f6d-4375-acc0-bc99fe5bf4af', '2025-07-29 11:30:44', '2025-07-29 11:31:33', 49, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 11:31:33'),
(51, 1, '123', 'ara', 'ac2c16b5-1506-4e13-a1b5-3957795100d0', '2025-07-29 16:29:35', '2025-07-29 17:53:10', 5015, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 17:53:10'),
(52, 1, '123', 'ara', '7f7f71f8-ba3f-4995-93b8-84c0e9663882', '2025-07-29 18:01:29', '2025-07-29 18:02:17', 48, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-29 18:02:17'),
(53, 1, '123', 'ara', 'efbf7942-d818-46b9-8f7b-3211106fc543', '2025-07-30 00:23:16', '2025-07-30 00:27:28', 252, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-30 00:27:28'),
(54, 1, '123', 'ara', '8460d52f-3aac-47ef-ae5b-afba922b3787', '2025-07-31 12:42:18', '2025-07-31 12:42:47', 29, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-31 12:42:47'),
(55, 1, '123', 'ara', '939ff695-460d-4f36-af26-866d44ad4dc7', '2025-07-31 12:49:40', '2025-07-31 13:22:36', 1976, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-31 13:22:36'),
(56, 1, '123', 'ara', 'dacb1eae-a283-4fe1-8af1-aff96e8483b9', '2025-07-31 13:24:19', '2025-07-31 18:04:37', 16818, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-07-31 18:04:37'),
(57, 1, '123', 'ara', '4894d16d-e26d-4b8f-b56c-2e93613261a6', '2025-07-31 18:04:37', '2025-08-01 01:29:26', 26689, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 01:29:26'),
(58, 1, '123', 'ara', '972afa6f-dafe-4d1f-9e3f-03c89ec321f3', '2025-08-01 01:29:26', '2025-08-01 01:29:49', 23, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 01:29:49'),
(59, 1, '123', 'ara', '10153157-ca10-48fe-80e5-11d33e06786c', '2025-08-01 03:24:24', '2025-08-01 03:27:09', 165, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 03:27:09'),
(60, 1, '123', 'ara', '559ba8d1-88dc-4baf-a917-0bda851e44de', '2025-08-01 03:33:05', '2025-08-01 04:25:26', 3141, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 04:25:26'),
(61, 1, '123', 'ara', '9b4b1a01-30d2-416e-839b-8624a65dc837', '2025-08-01 04:52:21', '2025-08-01 05:39:16', 2815, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 05:39:16'),
(62, 1, '123', 'ara', '9b4b1a01-30d2-416e-839b-8624a65dc837', '2025-08-01 05:39:16', '2025-08-01 15:56:48', 37052, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 15:56:48'),
(63, 1, '123', 'ara', 'c7ebea64-ee6b-471d-832f-5ff7acdecc90', '2025-08-01 15:56:48', '2025-08-01 15:57:50', 62, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-01 15:57:50'),
(64, 1, '123', 'ara', '9050579d-1dbb-4e71-ae10-75339292c084', '2025-08-02 13:36:32', '2025-08-02 13:41:52', 320, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-02 13:41:52'),
(65, 1, '123', 'ara', '7f7d2b75-28c2-49d5-9fc1-c035b96071fe', '2025-08-02 13:42:10', '2025-08-02 13:46:19', 249, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-02 13:46:19'),
(66, 1, '123', 'ara', 'b5b3dd02-7350-4c76-be44-d73a45833fb9', '2025-08-03 07:38:10', '2025-08-03 07:39:23', 73, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 07:39:23'),
(67, 1, '123', 'ara', '8ae819e7-90ea-4905-b596-4bb8adc45214', '2025-08-03 07:56:18', '2025-08-03 08:47:31', 3073, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 08:47:31'),
(68, 1, '123', 'ara', 'a49cbcb3-606c-4881-8934-c6981f15ed41', '2025-08-03 15:51:46', '2025-08-03 16:45:47', 3241, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 16:45:47'),
(69, 1, '123', 'ara', 'fa0d5651-b6a0-4bda-b597-96ee1ee775a8', '2025-08-03 16:46:41', '2025-08-03 16:54:46', 485, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 16:54:46'),
(70, 1, '123', 'ara', '55449a18-5367-4ac2-970f-e5ddfc63ae3c', '2025-08-03 16:55:30', '2025-08-03 17:09:51', 861, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 17:09:51'),
(71, 1, '123', 'ara', '62099a01-e4dc-4a7f-822c-0d2b10257f84', '2025-08-03 18:20:14', '2025-08-03 18:21:07', 53, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-03 18:21:07'),
(72, 1, '123', 'ara', '1abadac6-9bb2-4366-ba91-e8f3fd291167', '2025-08-04 05:59:04', '2025-08-04 06:29:15', 1811, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 06:29:15'),
(73, 1, '123', 'ara', '95b2f198-f6e3-403b-a742-0f14a73824ff', '2025-08-04 06:52:38', '2025-08-04 06:53:38', 60, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 06:53:38'),
(74, 1, '123', 'ara', 'ac1d0379-0d9c-431a-9bcb-21d94beffc8e', '2025-08-04 16:01:15', '2025-08-04 16:01:25', 10, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:01:25'),
(75, 1, '123', 'ara', '0236b9e7-5773-4c16-84d9-1102e0c4f5bf', '2025-08-04 16:01:28', '2025-08-04 16:01:41', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:01:41'),
(76, 1, '123', 'ara', '7d8b3c5c-09e1-4661-914d-b2c85ba9f7f5', '2025-08-04 16:01:45', '2025-08-04 16:04:54', 189, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:04:54'),
(77, 1, '123', 'ara', 'c18ec838-2987-4783-9975-6b9793258f48', '2025-08-04 16:05:17', '2025-08-04 16:19:32', 855, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:19:32'),
(78, 1, '123', 'ara', 'c18ec838-2987-4783-9975-6b9793258f48', '2025-08-04 16:19:32', '2025-08-04 16:20:04', 32, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:20:04'),
(79, 1, '123', 'ara', '69020e87-dcd2-486a-9cae-7afb69fd9329', '2025-08-04 16:20:07', '2025-08-04 16:20:10', 3, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:20:10'),
(80, 1, '123', 'ara', '7ece9a61-887d-4889-80dc-35484cc7917e', '2025-08-04 16:21:31', '2025-08-04 16:41:54', 1223, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-04 16:41:54'),
(81, 1, '123', 'ara', 'c4c61dc4-ee16-45cc-bb7e-d3fc8bbc21dc', '2025-08-04 17:55:39', '2025-08-05 07:31:35', 48956, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 07:31:35'),
(82, 1, '123', 'ara', 'd021ca6c-e32e-4279-a560-70ba6166f4e5', '2025-08-05 07:31:35', '2025-08-05 07:37:00', 325, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 07:37:00'),
(83, 1, '123', 'ara', 'd7767a51-89d7-4566-a6da-0763966b7dc0', '2025-08-05 07:41:10', '2025-08-05 07:42:18', 68, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 07:42:18'),
(84, 1, '123', 'ara', '83c24c39-7163-4157-9aa3-b00104fcc916', '2025-08-05 08:35:18', '2025-08-05 08:48:31', 793, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 08:48:31'),
(85, 1, '123', 'ara', '5426d0f2-f190-4524-ab9e-b7b5724bfee5', '2025-08-05 09:07:14', '2025-08-05 09:09:05', 111, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 09:09:05'),
(86, 1, '123', 'ara', 'a9654e69-a5bf-4f97-afb4-4341a6fbdf02', '2025-08-05 09:10:07', '2025-08-05 09:10:20', 13, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 09:10:20'),
(87, 1, '123', 'ara', '9a0825ec-6e77-4ffa-b549-d56163676f03', '2025-08-05 09:11:30', '2025-08-05 09:12:47', 77, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 09:12:47'),
(88, 1, '123', 'ara', '16ce7833-5d0b-42cc-bd77-1e6b71c6a5b9', '2025-08-05 09:39:23', '2025-08-05 09:41:48', 145, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 09:41:48'),
(89, 1, '123', 'ara', 'e4cfde3e-d79f-486c-8fc8-fd6a1e0c5ec8', '2025-08-05 09:42:50', '2025-08-05 09:43:49', 59, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-05 09:43:49'),
(90, 1, '123', 'ara', 'e39b81cf-31b2-4a6c-9207-bd38f1bd1b07', '2025-08-05 09:44:03', '2025-08-06 11:11:46', 91663, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 11:11:46'),
(91, 1, '123', 'ara', 'a8aefdd8-95ae-40b2-8b1f-75afcf12fb5a', '2025-08-06 11:11:46', '2025-08-06 11:12:44', 58, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 11:12:44'),
(92, 1, '123', 'ara', '5b797761-014a-4d74-94a9-2140c91bf07a', '2025-08-06 11:13:22', '2025-08-06 11:17:59', 277, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 11:17:59'),
(93, 1, '123', 'ara', '2669b901-2a25-4121-a6d6-7d0b66fa9f63', '2025-08-06 11:18:43', '2025-08-06 11:53:11', 2068, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 11:53:11'),
(94, 1, '123', 'ara', '8e811b3c-2daf-4e76-b6a9-505001c3b4b6', '2025-08-06 16:39:01', '2025-08-06 17:08:21', 1760, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 17:08:21'),
(95, 1, '123', 'ara', 'da197eb4-b0c6-42fb-951a-eec695128a71', '2025-08-06 17:29:42', '2025-08-06 17:41:29', 707, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-06 17:41:29'),
(96, 1, '123', 'ara', 'c2b4bfab-175e-4420-85d3-c2dc6313271e', '2025-08-06 18:14:29', '2025-08-07 01:39:37', 26708, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 01:39:37'),
(97, 1, '123', 'ara', '0af9659b-23b8-4312-81f7-419a7f1d4385', '2025-08-07 01:39:37', '2025-08-07 01:48:53', 556, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 01:48:53'),
(98, 1, '123', 'ara', 'af7d855b-4891-4e0b-9397-980a6d476f6a', '2025-08-07 06:32:36', '2025-08-07 06:32:44', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 06:32:44'),
(99, 1, '123', 'ara', 'f6638df9-affe-4728-8308-f5b646057d74', '2025-08-07 06:49:51', '2025-08-07 06:50:37', 46, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 06:50:37'),
(100, 1, '123', 'ara', '82840738-4301-4b42-983a-5386a7a4f45f', '2025-08-07 07:20:59', '2025-08-07 07:24:22', 203, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 07:24:22'),
(101, 1, '123', 'ara', '1576f7f3-f6ab-4973-bdad-187bfe07d3b1', '2025-08-07 07:53:51', '2025-08-07 08:21:09', 1638, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 08:21:09'),
(102, 1, '123', 'ara', '477c062d-5565-4558-88c7-afc1e3e856aa', '2025-08-07 08:30:55', '2025-08-07 08:36:10', 315, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 08:36:10'),
(103, 1, '123', 'ara', 'fe9730cd-ae11-407b-a525-aae281f3ae12', '2025-08-07 16:03:45', '2025-08-07 16:03:51', 6, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 16:03:51'),
(104, 1, '123', 'ara', 'daba20ba-31aa-4da3-95c5-5a00dfb9aeed', '2025-08-07 16:07:19', '2025-08-07 16:08:41', 82, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-07 16:08:41'),
(105, 1, '123', 'ara', 'cb662426-7d09-4f52-b827-efbe20312a10', '2025-08-08 01:23:21', '2025-08-08 01:46:30', 1389, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 01:46:30'),
(106, 1, '123', 'ara', 'fd25c716-3309-457a-b25d-55cadf171f5f', '2025-08-08 03:40:55', '2025-08-08 04:27:45', 2810, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 04:27:45'),
(107, 1, '123', 'ara', 'dce2022a-f06c-4e6b-b7f3-027356c25933', '2025-08-08 09:19:31', '2025-08-08 15:27:55', 22104, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 15:27:55'),
(108, 1, '123', 'ara', 'dee2177e-5ee9-48a6-8e47-8007710dcd77', '2025-08-08 15:27:55', '2025-08-08 15:31:09', 194, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 15:31:09'),
(109, 1, '123', 'ara', '347f3344-7db6-42d5-8632-12070219eb8f', '2025-08-08 15:32:24', '2025-08-08 15:35:27', 183, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 15:35:27'),
(110, 1, '123', 'ara', '85d600e2-84cc-4d8a-9bd2-6ba1bdca1ba8', '2025-08-08 15:36:49', '2025-08-08 15:37:19', 30, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 15:37:19'),
(111, 1, '123', 'ara', '94172eef-ceaf-42ad-a8ec-c375743f25d8', '2025-08-08 15:47:50', '2025-08-08 15:55:43', 473, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 15:55:43'),
(112, 1, '123', 'ara', '832012f3-db5a-4cd0-abe5-023c9908cec8', '2025-08-08 16:02:19', '2025-08-08 16:02:35', 16, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 16:02:35'),
(113, 1, '123', 'ara', 'b1ca647c-ff9c-433f-8272-f0431de5a1b6', '2025-08-08 17:59:32', '2025-08-08 18:00:22', 50, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:00:22'),
(114, 1, '123', 'ara', '3b7c37d8-bfe4-48ad-8819-1116624217f1', '2025-08-08 18:02:18', '2025-08-08 18:03:55', 97, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:03:55'),
(115, 1, '123', 'ara', '6e465414-65d3-462a-a85c-0a639052bb8f', '2025-08-08 18:04:47', '2025-08-08 18:05:12', 25, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:05:12'),
(116, 1, '123', 'ara', '9b63e5a5-d39d-4668-9211-f13b38938516', '2025-08-08 18:05:55', '2025-08-08 18:08:15', 140, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:08:15'),
(117, 1, '123', 'ara', '304e3d4a-ba7d-44d3-8a88-347012857236', '2025-08-08 18:09:56', '2025-08-08 18:19:51', 595, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:19:51'),
(118, 1, '123', 'ara', '1f012bb3-0bc9-4c96-910e-691b5ed101d6', '2025-08-08 18:22:33', '2025-08-08 18:48:09', 1536, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-08 18:48:09'),
(119, 1, '123', 'ara', '753420f9-b8b5-42c0-9779-26e1e01d3f17', '2025-08-09 06:19:55', '2025-08-09 06:20:40', 45, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 06:20:40'),
(120, 1, '123', 'ara', '8ef35979-f608-487c-9398-65ebcd47809b', '2025-08-09 06:47:20', '2025-08-09 06:48:36', 76, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 06:48:36'),
(121, 1, '123', 'ara', '3e92feb3-2df0-4c8f-8e2e-bd564b3ed1fa', '2025-08-09 06:49:05', '2025-08-09 06:49:13', 8, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 06:49:13'),
(122, 1, '123', 'ara', '515c9f02-c5c4-4364-b240-243e7852b7be', '2025-08-09 07:06:43', '2025-08-09 07:12:50', 367, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 07:12:50'),
(123, 1, '123', 'ara', 'b45c40d1-786a-4f2f-82ef-a8beaf90bc06', '2025-08-09 07:28:44', '2025-08-09 07:29:12', 28, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 07:29:12'),
(124, 1, '123', 'ara', '21dc100e-48b1-4266-9a7a-ef330f6067ab', '2025-08-09 07:32:22', '2025-08-09 07:38:41', 379, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 07:38:41'),
(125, 1, '123', 'ara', '6777ad02-d208-4939-bb26-ba828f165a91', '2025-08-09 07:43:54', '2025-08-09 07:45:37', 103, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 07:45:37'),
(126, 1, '123', 'ara', '79873baa-30e9-4681-8378-0d46158082c0', '2025-08-09 08:48:47', '2025-08-09 08:53:44', 297, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 08:53:44'),
(127, 1, '123', 'ara', '5c5749fe-f1b6-4e80-8e3d-5513bfc3d7c3', '2025-08-09 08:54:08', '2025-08-09 08:54:39', 31, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 08:54:39'),
(128, 1, '123', 'ara', 'bb4af7b2-a33c-4846-87ad-a8b971565db5', '2025-08-09 08:58:30', '2025-08-09 08:59:53', 83, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 08:59:53'),
(129, 1, '123', 'ara', 'd4afb6bb-335c-490a-ae3a-dd49f3ccca95', '2025-08-09 08:59:56', '2025-08-09 09:00:14', 18, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 09:00:14'),
(130, 1, '123', 'ara', '239bd488-2990-42bb-9b8b-a7c203e1d4ee', '2025-08-09 09:00:42', '2025-08-09 09:05:49', 307, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 09:05:49'),
(131, 1, '123', 'ara', '0adb43cd-2faa-4557-b69d-58227e274752', '2025-08-09 10:01:04', '2025-08-09 10:01:36', 32, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 10:01:36'),
(132, 1, '123', 'ara', 'e962deb3-3ba5-48a6-b68a-71787602eac4', '2025-08-09 10:01:41', '2025-08-09 10:01:43', 2, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 10:01:43'),
(133, 1, '123', 'ara', '39ed0fa5-0818-4e62-8d92-1d511a7da4c7', '2025-08-09 10:04:07', '2025-08-09 10:05:28', 81, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 10:05:28'),
(134, 1, '123', 'ara', '922ddd87-f69b-4b96-8c4e-c5d55e94aff5', '2025-08-09 10:06:18', '2025-08-09 10:07:17', 59, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 10:07:17'),
(135, 1, '123', 'ara', 'efabe9e2-4671-4ab2-917c-2f21e4d7ecd0', '2025-08-09 10:37:39', '2025-08-09 11:08:29', 1850, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 11:08:29'),
(136, 1, '123', 'ara', '836cf071-94fb-42fa-bf3b-bb6fa0d7510e', '2025-08-09 11:43:32', '2025-08-09 11:46:32', 180, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 11:46:32'),
(137, 1, '123', 'ara', 'aa465bc3-08e4-452b-9a1d-51135df90e07', '2025-08-09 12:00:53', '2025-08-09 12:01:12', 19, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:01:12'),
(138, 1, '123', 'ara', '33191d74-d0cc-491c-a89d-4e18f4b346dc', '2025-08-09 12:04:22', '2025-08-09 12:04:49', 27, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:04:49'),
(139, 4, '212103024', 'Avril', 'a9bc5a2f-b889-492c-b663-9b796a926774', '2025-08-09 12:06:00', '2025-08-09 12:06:33', 33, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:06:33'),
(140, 4, '212103024', 'Avril', '5ae42ba8-6d71-43ca-988d-3584578972f7', '2025-08-09 12:06:45', '2025-08-09 12:07:09', 24, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:07:09'),
(141, 4, '212103024', 'Avril', '14faab30-7e59-477d-ad19-e49c390612e8', '2025-08-09 12:21:20', '2025-08-09 12:22:13', 53, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:22:13'),
(142, 4, '212103024', 'Avril', 'f0171f7c-a315-4c24-800e-0c9f379b5b9f', '2025-08-09 12:26:41', '2025-08-09 12:27:44', 63, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:27:44'),
(143, 4, '212103024', 'Avril', 'f570bc63-81f5-4fec-a24c-acdc4698d92b', '2025-08-09 12:54:34', '2025-08-09 12:54:51', 17, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 12:54:51'),
(144, 4, '212103024', 'Avril', 'db468036-d023-4e61-a488-fdf7b6eb6ebd', '2025-08-09 13:32:33', '2025-08-09 13:33:06', 33, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 13:33:06'),
(145, 4, '212103024', 'Avril', 'dda95af8-130b-4099-91af-6a44b3f74c0e', '2025-08-09 13:34:57', '2025-08-09 13:35:08', 11, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 13:35:08'),
(146, 4, '212103024', 'Avril', 'ed6b88be-c891-4b53-b342-f2c79df5cf32', '2025-08-09 13:48:26', '2025-08-09 13:49:38', 72, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 13:49:38'),
(147, 1, '123', 'ara', '54b1d202-4477-462b-91e5-72d915a6e51c', '2025-08-09 13:49:14', '2025-08-09 13:50:03', 49, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 13:50:03'),
(148, 4, '212103024', 'Avril', 'a6ce04b5-5b7e-4605-b818-5cb285a5cf86', '2025-08-09 13:53:13', '2025-08-09 13:53:39', 26, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 13:53:39'),
(149, 4, '212103024', 'Avril', 'e88236e9-7401-48b7-9410-2ee8740242f9', '2025-08-09 14:16:23', '2025-08-09 14:18:23', 120, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 14:18:23'),
(150, 4, '212103024', 'Avril', 'b70bf417-a7ac-414a-a4da-220cf76a160f', '2025-08-09 14:26:48', '2025-08-09 14:27:43', 55, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 14:27:43'),
(151, 4, '212103024', 'Avril', 'ad24ee30-f885-44f1-b969-b17c49bbdc42', '2025-08-09 14:46:12', '2025-08-09 14:46:30', 18, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 14:46:30'),
(152, 4, '212103024', 'Avril', '04f02c40-3100-4f9b-8107-4c62786e03a4', '2025-08-09 14:49:45', '2025-08-09 14:49:58', 13, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 14:49:58'),
(153, 4, '212103024', 'Avril', '544e61e2-f900-4755-bff3-483001ff57b3', '2025-08-09 15:15:07', '2025-08-09 15:15:20', 13, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 15:15:20'),
(154, 4, '212103024', 'Avril', '8beb6d1d-892d-42b9-8047-c37f7e3f0931', '2025-08-09 15:23:54', '2025-08-09 15:33:25', 571, '182.1.83.84', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 15:33:25'),
(155, 4, '212103024', 'Avril', '3d689b1c-ee60-492c-81e5-8018dded32c8', '2025-08-09 16:05:37', '2025-08-09 16:06:00', 23, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:06:00'),
(156, 4, '212103024', 'Avril', '36eb6a79-bdb4-4fb2-bfbb-43932d8d0340', '2025-08-09 16:45:43', '2025-08-09 16:48:08', 145, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:48:08'),
(157, 4, '212103024', 'Avril', 'f2720f33-d1c5-4fd3-954e-0f7c250d4682', '2025-08-09 16:49:21', '2025-08-09 16:49:45', 24, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:49:45'),
(158, 4, '212103024', 'Avril', '0383bce6-63b9-4fc2-924f-b27ab2b386af', '2025-08-09 16:54:55', '2025-08-09 16:55:10', 15, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:55:10'),
(159, 4, '212103024', 'Avril', '2b53db70-9cf6-4d35-bf6b-5d4bd88e9ceb', '2025-08-09 16:55:31', '2025-08-09 16:55:40', 9, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:55:40'),
(160, 4, '212103024', 'Avril', '67fcbc56-17c6-4d85-9664-153ad182ebd6', '2025-08-09 16:56:59', '2025-08-09 16:57:08', 9, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 16:57:08'),
(161, 4, '212103024', 'Avril', 'ff5df584-cd4d-4425-a3d7-e1c387e347c1', '2025-08-09 17:02:59', '2025-08-09 17:03:50', 51, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:03:50'),
(162, 4, '212103024', 'Avril', '63dbc8b4-521f-4ca4-a499-4697667711ee', '2025-08-09 17:04:41', '2025-08-09 17:06:06', 85, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:06:06'),
(163, 1, '123', 'ara', 'e0d6024c-84e7-45cd-8e0b-cc4af6f360f1', '2025-08-09 17:06:08', '2025-08-09 17:06:10', 2, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:06:10'),
(164, 4, '212103024', 'Avril', '7d991204-bb3b-42c7-8ab7-c5eac9f67678', '2025-08-09 17:06:14', '2025-08-09 17:06:14', 0, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:06:14'),
(165, 4, '212103024', 'Avril', '526945b1-4eda-45a2-a06c-523b82ce3280', '2025-08-09 17:06:14', '2025-08-09 17:06:26', 12, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:06:26'),
(166, 4, '212103024', 'Avril', 'c18c5a64-c5ad-4a46-90f7-7b3a68bff127', '2025-08-09 17:07:50', '2025-08-09 17:08:48', 58, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:08:48'),
(167, 4, '212103024', 'Avril', '51989447-09ab-45d3-a23c-6f3eea57b3cf', '2025-08-09 17:09:28', '2025-08-09 17:09:38', 10, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:09:38'),
(168, 4, '212103024', 'Avril', '7bcc149b-d2ee-428a-806d-0113991bbf03', '2025-08-09 17:09:58', '2025-08-09 17:11:47', 109, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:11:47'),
(169, 4, '212103024', 'Avril', '6d436787-b3c1-4603-9d50-39d0a0c25352', '2025-08-09 17:12:43', '2025-08-09 17:13:09', 26, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:13:09'),
(170, 4, '212103024', 'Avril', '0056514e-ba64-496d-a0d6-23218c145a92', '2025-08-09 17:19:22', '2025-08-09 17:20:10', 48, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:20:10'),
(171, 4, '212103024', 'Avril', '14401fc8-bc14-43de-b0c8-c265495b87fa', '2025-08-09 17:20:30', '2025-08-09 17:21:42', 72, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:21:42'),
(172, 4, '212103024', 'Avril', '03ea9067-2c41-4cb5-8093-84042a02b11f', '2025-08-09 17:22:34', '2025-08-09 17:24:52', 138, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:24:52'),
(173, 4, '212103024', 'Avril', '0b5efbaf-46ff-41c3-bf88-f3aad71962c2', '2025-08-09 17:26:19', '2025-08-09 17:28:04', 105, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:28:04'),
(174, 4, '212103024', 'Avril', '759ef20d-426a-4b74-94bb-5c4d7c30cf61', '2025-08-09 17:28:26', '2025-08-09 17:32:42', 256, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:32:42'),
(175, 4, '212103024', 'Avril', '61e7b4b4-a2e4-4b39-a24e-1d3e8f302573', '2025-08-09 17:33:12', '2025-08-09 17:34:21', 69, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:34:21'),
(176, 4, '212103024', 'Avril', '7c3a45e8-f670-4304-b458-ec15e4039b6a', '2025-08-09 17:46:03', '2025-08-09 17:46:16', 13, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 17:46:16'),
(177, 4, '212103024', 'Avril', '2afee873-7dfe-45a7-ac4a-d8aef9e5a51c', '2025-08-09 18:48:19', '2025-08-09 18:49:34', 75, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 18:49:34'),
(178, 4, '212103024', 'Avril', 'b169cee4-caad-4e72-a4c1-4511d57d34a6', '2025-08-09 18:50:17', '2025-08-09 18:50:34', 17, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 18:50:34'),
(179, 4, '212103024', 'Avril', '4183bceb-8b4d-4fa5-838f-16256711eda9', '2025-08-09 19:14:17', '2025-08-09 19:15:21', 64, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 19:15:21'),
(180, 4, '212103024', 'Avril', 'bcc99c5a-7736-472f-a113-ac04fd55cb2e', '2025-08-09 19:15:53', '2025-08-09 19:16:09', 16, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 19:16:09'),
(181, 4, '212103024', 'Avril', '5139cb49-c1ce-4f08-8ca9-96dee97343d2', '2025-08-09 19:22:50', '2025-08-09 19:25:52', 182, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'ended', '2025-08-09 19:25:52'),
(182, 4, '212103024', 'Avril', '358fcbe7-ee93-4f09-a6bb-49b5cbaa4075', '2025-08-09 20:23:34', '2025-08-09 20:24:13', 39, '114.125.79.236', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Mobile Safari/537.36', 'ended', '2025-08-09 20:24:13'),
(183, 1, '123', 'ara', 'beb64e64-9e39-487e-8b44-0849c7d2c8fb', '2025-08-09 20:58:24', '2025-08-09 21:05:40', 436, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 21:05:40'),
(184, 4, '212103024', 'Avril', '69c773ec-731e-42ff-b83a-d48f69fdfda0', '2025-08-09 21:05:45', '2025-08-09 21:10:14', 269, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'ended', '2025-08-09 21:10:14'),
(185, 1, '123', 'ara', '4b8bc9a6-6d0b-4aa6-bd3f-f9cc5bca6745', '2025-08-09 21:10:26', NULL, NULL, '117.103.169.194', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/138.0.0.0 Safari/537.36', 'active', '2025-08-09 21:10:29');

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
  ADD UNIQUE KEY `unique_detail_penilaian_mahasiswa` (`id_penilaian_mahasiswa`,`id_pertanyaan`),
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
  ADD KEY `id_pembimbing` (`id_pembimbing`),
  ADD KEY `idx_penilaian_mahasiswa_proposal` (`id_proposal`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `alat_produksi`
--
ALTER TABLE `alat_produksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `anggaran_awal`
--
ALTER TABLE `anggaran_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT untuk tabel `anggaran_bertumbuh`
--
ALTER TABLE `anggaran_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `anggota_tim`
--
ALTER TABLE `anggota_tim`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT untuk tabel `arus_kas`
--
ALTER TABLE `arus_kas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT untuk tabel `bahan_baku`
--
ALTER TABLE `bahan_baku`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT untuk tabel `biaya_non_operasional`
--
ALTER TABLE `biaya_non_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `biaya_operasional`
--
ALTER TABLE `biaya_operasional`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `bimbingan`
--
ALTER TABLE `bimbingan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_laporan_akhir`
--
ALTER TABLE `detail_penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_laporan_kemajuan`
--
ALTER TABLE `detail_penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_mahasiswa`
--
ALTER TABLE `detail_penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `detail_penilaian_proposal`
--
ALTER TABLE `detail_penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `file_laporan_akhir`
--
ALTER TABLE `file_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `file_laporan_kemajuan`
--
ALTER TABLE `file_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `laba_rugi`
--
ALTER TABLE `laba_rugi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `laporan_akhir_awal`
--
ALTER TABLE `laporan_akhir_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `laporan_akhir_bertumbuh`
--
ALTER TABLE `laporan_akhir_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT untuk tabel `laporan_kemajuan_awal`
--
ALTER TABLE `laporan_kemajuan_awal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT untuk tabel `laporan_kemajuan_bertumbuh`
--
ALTER TABLE `laporan_kemajuan_bertumbuh`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=232;

--
-- AUTO_INCREMENT untuk tabel `laporan_neraca`
--
ALTER TABLE `laporan_neraca`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `log_aktivitas_mahasiswa`
--
ALTER TABLE `log_aktivitas_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=333;

--
-- AUTO_INCREMENT untuk tabel `log_aktivitas_pembimbing`
--
ALTER TABLE `log_aktivitas_pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1299;

--
-- AUTO_INCREMENT untuk tabel `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT untuk tabel `pembimbing`
--
ALTER TABLE `pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_anggaran`
--
ALTER TABLE `pengaturan_anggaran`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_bimbingan`
--
ALTER TABLE `pengaturan_bimbingan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `pengaturan_jadwal`
--
ALTER TABLE `pengaturan_jadwal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `penilaian_laporan_akhir`
--
ALTER TABLE `penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `penilaian_laporan_kemajuan`
--
ALTER TABLE `penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT untuk tabel `penilaian_mahasiswa`
--
ALTER TABLE `penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT untuk tabel `penilaian_proposal`
--
ALTER TABLE `penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `penjualan`
--
ALTER TABLE `penjualan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_laporan_akhir`
--
ALTER TABLE `pertanyaan_penilaian_laporan_akhir`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_laporan_kemajuan`
--
ALTER TABLE `pertanyaan_penilaian_laporan_kemajuan`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_mahasiswa`
--
ALTER TABLE `pertanyaan_penilaian_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `pertanyaan_penilaian_proposal`
--
ALTER TABLE `pertanyaan_penilaian_proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `produksi`
--
ALTER TABLE `produksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT untuk tabel `produk_bahan_baku`
--
ALTER TABLE `produk_bahan_baku`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=49;

--
-- AUTO_INCREMENT untuk tabel `program_studi`
--
ALTER TABLE `program_studi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT untuk tabel `proposal`
--
ALTER TABLE `proposal`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT untuk tabel `proposal_reviewer`
--
ALTER TABLE `proposal_reviewer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT untuk tabel `reviewer`
--
ALTER TABLE `reviewer`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `session_mahasiswa`
--
ALTER TABLE `session_mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=238;

--
-- AUTO_INCREMENT untuk tabel `session_pembimbing`
--
ALTER TABLE `session_pembimbing`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=186;

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
