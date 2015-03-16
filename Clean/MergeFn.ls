Fn1 = (Elem) ->
	console.log Elem

Fn2 = ->
	console.log "Fn2"





CombineFn = (ListFn) ->
	return (Elem)->
		I = 0
		Len = ListFn.length
		while I < Len
			Fn = ListFn[I]
			Fn Elem
			I += 1
		return

List = [Fn1,Fn2]

Fn = CombineFn List

Fn "hello"
