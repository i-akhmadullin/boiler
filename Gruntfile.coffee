module.exports = (grunt) ->
  'use strict'

  @initConfig

    concat:
      options:
        separator: ';'
      dist:
        src: [
          'lib/consoleshiv.js',
          'lib/**/!(jquery.min|html5shiv|consoleshiv).js',
          'blocks/**/*.js'
        ]
        dest: 'publish/script.js'

    uglify:
      dist:
        files:
          '<%= concat.dist.dest %>': ['<%= concat.dist.dest %>']

    jshint:
      files: [
        'Gruntfile.coffee',
        'lib/**/*.js',
        'blocks/**/*.js'
      ]
      options:
        globals:
          jQuery:   true
          console:  true
          module:   true
          document: true

    watch:
      scripts:
        files: ['<%= jshint.files %>']
        tasks: ['concat', 'reload']

      css:
        files: [
          'blocks/**/*.css',
          'blocks/**/*.styl',
          'blocks/**/*.less'
        ]
        tasks: ['styletto:dev', 'styletto:dev_ie', 'reload']

      reload:
        files: [
          '*.html'
        ]
        tasks: ['reload']

      jade:
        files: [
          'jade/**/*.jade'
        ]
        tasks: ['jade', 'reload']

    jade:
      compile:
        options:
          pretty:  true
          data:
            ga:      'UA-XXXXX-X'
            metrika: 'XXXXXXX'

        files: [{
          expand: true       # Enable dynamic expansion.
          cwd:    'jade'     # Src matches are relative to this path.
          src:    ['*.jade'] # Actual pattern(s) to match.
          dest:   ''         # Destination path prefix.
          ext:    '.html'    # Dest filepaths will have this extension.
        }]

    styletto:
      dev:
        src: [
          'lib/normalize-css/normalize.css',
          'blocks/i-reset/i-reset.styl',
          'lib/**/*.css',
          'blocks/b-*/**/*.css',
          'blocks/b-*/**/*.styl',
          'blocks/b-*/**/*.less'
        ]
        dest: 'publish/style.css'
        errors: 'alert'
        stylus:
          imports: [
            'blocks/config.styl',
            'blocks/i-mixins/i-mixins__clearfix.styl',
            'blocks/i-mixins/i-mixins__vendor.styl',
            'blocks/i-mixins/i-mixins__gradients.styl',
            'blocks/i-mixins/i-mixins__if-ie.styl'
          ]

      dev_ie:
        src: [
          'blocks/i-reset/i-reset.styl',
          'lib/**/*.css',
          'blocks/b-*/**/*.ie.css',
          'blocks/b-*/**/*.ie.styl',
          'blocks/b-*/**/*.ie.less'
        ]
        dest: 'publish/style.ie.css'
        errors: 'alert'
        stylus:
          variables: { 'ie': true }
          imports: [
            'blocks/config.styl',
            'blocks/i-mixins/i-mixins__clearfix.styl',
            'blocks/i-mixins/i-mixins__if-ie.styl'
          ]

      publish:
        src:  '<config:styletto.dev.dest>'
        dest: '<config:styletto.dev.dest>'
        compress: true
        base64:   true
        errors:   'error'

      publish_ie:
        src:  '<config:styletto.dev_ie.dest>'
        dest: '<config:styletto.dev_ie.dest>'
        compress: true
        base64:   true
        errors:   'error'


    server:
      # uncommment to set custom port
      # port: 3502,
      base: process.cwd()

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-stylus');

  @registerTask( 'default',  [ 'concat', 'jade' ])
  @registerTask( 'reloader', [ 'concat', 'jade', 'server' ])
  @registerTask( 'publish',  [ 'concat', 'uglify', 'jade' ])
