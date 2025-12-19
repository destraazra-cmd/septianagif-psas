<?php
// Drop Database SMK Pelanggaran
$host = 'localhost';
$username = 'root';
$password = '';

try {
    $conn = new mysqli($host, $username, $password);
    
    if ($conn->connect_error) {
        die("Koneksi gagal: " . $conn->connect_error);
    }
    
    // Drop database
    if ($conn->query("DROP DATABASE IF EXISTS smk_pelanggaran")) {
        echo "✅ Database 'smk_pelanggaran' berhasil dihapus!";
    } else {
        echo "❌ Error: " . $conn->error;
    }
    
    $conn->close();
    
} catch (Exception $e) {
    echo "❌ " . $e->getMessage();
}
?>