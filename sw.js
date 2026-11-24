// Offline-Speicher: Das Spiel funktioniert nach dem ersten Öffnen auch ohne Internet.
// Neue Versionen werden im Hintergrund geladen und beim nächsten Start benutzt.
const CACHE = 'mein-pferd-1.4.0';
const FILES = ['./', 'index.html', 'manifest.webmanifest', 'icon-180.png', 'icon-192.png', 'icon-512.png', 'icon-maskable-512.png'];
self.addEventListener('install', e => { e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES))); self.skipWaiting(); });
self.addEventListener('activate', e => {
  e.waitUntil(caches.keys().then(ks => Promise.all(ks.filter(k => k !== CACHE).map(k => caches.delete(k)))).then(() => self.clients.claim()));
});
self.addEventListener('fetch', e => {
  const req = e.request;
  if (req.method !== 'GET' || new URL(req.url).origin !== location.origin) return;
  // Die Spielseite selbst: zuerst aus dem Netz holen, damit ein Update sofort beim Öffnen da ist.
  // Ohne Internet (oder nach 4 Sekunden) kommt die gespeicherte Version.
  if (req.mode === 'navigate' || new URL(req.url).pathname.endsWith('/index.html')) {
    e.respondWith(caches.open(CACHE).then(async c => {
      const hit = await c.match('index.html');
      const net = fetch(req, { cache: 'no-store' }).then(res => { if (res.ok) c.put('index.html', res.clone()); return res; });
      const slow = new Promise(r => setTimeout(() => r(null), 4000));
      try { return (await Promise.race([net, slow])) || hit || await net; } catch (err) { return hit || Response.error(); }
    }));
    return;
  }
  e.respondWith(caches.open(CACHE).then(async c => {
    const hit = await c.match(req, { ignoreSearch: true });
    const net = fetch(req).then(res => { if (res.ok) c.put(req, res.clone()); return res; }).catch(() => hit);
    return hit || net;
  }));
});
