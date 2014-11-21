H = {}



require "mithril" # exposed via m

H.io = require "socket.io-client"
H._ = (require "prelude-ls")

H.JQ = (require "jquery")
H.TM = require "./TweenMax.min.js"
H.tempConv = require "./template-converter.js"

module.exports = H