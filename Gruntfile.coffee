module.exports = (grunt) ->

	# Project configuration.
	grunt.initConfig
		pkg: grunt.file.readJSON("package.json")
		watch:
			lib:
				files: ["_src/lib/*.coffee"]
				tasks: [ "coffee:lib" ]
			test:
				files: ["_src/test/*.coffee"]
				tasks: [ "coffee:test" ]
			
		coffee:
			lib:
				expand: true
				cwd: '_src',
				src: ["lib/*.coffee"]
				dest: ""
				ext: ".js"
			test:
				expand: true
				cwd: '_src',
				src: ["test/*.coffee"]
				dest: ""
				ext: ".js"

			options:
				flatten: false
				bare: false

		mochacli:
			options:
				require: [ "should" ]
				reporter: "spec"
				#bail: true
				timeout: 10000
				env:
					COUNT: process.env.COUNT

			all: [ "test/test.js" ]
			

	# Load npm modules
	grunt.loadNpmTasks "grunt-contrib-watch"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-mocha-cli"

	# ALIAS TASKS
	grunt.registerTask "watch", "regarde"
	grunt.registerTask "default", "build"
	grunt.registerTask "test", [ "build", "mochacli" ]

	grunt.registerTask "build", [ "coffee" ]
