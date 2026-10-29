const C="ss-live-6";
self.addEventListener("install",e=>{e.waitUntil(caches.open(C).then(c=>c.addAll(["/","/manifest.webmanifest","/icon-192.png"])));self.skipWaiting();});
self.addEventListener("activate",e=>{e.waitUntil(caches.keys().then(k=>Promise.all(k.filter(x=>x!==C).map(x=>caches.delete(x)))).then(()=>clients.claim()));});
self.addEventListener("fetch",e=>{const r=e.request,u=new URL(r.url);
if(r.method!=="GET"||u.pathname.startsWith("/__/")||!(u.origin===location.origin||["www.gstatic.com","fonts.googleapis.com","fonts.gstatic.com"].includes(u.hostname)))return;
e.respondWith(caches.open(C).then(async c=>{const hit=await c.match(r);const net=fetch(r).then(x=>{if(x.ok||x.type==="opaque")c.put(r,x.clone());return x;}).catch(()=>hit);return hit||net;}));});
