const RESOURCE_CACHE = 'wildlyinaccurate-resources'
const baseUrl = new URL('./', self.location)

self.addEventListener('fetch', event => {
  const requestUrl = new URL(event.request.url)

  if (requestUrl.origin === baseUrl.origin) {
    if (requestUrl.pathname.substr(0, 8) === '/assets/') {
      event.respondWith(staleWhileRevalidate(event.request))
    } else {
      event.respondWith(networkFirst(event.request))
    }
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

function staleWhileRevalidate (request) {
  return caches.open(RESOURCE_CACHE).then(cache =>
    cache.match(request).then(response => {
      const fetchPromise = fetch(request).then(networkResponse => {
        cache.put(request, networkResponse.clone())

        console.debug('Cache updated for', request.url)

        return networkResponse
      }).catch(() => {
        console.debug('Using stale cache for', request.url)
      })

      return response || fetchPromise
    })
  )
}
