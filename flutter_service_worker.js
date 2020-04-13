'use strict';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "index.html": "b74b62d6f76f88bd7c884ef147eb3244",
"/": "b74b62d6f76f88bd7c884ef147eb3244",
"main.dart.js": "70bd7e051021d2b6b3e36d057ff81b97",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "1c9459b79e5b55d22bec15cdbc790f1f",
"assets/LICENSE": "950d71e53e1d7229a0e6b9569adeba07",
"assets/AssetManifest.json": "3c296ef2d3ad438a079a6c55c801e17c",
"assets/FontManifest.json": "ed9cd32fa597ae46abed4ac894b9902b",
"assets/fonts/MaterialIcons-Regular.ttf": "56d3ffdef7a25659eab6a68a3fbfaf16",
"assets/assets/images/bullet.png": "8eca41372586b4d2446c22bee1fe77f2",
"assets/assets/images/enemy.png": "8dfb2f04967b1156a257c05f282ff8c6",
"assets/assets/images/stars.png": "839baa9b3605e008cb4008d3be7f048a",
"assets/assets/images/explosion.png": "81a3691935a18a30572870b759ad1683",
"assets/assets/images/player.png": "b2feeca37713e6e35e8915d1e2028ac3",
"assets/assets/audio/space-idea.mp3": "215e92c4c7f3f21f44ec4b647720f21b",
"assets/assets/audio/small-explosion.wav": "fc248495b0a6b700d81941f477fe70fe"
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
        return fetch(event.request);
      })
  );
});
