'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "/index.html": "b74b62d6f76f88bd7c884ef147eb3244",
"/main.dart.js": "e352c8e26ca3950c1b168046de26e102",
"/assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"/assets/FontManifest.json": "ed9cd32fa597ae46abed4ac894b9902b",
"/assets/AssetManifest.json": "af86a51f89c0cfbb21b219f395727974",
"/assets/LICENSE": "5e27a695a27ed685068473e2e16578d1",
"/assets/assets/images/player.png": "b2feeca37713e6e35e8915d1e2028ac3",
"/assets/assets/images/bullet.png": "8eca41372586b4d2446c22bee1fe77f2",
"/assets/assets/images/explosion.png": "81a3691935a18a30572870b759ad1683",
"/assets/assets/images/stars.png": "839baa9b3605e008cb4008d3be7f048a",
"/assets/assets/images/enemy.png": "8dfb2f04967b1156a257c05f282ff8c6"
};

self.addEventListener('activate', function (event) {
  event.waitUntil(
    caches.keys().then(function (cacheName) {
      return caches.delete(cacheName);
    }).then(function (_) {
      return caches.open(CACHE_NAME);
    }).then(function (cache) {
      return cache.addAll(Object.keys(RESOURCES));
    })
  );
});

self.addEventListener('fetch', function (event) {
  event.respondWith(
    caches.match(event.request)
      .then(function (response) {
        if (response) {
          return response;
        }
        return fetch(event.request, {
          credentials: 'include'
        });
      })
  );
});
