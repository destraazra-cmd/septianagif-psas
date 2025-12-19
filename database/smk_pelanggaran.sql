-- Database: SMK Bakti Nusantara 666 - Sistem Pelanggaran Siswa
-- Created: December 2024

-- Membuat database
CREATE DATABASE IF NOT EXISTS smk_pelanggaran;
USE smk_pelanggaran;

-- Tabel Users (Admin/Guru)
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    nama_lengkap VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    role ENUM('admin', 'guru', 'bk') DEFAULT 'guru',
    status ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabel Kelas
CREATE TABLE kelas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_kelas VARCHAR(20) NOT NULL,
    jurusan ENUM('TKJ', 'RPL', 'MM', 'OTKP') NOT NULL,
    tingkat ENUM('X', 'XI', 'XII') NOT NULL,
    wali_kelas VARCHAR(100),
    tahun_ajaran VARCHAR(10) NOT NULL,
    status ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Siswa
CREATE TABLE siswa (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nis VARCHAR(20) UNIQUE NOT NULL,
    nisn VARCHAR(20),
    nama_lengkap VARCHAR(100) NOT NULL,
    jenis_kelamin ENUM('L', 'P') NOT NULL,
    tempat_lahir VARCHAR(50),
    tanggal_lahir DATE,
    alamat TEXT,
    no_hp VARCHAR(15),
    email VARCHAR(100),
    nama_ayah VARCHAR(100),
    nama_ibu VARCHAR(100),
    pekerjaan_ayah VARCHAR(50),
    pekerjaan_ibu VARCHAR(50),
    no_hp_ortu VARCHAR(15),
    kelas_id INT,
    tahun_masuk YEAR,
    status ENUM('aktif', 'lulus', 'pindah', 'keluar') DEFAULT 'aktif',
    foto VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (kelas_id) REFERENCES kelas(id)
);

-- Tabel Jenis Pelanggaran
CREATE TABLE jenis_pelanggaran (
    id INT PRIMARY KEY AUTO_INCREMENT,
    kode_pelanggaran VARCHAR(10) UNIQUE NOT NULL,
    nama_pelanggaran VARCHAR(100) NOT NULL,
    kategori ENUM('ringan', 'sedang', 'berat', 'sangat_berat') NOT NULL,
    poin INT NOT NULL,
    deskripsi TEXT,
    sanksi_default TEXT,
    status ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabel Pelanggaran
CREATE TABLE pelanggaran (
    id INT PRIMARY KEY AUTO_INCREMENT,
    siswa_id INT NOT NULL,
    jenis_pelanggaran_id INT NOT NULL,
    tanggal_pelanggaran DATE NOT NULL,
    waktu_pelanggaran TIME,
    tempat_kejadian VARCHAR(100),
    kronologi TEXT,
    sanksi TEXT,
    poin INT NOT NULL,
    status_sanksi ENUM('belum', 'proses', 'selesai') DEFAULT 'belum',
    tanggal_selesai_sanksi DATE,
    pelapor VARCHAR(100),
    user_id INT,
    catatan TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id),
    FOREIGN KEY (jenis_pelanggaran_id) REFERENCES jenis_pelanggaran(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Tabel Prestasi
CREATE TABLE prestasi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    siswa_id INT NOT NULL,
    jenis_prestasi VARCHAR(100) NOT NULL,
    tingkat ENUM('sekolah', 'kecamatan', 'kota', 'provinsi', 'nasional', 'internasional') NOT NULL,
    juara VARCHAR(20),
    tanggal_prestasi DATE NOT NULL,
    penyelenggara VARCHAR(100),
    deskripsi TEXT,
    poin_positif INT DEFAULT 0,
    sertifikat VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id)
);

