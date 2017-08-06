const RESOURCE_CACHE = 'wildlyinaccurate-resources'
const baseUrl = new URL('./', self.location)

self.addEventListener('fetch', event => {
  const requestUrl = new URL(event.request.url)

  if (requestUrl.origin === baseUrl.origin) {
    event.respondWith(networkFirst(event.request))
  }
})

function networkFirst (request) {
  return fetch(request)
    .then(response => {
      caches.open(RESOURCE_CACHE).then(cache => {
        cache.put(request, response)
      })

      return response.clone()
    })
    .catch(() => caches.match(request))
}
