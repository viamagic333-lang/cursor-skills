# MCP Setup — как получить API-ключи для новых MCP-серверов

В Cursor уже добавлены 7 новых MCP-серверов. Чтобы они заработали,
нужно получить API-ключи для каждого и заменить плейсхолдеры в
`~/.cursor/mcp.json`.

После замены ключей — **перезапусти Cursor** (Cmd+Q, потом открой
заново), чтобы MCP-серверы подхватились.

---

## 1. Figma MCP

**Что даёт:** чтение Figma-файлов, извлечение design tokens, компонентов,
слоёв. Может конвертировать Figma → Tailwind/React код.

**Где взять ключ:**
1. Открой https://www.figma.com/developers/api#access-tokens
2. Войди в Figma-аккаунт
3. Нажми «Get personal access token» → придумай имя → сгенерируй
4. Скопируй токен (виден только один раз!)

**Замени в `~/.cursor/mcp.json`:**
```json
"FIGMA_API_KEY": "figd_xxxxxxxxxxxxxxxxxxxxx"
```

---

## 2. Neon MCP (serverless Postgres)

**Что даёт:** создание баз данных, выполнение SQL, управление схемой —
всё через Neon (бесплатный тариф: 0.5 GB storage, 100 compute hours/месяц).

**Где взять ключ:**
1. Открой https://neon.tech → зарегистрируйся (через GitHub)
2. Dashboard → «Account settings» → «API keys» → «Create new API key»
3. Скопируй ключ

**Замени:**
```json
"NEON_API_KEY": "neon_xxxxxxxxxxxxxx"
```

---

## 3. Cloudinary MCP (image CDN)

**Что даёт:** загрузка, оптимизация, resize, конвертация изображений
(webp, avif), CDN по всему миру. Бесплатный тариф: 25 GB storage,
25 GB bandwidth/месяц.

**Где взять ключи:**
1. Открой https://cloudinary.com → зарегистрируйся
2. После регистрации попадаешь в dashboard
3. Скопируй 3 значения: **Cloud Name**, **API Key**, **API Secret**

**Замени:**
```json
"CLOUDINARY_CLOUD_NAME": "your_cloud_name",
"CLOUDINARY_API_KEY": "123456789012345",
"CLOUDINARY_API_SECRET": "xxxxxxxxxxxxxxxxxxxxxxxxxx"
```

---

## 4. Notion MCP

**Что даёт:** чтение/запись Notion-страниц и баз. Полезно, если ведёшь
клиентские ТЗ или документацию в Notion.

**Где взять ключ:**
1. Открой https://www.notion.so/profile/integrations
2. «Develop your own integrations» → «New integration»
3. Придумай имя → выбери workspace → Submit
4. Скопируй **Internal Integration Secret** (начинается с `ntn_` или `secret_`)
5. **Важно:** открой нужные страницы в Notion → «...» → «Connections» →
   добавь свою интеграцию, иначе MCP не увидит их

**Замени:**
```json
"OPENAPI_MCP_HEADERS": "{\"Authorization\":\"Bearer ntn_xxxxxxxxxxxx\",\"Notion-Version\":\"2022-06-28\"}"
```

---

## 5. Stripe MCP (платежи)

**Что даёт:** создание invoices, приём платежей, подписки, возвраты —
всё для фриланс-бизнеса. **Внимание:** используй **test mode** ключ
(`sk_test_...`) для разработки, не production.

**Где взять ключ:**
1. Открой https://dashboard.stripe.com → зарегистрируйся
2. Включи «Test mode» (переключатель сверху)
3. «Developers» → «API keys» → скопируй **Secret key** (`sk_test_...`)

**Замени:**
```json
"STRIPE_SECRET_KEY": "sk_test_xxxxxxxxxxxxxxxxxxxxx"
```

---

## 6. Google Analytics MCP

**Что даёт:** запросы к GA4 — трафик, источники, поведение, конверсии.

**Где взять ключи (3 значения, сложнее остальных):**
1. Открой https://console.cloud.google.com → создай проект
2. «APIs & Services» → «Enable APIs» → включи **Google Analytics Data API**
3. «OAuth consent screen» → настрой (External, тестовый режим)
4. «Credentials» → «Create credentials» → «OAuth client ID» →
   тип **Desktop app** → скопируй **Client ID** и **Client Secret**
5. Получи **Property ID** из GA4: https://analytics.google.com →
   Admin → Property settings → Property ID

**Замени:**
```json
"GA_PROPERTY_ID": "123456789",
"GOOGLE_OAUTH_CLIENT_ID": "xxxxx.apps.googleusercontent.com",
"GOOGLE_OAUTH_CLIENT_SECRET": "GOCSPX-xxxxxxxxx"
```

---

## 7. Google Search Console MCP

**Что даёт:** индексация, ключевые слова, позиции, ошибки сканирования.

**Где взять ключ (через Service Account):**
1. Открой https://console.cloud.google.com → создай проект (или
   используй тот же, что для Analytics)
2. «APIs & Services» → «Enable APIs» → включи **Google Search Console API**
3. «Credentials» → «Create credentials» → «Service account»
4. Придумай имя → Done → открой созданный аккаунт → «Keys» →
   «Add key» → «Create new key» → JSON → скачается файл
5. Сохрани файл в надёжное место, например `~/secrets/gsc-service-account.json`
6. **Важно:** открой https://search.google.com/search-console →
   добавь email сервисного аккаунта (вида `xxx@xxx.iam.gserviceaccount.com`)
   как пользователя своего property, иначе MCP не получит доступ

**Замени:**
```json
"GSC_SERVICE_ACCOUNT_JSON": "/Users/magic/secrets/gsc-service-account.json"
```

---

## После замены всех ключей

1. Сохрани `~/.cursor/mcp.json`
2. **Перезапусти Cursor** (Cmd+Q → открой заново)
3. Открой любой проект
4. В чате Cursor увидишь, что MCP-серверы активировались
5. Проверь: попроси агента что-то сделать через новый MCP
   (например: «покажи мои последние 5 Notion-страниц»)

---

## Если что-то не работает

| Проблема | Решение |
|----------|--------|
| MCP не запускается | Проверь, что все плейсхолдеры заменены на реальные ключи |
| Ошибка авторизации | Проверь, что ключ правильный и не истёк |
| Notion не видит страницы | Добавь интеграцию на каждую нужную страницу вручную |
| Google APIs не работают | Проверь, что APIs включены в Cloud Console |
| Stripe возвращает 401 | Убедись, что используешь **test mode** ключ |
| Figma не видит файл | Файл должен быть в твоём workspace, не чужой |

---

## Безопасность

- **Никогда не коммить `~/.cursor/mcp.json` в git** — там будут ключи
- Если ключ утёк — отзовите его в панели соответствующего сервиса
- Для production-проектов используй отдельные ключи, не те же, что для разработки
- Stripe: **всегда** test mode для разработки, production только после тестов
