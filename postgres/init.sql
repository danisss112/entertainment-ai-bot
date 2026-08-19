-- =============================================================================
-- ENTERTAINMENT AI ASSISTANT - DATABASE SCHEMA & INITIAL SEED DATA
-- EL GROUP SPA & KARAOKE ASSISTANT
-- =============================================================================

-- Enable extension if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USERS TABLE
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    first_name VARCHAR(255),
    username VARCHAR(255),
    phone VARCHAR(50),
    platform VARCHAR(50) DEFAULT 'telegram',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. ADMINS TABLE
CREATE TABLE IF NOT EXISTS admins (
    id SERIAL PRIMARY KEY,
    telegram_id BIGINT UNIQUE NOT NULL,
    name VARCHAR(255),
    role VARCHAR(50) DEFAULT 'admin',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 3. OUTLETS TABLE
CREATE TABLE IF NOT EXISTS outlets (
    id SERIAL PRIMARY KEY,
    outlet_key VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    location_url TEXT,
    operational_hours VARCHAR(255),
    pricelist_photo_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. BARCODES TABLE (With 02:00 WIB daily expiration logic)
CREATE TABLE IF NOT EXISTS barcodes (
    id SERIAL PRIMARY KEY,
    outlet_key VARCHAR(50) UNIQUE NOT NULL REFERENCES outlets(outlet_key) ON DELETE CASCADE,
    file_id TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT REFERENCES admins(telegram_id)
);

-- 4b. BOT_BARCODES TABLE (Used by n8n workflow - standalone, no FK constraint)
CREATE TABLE IF NOT EXISTS bot_barcodes (
    outlet_key VARCHAR(50) PRIMARY KEY,
    file_id TEXT NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_by BIGINT
);

-- 4c. BOT_ADMIN_STATE TABLE (Tracks which outlet Admin selected before sending photo)
CREATE TABLE IF NOT EXISTS bot_admin_state (
    admin_id BIGINT PRIMARY KEY,
    outlet_key VARCHAR(50) NOT NULL,
    selected_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. TALENTS TABLE
CREATE TABLE IF NOT EXISTS talents (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100), -- Platinum, Gold, Celeb, Import, Panlok, Lokal
    availability VARCHAR(50) DEFAULT 'Available',
    rate VARCHAR(100),
    bio TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. EVENTS TABLE
CREATE TABLE IF NOT EXISTS events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    event_date TIMESTAMP WITH TIME ZONE,
    location VARCHAR(255),
    description TEXT,
    status VARCHAR(50) DEFAULT 'Upcoming',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. BOOKINGS & LEADS TABLE
CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    telegram_id BIGINT NOT NULL,
    customer_name VARCHAR(255),
    outlet_key VARCHAR(50),
    service_type VARCHAR(100),
    event_date VARCHAR(100),
    budget VARCHAR(100),
    notes TEXT,
    status VARCHAR(50) DEFAULT 'NEW', -- NEW, NEED_ADMIN, QUALIFIED, BOOKED, CANCELLED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. CHAT HISTORY TABLE
CREATE TABLE IF NOT EXISTS chat_history (
    id SERIAL PRIMARY KEY,
    telegram_id BIGINT NOT NULL,
    role VARCHAR(20) NOT NULL, -- 'user', 'assistant', 'system'
    content TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 9. KNOWLEDGE BASE TABLE (For AI Context & RAG)
CREATE TABLE IF NOT EXISTS knowledge (
    id SERIAL PRIMARY KEY,
    category VARCHAR(100),
    question_pattern VARCHAR(255),
    answer_text TEXT NOT NULL,
    keywords VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- =============================================================================
-- SEED DATA INITIALIZATION
-- =============================================================================

-- Seed Admin (Madam Tika Admin ID)
INSERT INTO admins (telegram_id, name, role) 
VALUES (5437246207, 'Madam Tika Admin', 'super_admin')
ON CONFLICT (telegram_id) DO NOTHING;

-- Seed Outlets
INSERT INTO outlets (outlet_key, name, location_url, operational_hours, pricelist_photo_url) VALUES
('centro',     'El Centro',           'https://g.co/kgs/XsooJhR', '14.00 - 01.00 WIB | Last Order 00.30', 'https://tikael.kereaktif.id/el_centro.jpeg'),
('spaPangjay', 'El Spa Pangjay',      'https://g.co/kgs/XsooJhR', '12.00 - 23.00 WIB | Last Order 22.30', 'https://tikael.kereaktif.id/el_spa_pangjay_new.jpeg'),
('seven',      'El Seven Club',       'https://g.co/kgs/XsooJhR', '18.00 - 04.00 WIB | Last Order 03.30', 'https://tikael.kereaktif.id/el_seven_club.jpeg'),
('norte',      'El Norte',            'https://g.co/kgs/2x2ah1j', '12.00 - 24.00 WIB | Last Order 23.30', 'https://tikael.kereaktif.id/el_norte.jpeg'),
('fenix',      'El Fenix',            'https://g.co/kgs/boEFS4t', '14.00 - 24.00 WIB | Last Order 23.30', 'https://tikael.kereaktif.id/el_fenix.jpeg'),
('spaKG',      'El Spa KG',           'https://g.co/kgs/boEFS4t', '12.00 - 23.00 WIB | Last Order 22.30', 'https://tikael.kereaktif.id/el_spa_kelapa_gading.jpeg'),
('orca',       'El Orca',             'https://g.co/kgs/uftGAAa', '12.00 - 23.00 WIB | Last Order 22.30', 'https://tikael.kereaktif.id/el_orca_new.jpeg'),
('casa',       'El Casa',             'https://g.co/kgs/JbtEvHK', '13.00 - 24.00 WIB | Last Order 23.30', 'https://tikael.kereaktif.id/el_casa.jpeg'),
('memento',    'El Memento',          'https://share.google/NkCFC2E5gQHcVXI7Y', '12.00 - 01.00 WIB | Last Order 00.30', 'https://tikael.kereaktif.id/el_memento.jpeg')
ON CONFLICT (outlet_key) DO UPDATE SET 
    name = EXCLUDED.name,
    location_url = EXCLUDED.location_url,
    operational_hours = EXCLUDED.operational_hours,
    pricelist_photo_url = EXCLUDED.pricelist_photo_url;

-- Seed Knowledge Base (Master Version from bot IA revisi.xlsx)
INSERT INTO knowledge (category, question_pattern, answer_text, keywords) VALUES
('jamops', 'Jam Operasional / Jam Buka Outlet', 
'⏰ Jam Operasional EL Group:
📍 El Centro: 14.00 - 01.00 | Last Order 00.30
📍 El Spa Pangjay: 12.00 - 23.00 | Last Order 22.30
📍 El Seven Club: 18.00 - 04.00 | Last Order 03.30
📍 El Norte: 12.00 - 24.00 | Last Order 23.30
📍 El Fenix: 14.00 - 24.00 | Last Order 23.30
📍 El Spa Gading: 12.00 - 24.00 | Last Order 23.30
📍 El Orca: 12.00 - 23.00 | Last Order 22.30
📍 El Casa: 13.00 - 24.00 | Last Order 23.30
📍 El Memento: 13.00 - 01.00 | Last Order 00.30
Note: We Are Open Every Day 😚', 'jam, ops, buka, tutup, operasional'),

('donotdo', 'Peraturan dan Larangan (Do Not Do)', 
'⚠️ PERATURAN & KETENTUAN EL GROUP:
DILARANG:
1. Membawa/mengonsumsi narkoba & zat terlarang.
2. Membawa senjata tajam/senjata api.
3. Membawa makanan & minuman dari luar.
4. Merekam video/mengambil foto selama room service.
5. Memaksa terapis melakukan tindakan di luar SOP.
6. Merusak fasilitas atau membawa pulang inventaris kamar.

Sanksi pelanggaran: Pemutusan layanan tanpa refund, denda, dan BLACKLIST PERMANEN.', 'aturan, dilarang, larangan, rules, donotdo, narkoba, fasilitas'),

('applymember', 'Registrasi Member EL Group', 
'🪪 Registrasi Member EL Group:
Kirim format registrasi ke @MadamTika:
- Nama member: (Bebas)
- No HP: (Aktif untuk terima kode aktivasi via SMS/WhatsApp)

Keuntungan:
- Member bisa dipakai di semua outlet EL Group.
- Cashback dapat diajukan Top Up (berlaku max 3 hari dari tanggal kedatangan).
Link kartu digital: https://app.elgroupapp.com/', 'member, registrasi, daftar, cashback, kartu'),

('estafet', 'Paket Estafet', 
'🔥 New Package Additional - ESTAFET:
- Pilih 3 ladies platinum di lokasi langsung (tidak bisa book).
- Durasi total 90 menit (3x FJ).
- Ladies ke-1: 30 menit.
- Ladies ke-2: 30 menit.
- Ladies ke-3: 30 menit.', 'estafet, paket, ladies, platinum'),

('threesome', 'Paket Threesome', 
'💦 PAKET THREESOME (KAMAR):
1. Durasi 2 Jam: 2x FJ, Total 4 Voucher (1 Ladies 2 Voucher).
2. Durasi 1 Jam: 1x FJ, Total 2 Voucher (1 Ladies 1 Voucher).', 'threesome, 3some, voucher, kamar'),

('doublejackpot', 'Paket Double Jackpot', 
'🎰 DOUBLE JACKPOT (Khusus El Seven):
- Durasi 60 menit, 2x 💦 (1x FJ + 1x HJ).
- Note: All You Can F (90 menit, max 3 ladies 30 menit, khusus grade GOLD).', 'jackpot, double, gold, seven'),

('ktv', 'Paket Karaoke KTV & Party', 
'🎤 PAKET KARAOKE KTV & PARTY:
- Karaoke Regular: 2 Voucher (Durasi 3 Jam: 2 jam KTV + 1 jam Room Service).
- Karaoke Party: 4 Voucher (Durasi 4 Jam: 2 jam KTV + 1 jam Party + 1 jam Room Service).
- Pool Spa: 3 Voucher (Durasi 4 Jam: 2 jam KTV + 1 jam Bikini + 1 jam Room Service).
- Close Voucher: 5 - 6 Voucher (Durasi hingga esok 12.00 am - 10.00 am).', 'ktv, karaoke, party, pool, bikini'),

('celeb', 'Aturan Booking Celeb / Price List Celeb', 
'⭐ ATURAN BOOKING CELEB:
1. Wajib booking H-1 (1 hari sebelumnya).
2. Wajib membayar DP (uang muka) 50%.
3. Bisa request di semua Outlet EL Group.', 'celeb, booking, dp, h-1, price list celeb'),

('payment', 'Metode Pembayaran', 
'💳 Metode Pembayaran Resmi EL Group:
- QRIS
- NFC Card EL
- Debit / Credit Card
- Transfer Bank
- Cash / Tunai
* Catatan: Pembayaran hanya dilakukan di kasir resmi.', 'payment, pembayaran, bayar, qris, transfer, cash, kartu'),

('contact', 'Kontak Reservasi & Admin', 
'📞 KONTAK RESERVASI RESMI:
• Booking Umum / Madam Tika: 087883488882 (https://wa.me/qr/O6QEVDUNDJB4G1 / Telegram: @MadamTika)
• Booking EL NORTE / Kim Asst: 081227282945 (https://wa.me/qr/XQRRH3QXZCZAA1 / Telegram: @kimasst)
• Booking EL FENIX / Dori Asst: 081376776722 (https://wa.me/qr/KSTLRQATOQ2PC1 / Telegram: @Doriasst)
• Telegram Group: @spakaraokejakarta', 'contact, kontak, admin, tika, whatsapp, wa, telegram, norte, fenix, nomor, hp, 087883488882, 081227282945, 081376776722'),

('lost_item', 'Barang Tertinggal / Lost and Found',
' Jangan khawatir kak! Silakan informasikan data berikut:
- Nama:
- Cabang:
- Tanggal kunjungan:
- Jam kunjungan:
- Barang yang tertinggal:
Kami akan membantu meneruskan informasi tersebut kepada tim outlet untuk pengecekan.', 'barang, ketinggalan, tertinggal, lost, found, hp, dompet'),

('ktp', 'Persyaratan KTP / Identitas',
'Untuk kebutuhan tertentu, identitas/KTP dapat diperlukan sesuai kebijakan outlet. Silakan sebutkan outlet yang ingin dikunjungi untuk informasi lebih lanjut.', 'ktp, identitas, id, bawa ktp'),

('rules_sop', 'Aturan Kedatangan & SOP Reservasi Barcode',
'📋 PERATURAN & KETENTUAN RESMI EL GROUP:
- Bagi yang mau datang ke semua outlet EL Group bisa langsung hub Madam Tika atau Kim & Dori.
- Bisa pilih Ladies lewat foto atau showing pilih langsung di lokasi.
- Dibutuhkan Reservasi & Barcode untuk akses masuk & akses lift setiap kali mau datang.
- Barcode di-scan di security.

Demi kenyamanan & keamanan bersama, seluruh tamu wajib mengikuti SOP & aturan yang berlaku. Terima kasih atas pengertiannya! ☺️', 'rules, aturan, sop, kedatangan, reservasi, barcode, security, lift, madam tika, kim, dori'),

('layanan_options', 'Perbedaan Layanan LC, Ladies Drink & Therapist',
'Hai kak 👋 EL Group ada 3 pilihan:

1. LC: Karaoke + Private 60mnt (Bisa karaoke terlebih dahulu dan bisa langsung Private Session 1v1 durasi 60 menit)
2. Ladies Drink: minum 30 mnt + Private 60 mnt El Seven (Teman minum durasi 30 menit. Bisa langsung private session duration 60 menit. Khusus untuk Talent EL Seven saja)
3. Therapist: Berendam + Pijat + Private 90 mnt El Spa (Teman berendam minum & lanjut pijat dahulu, kemudian dilanjutkan dengan private session durasi 90 menit)', 'lc, ladies drink, therapist, beda, perbedaan, pilihan, karaoke, minum, berendam, pijat, spa'),

('fr_review', 'Field Report / Feedback / Review Tamu (FR)',
'Hal kak, Nggak semua tamu kasih feedback/review, FR sebagian lebih pilih privacy. Tapi kakak nggak usah khawatir ya. Talent EL GROUP semua udah berpengalaman & rutin ikut training. Standar pelayanan kami selalu dijaga biar kakak nyaman & puas. Ditunggu kedatangannya di EL Group ✨', 'fr, field report, review, testimoni, feedback, masukan'),

('kesehatan_ladies', 'Kesehatan & Cek HIV Talent / Ladies',
'Kak tenang aja ya 🙏 Ladies EL Group semua sudah cek kesehatan & bebas HIV. Ada dokternya juga yang rutin cek. Jadi aman & nyaman kok 😃', 'sehat, kesehatan, dokter, hiv, penyakit, aman, terapis, ladies'),

('lokasi_cabang', 'Lokasi Cabang & Alamat Seluruh Outlet EL Group',
'👥 EL GROUP 💕🇮🇩

6 Outlet Terbaik di Jakarta & Tangerang

📍 1. EL CENTRO
• EL Centro — Lt. 8
• EL Spa Pangjay — Lt. 3
• EL Seven Club — Lt. 2
📌 Lokasi: Hotel Maxwell, Pangjay — Jakarta Pusat
🗺️ Maps: https://g.co/kgs/XsooJhR

📍 2. EL FENIX
• EL Fenix — Lt. 10
• EL Spa Kelapa Gading — Lt. 9
📌 Lokasi: Kelapa Gading — Jakarta Utara
🗺️ Maps: https://g.co/kgs/boEFS4t

📍 3. EL NORTE
📌 Lokasi: Pantai Indah Kapuk — Jakarta Utara
🗺️ Maps: https://g.co/kgs/2x2ah1j

📍 4. EL ORCA
📌 Lokasi: Green Lake City — Tangerang
🗺️ Maps: https://g.co/kgs/uftGAaA

📍 5. EL CASA
📌 Lokasi: Gading Serpong — Tangerang
🗺️ Maps: https://g.co/kgs/JbtEvHK

📍 6. EL MEMENTO
📌 Lokasi: Jakarta Selatan
🗺️ Maps: https://share.google/NkCFC2E5gQHcVXI7Yin

💕 EL GROUP — Your Premium Entertainment & Relaxation Destination', 'lokasi, cabang, alamat, outlet, dimana, mana saja, berapa cabang, maps, hotel maxwell, pangjay, pik, kelapa gading, glc, gading serpong, jaksel');
