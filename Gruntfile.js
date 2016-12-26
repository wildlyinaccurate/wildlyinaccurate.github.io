module.exports = function(grunt) {

    grunt.loadNpmTasks('grunt-elm');
    grunt.loadNpmTasks('grunt-uncss');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-contrib-imagemin');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-filerev');
    grunt.loadNpmTasks('grunt-usemin');

    grunt.initConfig({
        elm: {
            compile: {
                files: {
                    '_site/js/compiled/Collection.js': 'elm/Main.elm',
                }
            }
        },

        uncss: {
            dist: {
                options: {
                    htmlroot: '_site',
                    timeout: 2000,
                    ignoreSheets: [/fonts.googleapis/],
                    ignore: ['#carbonads', /\.carbon\-.+/, /\.search-results.+/]
                },
                files: {
                    '_site/css/main.css': [
                        '_site/index.html',
                        '_site/page2/index.html',
                        '_site/about/index.html',
                        '_site/projects/index.html',
                        '_site/search/index.html',
                        '_site/a-hackers-guide-to-git/index.html',
                        '_site/transitioning-to-a-new-keyboard-layout/index.html',
                        '_site/understanding-javascript-inheritance-and-the-prototype-chain/index.html',
                        '_site/functional-programming-resources/index.html',
                        '_site/worst-fonts-for-programming/index.html'
                    ]
                }
            }
        },

        uglify: {
            options: {
                screwIE8: true
            },
            dist: {
                files: [{
                    expand: true,
                    cwd: '_site/js',
                    src: '{**/,}*.js',
                    dest: '_site/js'
                }]
            }
        },

        cssmin: {
            dist: {
                files: {
                    '_site/css/main.css': ['_site/css/main.css']
                }
            }
        },

        htmlmin: {
            dist: {
                options: {
                    collapseWhitespace:    true,
                    conservativeCollapse:  true,
                    removeEmptyAttributes: true,
                },
                files: [{
                    expand: true,
                    cwd: '_site',
                    src: '**/*.html',
                    dest: '_site'
                }]
            }
        },

        imagemin: {
            assets: {
              files: [{
                expand: true,
                cwd: 'assets/',
                src: ['**/*.{png,jpg,gif}'],
                dest: 'assets/'
              }]
            }
        },

        filerev: {
            options: {
                algorithm: 'sha1',
                length: 7
            },
            styles: {
                src: '_site/css/main.css'
            },
            scripts: {
                src: '_site/js/{**/,}*.js'
            }
        },

        usemin: {
            html: '_site/{**/,}*.html',
            options: {
                assetsDirs: '_site',
            }
        },
    });

    grunt.registerTask('build', [
        'elm',
        'uncss',
        'cssmin',
        'uglify',
        'filerev',
        'usemin',
        'htmlmin',
        'imagemin'
    ]);

};
