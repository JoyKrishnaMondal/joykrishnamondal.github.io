browserify = require "browserify"
require! fs

White = "\033[0;37m"
Green = "\033[1;32m"
LightGreen = "\033[0;32m"
RedLight = "\033[0;31m"
Red = "\033[1;31m"
Brown = "\033[0;33m"

names = process.argv

#Keep it all javascript file watches

Input = [names[2],"static.js"]

log = (string,replace)->

	if replace == false
		console.log string
		return

	process.stdout.clearLine!
	process.stdout.cursorTo 0
	process.stdout.write string

exitFn = ->

		fs.unlink Input[1]

		console.log "\n" + Green + Input[1] + Brown + " deleted" + White

		process.exit!

SetWatch = (filename,CompiledName) ->

	Repeats = 0
	TryCatchFn = (Fn) ->
		try
			Fn!
		catch err
			console.log RedLight + err


	compile = (external) ->
		b = browserify!
		b.require "./" + filename
		b.bundle (err,buff)->

			if err
				console.log Red + err + White
				return

			fs.writeFile CompiledName,buff.toString!,(err)->

				if err

					throw Red + err + White

				log Brown + "browserify|" + Green + Repeats + Brown + "|: " + Green + filename + Brown + " > " + Green + CompiledName + White
				Repeats++





	changeVal = 0
	FileProcess = (err,file)->
		switch true
		|err != "change" => return
		|changeVal == 0 =>
			changeVal++
			return
		|changeVal == 1 => --changeVal
		# |otherwise => throw (Red + "Something went wrong at FileProcess" + White)

		TryCatchFn compile

	Main = ->

		TryCatchFn compile # runs browserify

		fs.watch filename,FileProcess # set up watch

		console.log  Brown + "browserify watch for " + Green + filename + Brown + " has started .." + White

		process.on "SIGINT",exitFn

	Main!



SetWatch Input[0],"static.js"
# SetWatch Input[2],"bundle.js"







