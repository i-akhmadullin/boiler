module.exports = (grunt) ->
  'use strict'

  require('matchdep').filterDev('grunt-*').forEach(grunt.loadNpmTasks);

  @initConfig

    bower:
      install:
        options:
          targetDir:      './lib'
          layout:         'byType'
          install:        true
          verbose:        false
          cleanTargetDir: false
          cleanBowerDir:  true

    concat:
      options:
        separator: ';'
      dist:
        src: [
          'lib/consoleshiv.js',
          'lib/**/*.js',
          '!lib/jquery/*.js',
          '!lib/html5shiv/*.js',
          'blocks/**/*.js'
        ]
        dest: 'publish/script.js'

    uglify:
      dist:
        files:
          '<%= concat.dist.dest %>': ['<%= concat.dist.dest %>']

    jshint:
      files: [
        'lib/consoleshiv.js',
        'lib/**/*.js',
        '!lib/jquery/*.js',
        '!lib/html5shiv/*.js',
        'blocks/**/*.js'
      ]
      options:
        curly:    true
        eqeqeq:   true
        eqnull:   true
        quotmark: true
        undef:    true
        unused:   true

        browser:  true
        jquery:   true
        globals:
          console: true

    watch:
      options:
        interrupt:  true
        nospawn:    true
        livereload: true

      scripts:
        files: [
          'lib/**/*.js',
          'blocks/**/*.js'
        ]
        tasks: ['concat']

      css:
        files: [
          'blocks/**/*.css',
          'blocks/**/*.styl',
          'blocks/**/*.less'
        ]
        tasks: ['stylus:dev', 'stylus:dev_ie']

      jade:
        files: [
          'jade/**/*.jade'
        ]
        tasks: ['jade:develop']

    jade:
      options:
        pretty:  true

      develop:
        options:
          data:
            ga:      'UA-XXXXX-X'
            metrika: 'XXXXXXX'
            isDevelopment: true
        files: [{
          expand: true       # Enable dynamic expansion.
          cwd:    'jade'     # Src matches are relative to this path.
          src:    ['*.jade'] # Actual pattern(s) to match.
          dest:   ''         # Destination path prefix.
          ext:    '.html'    # Dest filepaths will have this extension.
        }]

      publish:
        options:
          data:
            ga:      '<%= jade.develop.options.data.ga %>'
            metrika: '<%= jade.develop.options.data.metrika %>'
            isDevelopment: false
        files: '<%= jade.develop.files %>'

    stylus:
      options:
        compress: false
        paths: ['blocks/']
        import: [
          'config',
          'i-mixins/i-mixins__clearfix.styl',
          'i-mixins/i-mixins__vendor.styl',
          'i-mixins/i-mixins__gradients.styl',
          'i-mixins/i-mixins__if-ie.styl'
        ]

      dev:
        options:
          define:
            ie: false
        files:
          'publish/style.css': [
            'lib/normalize-css/normalize.css',
            'blocks/i-reset/i-reset.styl',
            'lib/**/*.css',
            'blocks/b-*/**/*.css',
            'blocks/b-*/**/*.styl',
            'blocks/b-*/**/*.less',
            '!blocks/i-*/'
          ]

      dev_ie:
        options:
          define:
            ie: true
        files:
          'publish/style.ie.css': [
            'blocks/i-reset/i-reset.styl',
            'lib/**/*.css',
            'blocks/b-*/**/*.ie.css',
            'blocks/b-*/**/*.ie.styl',
            'blocks/b-*/**/*.ie.less',
            '!blocks/i-*/'
          ]

      publish:
        options:
          compress: true
        files: 
          'publish/style.css': 'publish/style.css'
        # base64: true

      publish_ie:
        options:
          compress: true
        files: 
          'publish/style.ie.css': 'publish/style.ie.css'
        # base64: true

    open:
      mainpage:
        path: require('path').join(__dirname, 'main.html');


  @registerTask( 'default',    [ 'jshint', 'concat', 'stylus:dev', 'stylus:dev_ie', 'jade:develop' ])
  @registerTask( 'livereload', [ 'default', 'open', 'watch' ])

  @registerTask( 'publish',    [ 'jshint', 'concat', 'uglify', 'stylus', 'jade:publish' ])
