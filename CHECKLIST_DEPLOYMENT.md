# 📋 CHECKLIST DEPLOYMENT COMPLETE - ENTERTAINMENT AI ASSISTANT V1

Dokumen ini adalah **panduan langkah demi langkah dengan checklist markdown** yang bisa Anda tandai (`- [x]`) saat mengerjakan deployment bot di VPS.

---

## 🐙 TAHAP SPECIAL: SETUP GIT WORKFLOW (LOCAL ↔️ GITHUB ↔️ VPS)

Gunakan metode ini agar setiap ada perubahan kodingan/workflow di laptop, Anda **cukup `git push` di laptop dan `git pull` di VPS** tanpa perlu upload manual via SFTP/FileZilla.

- [ ] **0.1. Buat Repository Baru di GitHub / GitLab**
  - Buka [GitHub.com](https://github.com) -> Klik **New Repository**.
  - Beri nama repository: `entertainment-ai-bot` (set ke **Private** agar aman).
  - Klik **Create repository**.
  - Salin URL Repository Anda (contoh: `https://github.com/username Anda/entertainment-ai-bot.git` atau SSH URL).

- [ ] **0.2. Inisialisasi Git di Laptop Anda**
  - Buka terminal / PowerShell di laptop Anda di folder `c:\Users\Danis\Downloads\project`.
  - Jalankan perintah berikut berturut-turut:
    ```bash
    git init
    git branch -M main
    git add .
    git commit -m "feat: initial commit entertainment ai assistant v1"
    git remote add origin https://github.com/USERNAME_ANDA/entertainment-ai-bot.git
    git push -u origin main
    ```

- [ ] **0.3. Clone Repository Pertama Kali di VPS**
  - Connect ke VPS via SSH (`ssh root@IP_VPS_ANDA`).
  - Masuk ke folder `/opt` di VPS:
    ```bash
    cd /opt
    ```
  - Clone repository dari GitHub ke VPS:
    ```bash
    git clone https://github.com/USERNAME_ANDA/entertainment-ai-bot.git entertainment-ai
    cd /opt/entertainment-ai
    ```
  - Buat script `deploy.sh` dapat dieksekusi:
    ```bash
    chmod +x deploy.sh
    ```

---

## 🔄 CARA UPDATE KODINGAN DI MASA DEPAN (DAY-TO-DAY WORKFLOW)

Setiap kali Anda membuat perubahan kodingan, schema DB, atau file workflow di laptop:

### 1️⃣ Di Laptop Anda:
```bash
git add .
git commit -m "update: perbaikan prompt AI dan keyboard menu"
git push origin main
```

### 2️⃣ Di VPS Anda (Cukup 1 Perintah!):
```bash
cd /opt/entertainment-ai
./deploy.sh
```
*(Script `./deploy.sh` akan otomatis melakukan `git pull`, dan me-restart container Docker tanpa perlu mengetik banyak perintah)*.

---

## 📌 TAHAP 1: PERSIAPAN DOMAIN & VPS

- [ ] **1.1. Pointing DNS Domain**
  - Buka dashboard DNS domain Anda (Cloudflare / Rumahweb / Niagahoster / Namecheap).
  - Tambahkan **A Record**:
    - **Host / Subdomain**: `n8n` (misal domain Anda `elgroup.com`, jadinya `n8n.elgroup.com`).
    - **Value / Target IP**: Masukkan **IP Public VPS** Anda (contoh: `103.150.x.x`).
    - **TTL**: Auto / 300.
    - *Note (Cloudflare)*: Matikan proxy awan oranye (set ke **DNS Only / Gray Cloud**) terlebih dahulu agar SSL Let's Encrypt berjalan lancar.

- [ ] **1.2. Login ke VPS via SSH**
  - Buka terminal / Command Prompt / PuTTY / MobaXterm di laptop.
  - Jalankan perintah:
    ```bash
    ssh root@IP_VPS_ANDA
    ```
  - Masukkan password SSH VPS Anda.

- [ ] **1.3. Install Docker & Docker Compose di VPS**
  - Jalankan perintah berikut di terminal VPS:
    ```bash
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    ```
  - Cek apakah Docker sudah terinstall:
    ```bash
    docker --version
    docker compose version
    ```

---

## 📌 TAHAP 2: SETUP FOLDER PROYEK DI VPS

- [ ] **2.1. Masuk ke Folder Proyek di VPS**
  - Karena proyek sudah di-clone di Tahap 0.3, masuk ke folder:
    ```bash
    cd /opt/entertainment-ai
    ```

---

## 📌 TAHAP 3: KONFIGURASI FILE ENVIRONMENT & NGINX

- [ ] **3.1. Konfigurasi File `.env` (Hanya Sekali di VPS)**
  - Masuk ke folder proyek di VPS:
    ```bash
    cd /opt/entertainment-ai
    ```
  - Salin `.env.example` menjadi `.env`:
    ```bash
    cp .env.example .env
    nano .env
    ```
  - Ubah isian di dalam `.env`:
    - `N8N_HOST=n8n.domainanda.com` (ganti dengan domain aktual Anda).
    - `POSTGRES_USER=elgroup_user`
    - `POSTGRES_PASSWORD=PasswordDBYangSangatAman123!`
    - `TELEGRAM_BOT_TOKEN=8791438411:AAFKzCvX3g4xh3IW6V5jqzoc7SxDOqR_Pns`
    - `OPENAI_API_KEY=sk-proj-xxxx...` (masukkan OpenAI API Key Anda).
    - `ADMIN_TELEGRAM_ID=5437246207`
  - Simpan file: Tekan `Ctrl + O`, lalu `Enter`. Keluar: Tekan `Ctrl + X`.

- [ ] **3.2. Konfigurasi Nginx (`nginx/conf.d/n8n.conf`)**
  - Edit file Nginx:
    ```bash
    nano nginx/conf.d/n8n.conf
    ```
  - Ganti tulisan `n8n.yourdomain.com` di dua tempat (baris `server_name`) menjadi nama domain Anda (misal `n8n.elgroup.com`).
  - Simpan: `Ctrl + O`, `Enter`. Keluar: `Ctrl + X`.

---

## 📌 TAHAP 4: GENERATE SERTIFIKAT SSL (HTTPS)

- [ ] **4.1. Install Certbot di VPS**
  - Jalankan perintah di VPS:
    ```bash
    apt update && apt install -y certbot
    ```

- [ ] **4.2. Generate Sertifikat SSL Gratis**
  - Jalankan Perintah:
    ```bash
    certbot certonly --standalone -d n8n.domainanda.com
    ```
  - Masukkan alamat email Anda saat diminta.
  - Ketik `Y` untuk menyetujui Terms of Service.
  - Jika berhasil, SSL akan disimpan di `/etc/letsencrypt/live/n8n.domainanda.com/`.

---

## 📌 TAHAP 5: MENJALANKAN SERVICE DOCKER

- [ ] **5.1. Start Container Docker**
  - Di dalam folder `/opt/entertainment-ai`, jalankan:
    ```bash
    docker compose up -d
    ```

- [ ] **5.2. Verifikasi Container Running**
  - Periksa status container:
    ```bash
    docker compose ps
    ```
  - Pastikan ketiga service berikut menunjukkan status `Up` / `Running`:
    - `entertainment_db`
    - `entertainment_n8n`
    - `entertainment_nginx`

---

## 📌 TAHAP 6: PENDAFTARAN & CONFIGURASI N8N (DETAIL)

- [ ] **6.1. Buka n8n di Browser**
  - Akses URL: `https://n8n.domainanda.com` di browser Anda (Chrome/Firefox/Edge).

- [ ] **6.2. Registrasi Akun Owner/Admin n8n Pertama Kali**
  - Karena ini instalasi baru dari nol, n8n akan menampilkan halaman **"Set up owner account"**.
  - Isi form pendaftaran:
    - **Email**: Masukkan email aktif Anda.
    - **First Name**: (Contoh: Admin).
    - **Last Name**: (Contoh: EL Group).
    - **Password**: Buat password yang kuat untuk login ke n8n.
  - Klik tombol **Next / Finish setup**.
  - Anda akan langsung masuk ke Dashboard n8n!

- [ ] **6.3. Import 5 File Workflow n8n**
  - Di sidebar kiri n8n, klik menu **Workflows**.
  - Di pojok kanan atas, klik tombol **Import from File** (atau ikon `...` -> **Import from File**).
  - Pilih dan import 5 file JSON dari folder `workflows/` satu per satu:
    1. `workflows/1_telegram_router.json` (Nama: *1. Telegram Menu & Keyboard Router*)
    2. `workflows/2_admin_barcode_handler.json` (Nama: *2. Barcode & Admin Management*)
    3. `workflows/3_ai_chat_knowledge.json` (Nama: *3. AI Chat & Knowledge Engine*)
    4. `workflows/4_group_mention_handler.json` (Nama: *4. Telegram Group Mention Handler*)
    5. `workflows/5_booking_lead_notifier.json` (Nama: *5. Booking & Lead Admin Handover Notifier*)

- [ ] **6.4. Menambahkan Credentials di n8n**
  - Di sidebar kiri n8n, klik menu **Credentials** -> Klik **Add Credential**.
  
  - **A. Credential PostgreSQL**:
    - Cari dan pilih **PostgreSQL**.
    - **Host**: `postgres` (isi persis kata `postgres`, bukan localhost).
    - **Database**: `elgroup_db` (atau sesuai `.env`).
    - **User**: `elgroup_user` (atau sesuai `.env`).
    - **Password**: Password DB yang dibuat di `.env`.
    - **Port**: `5432`.
    - Klik **Save**.
  
  - **B. Credential OpenAI**:
    - Cari dan pilih **OpenAI API**.
    - **API Key**: Tempelkan Secret API Key dari OpenAI (`sk-proj-...`).
    - Klik **Save**.
  
  - **C. Credential Telegram Bot**:
    - Cari dan pilih **Telegram API**.
    - **Access Token**: Tempelkan Token Bot dari BotFather (`8791438411:AAFKzCv...`).
    - Klik **Save**.

- [ ] **6.5. Hubungkan Credentials ke Node & Aktifkan Workflow**
  - Buka masing-masing workflow yang sudah di-import.
  - Pastikan node yang membutuhkan credential (Postgres / OpenAI / Telegram) memilih nama Credential yang baru dibuat.
  - Di pojok kanan atas tiap workflow, geser tombol **Active** dari **OFF** menjadi **ON** (berwarna hijau).

---

## 📌 TAHAP 7: CONNECT TELEGRAM WEBHOOK

- [ ] **7.1. Daftarkan Webhook ke Telegram API**
  - Buka tab baru di browser Anda, lalu ketik URL berikut (ganti `n8n.domainanda.com` dengan domain Anda):
    ```text
    https://api.telegram.org/bot8791438411:AAFKzCvX3g4xh3IW6V5jqzoc7SxDOqR_Pns/setWebhook?url=https://n8n.domainanda.com/webhook/telegram-webhook
    ```

- [ ] **7.2. Pastikan Respon Webhook Berhasil**
  - Di layar browser Anda harus muncul respon teks seperti berikut:
    ```json
    {
      "ok": true,
      "result": true,
      "description": "Webhook was set"
    }
    ```

---

## 📌 TAHAP 8: E2E TESTING BOT TELEGRAM

- [ ] **8.1. Test Command `/start` & Reply Keyboard**
  - Buka Telegram, cari bot Anda dan kirim `/start`.
  - **Ekspektasi**: Bot membalas dengan teks ucapan selamat datang dan tombol Reply Keyboard (`MD Kontak`, `Rules`, `Apply Member`, `Jam Ops`, `Barcode Masuk`, dll).

- [ ] **8.2. Test Tombol `🎫 Barcode Masuk`**
  - Tekan tombol `🎫 Barcode Masuk` -> Pilih salah satu outlet (misal *El Centro*).
  - **Ekspektasi**: Bot menampilkan status barcode (valid/belum diupdate hari ini).

- [ ] **8.3. Test AI Chat & Knowledge Engine**
  - Ketik pesan teks biasa: *"Jam buka El Norte jam berapa ya?"*
  - **Ekspektasi**: AI membalas jam operasional El Norte secara akurat (*12.00 - 24.00 WIB*).

- [ ] **8.4. Test Booking Lead & Handover Admin**
  - Ketik pesan: *"Saya mau booking tempat untuk besok jam 7 malam di El Seven"*
  - **Ekspektasi**: AI menjawab pertanyaan, lalu secara otomatis mengirimkan notifikasi pesan **NEW BOOKING LEAD** langsung ke akun Telegram Admin (`5437246207`).

- [ ] **8.5. Test Admin Command `/updatebarcode`**
  - Kirim `/updatebarcode` dari akun Telegram Admin (`5437246207`).
  - **Ekspektasi**: Bot menampilkan pilihan outlet. Pilih outlet -> Kirim foto barcode -> Bot membalas *"BERHASIL DIUPDATE!"*.

---

🎉 **SELAMAT! Sistem Entertainment AI Assistant V1 Anda telah 100% Berjalan dan Siap Digunakan.**
