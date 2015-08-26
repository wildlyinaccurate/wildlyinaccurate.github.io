(function() {

    'use strict'

    Elm.embed(
        Elm.Main,
        document.querySelector('.collection-container'),
        { getFixtures: getData() }
    )

    function getData() {
        var container = document.querySelector('.post-content')
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

})()
