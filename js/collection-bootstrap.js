var Elm = require('./compiled/Collection')

var mountPoint = document.createElement('div')
var staticContainer = document.querySelector('.collection-container')

Elm.Main.embed(
    mountPoint,
    getData()
)

staticContainer.innerHTML = ''
staticContainer.parentNode.appendChild(mountPoint)

function getData() {
    var container = document.querySelector('article')
    var items = container.querySelectorAll('[data-collection-item]')

    var data = [].slice.call(items).map(function(item) {
        return {
            title: item.querySelector('[data-title]').textContent,
            url: item.querySelector('[data-url]').getAttribute('href'),
            description: item.querySelector('[data-description] > p').innerHTML,
            category: item.getAttribute('data-category'),
            tags: JSON.parse(item.getAttribute('data-tags'))
        }
    })

    return {
        items: data,
        filters: []
    }
}
