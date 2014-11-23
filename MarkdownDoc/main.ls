
{io,JQ,tempConv,_,TM,move,__} = require "./headers.js"


#mithril exposed as m
log = (X) -> console.log(JSON.parse(JSON.stringify(X)))

CreateArray = (size,val= 0) -> 
	Arr = []
	
	for I from 0 to (size - 2)
		Arr.push(val)

	Arr


SetValArray = (list,index,val)->

	for I in ( __.range index,list.length )
		list[I] = val
	list


ElementPointers = {}

config = (Name)->
	eval "var Ob = function(e){return ElementPointers." + Name + " =" + " e;}"
	return Ob
JQ.get "test.html", (doc) ->

	Mdoc =  eval (tempConv.Template doc).toString!
	app = {}
	Signals = {}
	Signals.OpenIndex = false
	Nines = CreateArray 7,0
	Nines[0] = 1
	FindHeaders = (doc)->

		listofHeaders = []
		Output = {}
		Search = (elem,dept)->
			Output = {}
			if (typeof elem == "string")
				return

			find = (/h([2-9])/.exec elem.tag)

			if find != null

				Output.name = elem.children[0]
				Output.height = find[1]
				Output.dept = dept
				listofHeaders.push Output

			else
				_.map ((x)-> Search x, dept + 1),elem.children

		_.map ((x)-> Search x,0),doc

		listofHeaders
	CreateHeaderM = (list)->
		style =
			"text-decoration": "none"
			"color":"black"
		nest = (accum,next)->

			CurrentHeight = (_.last accum).height
			if CurrentHeight < next.height
				(_.last accum).kid.push next
			else if CurrentHeight >= next.height
				accum.push next

			accum
		RunForEachKid = (x) -> _.fold nest , [x[0]] ,( _.tail x)
		Recur = (x)->

			Second = (x)->

				if x.kid.length == 0
					return

				x.kid = RunForEachKid x.kid

				_.each (Second),x.kid

			First = RunForEachKid x

			_.each Second,First

			First
		Fn = (x) ->

			out = [(m "li",( m "a",(style:style,href:("#" + x.name)),x.name)),(m "ol",(_.map Fn,x.kid))]
			
			out

		_.each ((x)-> x.kid = []),list

		Stuff = Recur list

		m "ol",(_.map Fn, Stuff)

	AddReferenceToHead = (x) -> x.children[0] = m "a",(name:x.children[0]), x.children[0]

	GetHeaders = (x) -> _.filter (x) ->

		test = /h[2-9]/.exec x.tag
		
		if test != null 

			return true
		else return false
	,x

	NinesCompress =->

		WithNum = _.filter ((x)-> if x == 0 then false else true),Nines
		
		_.fold (acc,post)->
			acc + "." + post
		,"",WithNum

	EditName = (elem) ->

		elem.children[0] = _.tail NinesCompress! + " " + elem.children[0]

		elem

	FoldFn = (pre,post) ->
		
		
		
		Last = (parseInt _.tail pre.tag) - 2
		Next = (parseInt _.tail post.tag) - 2
		if Next > Last
			Nines[Next]++
			SetValArray Nines,Next+1,0
		if Last == Next
			Nines[Last]++
			SetValArray Nines,Last+1,0
		if Next < Last
			Nines[Next]++
			SetValArray Nines,Last,0


		EditName post

		post

	

	IndexM = CreateHeaderM FindHeaders Mdoc

	Headers = GetHeaders Mdoc
	
	_.fold FoldFn ,(EditName _.head Headers) , _.tail Headers
	
	_.map AddReferenceToHead,Headers
	
	app.controller = ->

	OnMouseClick = ->

		if Signals.OpenIndex == false
			TM.to ElementPointers.triangle, 0.5, (left:"15%",rotation:180)
			TM.to ElementPointers.doc, 0.5, (left:"10%","padding-right":"0%")
			TM.to ElementPointers.Index, 0.5,(left:"0%")

		else

			TM.to ElementPointers.triangle, 0.5, (left:0,rotation:360)
			TM.to ElementPointers.doc, 0.5, (left:"0%","padding-right":"10%")
			TM.to ElementPointers.Index, 0.5,(left:"-20%")
		Signals.OpenIndex = !Signals.OpenIndex

	FadeInTriangle = ->
		TM.to ElementPointers.triangle,0.5,("opacity":0.5)

	FadeOutTriangle = ->
		TM.to ElementPointers.triangle,0.5,("opacity":0.1)

	app.view = (ctrl) ->
		
		CMUN = m "link",(rel:"stylesheet" href: "Serif/cmun-serif.css")
		head = m "head",[CMUN]

		triangleCSS =
			width: "0"
			height: "0"
			top:"45%"
			border-top: "45px solid transparent"
			border-bottom: "45px solid transparent"
			border-left: "45px solid rgb(0,0,0)"
			opacity:"0.1"
			position:"fixed"
			z-index: 100


		triangleM = m "div",
			style:triangleCSS
			config:(config "triangle")
			onclick:OnMouseClick
			onmouseover:FadeInTriangle
			onmouseleave:FadeOutTriangle

			# config:config "TriContainer"

		# triangleHWHTML = m "div", triangleHW2,triangleM

		styleMain =
			"font-family":"'Computer Modern Serif'"

		styleTextBody =
			"padding-left":"10%"
			"padding-right":"10%"
			"text-align":"justify"
			"font-size":"10pt"
			"position":"absolute"
			"overflow-y": "auto"
		IndexCSS =
			"top":"0"
			"left":"-20%"
			"font-size":"10pt"
			# "margi	n": "0px"
			# "padding": "0px"
			"width":"20%"
			"height":"100%"
			"-webkit-transform": "translateZ(0)"
			"position":"fixed"
			"overflow-y": "scroll"
			"overflow-x": "auto"
			# "z-index":"99"



		Index = m "div" ,(style:IndexCSS,config:config "Index"), IndexM
			# "left":"40%"

		# IndexStyle =
			# "position":"fixed"
			# "left":"0px"
		# console.log Mdoc

		hello = m "div",(config:config "hello"),"hello world"
		# Doc = m "div",(config:((e)->e = ElementPointers.body)),


		doc = m "div",(style:styleTextBody,config:config "doc"),[Mdoc]

		body = m "body",(config:config "body"),[doc]

		html  = m "html",(style:styleMain),[head,triangleM,body,Index]



		html


	m.module document ,app



