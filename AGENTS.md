# 🤖 MEMORY & PROJECT RULES - EL GROUP TELEGRAM & WHATSAPP BOT

Dokumen ini berisi konfigurasi tetap, aturan sistem, arsitektur, dan SOP yang selalu diingat untuk proyek **EL Group Entertainment AI Assistant (Omnichannel: Telegram + WhatsApp)**.

---

## 🔑 1. IDENTITAS, NOMOR RESMI & ADMIN
- **Telegram Bot Token**: `8791438411:AAFKzCvX3g4xh3IW6V5jqzoc7SxDOqR_Pns`
- **Username Bot**: `@Elgroupspa_bot`
- **Admin Resmi (Madam Tika)**: `5437246207` (HANYA ID INI yang memiliki akses Admin / Takeover).
- **Nomor WhatsApp Resmi Bot**: `6287883488882` (Madam Tika / Aunty Dwi).
- **Akun User / Tester (Danis)**: `5660757898` (Diperlakukan sebagai Customer / Regular User, BUKAN Admin).
- **Grup Telegram Resmi**: `@spakaraokejakarta` (Sesi Forum Topic ID: `1` untuk diskusi).

---

## 📱 2. INTEGRASI WHATSAPP (EVOLUTION API v2)
- **Service Name**: `evolution-api` (Container: `entertainment_wa`)
- **Docker Image**: `evoapicloud/evolution-api:latest`
- **API Key**: `elgroup_wa_secret_2026`
- **Instance Name**: `elgroup_bot`
- **Database Schema**: Terisolasi pada PostgreSQL URI `?schema=evolution_api`
- **Cache Config**: `CACHE_REDIS_ENABLED=false` & `CACHE_LOCAL_ENABLED=true` (tanpa Redis server luar).
- **Webhook URL**: `https://n8n.madamtikael.id/webhook/whatsapp-incoming` dengan event `MESSAGES_UPSERT`.
- **Kirim Teks WA**: `POST http://evolution-api:8080/message/sendText/elgroup_bot`
- **Kirim Gambar WA**: `POST http://evolution-api:8080/message/sendMedia/elgroup_bot`

---

## ⚡ 3. SMART AUTO-TAKEOVER (TELEGRAM & WHATSAPP)
1. **Khusus DM Pribadi (1-on-1 Business Chat, Private Telegram & WhatsApp)**.
2. **Auto-Pause (5 Menit)**:
   - **Telegram Business**: Ketika Admin (`5437246207`) membalas pesan tamu (`fromId !== chatId`), bot otomatis **DIAM (PAUSED)** selama **5 menit**.
   - **WhatsApp**: Ketika Madam Tika membalas chat tamu langsung dari aplikasi WhatsApp HP (`fromMe = true`), bot otomatis **DIAM (PAUSED)** selama **5 menit**.
   - Setiap kali Admin membalas lagi, timer 5 menit di-reset dari awal.
3. **Auto-Resume (24/7)**:
   - Jika setelah 5 menit Admin tidak membalas lagi dan tamu mengirim chat baru, bot otomatis **mengambil alih** dan membalas tamu.
4. **Perintah Cepat Admin Telegram**:
   - `/pause`: Mengunci bot diam 2 jam.
   - `/resume` (atau `/unpause`): Membuka kunci bot agar aktif kembali seketika.

---

## 🎫 4. SISTEM BARCODE MASUK RESMI (TELEGRAM & WHATSAPP)
1. **Admin Update Barcode**:
   - Admin upload foto barcode harian via perintah `/updatebarcode` di Telegram (`bot_barcodes`).
   - Jadwal reset otomatis setiap hari jam **02:00 WIB** (`Schedule Reset Barcode 02:00 WIB`).
2. **Tamu Minta Barcode di WhatsApp / Telegram**:
   - Keyword: *"minta barcode"*, *"minta akses"*, *"barcode el centro"*, *"akses fenix"*, dll.
   - Jika sebut cabang: Bot langsung mengirimkan **Foto QR Code Barcode Masuk Resmi** + Lokasi + Nomor Lantai + SOP *"Sebutkan atas nama Madam Tika"*.
   - Jika belum sebut cabang: Bot membalas dengan daftar pilihan nama outlet lengkap.

---

## 💬 5. ALUR PERCAKAPAN RESERVASI & PERTANYAAN KHUSUS
1. **Pertanyaan Aneh / Di Luar SOP / Di Luar Knowledge**:
   - Bot membalas ramah: *"Mohon bersabar ya kak, pertanyaan Kakak sudah kami teruskan dan akan segera dijawab langsung oleh Madam Tika 🙏✨"*
   - AI menyertakan tag `[ESCALATE_QUESTION: <ringkasan>]`.
   - Node `Send AI Reply Smart` mengirim notifikasi alert lengkap ke Telegram Madam Tika (`5437246207`) dengan link langsung chat tamu (WA / Telegram).
2. **Alur Reservasi Interaktif**:
   - **Tahap 1 (Tanya detail)**: Bot menanyakan outlet tujuan (*Centro, Pangjay, Seven, Norte, Fenix, KG, Orca, Casa, Memento*) dan rencana jam kedatangan.
   - **Tahap 2 (Konfirmasi)**: Setelah tamu menyebutkan cabang & jam, bot mengonfirmasi data dicatat dan diteruskan ke Madam Tika (`[BOOKING_LEAD: ...]`), lalu mengirim notifikasi rincian booking lengkap ke Admin Telegram.

---

## 💆‍♀️ 6. SOP ROOM SERVICE (BY MADAM TIKA)
Setiap kali tamu meminta atau menanyakan **Rules / SOP / SOP Room Service** (baik lewat tombol menu `📋 RULES`, perintah `/rules`, atau chat biasa):
- **Wajib Ingatkan**:
  `⚠️ WAJIB IKUTI SOP ⚠️`
  `Demi kenyamanan bersama 👍🏻`
- **8 Rangkaian Layanan SOP Room Service**:
  1. 👣 **Baby shower**
  2. 🪷 **Massage relaxsasi sensual**
  3. 🤍 **Body message (BM)**
  4. 🐾 **Mandi kucing (MK)**
  5. 🥭 **Petik mangga (PM)**
  6. 🤲✨ **Hand job (HJ)**
  7. 💨 **Blow job (BJ)**
  8. 💕 **Fuck job (FJ)**
- **Foto Pendukung Rules**:
  - `http://tikael.madamtikael.id/rules_sop.jpeg` (Attention Guys / Barcode SOP)
  - `http://tikael.madamtikael.id/rules_layanan.jpeg` (3 Pilihan Layanan: LC, Ladies Drink, Therapist)

---

## 🛠️ 7. WORKFLOW GENERATION & CODING RULES
- **Generator Script**: `scratch/build_clean_workflow.js`
- **Output Target**: `workflows/master_bot_workflow.json`
- **Aturan Pemanggilan Node di n8n**:
  - Selalu gunakan `.first().json` (contoh: `$('Is AI Needed').first().json`) dan **HINDARI** `.item.json` untuk mencegah error *Paired item data unavailable* di n8n.
- **Trigger Omnichannel**:
  - `Telegram Webhook` -> `Has Text or Callback` -> `Parse & Send Direct Reply` -> Routing
  - `WhatsApp Webhook` -> `Parse WhatsApp Message` -> Routing (`Is Update Session`, `Is Barcode Request`, `Is AI Needed`)

