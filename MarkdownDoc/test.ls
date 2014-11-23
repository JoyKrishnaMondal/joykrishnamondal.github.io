OB = {}
OB.string1 = "hello"
log = (X) -> console.log(JSON.parse(JSON.stringify(X)))

change = (x)->
	
	x.string1 = "love"
	

log change OB

log OB.string1
