md = (require "markdown").markdown

fs = require "fs"

filename = process.argv[2]


ErrorHandle = (callback) ->

	Fn = (err,data) ->
		if err
			throw err
		else
		callback data

	Fn


FileProcess = (err,file)->
	if (err !== "change")
		return

	fs.readFile file, (err,data)->
		if err
			throw err
		HTML = md.toHTML data.toString!

		fs.writeFile (/(.*)\./.exec file)[1] + ".html",HTML,(err)->
			if err
				throw err

fs.watch filename , FileProcess