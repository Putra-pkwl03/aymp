# Konfigurasi auto-fill - ENABLED untuk data baru dalam jadwal aktif
AUTO_FILL_CONFIG = {
    'CHECK_INTERVAL': 60,
    'PRIORITY_CHECK_INTERVAL': 30,
    'DB_HOST': 'localhost',
    'DB_USER': 'root',
    'DB_PASSWD': '',
    'DB_NAME': 'aymp',
    'AUTO_FILL_ENABLED': True,  # ✅ ENABLED untuk data baru
    'ENABLE_SMART_CHECKING': True,  # ✅ ENABLED
    'MAX_BATCH_SIZE': 10,
    'DEFAULT_SCORE': 0,
    'DEFAULT_STATUS': 'terkunci',
    'DEFAULT_KETERANGAN': 'Auto-filled: Sesi terlewat',
    'SKIP_OLD_DATA': False,  # ✅ Tidak skip data lama, biarkan logika di app.py yang menangani
    'OLD_DATA_THRESHOLD_DAYS': 7,
    'STRICT_OLD_DATA_CHECK': False,  # ✅ Tidak terlalu ketat
    'DISABLE_AUTO_FILL_FOR_OLD_DATA': False,  # ✅ Aktifkan auto-fill untuk semua data
    'STRICT_DATE_VALIDATION': False,  # ✅ Tidak terlalu ketat
    'VALIDATE_METADATA': True,  # ✅ Validasi metadata
    'CLEANUP_INVALID_AUTO_FILL': True,  # ✅ Cleanup auto-fill yang salah
    'STOP_WORKER_ON_ERROR': False,  # ✅ Jangan berhenti jika ada error
    'MAX_RETRY_ATTEMPTS': 3,  # ✅ Maksimal 3x retry
    'WORKER_TIMEOUT': 30  # ✅ Timeout 30 detik
}

INTERVAL_CONFIG = {
    'jam': {'multiplier': 3600, 'description': 'per jam'},
    'hari': {'multiplier': 86400, 'description': 'per hari'},
    'minggu': {'multiplier': 604800, 'description': 'per minggu'},
    'bulan': {'multiplier': 2592000, 'description': 'per bulan'}
}
