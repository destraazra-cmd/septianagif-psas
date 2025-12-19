<?php
// Konfigurasi Database
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'smk_pelanggaran';

// Membuat koneksi
$conn = new mysqli($host, $username, $password, $database);

// Cek koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}

// Set charset
$conn->set_charset("utf8");

// Fungsi untuk membersihkan input
function clean_input($data) {
    global $conn;
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $conn->real_escape_string($data);
}

// Fungsi untuk format tanggal Indonesia
function format_tanggal($tanggal) {
    $bulan = array(
        1 => 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    );
    
    $split = explode('-', $tanggal);
    return $split[2] . ' ' . $bulan[(int)$split[1]] . ' ' . $split[0];
}

// Fungsi untuk mendapatkan kategori berdasarkan total poin
function get_kategori_siswa($total_poin) {
    if ($total_poin <= 10) {
        return array('kategori' => 'Baik', 'class' => 'success');
    } elseif ($total_poin <= 25) {
        return array('kategori' => 'Cukup', 'class' => 'warning');
    } elseif ($total_poin <= 50) {
        return array('kategori' => 'Kurang', 'class' => 'danger');
    } else {
        return array('kategori' => 'Sangat Kurang', 'class' => 'dark');
    }
}
?>