-- Tabel Panggilan Orang Tua
CREATE TABLE panggilan_ortu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    siswa_id INT NOT NULL,
    pelanggaran_id INT,
    tanggal_panggilan DATE NOT NULL,
    waktu_panggilan TIME,
    yang_hadir VARCHAR(100),
    hasil_konsultasi TEXT,
    tindak_lanjut TEXT,
    status ENUM('dijadwalkan', 'hadir', 'tidak_hadir', 'reschedule') DEFAULT 'dijadwalkan',
    user_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (siswa_id) REFERENCES siswa(id),
    FOREIGN KEY (pelanggaran_id) REFERENCES pelanggaran(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Insert data default

-- Insert Users
INSERT INTO users (username, password, nama_lengkap, email, role) VALUES
('admin', MD5('admin123'), 'Administrator', 'admin@smkbaktinusantara666.sch.id', 'admin'),
('guru_bk', MD5('bk123'), 'Sari Dewi, S.Pd', 'bk@smkbaktinusantara666.sch.id', 'bk'),
('wali_kelas', MD5('wali123'), 'Ahmad Fauzi, S.Pd', 'wali@smkbaktinusantara666.sch.id', 'guru');

-- Insert Kelas
INSERT INTO kelas (nama_kelas, jurusan, tingkat, wali_kelas, tahun_ajaran) VALUES
('X TKJ 1', 'TKJ', 'X', 'Budi Santoso, S.Kom', '2024/2025'),
('X TKJ 2', 'TKJ', 'X', 'Siti Nurhaliza, S.T', '2024/2025'),
('XI TKJ 1', 'TKJ', 'XI', 'Ahmad Fauzi, S.Pd', '2024/2025'),
('XI TKJ 2', 'TKJ', 'XI', 'Dewi Sartika, S.Kom', '2024/2025'),
('XII TKJ 1', 'TKJ', 'XII', 'Andi Wijaya, S.T', '2024/2025'),
('XII TKJ 2', 'TKJ', 'XII', 'Maya Sari, S.Kom', '2024/2025'),
('X RPL 1', 'RPL', 'X', 'Rizki Pratama, S.Kom', '2024/2025'),
('X RPL 2', 'RPL', 'X', 'Indah Permata, S.T', '2024/2025'),
('XI RPL 1', 'RPL', 'XI', 'Bayu Setiawan, S.Kom', '2024/2025'),
('XI RPL 2', 'RPL', 'XI', 'Lina Marlina, S.T', '2024/2025'),
('XII RPL 1', 'RPL', 'XII', 'Doni Prasetyo, S.Kom', '2024/2025'),
('XII RPL 2', 'RPL', 'XII', 'Eka Putri, S.T', '2024/2025'),
('X MM 1', 'MM', 'X', 'Rudi Hermawan, S.Sn', '2024/2025'),
('XI MM 1', 'MM', 'XI', 'Fitri Handayani, S.Sn', '2024/2025'),
('XII MM 1', 'MM', 'XII', 'Agus Salim, S.Sn', '2024/2025'),
('X OTKP 1', 'OTKP', 'X', 'Ratna Sari, S.Pd', '2024/2025'),
('XI OTKP 1', 'OTKP', 'XI', 'Hendra Gunawan, S.E', '2024/2025'),
('XII OTKP 1', 'OTKP', 'XII', 'Wulan Dari, S.Pd', '2024/2025');

-- Insert Jenis Pelanggaran
INSERT INTO jenis_pelanggaran (kode_pelanggaran, nama_pelanggaran, kategori, poin, deskripsi, sanksi_default) VALUES
('R001', 'Terlambat 1-15 menit', 'ringan', 5, 'Datang terlambat 1-15 menit dari jam masuk sekolah', 'Teguran lisan dan berdiri di depan kelas 10 menit'),
('R002', 'Terlambat 16-30 menit', 'ringan', 10, 'Datang terlambat 16-30 menit dari jam masuk sekolah', 'Teguran tertulis dan berdiri di depan kelas 15 menit'),
('R003', 'Tidak mengerjakan tugas', 'ringan', 8, 'Tidak mengerjakan tugas yang diberikan guru', 'Mengerjakan tugas tambahan dan teguran tertulis'),
('R004', 'Seragam tidak lengkap', 'ringan', 7, 'Tidak memakai atribut sekolah lengkap', 'Teguran dan melengkapi seragam'),
('R005', 'Rambut tidak rapi', 'ringan', 6, 'Rambut tidak sesuai dengan peraturan sekolah', 'Potong rambut dan teguran'),
('S001', 'Terlambat >30 menit', 'sedang', 15, 'Datang terlambat lebih dari 30 menit', 'Tidak boleh masuk kelas dan panggil orang tua'),
('S002', 'Alpha tanpa keterangan', 'sedang', 12, 'Tidak masuk sekolah tanpa keterangan yang jelas', 'Teguran tertulis dan panggil orang tua'),
('S003', 'Tidak berseragam', 'sedang', 15, 'Tidak memakai seragam sekolah', 'Pulang dan ganti seragam'),
('S004', 'HP bunyi saat pelajaran', 'sedang', 10, 'Handphone berbunyi saat jam pelajaran', 'Sita HP 1 hari dan teguran tertulis'),
('S005', 'Keluar kelas tanpa izin', 'sedang', 12, 'Meninggalkan kelas saat jam pelajaran tanpa izin', 'Teguran tertulis dan berdiri di depan kelas'),
('B001', 'Menyontek saat ujian', 'berat', 25, 'Melakukan kecurangan saat ujian atau ulangan', 'Nilai ujian 0 dan skorsing 1 hari'),
('B002', 'Berkelahi', 'berat', 30, 'Terlibat perkelahian dengan siswa lain', 'Skorsing 3 hari dan panggil orang tua'),
('B003', 'Merusak fasilitas sekolah', 'berat', 25, 'Merusak atau menghilangkan fasilitas milik sekolah', 'Ganti rugi dan skorsing 2 hari'),
('B004', 'Bullying', 'berat', 35, 'Melakukan intimidasi atau kekerasan terhadap siswa lain', 'Skorsing 1 minggu dan konseling wajib'),
('B005', 'Merokok di area sekolah', 'berat', 30, 'Merokok di lingkungan sekolah', 'Skorsing 3 hari dan panggil orang tua'),
('SB001', 'Membawa senjata tajam', 'sangat_berat', 50, 'Membawa benda tajam atau senjata ke sekolah', 'Skorsing 2 minggu dan lapor ke pihak berwajib'),
('SB002', 'Narkoba', 'sangat_berat', 100, 'Menggunakan atau mengedarkan narkoba', 'Dikeluarkan dari sekolah'),
('SB003', 'Asusila', 'sangat_berat', 75, 'Melakukan perbuatan asusila', 'Skorsing 1 bulan atau dikeluarkan'),
('SB004', 'Mencuri', 'sangat_berat', 60, 'Mengambil barang milik orang lain tanpa izin', 'Skorsing 2 minggu dan ganti rugi'),
('SB005', 'Memalsukan dokumen', 'sangat_berat', 50, 'Memalsukan tanda tangan atau dokumen sekolah', 'Skorsing 1 minggu dan panggil orang tua');

-- Insert Sample Siswa
INSERT INTO siswa (nis, nisn, nama_lengkap, jenis_kelamin, tempat_lahir, tanggal_lahir, alamat, no_hp, email, nama_ayah, nama_ibu, pekerjaan_ayah, pekerjaan_ibu, no_hp_ortu, kelas_id, tahun_masuk) VALUES
('2024001', '1234567890', 'Ahmad Rizki Pratama', 'L', 'Jakarta', '2007-05-15', 'Jl. Merdeka No. 10, Jakarta Selatan', '081234567890', 'ahmad.rizki@gmail.com', 'Budi Pratama', 'Siti Aminah', 'Pegawai Swasta', 'Ibu Rumah Tangga', '081234567891', 5, 2022),
('2024002', '1234567891', 'Siti Nurhaliza Putri', 'P', 'Jakarta', '2007-03-20', 'Jl. Sudirman No. 15, Jakarta Pusat', '081234567892', 'siti.nurhaliza@gmail.com', 'Ahmad Yusuf', 'Fatimah', 'PNS', 'Guru', '081234567893', 11, 2022),
('2024003', '1234567892', 'Budi Santoso', 'L', 'Bogor', '2008-01-10', 'Jl. Diponegoro No. 20, Jakarta Timur', '081234567894', 'budi.santoso@gmail.com', 'Santoso', 'Dewi Lestari', 'Wiraswasta', 'Pedagang', '081234567895', 14, 2023),
('2024004', '1234567893', 'Dewi Sartika', 'P', 'Depok', '2008-07-25', 'Jl. Gatot Subroto No. 25, Jakarta Barat', '081234567896', 'dewi.sartika@gmail.com', 'Sartika Wijaya', 'Indah Permata', 'Dokter', 'Perawat', '081234567897', 1, 2024),
('2024005', '1234567894', 'Andi Wijaya', 'L', 'Jakarta', '2008-09-12', 'Jl. Thamrin No. 30, Jakarta Pusat', '081234567898', 'andi.wijaya@gmail.com', 'Wijaya Kusuma', 'Maya Sari', 'Insinyur', 'Akuntan', '081234567899', 7, 2024),
('2024006', '1234567895', 'Maya Sari', 'P', 'Tangerang', '2008-11-05', 'Jl. Kuningan No. 35, Jakarta Selatan', '081234567800', 'maya.sari@gmail.com', 'Sari Budi', 'Lina Marlina', 'Manager', 'Designer', '081234567801', 13, 2024);

-- Insert Sample Pelanggaran
INSERT INTO pelanggaran (siswa_id, jenis_pelanggaran_id, tanggal_pelanggaran, waktu_pelanggaran, tempat_kejadian, kronologi, sanksi, poin, pelapor, user_id) VALUES
(1, 1, '2024-12-01', '07:20:00', 'Gerbang Sekolah', 'Siswa datang terlambat 15 menit karena macet', 'Teguran lisan dan berdiri di depan kelas 10 menit', 5, 'Satpam Sekolah', 1),
(3, 4, '2024-12-05', '07:00:00', 'Ruang Kelas XI MM 1', 'Siswa tidak memakai dasi dan badge sekolah', 'Teguran dan melengkapi seragam', 7, 'Wali Kelas', 3),
(2, 3, '2024-12-10', '10:00:00', 'Ruang Kelas XII RPL 1', 'Tidak mengerjakan tugas Matematika', 'Mengerjakan tugas tambahan dan teguran tertulis', 8, 'Guru Matematika', 2),
(1, 2, '2024-12-15', '07:25:00', 'Gerbang Sekolah', 'Siswa datang terlambat 25 menit karena bangun kesiangan', 'Teguran tertulis dan berdiri di depan kelas 15 menit', 10, 'Guru Piket', 1),
(4, 9, '2024-12-18', '09:30:00', 'Ruang Kelas X TKJ 1', 'HP berbunyi saat pelajaran Bahasa Indonesia', 'Sita HP 1 hari dan teguran tertulis', 10, 'Guru Bahasa Indonesia', 3);

-- Insert Sample Prestasi
INSERT INTO prestasi (siswa_id, jenis_prestasi, tingkat, juara, tanggal_prestasi, penyelenggara, deskripsi, poin_positif) VALUES
(2, 'Lomba Programming', 'provinsi', 'Juara 2', '2024-10-15', 'Dinas Pendidikan DKI Jakarta', 'Lomba membuat aplikasi web', 20),
(1, 'Lomba Jaringan Komputer', 'kota', 'Juara 1', '2024-11-20', 'SMKN 1 Jakarta', 'Kompetisi konfigurasi jaringan', 15),
(5, 'Olimpiade Matematika', 'sekolah', 'Juara 3', '2024-09-10', 'SMK Bakti Nusantara 666', 'Olimpiade Matematika tingkat sekolah', 5);

-- Insert Sample Panggilan Orang Tua
INSERT INTO panggilan_ortu (siswa_id, pelanggaran_id, tanggal_panggilan, waktu_panggilan, yang_hadir, hasil_konsultasi, tindak_lanjut, status, user_id) VALUES
(1, 4, '2024-12-20', '10:00:00', 'Ibu Siti Aminah', 'Orang tua berkomitmen untuk membangunkan anak lebih pagi', 'Monitoring kedisiplinan selama 1 bulan', 'hadir', 2),
(4, 5, '2024-12-22', '14:00:00', 'Ayah Sartika Wijaya', 'Diskusi tentang penggunaan HP yang bijak', 'Anak tidak boleh bawa HP ke sekolah selama 1 minggu', 'hadir', 2);