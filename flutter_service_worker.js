'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"manifest.json": "35b88d0749141eb3b0bffd76aebefa29",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"flutter_bootstrap.js": "a1d9e532c2061c403ba39ffd1467a04a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "639510c52e339f685c2bb0be4c3633d7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/sounds/power_on.wav": "82f01632200f3f6462936373218eaf19",
"assets/assets/sounds/blip.wav": "d0463a55d52e5ae3985b53376fd9def4",
"assets/assets/sounds/complete.wav": "f16694c9400b5076d9907c571b6afd2a",
"assets/assets/sounds/brew.wav": "87f54ca6e7772548f65fbb0157a8dada",
"assets/assets/sounds/steam.wav": "a91c6789b1bb63618d63e7ee1335c8a6",
"assets/assets/sounds/pour.wav": "7620e8326f9ac8facd38ef9528b85f5c",
"assets/assets/sounds/grind.wav": "54211b31ade5058df987fdc703ace9ea",
"assets/assets/images/espresso_machine.jpg": "e7b98ea83f838de63040911668a689af",
"assets/NOTICES": "f62ec6886562f2743846a8a39e15c443",
"assets/fonts/MaterialIcons-Regular.otf": "d95ed6dcfb2225a712b56bc04b57978e",
"assets/AssetManifest.bin.json": "1ba078731bc801ec8588eb2762fdcae1",
"assets/AssetManifest.json": "674acfa6c8d46639061fc76904e63b29",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "ad1666f3d223ed05b4309ef9339c41ee",
".git/COMMIT_EDITMSG": "93211848693005ae7aefef20d8b4b30b",
".git/logs/HEAD": "a182d6d2eb3b7cf1f9d28f71eb1c8e65",
".git/logs/refs/heads/gh-pages": "a182d6d2eb3b7cf1f9d28f71eb1c8e65",
".git/config": "07da3af1517e77937b09cc039da45e99",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/push-to-checkout.sample": "c7ab00c7784efeadad3ae9b228d4b4db",
".git/hooks/pre-commit.sample": "305eadbbcd6f6d2567e033ad12aabbc4",
".git/hooks/pre-push.sample": "2c642152299a94e05ea26eae11993b13",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/sendemail-validate.sample": "4d67df3a8d5c98cb8565c07e42be0b04",
".git/hooks/pre-merge-commit.sample": "39cb268e2a85d436b9eb6f47614c3cbc",
".git/hooks/fsmonitor-watchman.sample": "a0b2633a2c8e97501610bd3f73da66fc",
".git/hooks/update.sample": "647ae13c682f7827c22f5fc08a03674e",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/HEAD": "5ab7a4355e4c959b0c5c008f202f51ec",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/refs/heads/gh-pages": "b138a204264be96cfb25f1bd23a91272",
".git/objects/b3/595b351edc5fd64d6de4e46918d8f3421855a7": "720bfe167042c44f79c8fe8a9341c402",
".git/objects/b3/3ab3a370ff72435f7e20dad5571c4ca05d0645": "f1dee6633befde51d75dec0ec6d514f0",
".git/objects/45/f86635a13057e7b1f205d8cbfe5939434bbfcb": "666485aff011fbb32fd0f354d855a8f0",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d6/5ec859cb3ac985fc27c420282771329a7cb092": "745dbc78e57678f5cd29869ec2c3f232",
".git/objects/5b/69eea5c80f52bed059db586224d303f25d4d1d": "a70944e24a06a647e4b7467d069842af",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/30/65ffc7958f4eb9bfdf66fc563e83dbae7c5c55": "ea53c8b3e31f7c1be260343d884f4f0c",
".git/objects/8c/48083fe17066fee51c7c5c8c957633d6920eac": "1f6df9c671e4722eefbf6835828ee3c4",
".git/objects/b1/4993470993573a189ae8ac4c9a91514b8c18a5": "232eb2b88efa90b6ee67ac1052ef15ad",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/91/6fac4ced38f335b3c94a2ed1dd0a6d4fcb7a45": "66de93e279f87c9e591094c744d0864b",
".git/objects/bc/84b78d67a0203b56bc9d624e4ed516f81428e9": "78aec4d38822bdaefb94385b240a02b2",
".git/objects/89/2f29291da438570f94ae3ddfeb406171f00deb": "451a7e4c1c2ccbfa25eb79738a841270",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/c9/6827e393ebb57059144de098e953e05b5fdc36": "6de17b17510b4f0c7e7e430c0e6f497e",
".git/objects/17/7c28f75da3b9d0048a6e15cdfa829238bcc6aa": "5ff1e198d74caa4ed3ce38432f0724bd",
".git/objects/00/114ea13af33fd1e1efc2c839c5e7e0eca669c8": "1fb353239c8f67a4c112206f5e0baa12",
".git/objects/0b/e748f1a269ea639aa3063415f2f33761a3dfed": "94c8f3af20b3057b7cc0032585bc0066",
".git/objects/f4/9b4d15cf59af91f57a26133368830e5133c103": "5e8a1424c7b5f8952a258c142dd2975a",
".git/objects/a1/a931a590ca458c97257de52c0f409e9031d360": "4a1e14bb1f4507f74e6bf142ba1bb349",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/29/f1c83818f790331e5ee058fdb8c8f068f63d66": "4e21b353eb57809a4ab3843922962560",
".git/objects/33/cc2a1a973e4f781248278ce5dffcbb2681ffec": "34c80fa1dfe1927281dbbc3d8a0679f3",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/08/b0391c0d20264951a37dde82ce48aecfd2156a": "1fbab6cb8b4dba7c33be77d72703dad2",
".git/objects/55/40c518fc82e3545f6016cbdcbfcbe5f7a5b253": "d301833c025f89fc72608fc46dda756b",
".git/objects/d5/64d0bc3dd917926892c55e3706cc116d5b165e": "ab5f20dcd5b558888db7d80b0f979f8a",
".git/objects/d5/bb50b3c3bc534b51ba035a5e8495ba7af5025b": "81d30e6f235d2cd1960b1a0d917b3043",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/9b/c89cc98fc3c3d0b8061208b61effadc955c7d6": "2a3eb6599e7053e5612f5a116734a827",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/82/73c97bd97caaf8502e379c9d1320824f5eeff4": "783a695d48373ccf50e5e0ccccfa3b10",
".git/objects/92/b948ea1bba735d52adb51c006a5e5ab672aa55": "1d98b428f1e620867deb6c2bbfe1ebe6",
".git/objects/9a/340f21af0709f3b9082d83395dfd981794c2b0": "ae8bce828f00fb3fcf8d4b7f79f24e92",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/18/6b89fba28f528772337c2aa823b7683183853f": "aa58a7a5a47846b3e58759828ecbc54a",
".git/objects/21/d062750739afbcd0096137427b19e5e77e7476": "ff537a706ecf9541a10ac5de587ba0fe",
".git/objects/1c/3a23b2c765598de01f0b5598fd1871f74eec9f": "d639094f477a996fedd156a6c65749d1",
".git/objects/40/0d5b186c9951e294699e64671b9dde52c6f6a0": "f6bd3c7f9b239e8898bace6f9a7446b9",
".git/objects/1b/cd2b88c262164015517a190617b0fcd75e26e4": "051a379d1627d0a04708df9499f98b16",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/da/9152862eb93baaf3b98e5aff0aeba09a4e8d24": "c90f31d51cab5dff71097c0b8131542f",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/da/64aadc21cc3160dded25b4c2ac99eb2bc6bbd1": "63af029b42b8ed95e1c1909a59763544",
".git/objects/73/ec43a24cf49b21816554c1d81d3188f0150e05": "bad9caa88ebab646a63b4b7f34f9e865",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/7916a730892454597f71b1d2f290fe7fb53271": "f9cd40b11e4fbcfc18f8e4f372fbbb18",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/3b/c65412543be4ce4a57278486d79c2c139a922f": "526d4ac4a22dd358f8b76310eeab28f0",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/f1/a215a5cb8d619cc9de8b94dc25293d8d7e59f4": "2405b181ddb7b82c3f96652d1ca6ffdf",
".git/objects/4d/936e0465ad24c9075b58a7fc6e6c4fad057a9b": "80f9af1d5aa6ad906de9245c58cd7109",
".git/objects/4d/f4984b64bf1d9a482efb07235fe1369df54371": "3a4208271103b145f39e2350f81318ca",
".git/objects/4d/5117260465286be764e2bfc110f28289286808": "2b1dc98bab5e5d286c9fb2a0a146b846",
".git/index": "39334621e814ebdd125828cfd236019c",
"index.html": "8061e2ad0322cb42098d1f70cc3fa1f3",
"/": "8061e2ad0322cb42098d1f70cc3fa1f3",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"main.dart.js": "dc485c855f2f7a9fb4eb2f64dfed957f",
"flutter.js": "f393d3c16b631f36852323de8e583132"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
