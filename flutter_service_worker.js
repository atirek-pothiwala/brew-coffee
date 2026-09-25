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
"flutter_bootstrap.js": "7db5263ede78bed28cd4d7a272971383",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"version.json": "639510c52e339f685c2bb0be4c3633d7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "142c682d4557eea2b3c6a0e2d973ed10",
"assets/fonts/MaterialIcons-Regular.otf": "e24e4b61b02a2e51d503a98ee2121c61",
"assets/AssetManifest.bin.json": "8a8e31302821d3543929e0a0fdd4e4a8",
"assets/AssetManifest.json": "cf9458f284b962c5d48fa6f82566d6ae",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "a4a3e32a562cb24e140f29381e4fbf09",
".git/COMMIT_EDITMSG": "a317b00a5ce68bac3150d4d98eeecb06",
".git/logs/HEAD": "9db265ab0f35d8429a77f1778e5d6f60",
".git/logs/refs/heads/gh-pages": "9db265ab0f35d8429a77f1778e5d6f60",
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
".git/refs/heads/gh-pages": "4efbafc8edfacf14672f06c02b811572",
".git/objects/57/5ac8c8c68644379173f67afb8b7a783a0d3332": "f1b9bfe95c9f9c5fbd913b6626a90c67",
".git/objects/2d/4fd81df08a80ac1221bdc17141e76171cd219a": "032abd535523db9dd5eed7651d179dbf",
".git/objects/2d/c9ece5a93692d78c87da1c151998b0f3eb4c77": "97d0f6cd51404deff7f81d96e6c22217",
".git/objects/b3/595b351edc5fd64d6de4e46918d8f3421855a7": "720bfe167042c44f79c8fe8a9341c402",
".git/objects/b3/3ab3a370ff72435f7e20dad5571c4ca05d0645": "f1dee6633befde51d75dec0ec6d514f0",
".git/objects/a0/e58dd982d82d183d1ea283cad923d147e21308": "1049bd4400865035bb5632360622972c",
".git/objects/f5/569f5d26e11071c04c2f2a0e0cfa9c0fe717de": "dca32b571cbc403e5e45a436d57f0553",
".git/objects/45/f86635a13057e7b1f205d8cbfe5939434bbfcb": "666485aff011fbb32fd0f354d855a8f0",
".git/objects/dd/bd79bed5d41b98368f47779b7a39d03dcea2dc": "5631fa14147f7c1eca9c32e3dc70d359",
".git/objects/d6/9c56691fbdb0b7efa65097c7cc1edac12a6d3e": "868ce37a3a78b0606713733248a2f579",
".git/objects/d6/5ec859cb3ac985fc27c420282771329a7cb092": "745dbc78e57678f5cd29869ec2c3f232",
".git/objects/5b/69eea5c80f52bed059db586224d303f25d4d1d": "a70944e24a06a647e4b7467d069842af",
".git/objects/61/5eb4baae72b059c96b660a766836e082fabf31": "3c348eb291d9146d172671db917a7b3c",
".git/objects/03/a53eaf1d204f20f84d8d6e02e644de6d0109f6": "f59411df02890a95fd15858d7f0b1b15",
".git/objects/12/46ba333aa8a0a1965b457a4faff286069da88e": "8bc58e0672fefd2351e963ab1c50400f",
".git/objects/e5/ad86a1cf88a53480540fc99e353561d27e608d": "435996602a330472f05f9b65e7af69e9",
".git/objects/46/4ab5882a2234c39b1a4dbad5feba0954478155": "2e52a767dc04391de7b4d0beb32e7fc4",
".git/objects/25/8b3eee70f98b2ece403869d9fe41ff8d32b7e1": "05e38b9242f2ece7b4208c191bc7b258",
".git/objects/3a/7525f2996a1138fe67d2a0904bf5d214bfd22c": "ab6f2f6356cba61e57d5c10c2e18739d",
".git/objects/30/65ffc7958f4eb9bfdf66fc563e83dbae7c5c55": "ea53c8b3e31f7c1be260343d884f4f0c",
".git/objects/db/ea5e03ade0e33d5120e45a95cadb524b8b03f9": "63f77efedc78755abf2607ba346303d6",
".git/objects/8c/48083fe17066fee51c7c5c8c957633d6920eac": "1f6df9c671e4722eefbf6835828ee3c4",
".git/objects/b1/4993470993573a189ae8ac4c9a91514b8c18a5": "232eb2b88efa90b6ee67ac1052ef15ad",
".git/objects/b1/5ad935a6a00c2433c7fadad53602c1d0324365": "8f96f41fe1f2721c9e97d75caa004410",
".git/objects/b1/f5525c19c12e389610c093d64a3bfa42558a39": "135e5945b3bdb618ebdd2ff4d7fa9c7f",
".git/objects/98/57c9b3b0448c92818efc5fda0f206b21914168": "ecbde07c564dabbec0f249821051b8af",
".git/objects/91/6fac4ced38f335b3c94a2ed1dd0a6d4fcb7a45": "66de93e279f87c9e591094c744d0864b",
".git/objects/91/4ef390c3df00fe982521c9979a35e01b4ca8bb": "3760e0994fbd6da37dd7d4de424be38f",
".git/objects/0f/ffb94923b2fbafe0714ac4c20a4d76dea16a9b": "49b73a71ccf084506bd9864f05925eec",
".git/objects/bc/84b78d67a0203b56bc9d624e4ed516f81428e9": "78aec4d38822bdaefb94385b240a02b2",
".git/objects/c2/602fd71c763a9a2487ed20d577616ae9147adf": "c22fb6be68a26a3e4655bcee57b06e4a",
".git/objects/d2/474f86128b6656bc905d7e332f21c731c8279f": "f5e20e7f4a1ec9d4050dee498fed03e3",
".git/objects/a3/1de88e307337d8796f39c883da9c5e83c25b88": "ad0aa23010ee88ba9c9fb3b5ae3a1bde",
".git/objects/7c/a1de8736dd1d9b621434ac9c54baebfbe67548": "4890e87274c564ad46c07adc311bffcb",
".git/objects/7c/e6545455e776af06857c302dc553467599e946": "ac613e042f4456ef1f086d53b411b07f",
".git/objects/e3/df0edef592ddbf9b45749c9af505db9a62a6b5": "6de46485ff9286c42ee1c0672f94727d",
".git/objects/89/2f29291da438570f94ae3ddfeb406171f00deb": "451a7e4c1c2ccbfa25eb79738a841270",
".git/objects/b9/2a0d854da9a8f73216c4a0ef07a0f0a44e4373": "f62d1eb7f51165e2a6d2ef1921f976f3",
".git/objects/ec/b5e2110a3c83dcc38ca02c23b3992fe769c1ec": "91206c8b3116b2e993a838884d40b295",
".git/objects/b5/2a09bdc4e003b92625783139187663bc59a0e6": "ebe891f82dd14dd336f1caf849e7717c",
".git/objects/c9/e5b5e46dc65e545b7bfb6268907064c0a18d7c": "cb54ff5d99b5beeb3a188fe7ea73ba15",
".git/objects/c9/ed84d3d28a40b66eedc63db4de304643d56809": "f4f7dec0cb83c175abd87095aa700d10",
".git/objects/c9/8c1cb02224d08a1bafe3fcd07a217de089edf6": "5c0009d7caf8524769ef513aa5fd4fcf",
".git/objects/c9/6827e393ebb57059144de098e953e05b5fdc36": "6de17b17510b4f0c7e7e430c0e6f497e",
".git/objects/6e/d36b386833eaa3da4625be2740d06d63b5ced3": "6b5e6905346b7468a76025521aa65c3a",
".git/objects/79/bd13f252018ee7b100bc6d5147113458fae57c": "becd8acf5aa5e19d889638d48aef4b14",
".git/objects/17/7c28f75da3b9d0048a6e15cdfa829238bcc6aa": "5ff1e198d74caa4ed3ce38432f0724bd",
".git/objects/00/114ea13af33fd1e1efc2c839c5e7e0eca669c8": "1fb353239c8f67a4c112206f5e0baa12",
".git/objects/0b/e748f1a269ea639aa3063415f2f33761a3dfed": "94c8f3af20b3057b7cc0032585bc0066",
".git/objects/f4/9b4d15cf59af91f57a26133368830e5133c103": "5e8a1424c7b5f8952a258c142dd2975a",
".git/objects/a1/e739cc397a1b73edf0f068c04b67751ee251d7": "ad1f9abb0dfdfd0dfadc3e27ecbc5618",
".git/objects/a1/a931a590ca458c97257de52c0f409e9031d360": "4a1e14bb1f4507f74e6bf142ba1bb349",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b7/b75bdd75fa79de7c91506d35612c0dea89ef67": "dab0bcbf07686805bfd06e28b2ee8ed3",
".git/objects/29/f1c83818f790331e5ee058fdb8c8f068f63d66": "4e21b353eb57809a4ab3843922962560",
".git/objects/29/e94323ac92e030640a57c680324017b0d2f3b1": "c0577299613e71a6d9cfe34169d465b6",
".git/objects/de/f27fb40584a14fe41b95978f436f8eda0f10a2": "fb5c4639cd76481b893e2189982ffefe",
".git/objects/fa/5f7fa7ededa4a43513fa95d249b1810739c279": "7ed31d2559bd7c0d71b8761dd7e68a65",
".git/objects/33/cc2a1a973e4f781248278ce5dffcbb2681ffec": "34c80fa1dfe1927281dbbc3d8a0679f3",
".git/objects/84/0516208d35dcb4298847ab835e2ef84ada92fa": "36a4a870d8d9c1c623d8e1be329049da",
".git/objects/08/32d0db2def1613c1c45aa4fe9156a1c6b7d589": "e05df183e5eeaddf39672a2516f9c41d",
".git/objects/08/b0391c0d20264951a37dde82ce48aecfd2156a": "1fbab6cb8b4dba7c33be77d72703dad2",
".git/objects/fe/4ebfd4680a5fd9d4f93e797cfda7376a34b9f9": "9fb607aff25430edd4fd7ccc85dc6618",
".git/objects/af/a25cb97d945aa6aae856cac3a9e73af99a27a7": "b4322a26ed4cf3656dfe5608b30c1b06",
".git/objects/55/40c518fc82e3545f6016cbdcbfcbe5f7a5b253": "d301833c025f89fc72608fc46dda756b",
".git/objects/55/a48a531d1075eae58b2524812dbf35c3b76ab2": "cdaa5624416ebef892b46ad4f0504a0e",
".git/objects/d5/64d0bc3dd917926892c55e3706cc116d5b165e": "ab5f20dcd5b558888db7d80b0f979f8a",
".git/objects/d5/bb50b3c3bc534b51ba035a5e8495ba7af5025b": "81d30e6f235d2cd1960b1a0d917b3043",
".git/objects/ca/9eaed5981bf43098d8a81dd6ac62d4696c8306": "d2c726ea9ba389af69470f48dbd0d2d7",
".git/objects/85/6a39233232244ba2497a38bdd13b2f0db12c82": "eef4643a9711cce94f555ae60fecd388",
".git/objects/9b/c89cc98fc3c3d0b8061208b61effadc955c7d6": "2a3eb6599e7053e5612f5a116734a827",
".git/objects/9b/98927f29ab1d63595e270c9eadb9809f2e0880": "96e1a7e0236bb6f7a3352b9dbcbddb59",
".git/objects/13/a65755172ef38f492e46bbeb928760f59b9519": "982c26e0184970b2fee9bcc3cbfa930d",
".git/objects/90/bcfcf0a77ab618a826db0fd8b0942963b653af": "fc109675cdf1233dd6599a4c3c0a7a69",
".git/objects/d1/9c7275c85442399f85f4c23346949beb245f46": "ac3f23884b29f33f1a5655ade7ac87fb",
".git/objects/82/73c97bd97caaf8502e379c9d1320824f5eeff4": "783a695d48373ccf50e5e0ccccfa3b10",
".git/objects/92/b948ea1bba735d52adb51c006a5e5ab672aa55": "1d98b428f1e620867deb6c2bbfe1ebe6",
".git/objects/9a/340f21af0709f3b9082d83395dfd981794c2b0": "ae8bce828f00fb3fcf8d4b7f79f24e92",
".git/objects/ba/5317db6066f0f7cfe94eec93dc654820ce848c": "9b7629bf1180798cf66df4142eb19a4e",
".git/objects/1a/9579efd2056bdf6b915c1425ed744663027ca2": "692d02f79994fdf790cd45bf36147c1a",
".git/objects/4c/568473b52ac011111d3e2eee5f4307911cce63": "d324974547aa0886c680a3354b0a87b3",
".git/objects/18/6b89fba28f528772337c2aa823b7683183853f": "aa58a7a5a47846b3e58759828ecbc54a",
".git/objects/f0/36fb164d114e74e867cf768ef96e2291bf1b3c": "a35ecf851b5f616a4a8aff0931dcd29d",
".git/objects/21/d062750739afbcd0096137427b19e5e77e7476": "ff537a706ecf9541a10ac5de587ba0fe",
".git/objects/1c/3a23b2c765598de01f0b5598fd1871f74eec9f": "d639094f477a996fedd156a6c65749d1",
".git/objects/40/0d5b186c9951e294699e64671b9dde52c6f6a0": "f6bd3c7f9b239e8898bace6f9a7446b9",
".git/objects/40/ed90f6b41806d7913de5c5380b325bf21fb78a": "ff21e6e8ab7c970df6e951fecad798d0",
".git/objects/7e/e9b6d31751c7ef108ca9e246cb677bb3def7ee": "1116911148538dfc438421dccb389fed",
".git/objects/1b/cd2b88c262164015517a190617b0fcd75e26e4": "051a379d1627d0a04708df9499f98b16",
".git/objects/1f/45b5bcaac804825befd9117111e700e8fcb782": "7a9d811fd6ce7c7455466153561fb479",
".git/objects/54/e71d29171cd521b6f06ff458b5335b762a0ac7": "9c446bd1cc730f1cdbdb7dedbee6a8a9",
".git/objects/da/9152862eb93baaf3b98e5aff0aeba09a4e8d24": "c90f31d51cab5dff71097c0b8131542f",
".git/objects/da/fd65422747502c19b5c74b4230282644d2169c": "d8a62caf99a372ff6c7692e143787ce3",
".git/objects/da/64aadc21cc3160dded25b4c2ac99eb2bc6bbd1": "63af029b42b8ed95e1c1909a59763544",
".git/objects/73/ec43a24cf49b21816554c1d81d3188f0150e05": "bad9caa88ebab646a63b4b7f34f9e865",
".git/objects/d4/3532a2348cc9c26053ddb5802f0e5d4b8abc05": "3dad9b209346b1723bb2cc68e7e42a44",
".git/objects/d4/7916a730892454597f71b1d2f290fe7fb53271": "f9cd40b11e4fbcfc18f8e4f372fbbb18",
".git/objects/8e/a9b524514985abfa444f5285194c220d480f91": "5aa8b5552f91c5cebaa95b7fbd8ad0de",
".git/objects/70/b954bc1adeb7a85f010420837024ca9673b92f": "e5fb5e9728d266b8c5e7552bb4489a38",
".git/objects/e2/ffb189e9e9cf433332dc800cdde840e1dde7ef": "2cec9828af76d55392f0434a058abab2",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/3b/c65412543be4ce4a57278486d79c2c139a922f": "526d4ac4a22dd358f8b76310eeab28f0",
".git/objects/8a/ecd9cab401a7751e76de7aaa788a1b3050dc8d": "f82de8ef811848c5760dc925f2dbd96c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/aa/262e926d67a8524149e08776aa7a2f28bb322a": "490c2c078705f4e82ebe58b9cbfc3df6",
".git/objects/aa/1f125519625c880707e300de23a4103c355d21": "0f6e7a71e54056966bac09bbe1e7cd6d",
".git/objects/aa/5c71460eaf5bc8664c8cdbfa5c238989fa2e11": "aa7e19c393b0a19697b0d1f3075d5812",
".git/objects/6b/d48b40649557003b45c031928c92a358777782": "8d2231b96fa2bbe709d054e006507029",
".git/objects/6b/e909fbf40b23748412f0ea89bf0fae827ed976": "5f118419157d9534688915220cc803f7",
".git/objects/ad/b1fac2e8c50adb773f2a015712bd1e378e30f5": "6b76598cc11f9a8e717895063c4e6550",
".git/objects/ce/03197e44416594d3daee1729f092fc9d80c30c": "9097871bc0c1e69267b5b3faf7d0e684",
".git/objects/44/a8b8e41b111fcf913a963e318b98e7f6976886": "5014fdb68f6b941b7c134a717a3a2bc6",
".git/objects/f2/04823a42f2d890f945f70d88b8e2d921c6ae26": "6b47f314ffc35cf6a1ced3208ecc857d",
".git/objects/f2/f6b7e642fa37a26afe6bad299cbadee0f724f4": "e3737ca205ff7e1178999bb585bce54c",
".git/objects/eb/9b4d76e525556d5d89141648c724331630325d": "37c0954235cbe27c4d93e74fe9a578ef",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/32/aa3cae58a7432051fc105cc91fca4d95d1d011": "4f8558ca16d04c4f28116d3292ae263d",
".git/objects/27/264ca12a33e0ef775c1f4ea3019aa58cb89fea": "9c02c4fc16b584b2b60307cc9786a2d6",
".git/objects/d0/23371979cf1e985205df19078051c10de0a82d": "700b71074bad7afee32068791dec7442",
".git/objects/f1/a215a5cb8d619cc9de8b94dc25293d8d7e59f4": "2405b181ddb7b82c3f96652d1ca6ffdf",
".git/objects/4d/936e0465ad24c9075b58a7fc6e6c4fad057a9b": "80f9af1d5aa6ad906de9245c58cd7109",
".git/objects/4d/f4984b64bf1d9a482efb07235fe1369df54371": "3a4208271103b145f39e2350f81318ca",
".git/objects/4d/5117260465286be764e2bfc110f28289286808": "2b1dc98bab5e5d286c9fb2a0a146b846",
".git/objects/3e/8ecd26e35ba35aaa6625b12ebe7646699bf2e9": "80f787363245952852a5bc0c87f1e8e9",
".git/objects/8d/97baa405ee5b3f5df5b381e39f14ff439d3379": "c058c4c7c81593bfe7ca4c472a21c9e8",
".git/objects/8d/c994c3038d4e20e1597ff4c127328efacd8d87": "f0990d44ef43af70b87de294f34836ca",
".git/index": "135e9ea8fc698737becc9aa3df90bce0",
"index.html": "8061e2ad0322cb42098d1f70cc3fa1f3",
"/": "8061e2ad0322cb42098d1f70cc3fa1f3",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"main.dart.js": "416592f753eadd7014d1579f463cd73a",
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
