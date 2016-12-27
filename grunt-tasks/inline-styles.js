var cheerio = require('cheerio')

module.exports = function(grunt) {
    grunt.registerMultiTask('inlinestyles', 'Inlines external stylesheets if they are small enough', function() {
        this.files.forEach(function(file) {
            var path = file.src.toString()
            var $ = cheerio.load(grunt.file.read(path))

            $('link[rel=stylesheet]').each(function() {
                var link = $(this)
                var linkPath = file.orig.cwd + '/' + link.attr('href')

                if (grunt.file.exists(linkPath)) {
                    var contents = grunt.file.read(linkPath)

                    link.replaceWith('<style>' + contents + '</style>')

                    grunt.file.write(file.dest, $.html())
                }
            })

        })
    })
}
