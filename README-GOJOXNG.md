# 🌀 GojoXNG

**محرك بحث خاص يحترم الخصوصية** — مبني على [SearXNG](https://github.com/searxng/searxng) ومخصص باسم **GojoXNG** مع شعار أصلي بأسلوب الأنمي.

![GojoXNG Logo](searx/static/themes/simple/img/gojoxng-logo.png)

---

## ✨ المميزات

- 🔒 **خصوصية كاملة**: لا تتبع، لا تخزين لسجل البحث، لا ملفات تعريف ارتباط للتصنت
- 🌀 **شعار GojoXNG الأصلي**: تصميم أنمي أصلي بأسلوب الساحر
- 🚫 **بدون إعلانات أو تتبع**: محرك بحث مفتوح المصدر (AGPL-3.0)
- 🌐 **ميتا-بحث**: يجمع النتائج من محركات بحث متعددة (Google, Bing, DuckDuckGo, وغيرها)
- 🐳 **جاهز للنشر**: ملفات Docker و Docker Compose مضمنة
- 🔌 **يعمل على أي استضافة**: يدعم Docker، VPS، الاستضافات المشتركة، والسحابة

---

## 📦 المتطلبات

- **Docker** 20.10+ و **Docker Compose** v2 (الخيار الأسهل)
- أو **Python 3.12+** للتشغيل المباشر بدون Docker
- أو **VPS/استضافة سحابية** تدعم Docker

---

## 🚀 التشغيل السريع بـ Docker (الطريقة الموصى بها)

### 1. إعداد المتغيرات البيئية

```bash
cd gojoxng
cp .env.example .env
```

افتح ملف `.env` وعدّل القيم:
```bash
GOJOXNG_URL=https://your-domain.com/
GOJOXNG_HOST=127.0.0.1   # استخدم 0.0.0.0 لتعميم الوصول
GOJOXNG_PORT=8080
GOJOXNG_SECRET=$(openssl rand -hex 32)  # مفتاح سري قوي
```

### 2. توليد مفتاح سري قوي

```bash
# على Linux/macOS
openssl rand -hex 32

# أو استخدم Python
python3 -c "import secrets; print(secrets.token_hex(32))"
```

انسخ الناتج إلى `GOJOXNG_SECRET` في ملف `.env`.

### 3. تشغيل الحاوية

```bash
docker compose up -d --build
```

انتظر دقيقة حتى يكتمل البناء، ثم افتح المتصفح على:
```
http://localhost:8080
```

### 4. التحقق من التشغيل

```bash
docker compose ps        # حالة الحاويات
docker compose logs -f   # السجلات الحية
```

---

## 🌐 النشر على الاستضافات المختلفة

### الخيار A: VPS مع Docker (DigitalOcean, Hetzner, Linode, Vultr)

```bash
# 1. سجّل دخول إلى الخادم
ssh root@your-server-ip

# 2. تثبيت Docker
curl -fsSL https://get.docker.com | sh

# 3. انسخ المشروع
git clone <your-repo-url> gojoxng
cd gojoxng

# 4. اضبط الإعدادات
cp .env.example .env
# عدّل .env — استخدم عنوان نطاقك و مفتاح سري قوي

# 5. شغّل
docker compose up -d --build

# 6. ثبّت Nginx + Certbot للـ HTTPS
apt install nginx certbot python3-certbot-nginx
cp nginx-gojoxng.conf /etc/nginx/sites-available/gojoxng
ln -s /etc/nginx/sites-available/gojoxng /etc/nginx/sites-enabled/
# عدّل النطاق في الملف
certbot --nginx -d your-domain.com
```

### الخيار B: Caddy (أسهل HTTPS تلقائي)

```bash
apt install caddy
cp Caddyfile /etc/caddy/Caddyfile
# عدّل your-domain.com
systemctl restart caddy
```

### الخيار C: Render / Railway / Fly.io (سحابة)

هذه المنصات تدعم Docker مباشرة:
1. ارفع المستودع إلى GitHub
2. أنشئ خدمة جديدة واختر "Docker"
3. اضبط المنفذ على `8080`
4. أضف متغيرات البيئة من `.env.example`

### الخيار D: استضافة مشتركة (بدون Docker)

تحتاج استضافة تدعم Python 3.12+:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -e .
pip install granian[pname]==2.7.9
export SEARXNG_SECRET="your-secret-key"
export SEARXNG_BIND_ADDRESS=0.0.0.0
granian searx.webapp:app --host 0.0.0.0 --port 8080
```

---

## ⚙️ الإعدادات المتقدمة

### تخصيص محركات البحث

عدّل ملف `config/settings.yml` لإضافة أو تعطيل محركات البحث:

```yaml
engines:
  - name: google
    engine: google
    disabled: false
  - name: duckduckgo
    engine: duckduckgo
    disabled: false
```

### تفعيل الـ Rate Limiter (للمثيلات العامة)

في ملف `.env`:
```bash
GOJOXNG_LIMITER=true
```

### تفعيل Valkey/Redis (للأداء العالي)

ملف `docker-compose.yml` يتضمن Valkey تلقائياً. إذا أردت تعطيله، احذف خدمة `valkey`.

---

## 🔒 ميزات الخصوصية المفعّلة

| الميزة | الحالة | الوصف |
|--------|--------|--------|
| `image_proxy` | ✅ مفعّل | تمرير الصور عبر الخادم لإخفاء عنوان IP الخاص بك |
| `method: POST` | ✅ مفعّل | إخفاء استعلامات البحث من سجلات الخادم والمتصفح |
| `enable_metrics` | ❌ معطّل | لا تسجيل إحصائيات الاستخدام |
| `query_in_title` | ❌ معطّل | عدم وضع استعلام البحث في عنوان الصفحة |
| `Referrer-Policy` | ✅ no-referrer | لا إرسال معلومات المصدر |
| `X-Robots-Tag` | ✅ noindex, nofollow | منع فهرسة نتائج البحث |
| `Permissions-Policy` | ✅ مفعّل | تعطيل الكاميرا/الميكروفون/الموقع |

---

## 🛠️ أوامر الإدارة

```bash
# إيقاف
docker compose down

# إعادة تشغيل
docker compose restart

# تحديث بعد تعديل الكود
docker compose up -d --build

# عرض السجلات
docker compose logs -f gojoxng

# إعادة بناء من الصفر
docker compose build --no-cache
```

---

## 🎨 تخصيص الشعار

ملفات الشعار موجودة في:
```
searx/static/themes/simple/img/
├── gojoxng-logo.png       # الشعار الرئيسي (الصفحة الرئيسية)
├── gojoxng-favicon.png    # أيقونة المتصفح
├── favicon.png            # نسخة من الفافيكون
├── 192.png / 512.png      # أيقونات PWA
```

لاستبدال الشعار، ضع صورك الخاصة بنفس الأسماء.

---

## 📁 بنية المشروع

```
gojoxng/
├── Dockerfile              # صورة Docker جاهزة للنشر
├── docker-compose.yml      # إعداد Docker Compose مع Valkey
├── .env.example            # قالب المتغيرات البيئية
├── nginx-gojoxng.conf      # إعداد Nginx للوكيل العكسي
├── Caddyfile               # بديل Caddy مع HTTPS تلقائي
├── config/
│   └── settings.yml        # إعدادات GojoXNG المنشورة
├── searx/                  # الكود المصدري (SearXNG fork)
│   ├── settings.yml        # الإعدادات الافتراضية
│   ├── templates/simple/   # قوالب HTML المخصصة
│   └── static/themes/simple/img/  # الشعارات والأيقونات
└── container/              # سكريبتات Docker
```

---

## ❓ استكشاف الأخطاء

**المشكلة: الصفحة لا تتحميل**
```bash
docker compose logs gojoxng   # تحقق من السجلات
docker compose ps             # تأكد من أن الحاوية تعمل
```

**المشكلة: لا تظهر نتائج البحث**
- بعض محركات البحث تحظر عناوين IP الخاصة بمراكز البيانات
- جرّب تفعيل محركات بحث أخرى في `config/settings.yml`
- فكّر في استخدام بروكسي صادر (outgoing proxy)

**المشكلة: الشعار لا يظهر**
```bash
# تحقق من وجود الملف
docker compose exec gojoxng ls /usr/local/searxng/searx/static/themes/simple/img/gojoxng-logo.png
```

---

## 📄 الترخيص

GojoXNG مبني على SearXNG ومرخّص تحت **AGPL-3.0-or-later**.
راجع ملف `LICENSE` للتفاصيل الكاملة.

الشعار الأصلي لـ GojoXNG هو تصميم أصلي بأسلوب الأنمي ولا يستنسخ أي عمل محمي بحقوق الملكية.

---

## 🙏 شكر وتقدير

- [SearXNG](https://github.com/searxng/searxng) — المشروع الأساسي
- مجتمع المصدر المفتوح
