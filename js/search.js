var Hogan = require('hogan.js')

function Search(data) {
    this.data = data
    this.cache = {}
}

Search.prototype.matchArray = function(array, needle) {
    var _this = this

    return array.some(function(val) {
        return _this.match(val, needle)
    })
}

Search.prototype.match = function(str, needle) {
    return str.match(new RegExp(needle, 'i'))
}

Search.prototype.query = function(query) {
    var _this = this

    query = query.toLocaleLowerCase()

    if (!this.cache[query]) {
        var results = []

        this.data.posts.forEach(function(post) {
            if (
                _this.match(post.title, query) ||
                _this.matchArray(post.categories, query) ||
                _this.matchArray(post.tags, query)
            ) {
                results.push(post)
            }
        })

        this.data.tags.forEach(function(tag) {
            if (_this.match(tag, query)) {
                results.push({
                    type: 'tag',
                    title: tag,
                    url: '/tag/' + tag + '/'
                })
            }
        })

        this.data.categories.forEach(function(category) {
            if (_this.match(category, query)) {
                results.push({
                    type: 'category',
                    title: category,
                    url: '/category/' + category + '/'
                })
            }
        })

        this.cache[query] = results
    }

    return this.cache[query]
}

var input = document.querySelector('.search-input')
var resultsContainer = document.querySelector('.search-results')
var search
var debounce

var resultsTemplate = Hogan.compile(
    document.getElementById('tmpl-search-results').innerHTML
)

var xhr = new XMLHttpRequest()
xhr.onload = onSearchDataLoaded
xhr.open('get', '/search.json', true)
xhr.send()

function onSearchDataLoaded() {
    search = new Search(JSON.parse(this.responseText))

    // Perform an initial search in case the user was typing while the data
    // was being loaded
    performSearch(input)

    input.addEventListener('keyup', performSearch.bind(this, input))
}

function performSearch(input) {
    clearTimeout(debounce)

    debounce = setTimeout(function() {
        var query = input.value

        if (query.length > 2) {
            renderResults(query, search.query(query))
        } else {
            renderResults()
        }
    }, 150)
}

function renderResults(query, results) {
    resultsContainer.innerHTML = resultsTemplate.render({
        query: query,
        results: results,
    })
}
