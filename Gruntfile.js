const imageminPngquant = require('imagemin-pngquant')
const imageminJpegtran = require('imagemin-jpegtran')

module.exports = function (grunt) {
  grunt.loadNpmTasks('grunt-uncss')
  grunt.loadNpmTasks('grunt-contrib-cssmin')
  grunt.loadNpmTasks('grunt-contrib-htmlmin')
  grunt.loadNpmTasks('grunt-contrib-imagemin')
  grunt.loadNpmTasks('grunt-filerev')
  grunt.loadNpmTasks('grunt-usemin')

  grunt.loadTasks('grunt-tasks')

  grunt.initConfig({
    uncss: {
      dist: {
        options: {
          htmlroot: '_site',
          timeout: 2000,
          ignoreSheets: [/collection.css/, /toc.css/, /highlight.css/],
          ignore: [
            '#carbonads',
            /\.carbon\-.+/
          ]
        },
        files: {
          '_site/css/main.css': [
            '_site/a-hackers-guide-to-git/index.html',
            '_site/about/index.html',
            '_site/index.html',
            '_site/page2/index.html',
            '_site/projects/index.html',
            '_site/transitioning-to-a-new-keyboard-layout/index.html',
            '_site/understanding-javascript-inheritance-and-the-prototype-chain/index.html',
            '_site/web-performance-teardown-trademe/index.html',
            '_site/worst-fonts-for-programming/index.html'
          ]
        }
      }
    },

    cssmin: {
      dist: {
        files: {
          '_site/css/main.css': ['_site/css/main.css'],
          '_site/css/collection.css': ['_site/css/collection.css'],
          '_site/css/highlight.css': ['_site/css/highlight.css'],
          '_site/css/toc.css': ['_site/css/toc.css']
        }
      }
    },

    htmlmin: {
      dist: {
        options: {
          collapseWhitespace: true,
          conservativeCollapse: true,
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
        options: {
          use: [imageminJpegtran(), imageminPngquant()]
        },
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
        src: '_site/css/*.css'
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

    inlinestyles: {
      dist: {
        files: [{
          expand: true,
          cwd: '_site',
          src: '**/*.html',
          dest: '_site'
        }]
      }
    }
  })

  grunt.registerTask('build', [
    'uncss',
    'cssmin',
    'filerev',
    'usemin',
    'inlinestyles',
    'htmlmin'
  ])
}
