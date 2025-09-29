<div align="center">
    <img src="https://github.com/user-attachments/assets/1b2ec02b-6bf6-4c62-b8e3-bfba4aaafd93" alt="SSB Logo" width="325" height="auto">
    <h1>SECRET SING-BOX</h1>
    <a href="https://github.com/moosti/Secret-Sing-Box-IR/blob/main/.github/README.md">English</a> | فارسی<br><br>
</div>

### راه‌اندازی آسان پروکسی با TLS termination بر روی NGINX یا HAProxy
این اسکریپت برای پیکربندی کامل و سریع یک سرور پروکسی امن با هسته [Sing-Box](https://sing-box.sagernet.org) و فرانت‌اند [NGINX](https://nginx.org/en/) یا [HAProxy](https://www.haproxy.org) طراحی شده است. برای پروکسی کردن ترافیک، از پروتکل‌های **Trojan** و **VLESS** استفاده می‌شود. دو گزینه راه‌اندازی سرور:

- تمام درخواست‌های پروکسی توسط NGINX دریافت می‌شوند، درخواست‌ها فقط در صورتی که حاوی مسیر صحیح باشند به Sing-Box منتقل می‌شوند (ترانسپورت WebSocket یا HTTPUpgrade)

![nginx-en](https://github.com/user-attachments/assets/8b832294-f14f-4c8b-876e-30b1d160fd1e)

- تمام درخواست‌های پروکسی توسط HAProxy دریافت می‌شوند، سپس رمزهای عبور Trojan از ۵۶ بایت اول درخواست با استفاده از اسکریپت Lua خوانده می‌شوند، درخواست‌ها فقط در صورتی که حاوی رمز عبور صحیح Trojan باشند به Sing-Box منتقل می‌شوند (ترانسپورت TCP) — روش [FPPweb3](https://github.com/FPPweb3)

![haproxy-en](https://github.com/user-attachments/assets/a9753846-4f40-414d-b4eb-4c37b4e9de14)

هر دو روش راه‌اندازی، شناسایی Sing-Box از بیرون را غیرممکن می‌کنند که امنیت را بهبود می‌بخشد.

> [!IMPORTANT]
> سیستم عامل پیشنهادی برای سرور: Debian 11/12 یا Ubuntu 22.04/24.04. فقط ۵۱۲ مگابایت RAM، ۵ گیگابایت فضای دیسک و ۱ هسته پردازنده کافی است. همچنین به یک IPv4 روی سرور و دامنه شخصی خود نیاز دارید ([چگونه آن را تنظیم کنیم؟](https://github.com/moosti/Secret-Sing-Box-IR/blob/main/.github/cf-settings-en.md)). به عنوان root روی سیستم تازه نصب شده اجرا کنید. قبل از اجرای این اسکریپت، لازم است سیستم را به‌روزرسانی و راه‌اندازی مجدد کنید.

> [!NOTE]
> با قوانین مسیریابی برای ایران. پورت‌های باز روی سرور: ۴۴۳ و SSH.
>
> این پروژه برای اهداف آموزشی و نمایشی ایجاد شده است. لطفاً قبل از استفاده از آن مطمئن شوید که اقدامات شما قانونی است.

### شامل موارد زیر:
1) راه‌اندازی سرور Sing-Box
2) راه‌اندازی ریورس پروکسی NGINX یا HAProxy و وب‌سایت روی پورت ۴۴۳
3) گواهی‌های TLS با تمدید خودکار
4) راه‌اندازی امنیتی (SSH، UFW و unattended-upgrades) — اختیاری
5) Multiplexing برای بهینه‌سازی اتصالات و حل مشکل TLS in TLS
6) فعال‌سازی BBR
7) راه‌اندازی WARP
8) راه‌اندازی اختیاری زنجیره پروکسی از دو یا چند سرور
9) گزینه‌ای برای راه‌اندازی اتصال به IP سفارشی Cloudflare روی کلاینت
10) کانفیگ‌های Sing-Box کلاینت با قوانین مسیریابی برای ایران
11) مدیریت خودکار فایل‌های کانفیگ کاربر
12) صفحه برای توزیع راحت اشتراک‌ها ([مثال](https://a-zuro.github.io/Secret-Sing-Box/sub-en.html))
 
### راه‌اندازی سرور:

برای راه‌اندازی سرور، این دستور را روی آن اجرا کنید:

```
bash <(curl -Ls https://raw.githubusercontent.com/moosti/Secret-Sing-Box-IR/master/Scripts/install-server.sh); source /etc/bash.bashrc
```

سپس فقط اطلاعات لازم را وارد کنید:

![pic-1-en](https://github.com/user-attachments/assets/8d78bb20-eb5c-4074-865e-a858869a6103)

> [!CAUTION]
> رمزهای عبور، UUIDها، مسیرها و سایر داده‌ها در تصویر بالا فقط برای مثال هستند. از آنها روی سرور خود استفاده نکنید.

در پایان، اسکریپت لینک‌های شما به کانفیگ‌های کلاینت و صفحه اشتراک را نشان می‌دهد، توصیه می‌شود آنها را ذخیره کنید.

-----

برای نمایش منوی تنظیمات، این دستور را اجرا کنید:

```
ssb
```

سپس دستورالعمل‌ها را دنبال کنید:

![pic-2-en](https://github.com/user-attachments/assets/3a40dea9-2b7c-4480-b2f2-fae986376502)

گزینه ۵ تنظیمات را در کانفیگ‌های کلاینت همه کاربران همگام‌سازی می‌کند که نیاز به ویرایش کانفیگ هر کاربر به صورت جداگانه را از بین می‌برد:

5.1. تنظیمات را با [قالب از GitHub](https://github.com/moosti/Secret-Sing-Box-IR/blob/main/Config-Templates/client.json) همگام‌سازی می‌کند.

5.2. تنظیمات را با قالب محلی همگام‌سازی می‌کند، امکان تنظیم قوانین سفارشی در کانفیگ‌های کلاینت را فراهم می‌کند. اگر مجموعه قوانین جدیدی با استفاده از این گزینه به کانفیگ‌ها اضافه شوند، در صورتی که از [SagerNet](https://github.com/SagerNet/sing-geosite/tree/rule-set) باشند، به طور خودکار روی سرور دانلود می‌شوند.

### کلیدهای WARP+:

برای فعال‌سازی کلید WARP+، این دستور را وارد کنید (کلید را با کلید خود جایگزین کنید):

```
warp-cli registration license CMD5m479-Y5hS6y79-U06c5mq9
```

### راه‌اندازی کلاینت:
> [!IMPORTANT]
> به دلیل تنظیمات مسیریابی کامل‌تر، استفاده از اپلیکیشن Sing-Box توصیه می‌شود، اما می‌توانید لینک را به اپلیکیشن [Hiddify](https://github.com/hiddify/hiddify-app/releases/latest) وارد کنید یا از هر اپلیکیشن کلاینت مبتنی بر Sing-Box یا هسته‌های Clash/Mihomo استفاده کنید. اگر برخی اپلیکیشن‌ها هنگام استفاده از Hiddify پروکسی نمی‌شوند، گزینه‌های کانفیگ > حالت سرویس > VPN را تغییر دهید.
>
> در برخی دستگاه‌ها، "stack": "system" در تنظیمات رابط tun در کانفیگ‌های کلاینت ممکن است کار نکند. در چنین مواردی، توصیه می‌شود آن را با "gvisor" با استفاده از گزینه ۴ در منوی تنظیمات جایگزین کنید (به بالا مراجعه کنید).

[Android، iOS و macOS](https://github.com/moosti/Secret-Sing-Box-IR/blob/main/.github/Sing-Box-Android-iOS-en.md). راهنما برای Android ارائه شده است، رابط اپلیکیشن در iOS و macOS متفاوت است، اما تنظیمات مشابهی دارد.

[Windows](https://github.com/moosti/Secret-Sing-Box-IR/blob/main/.github/Sing-Box-Windows-en.md). این روش شامل راه‌اندازی هسته خالص Sing-Box است و GUI ندارد.

[Linux](https://github.com/moosti/Secret-Sing-Box-IR/blob/main/.github/README-EN.md#client-setup). دستور زیر را اجرا کنید و دستورالعمل‌ها را دنبال کنید (برای توزیع‌های مبتنی بر Debian).
```
bash <(curl -Ls https://raw.githubusercontent.com/moosti/Secret-Sing-Box-IR/master/Scripts/sb-pc-linux-en.sh)
```

### Stargazers در طول زمان:
[![Stargazers over time](https://starchart.cc/moosti/Secret-Sing-Box-IR.svg?variant=adaptive)](https://starchart.cc/moosti/Secret-Sing-Box-IR)