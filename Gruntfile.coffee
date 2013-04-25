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
        tasks: ['stylus:dev', 'stylus:dev_ie', 'reload']

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

    stylus:
      # options:
      #   import: [
      #     'blocks/config.styl',
      #     # 'blocks/i-mixins/i-mixins__clearfix.styl',
      #     # 'blocks/i-mixins/i-mixins__vendor.styl',
      #     # 'blocks/i-mixins/i-mixins__gradients.styl',
      #     # 'blocks/i-mixins/i-mixins__if-ie.styl'
      #   ]

      dev:
        # options:
        #   define: {
        #     ie: false
        #   },
        files: {
          'lib/normalize-css/normalize.css'
          'blocks/i-reset/i-reset.styl'
          # 'lib/**/*.css'
          # 'blocks/b-*/**/*.css'
          # 'blocks/b-*/**/*.styl'
          # 'blocks/b-*/**/*.less'
        }
        dest: 'publish/style.css'

      dev_ie:
        options:
          define: {
            ie: true
          }
        files: {
          'blocks/i-reset/i-reset.styl'
          'lib/**/*.css'
          # 'blocks/b-*/**/*.ie.css'
          # 'blocks/b-*/**/*.ie.styl'
          # 'blocks/b-*/**/*.ie.less'
        }
        dest: 'publish/style.ie.css'

      # publish:
      #   options:
      #     compress: true
      #   files:  '<%= stylus.dev.dest %>'
      #   dest:   '<%= stylus.dev.dest %>'
      #   # base64: true

      # publish_ie:
      #   options:
      #     compress: true
      #   files:  '<%= stylus.dev_ie.dest %>'
      #   dest:   '<%= stylus.dev_ie.dest %>'
      #   # base64: true

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-jade');
  grunt.loadNpmTasks('grunt-contrib-stylus');

  @registerTask( 'default',  [ 'concat', 'stylus:dev', 'stylus:dev_ie', 'jade' ])
  @registerTask( 'reloader', [ 'concat', 'stylus:dev', 'stylus:dev_ie', 'jade', 'server' ])
  # @registerTask( 'publish',  [ 'concat', 'uglify', 'stylus', 'jade' ])
