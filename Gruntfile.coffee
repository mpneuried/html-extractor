module.exports = (grunt) ->

	# Project configuration.
	grunt.initConfig
		pkg: grunt.file.readJSON("package.json")
		watch:
			lib:
				files: ["_src/**/*.coffee"]
				tasks: [ "coffee:base" ]
			module_test:
				files: [ "_src/**/*.coffee" ]
				tasks: [ "coffee:base", "test" ]
			
		coffee:
			base:
				expand: true
				cwd: '_src',
				src: ["**/*.coffee"]
				dest: ""
				ext: ".js"

			options:
				flatten: false
				bare: false

		mochacli:
			options:
				require: [ "should" ]
				reporter: "spec"
				bail: if process.env.BAIL? then true else false
				timeout: 10000
				env:
					COUNT: process.env.COUNT

			all: [ "test/test.js" ]
			

	# Load npm modules
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-mocha-cli"

	# ALIAS TASKS
	grunt.registerTask "default", "build"
	grunt.registerTask "test", [ "build", "mochacli" ]
	grunt.registerTask( "watch-test", [ "watch:module_test" ] )

	# ALIAS SHORTS
	grunt.registerTask( "b", "build" )
	grunt.registerTask( "w", "watch:lib" )
	grunt.registerTask( "wt", "watch-test" )
	grunt.registerTask( "t", "test" )

	grunt.registerTask "build", [ "coffee:base" ]
