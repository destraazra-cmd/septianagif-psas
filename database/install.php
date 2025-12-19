<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Install Database - SMK Bakti Nusantara 666</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            margin: 0;
            padding: 20px;
            min-height: 100vh;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        h1 {
            color: #2c3e50;
            text-align: center;
            margin-bottom: 30px;
        }
        .status {
            padding: 15px;
            border-radius: 8px;
            margin: 10px 0;
        }
        .success {
            background: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
        }
        .error {
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
        }
        .info {
            background: #d1ecf1;
            border: 1px solid #bee5eb;
            color: #0c5460;
        }
        .btn {
            background: #3498db;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
            display: inline-block;
            margin: 10px 5px;
        }
        .btn:hover {
            background: #2980b9;
        }
        .btn-success {
            background: #27ae60;
        }
        .btn-success:hover {
            background: #229954;
        }
        pre {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            overflow-x: auto;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🏫 Install Database SMK Bakti Nusantara 666</h1>
        
        <?php
        if (isset($_POST['install'])) {
            // Konfigurasi database
            $host = 'localhost';
            $username = 'root';
            $password = '';
            
            try {
                // Koneksi ke MySQL (tanpa database)
                $conn = new mysqli($host, $username, $password);
                
                if ($conn->connect_error) {
                    throw new Exception("Koneksi gagal: " . $conn->connect_error);
                }
                
                echo '<div class="status success">✅ Koneksi ke MySQL berhasil!</div>';
                
                // Baca file SQL
                $sql_file = 'smk_pelanggaran.sql';
                if (!file_exists($sql_file)) {
                    throw new Exception("File SQL tidak ditemukan: " . $sql_file);
                }
                
                $sql_content = file_get_contents($sql_file);
                
                // Pisahkan query berdasarkan semicolon
                $queries = explode(';', $sql_content);
                
                $success_count = 0;
                $error_count = 0;
                
                foreach ($queries as $query) {
                    $query = trim($query);
                    if (!empty($query) && !preg_match('/^--/', $query)) {
                        if ($conn->query($query)) {
                            $success_count++;
                        } else {
                            $error_count++;
                            echo '<div class="status error">❌ Error: ' . $conn->error . '</div>';
                            echo '<pre>' . htmlspecialchars($query) . '</pre>';
                        }
                    }
                }
                
                echo '<div class="status success">✅ Database berhasil dibuat!</div>';
                echo '<div class="status info">📊 ' . $success_count . ' query berhasil dieksekusi</div>';
                
                if ($error_count > 0) {
                    echo '<div class="status error">⚠️ ' . $error_count . ' query gagal dieksekusi</div>';
                }
                
                // Test koneksi ke database yang baru dibuat
                $conn->select_db('smk_pelanggaran');
                $result = $conn->query("SHOW TABLES");
                
                echo '<div class="status success">📋 Tabel yang berhasil dibuat:</div>';
                echo '<ul>';
                while ($row = $result->fetch_array()) {
                    echo '<li>' . $row[0] . '</li>';
                }
                echo '</ul>';
                
                // Cek data sample
                $result = $conn->query("SELECT COUNT(*) as total FROM siswa");
                $row = $result->fetch_assoc();
                echo '<div class="status info">👥 Total siswa sample: ' . $row['total'] . '</div>';
                
                $result = $conn->query("SELECT COUNT(*) as total FROM pelanggaran");
                $row = $result->fetch_assoc();
                echo '<div class="status info">⚠️ Total pelanggaran sample: ' . $row['total'] . '</div>';
                
                $result = $conn->query("SELECT COUNT(*) as total FROM users");
                $row = $result->fetch_assoc();
                echo '<div class="status info">👤 Total users: ' . $row['total'] . '</div>';
                
                echo '<div style="text-align: center; margin-top: 30px;">';
                echo '<a href="../index.html" class="btn btn-success">🚀 Mulai Menggunakan Aplikasi</a>';
                echo '</div>';
                
                $conn->close();
                
            } catch (Exception $e) {
                echo '<div class="status error">❌ ' . $e->getMessage() . '</div>';
            }
        } else {
        ?>
        
        <div class="status info">
            <h3>📋 Informasi Instalasi</h3>
            <p>Proses ini akan:</p>
            <ul>
                <li>Membuat database <strong>smk_pelanggaran</strong></li>
                <li>Membuat tabel-tabel yang diperlukan</li>
                <li>Mengisi data sample untuk testing</li>
            </ul>
            
            <h4>🔐 Login Default:</h4>
            <ul>
                <li><strong>Admin:</strong> username = admin, password = admin123</li>
                <li><strong>Guru BK:</strong> username = guru_bk, password = bk123</li>
                <li><strong>Wali Kelas:</strong> username = wali_kelas, password = wali123</li>
            </ul>
        </div>
        
        <div class="status error">
            <h3>⚠️ Peringatan</h3>
            <p>Pastikan:</p>
            <ul>
                <li>XAMPP sudah berjalan (Apache & MySQL)</li>
                <li>Tidak ada database dengan nama <strong>smk_pelanggaran</strong> sebelumnya</li>
                <li>Jika sudah ada, database lama akan ditimpa!</li>
            </ul>
        </div>
        
        <form method="post" style="text-align: center; margin-top: 30px;">
            <button type="submit" name="install" class="btn" onclick="return confirm('Yakin ingin menginstall database? Data lama akan hilang!')">
                🔧 Install Database
            </button>
        </form>
        
        <?php } ?>
        
        <div style="text-align: center; margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;">
            <small>SMK Bakti Nusantara 666 - Sistem Pelanggaran Siswa v2.1.0</small>
        </div>
    </div>
</body>
</html>