const CACHE_NAME = 'zigclip-v1';
const URLS_TO_CACHE = [
  './',
  './index.html',
  './manifest.json',
  './css/reset.css',
  './css/theme.css',
  './css/components.css',
  './css/screens.css',
  './css/animations.css',
  './js/app.js',
  './js/arena.js',
  './js/videoManager.js',
  './js/eloSystem.js',
  './js/ranking.js',
  './js/brag.js',
  './js/storage.js',
  './js/effects.js',
  './js/dataManager.js',
  './data/clips.json',
  './assets/sounds/kill.mp3'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('SW: Caching static assets');
        return cache.addAll(URLS_TO_CACHE);
      })
      .catch(err => console.warn('SW: Cache install failed', err))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('SW: Deleting old cache', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
  self.clients.claim();
});

self.addEventListener('fetch', event => {
  const { request } = event;
  const url = new URL(request.url);
  
  if (url.pathname.includes('/data/clips.json')) {
    event.respondWith(
      fetch(request)
        .then(response => {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(request, responseClone));
          return response;
        })
        .catch(() => caches.match(request))
    );
  } else if (url.pathname.includes('/assets/videos/')) {
    event.respondWith(
      caches.match(request).then(cached => {
        if (cached) return cached;
        return fetch(request).then(response => {
          const responseClone = response.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(request, responseClone));
          return response;
        });
      })
    );
  } else {
    event.respondWith(
      caches.match(request)
        .then(cached => cached || fetch(request))
        .catch(() => caches.match('./index.html'))
    );
  }
});
