<?php
//error_reporting(E_ALL);
//ini_set('display_errors', 1);
//ini_set('display_startup_errors', 1);

$clientBotTele='8791438411:AAFKzCvX3g4xh3IW6V5jqzoc7SxDOqR_Pns';
require_once __DIR__ . "/vendor/autoload.php";

use TuriBot\Client;
$client = new Client($clientBotTele, false);
$update = $client->getUpdate();
if (!isset($update)) {
    exit();
}
if (isset($update->message) or isset($update->edited_message)) {
    $chat_id = $client->easy->chat_id;
    $from_id = $client->easy->from_id;
    $from_name = $client->easy->first_name;
    
    //$pesanChat='';
    $text = $client->easy->text;
    if($from_id > 0 || $from_id == -1001993407659)
    {
        $menu["keyboard"] = [
                        [
                            [
                                "text"          => "🙍‍♀️ CONTACT",
                            ],
                            [
                                "text"          => "🚫 🙅 Do Not Do",
                            ],
                            [
                                "text"          => "📋 RULES",
                            ]
                        ],[
                            [
                                "text"          => "🪪 Apply Member EL",
                            ],
                            [
                                "text"          => "⏰ Jam Ops",
                            ],
                        ],[
                            [
                                "text"          => "💵 Payment",
                            ],
                            [
                                "text"          => "💎 Price List EL",
                            ]
                        ],
                    ];
                
        $menu['resize_keyboard'] = true;

        // Keyboard cabang untuk Price List
        $menuCabang = [];
        $menuCabang['keyboard'] = [
            [
                ["text" => "🏢 El Centro"],
                ["text" => "🏢 El Spa Pangjay"],
                ["text" => "🏢 El Seven Club"],
            ],[
                ["text" => "🏢 El Norte"],
                ["text" => "🏢 El Fenix"],
                ["text" => "🏢 El Spa KG"],
            ],[
                ["text" => "🏢 El Orca"],
                ["text" => "🏢 El Casa"],
                ["text" => "🏢 El Memento"],
            ],[
                ["text" => "⭐ Price List Celeb"],
                ["text" => "🔙 Kembali"],
            ],
        ];
        $menuCabang['resize_keyboard'] = true;

        if (strtolower(substr($text,0,6)) == '/start') {

$pesanChat="EL GROUP SPA KARAOKE JAKARTA💆‍♀️🎤

Gabung grup untuk dapatin promo & update terbaru!  
_\"Nikmatin waktu luang anda dengan hiburan yang menyenangkan\"_

Join Grup Telegram👇
https://t.me/Spakaraokejakartapusat

Tersedia: Lokal, Panlok, Import 🇮🇩🇯🇵

📍 Outlet Kami:
1. El Centro, El SPA Pangjay & El Seven Club
2. El Norte PIK 
3. El Fenix & El SPA Kelapa Gading 
4. El Orca GLC
5. El Lucha GLC
6. El Casa GADSER
7. El Memento JAKSEL

⏰ Open Everyday
11:00 - 24:00 WIB | Last Order 23:30

_Customer Service Fast Response 24/7_";

                $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);

        }elseif (strtolower(substr($text,0,8)) == '/donotdo' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'do not do') 
        {
            $pesanChat="PERATURAN & KETENTUAN EL GROUP ⚠️

DILARANG:
1. Membawa/mengonsumsi narkoba & zat terlarang
2. Membawa senjata tajam/senjata api
3. Membawa makanan & minuman dari luar
4. Merekam video/mengambil foto selama room service
5. Memaksa terapis melakukan tindakan di luar SOP
6. Merusak fasilitas atau membawa pulang Inventaris kamar

KEBIJAKAN:
Pelanggan yang melanggar akan dikenakan Sanksi tegas berupa:
- Pemutusan layanan tanpa refund
- Denda sesuai kerusakan/kerugian
- BLACKLIST PERMANEN dari semua Outlet EL Group.

Demi kenyamanan & keamanan bersama. Terima kasih atas pengertiannya.";
$client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }elseif (strtolower(substr($text,0,7)) == '/jamops' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'jam ops') 
        {
            $pesanChat="⏰ 𝗝𝗮𝗺 𝗢𝗽𝗲𝗿𝗮𝘀𝗶𝗼𝗻𝗮𝗹 𝗘𝗟 𝗚𝗿𝗼𝘂𝗽 

📍 𝗘𝗟 𝗖𝗲𝗻𝘁𝗿𝗼: 14.00 - 01.00 | Last Order 00.30  
📍 𝗘𝗟 𝗦𝗽𝗮 𝗣𝗮𝗻𝗴𝗷𝗮𝘆: 12.00 - 23.00 | Last Order 22.30  
📍 𝗘𝗟 𝗦𝗲𝘃𝗲𝗻 𝗖𝗹𝘂𝗯: 18.00 - 04.00 | Last Order 03.30  
📍 𝗘𝗟 𝗡𝗼𝗿𝘁𝗲: 12.00 - 24.00 | Last Order 23.30  
📍 𝗘𝗟 𝗙𝗲𝗻𝗶𝘅: 14.00 - 24.00 | Last Order 23.30  
📍 𝗘𝗟 𝗦𝗽𝗮 𝗚𝗮𝗱𝗶𝗻𝗴: 12.00 - 23.00 | Last Order 22.30  
📍 𝗘𝗟 𝗢𝗿𝗰𝗮: 12.00 - 23.00 | Last Order 22.30  
📍 𝗘𝗟 𝗖𝗮𝘀𝗮: 13.00 - 24.00 | Last Order 23.30  
📍 𝗘𝗟 𝗠𝗲𝗺𝗲𝗻𝘁𝗼: 12.00 - 01.00 | Last Order 00.30  

━━━━━━━━━━━━━━━  
𝗡𝗼𝘁𝗲: 𝗪𝗲 𝗔𝗿𝗲 𝗢𝗽𝗲𝗻 𝗘𝘃𝗲𝗿𝘆 𝗗𝗮𝘆 😘";
$client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }elseif (strtolower(substr($text,0,12)) == '/applymember' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'apply member el') 
        {
            $client->sendPhoto($chat_id,'https://tikael.kereaktif.id/tika_3.jpg',NULL,"🪪 Registrasi Member EL Group

Untuk daftar member, kirim format di bawah ini ke : @MadamTika

Nama member : Bebas  
No HP : Harus Aktif untuk terima kode aktivasi via SMS/WhatsApp

✅ Member bisa dipakai di semua outlet EL Group  

🔗 Link kartu digital: https://app.elgroupapp.com/

_Free Registrasi_");
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/tika_4a.jpeg', caption: "REMINDER CASH BACK EL GROUP 


Jangan lupa tunjukkan kartu member digital kamu ke kasir ya, biar Cash Back-nya langsung di Ajukan Top Up! 💸

Perlu diingat :
Pengajuan Cash Back hanya berlaku 3 hari sejak tanggal kedatangan.  
Pastikan kamu nggak kelewatan kesempatan ini ya!", reply_markup: $menu);
        }
        elseif(strtolower(substr($text,0,8)) =='/estafet')
        {
            $pesanChat="...New Package additional
Estafet ~> 

Pilih 3 ladies platinum di lokasi ga bisa book ....pilihnya di lokasi langsung

Durasi 90 mnt 3x Fj 💦
Ladies ke 1 masuk selama 30 mnt lanjut 💦
Ladies ke 2 masuk selama 30 mnt lanjut 💦
Ladies ke 3 masuk selama 30 menit 💦
";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif(strtolower(substr($text,0,10)) =='/threesome')
        {
            $pesanChat="<b>THREESOME (KAMAR)</b>

<b>1. Durasi 2 Jam</b>
- 2x FJ 💦
- 1 Ladies 2 Voucher
👉 Total: <b>4 Voucher</b>

<b>2. Durasi 1 Jam</b>
- 1x FJ 💦
- 1 Ladies 1 Voucher
👉 Total: <b>2 Voucher</b>";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif (strtolower(substr($text,0,14)) == '/doublejackpot' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'double jackpot')
        {
            $pesanChat="all you can' f itu :
- Durasi 90 menit 
- bisa ganti ganti max 3 ladies selama 30 menit
- 3x 💦
- khusus untuk grade GOLD 

* sedangkan double jackpot durasi 60 menit  2x 💦  dgn *1 x FJ 1x HJ*💦


Berlaku di El Seven Saja.
";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif(strtolower(substr($text,0,4)) =='/ktv')
        {
            $pesanChat="<b>KARAOKE REGULAR</b>
2 Voucher  Durasi 3 Jam
- 2 jam KTV
- 1 jam Room Service 

<b>KARAOKE PARTY</b>
4 Voucher Durasi 4 JAM
- 2 Jam KTV
- 1 Jam Party
- 1 Jam room service

<b>POOL SPA</b>
3 Voucher Durasi 4 JAM
- 2 Jam KTV
- 1 Jam bikini 👙
- 1 Jam Room service

<b>Close Vocher</b>
5 -- 6 VOUCHER
Durasi hingga esok jam 12.00 am -10.00 am
";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif(strtolower(substr($text,0,6)) =='/celeb')
        {
            $pesanChat="Aturan booking:

- Wajib melakukan booking H-1 (1 hari sebelumnya)
- Wajib membayar DP (uang muka) 50%
- Bisa melakukan request di semua Outlet EL Group

Mohon diperhatikan ya! 😊
";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif (strtolower(substr($text,0,8)) == '/contact' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'contact') 
        {
            $client->sendPhoto($chat_id,'https://tikael.kereaktif.id/ptika2.jpg');
            $pesanChat="𝗕𝗮𝗿𝗰𝗼𝗱𝗲 & 𝗥𝗲𝘀𝗲𝗿𝘃𝗮𝘀𝗶 🔗

💙  Madam Tika
https://wa.me/qr/O6QEVDUNDJB4G1

💙  Kim Asst Norte
https://wa.me/qr/XQRRH3QXZCZAA1

💙  Dori Asst Fenix
https://wa.me/qr/KSTLRQATOQ2PC1

TELEGRAM :
💥@MadamTika
💥@kimasst
💥@Doriasst";
$client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
        }
        elseif (strtolower(substr($text,0,8)) == '/payment' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'payment') 
        {
            $pesanChat="Metode Pembayaran";
            $client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
            $client->sendPhoto($chat_id,'https://tikael.kereaktif.id/botikapayment.jpg');
        }
        elseif (strtolower(substr($text,0,6)) == '/rules' || strtolower(trim(preg_replace('/[^\p{L}\p{N}\s]/u', '', $text))) == 'rules') 
        {
            $client->sendPhoto($chat_id,'https://tikael.kereaktif.id/botikar1c.jpeg');
            
            $pesanChat="👥  𝗘𝗟 𝗚𝗿𝗼𝘂𝗽 💕🇮🇩

📍𝐄𝐋 𝐂𝐄𝐍𝐓𝐑𝐎
-    EL Spa Pangjay 
-    EL Seven Club
https://g.co/kgs/XsooJhR

📍𝐄𝐋 𝐅𝐄𝐍𝐈𝐗 
-    El Spa K. Gading
https://g.co/kgs/boEFS4t

📍𝐄𝐋 𝐍𝐎𝗥𝑇𝐸
https://g.co/kgs/2x2ah1j

📍𝐄𝐋 𝐎𝐑𝐂𝐀
https://g.co/kgs/uftGAAa

📍𝐄𝐋 𝐂𝐀𝐒𝐀
https://g.co/kgs/JbtEvHK

📍𝐄𝐋 𝐌𝐄𝐌𝐄𝐍𝐓𝐎
https://share.google/NkCFC2E5gQHcVXI7Y";
$client->sendMessage(chat_id: $chat_id, text: $pesanChat, parse_mode: 'HTML', reply_markup: $menu);
$client->sendPhoto($chat_id, 'https://tikael.kereaktif.id/botikar2c.jpeg');
$client->sendPhoto($chat_id, 'https://tikael.kereaktif.id/botikar3c.jpeg');
        }elseif (str_contains(mb_strtolower($text), 'price list celeb') || str_contains(mb_strtolower($text), 'price list celeb') || str_contains(mb_strtolower($text), 'celeb')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/celeb.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'price list')) {
            $client->sendMessage(chat_id: $chat_id, text: "Pilih outlet untuk melihat price list 👇", reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el centro')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_centro.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el spa pangjay')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_spa_pangjay.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el seven club')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_seven_club.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el norte')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_norte.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el fenix')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_fenix.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el spa kg')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_spa_kelapa_gading.jpeg', reply_markup: $menuCabang);
       }elseif (str_contains(mb_strtolower($text), 'el orca')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_orca_new.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el casa')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_casa.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'el memento')) {
            $client->sendPhoto(chat_id: $chat_id, photo: 'https://tikael.kereaktif.id/el_memento.jpeg', reply_markup: $menuCabang);
        }elseif (str_contains(mb_strtolower($text), 'kembali')) {
            $client->sendMessage(chat_id: $chat_id, text: "Menu utama 👇", reply_markup: $menu);
        }else{
            //$pesanChat="Hi ".$from_name;
        }
                

                
    }
}
?>