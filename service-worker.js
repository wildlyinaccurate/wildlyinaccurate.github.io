const RESOURCE_CACHE='wildlyinaccurate-resources',baseUrl=new URL('./',self.location);self.addEventListener('fetch',(f)=>{const g=new URL(f.request.url);g.origin===baseUrl.origin&&f.respondWith(staleWhileRevalidate(f.request))});function staleWhileRevalidate(f){return caches.open(RESOURCE_CACHE).then((g)=>g.match(f).then((h)=>{const i=fetch(f).then((j)=>{return g.put(f,j.clone()),console.debug('Cache updated for',f.url),j}).catch(()=>{console.debug('Using stale cache for',f.url)});return h||i}))}
