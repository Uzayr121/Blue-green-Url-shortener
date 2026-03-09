from fastapi import FastAPI, HTTPException, Request
from fastapi.responses import RedirectResponse, HTMLResponse
import hashlib, time
from .ddb import put_mapping, get_mapping

app = FastAPI()

HTML = """<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>shorten</title>
  <link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;600&display=swap" rel="stylesheet"/>
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #0c0c0c;
      font-family: 'IBM Plex Mono', monospace;
      color: #e0e0e0;
      padding: 24px;
    }
    .card {
      width: 100%;
      max-width: 560px;
    }
    h1 {
      font-size: 13px;
      font-weight: 600;
      letter-spacing: 0.2em;
      text-transform: uppercase;
      color: #b0f040;
      margin-bottom: 32px;
    }
    .row {
      display: flex;
      border: 1px solid #2a2a2a;
    }
    .row:focus-within { border-color: #444; }
    input {
      flex: 1;
      padding: 14px 16px;
      background: #141414;
      border: none;
      outline: none;
      color: #e0e0e0;
      font-family: inherit;
      font-size: 13px;
      caret-color: #b0f040;
    }
    input::placeholder { color: #444; }
    button {
      padding: 14px 20px;
      background: #b0f040;
      color: #0c0c0c;
      border: none;
      cursor: pointer;
      font-family: inherit;
      font-size: 12px;
      font-weight: 600;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      transition: background 0.1s;
    }
    button:hover { background: #c5ff50; }
    button:disabled { background: #2a2a2a; color: #555; cursor: not-allowed; }
    #result {
      margin-top: 20px;
      min-height: 56px;
      font-size: 13px;
    }
    .success {
      border: 1px solid #b0f040;
      padding: 16px;
      background: rgba(176,240,64,0.05);
    }
    .success-label { font-size: 10px; color: #b0f040; letter-spacing: 0.15em; text-transform: uppercase; margin-bottom: 8px; opacity: 0.6; }
    .short-url { color: #b0f040; font-size: 18px; font-weight: 600; display: flex; align-items: center; gap: 12px; }
    .short-url a { color: inherit; text-decoration: none; }
    .short-url a:hover { text-decoration: underline; }
    .copy { font-size: 10px; letter-spacing: 0.08em; background: transparent; border: 1px solid #333; color: #888; padding: 4px 10px; text-transform: uppercase; }
    .copy:hover { border-color: #b0f040; color: #b0f040; background: transparent; }
    .error { border: 1px solid #ff4545; padding: 14px 16px; color: #ff4545; font-size: 12px; }
  </style>
</head>
<body>
  <div class="card">
    <h1>// url shortener</h1>
    <div class="row">
      <input id="url" type="url" placeholder="https://your-long-url.com/..." autocomplete="off" spellcheck="false" />
      <button id="btn" onclick="shorten()">Shorten</button>
    </div>
    <div id="result"></div>
  </div>
  <script>
    document.getElementById('url').addEventListener('keydown', e => e.key === 'Enter' && shorten());

    async function shorten() {
      const input = document.getElementById('url');
      const btn = document.getElementById('btn');
      const result = document.getElementById('result');
      const url = input.value.trim();
      if (!url) return;

      btn.disabled = true;
      btn.textContent = '...';
      result.innerHTML = '';

      try {
        const res = await fetch('/shorten', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ url })
        });
        const data = await res.json();
        if (!res.ok) throw new Error(data.detail || 'error');

        const shortUrl = location.origin + '/' + data.short;
        result.innerHTML = `
          <div class="success">
            <div class="success-label">shortened</div>
            <div class="short-url">
              <a href="${shortUrl}" target="_blank">${shortUrl}</a>
              <button class="copy" onclick="copy('${shortUrl}', this)">copy</button>
            </div>
          </div>`;
        input.value = '';
      } catch(e) {
        result.innerHTML = `<div class="error">// ${e.message}</div>`;
      } finally {
        btn.disabled = false;
        btn.textContent = 'Shorten';
      }
    }

    function copy(text, el) {
      navigator.clipboard.writeText(text).then(() => {
        el.textContent = 'copied!';
        setTimeout(() => el.textContent = 'copy', 1500);
      });
    }
  </script>
</body>
</html>"""


@app.get("/", response_class=HTMLResponse)
def index():
    return HTML


@app.get("/healthz")
def health():
    return {"status": "ok", "ts": int(time.time())}


@app.post("/shorten")
async def shorten(req: Request):
    body = await req.json()
    url = body.get("url")
    if not url:
        raise HTTPException(400, "url required")

    short = hashlib.sha256(url.encode()).hexdigest()[:8]
    put_mapping(short, url)
    return {"short": short, "url": url}


@app.get("/{short_id}")
def resolve(short_id: str):
    item = get_mapping(short_id)
    if not item:
        raise HTTPException(404, "not found")
    return RedirectResponse(item["url"])