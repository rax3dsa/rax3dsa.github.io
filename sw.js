/* RAX3D invoicing app: service worker ONLY for «🛒 طلب جديد» phone notifications (Web Push). No caching, no fetch handler: the app loads exactly as before. */
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('push', e => {
  let d = {}; try { d = e.data ? e.data.json() : {}; } catch (_) { d = { b: e.data ? e.data.text() : '' }; }
  e.waitUntil(self.registration.showNotification(d.t || 'RAX3D', { body: d.b || '', icon: 'icon.png', badge: 'icon.png', tag: 'rax3d-order', renotify: true, data: { u: d.u || '' } }));
});
self.addEventListener('notificationclick', e => {
  e.notification.close();
  e.waitUntil(self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then(l => { for (const c of l) { if ('focus' in c) return c.focus(); } return self.clients.openWindow('./'); }));
});
