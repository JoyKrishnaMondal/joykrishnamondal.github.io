fs = require "fs"
express = require "express"
socket = require "socket.io"

indexhtml =
	"<html>
	<script type='text/javascript' src = 'static.js'></script>
	<script type='text/javascript' src = 'main.js'></script>
	</html>"


White = "\033[0;37m"
LightGreen = "\033[1;32m"
Green = "\033[0;32m"
RedLight = "\033[0;31m"
Red = "\033[1;31m"
Brown = "\033[0;33m"

fs.writeFile "index.html", indexhtml, (err) ->
	console.log   LightGreen + "index.html" + Brown + " created with src "+ LightGreen + "main.js" + Brown + " and " + LightGreen + "static.js" + White

RepeatsServerCall = 0;

app = express!

app.use (req, res, next)->

	logString = Brown + "Calls:" + LightGreen + RepeatsServerCall + Brown + "|" + LightGreen + req.url + White
	console.log logString
	RepeatsServerCall++
	next!

app.use express.static __dirname

app.listen 8080

