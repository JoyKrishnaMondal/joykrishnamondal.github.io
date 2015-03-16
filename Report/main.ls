
{io,JQ,tempConv,_,TM,move,__,udc,katex,Chart,reg} = require "./headers.js"
log = (X) -> console.log(JSON.parse(JSON.stringify(X)))

GlobalCOe = (pol,name) ->

	y = [14079.8, 15685.0, 18061.0, 18641.4, 20988.7, 21851.0, 23758.6, 27501.4, 28966.4, 30509.4, 31342.3, null,null,null,null,null]

	x = [1971,1975,1980,1985,1990,1995,2000,2005,2009,2010,2011,2012,2013,2014,2015,2020]

	vals = reg 'polynomial',(_.zip x , y),pol
	array = vals.points

	R = {}
	R.name = name
	R.y = _.map ((arr)-> arr[1]),array
	R.Label = _.map ((x) -> x.toString!), x
	R.type = "Line"
	R.x = x

	R

GlobalGDP = (pol,name)->

	y = [41016,null,null,null,null,43070,null,null,null,null,62220,null,null,71830,74909,null,null,null,null,null,null,null]
	# R.x = [2013,2012,2010,2005,2000]
	x = [2000 to 2020]
	vals = reg 'polynomial',(_.zip x , y),pol
	array = vals.points


	R = {}
	R.name = name
	R.y = _.map ((arr)-> arr[1]),array
	R.Label = _.map ((x) -> x.toString!), x
	R.type = "Line"
	R.x = x

	R

ECommerce = ->
	#Using cubic regression for e-commerce sales worldwide to predict sales in 2020.
	x = [2013,2014,2015,2016,2017,2018,2019,2020]
	y = [1.233,1.471,1.700,1.922,2.143,2.356,null,null]
	vals = reg 'polynomial',(_.zip x , y),2
	array = vals.points
	y = _.map ((arr)-> arr[1]),array
	Label = _.map ((x) -> x.toString!), x
	R = {}
	R.name = "ECommerce"
	R.type = "Bar"
	R.x = x
	R.y = y
	R.Label = Label

	return R


CreateR = (R) ->
	R.options =
		scaleShowGridLines : true
		scaleGridLineColor : "rgba(0,0,0,.05)"
		scaleGridLineWidth : 1
		bezierCurve : true
		bezierCurveTension : 0.4
		pointDot : true
		pointDotRadius : 7
		pointDotStrokeWidth : 1
		pointHitDetectionRadius : 20
		datasetStroke : true
		datasetStrokeWidth : 2
		datasetFill : true
		legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
	R.data =
		labels:R.Label
		datasets:
			[
				label: "My First dataset"
				fillColor: "rgba(176,97,97,0.3)"
				strokeColor: "rgba(220,220,220,1)"
				pointColor: "rgba(225,225,225,1)"
				pointStrokeColor: "\#fff"
				pointHighlightFill: "rgba(225,225,225,1)"
				pointHighlightStroke: "rgba(220,220,220,1)"
				data:R.y
			]
	R

ChartArray = _.map CreateR,[ECommerce!,(GlobalGDP 3,"cube"),(GlobalGDP 1,"line"),(GlobalCOe 1,'CO')]
# ChartArray = _.map Calculations,[ECommerce!]
#mithril exposed as m

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
signals = {}
signals.load = __.map [1 to ChartArray.length],-> false


CreateSimpleChart = (R,i) ->
	f = (element)->
		if signals.load[i] == false
			console.log 'foundit !'
			ctx = element.getContext "2d"
			ctx.canvas.width = window.innerWidth*0.5
			ctx.canvas.height = window.innerHeight/2
			NeWChart = (new Chart ctx)[R.type] R.data,R.options
			signals.load[i] = true
	return f


config = (Name)->
	Ob = (E)->
		ElementPointers[Name] = E
	return Ob

JQ.get "test.html", (doc) ->

	Mdoc =  eval (tempConv.Template doc).toString!
	app = {}
	Signals = {}
	Signals.OpenIndex = false
	Nines = CreateArray 7,0
	Nines[0] = 1
	cleanEnter = (doc) ->
		clean = (x)->
			if typeof x == "object"
				return true
			else
				return false

		_.filter clean , doc
	FindRef = (doc) ->

		GlobRef = []

		f = (x) ->
			if x.attrs == undefined
				0
			else
				if x.attrs.tag == undefined
					0
				else
					GlobRef.push x
			if x.children != undefined && x.children.length > 0
				_.map f , x.children

		_.map f, doc

		return GlobRef
	Linkstyle =
			"text-decoration": "none"
			"color":"black"
			"font-style":"normal"

	ChangeSourceHTML = (x)->

		copy = udc x.children

		M = [m "a",(style:Linkstyle,name:x.attrs.tag,href:x.attrs.href),copy]

		x.children = M

	GlobalRef = FindRef cleanEnter Mdoc

	GlobalRefReal = udc GlobalRef

	_.map ChangeSourceHTML , GlobalRef

	FindCite = (doc)->

		GlobCite = []
		f = (x)->
			if x.tag == "cite"
				GlobCite.push x
			else if x.children == undefined
				0
			else if x.children.length > 0
					_.map f , x.children

		_.map f,doc

		GlobCite

	GlobalCite = FindCite cleanEnter Mdoc

	FindRef = (name) ->
		if GlobalRefReal.length == 0
			console.log "Reference List is zero"
			return
		else
			for I from 0 to GlobalRefReal.length
				if GlobalRefReal[I].attrs.tag == name
					return I
			console.log "Couldn't Find Reference"


	ChangeCiteHTML = (x) ->
		name = x.children[0]

		M = m "a",(style:Linkstyle,href:("#" + name)),[("[" + (FindRef(name) + 1) + "]")]
		x.children = [M]

	_.map ChangeCiteHTML,GlobalCite

	FindFigCapion = (doc) ->
		GlobRef = {}
		GlobRef.FigRef = []
		GlobRef.ImageRef = []
		GlobRef.equ = []
		GlobRef.equIn = []
		GlobRef.equRef = []
		GlobRef.Charts = []
		f = (x)->
			if x.tag == "figcaption"
				GlobRef.FigRef.push x
			else if x.tag == "imageref"
				GlobRef.ImageRef.push x
			else if x.tag == "equ"
				GlobRef.equ.push x
			else if x.tag == "equin"
				GlobRef.equIn.push x
			else if x.tag == "equref"
				GlobRef.equRef.push x
			else if x.tag == "chart"
				GlobRef.Charts.push x
			else if x.children == undefined
				0
			else if x.children.length > 0
					_.map f , x.children

		_.map f,doc

		GlobRef

	Ref = FindFigCapion cleanEnter Mdoc

	ChangeImageRefHTML = (RefOb) ->



		FindEqu = (name) ->
			# console.log name
			for I from 0 to (RefOb.equ.length-1)
					if RefOb.equ[I].attrs.name == name
						return I

			console.log "Couldnt Find equation Reference for:"
			# console.log name

		g = (x,i)->
			name = x.children[0]
			href = x.attrs.name
			# stuff = name.replace /(\w*?)\{(.*?)\}/g,"\\$1{$2}"
			temp = eval (tempConv.Template katex.renderToString name).toString!
			CENTER = m "a",(name:href,style:("text-align":"center","text-decoration":"none")),temp
			LEFT = m "span",(style:("float":"right")),("(" + (i + 1) + ")" )
			x.children = [(m "div",(style:("text-align":"center")),[CENTER,LEFT])]

		line = (x) ->
			name = x.children[0]

			# stuff = name.replace /(\w*?)\{(.*?)\}/g,"\\$1{$2}"
			temp = eval (tempConv.Template katex.renderToString name).toString!
			x.children = temp

		FindImage = (name) ->

			for I from 0 to (RefOb.FigRef.length-1)
				if RefOb.FigRef[I].attrs.caption == name
					return I
			return null

		f = (x) ->
			name = x.children[0]
			val = FindImage name
			if  val != null
				M = "Figure " + ( val + 1)
				x.children = [M]

		_.map f, RefOb.ImageRef

		h = (x,i) ->

			string = x.children
			M = __.flatten [(m "span", "Figure " + (i + 1) + " - "),string]
			x.children = M


		style =
			"text-decoration": "none"
			"color":"black"
		t = (x) ->
			name = x.children[0]
			val = FindEqu name
			M = m "a",(style:style,href:("#" + name)),"(" + (val + 1) + ")"
			x.children = [M]

		Cinsert = (x) ->
			child = x.children[0]

			name = __.each ChartArray, (y,i)->
				console.log i
				if y.name == child
					con = CreateSimpleChart y,i
					chart = m "center", (m "canvas",(config:con))
					x.children = [chart]



		if  RefOb.equRef.length != 0
			_.map t, RefOb.equRef
		if RefOb.equ.length != 0
			__.each RefOb.equ,g
		if RefOb.equIn.length != 0
			__.each RefOb.equIn,line
		if RefOb.ImageRef.length != 0
			_.map f, RefOb.ImageRef
		if RefOb.FigRef.length != 0
			__.each RefOb.FigRef,h
		if  RefOb.Charts.length != 0
			__.each RefOb.Charts,Cinsert



	ChangeImageRefHTML Ref
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
			indent =
				"text-decoration":"none"
				"padding":"1%"
				"padding-left":"5%"

			out = [(m "li",( m "a",(style:style,href:("#" + x.name)),x.name)),(m "ol",(style:indent),(_.map Fn,x.kid))]

			out

		_.each ((x)-> x.kid = []),list

		Stuff = Recur list
		topCSS =
			"left":"-20px"
			"margin-left":"2%"
			# "text-decoration":"underline"


		m "ol",(style:topCSS),(_.map Fn, Stuff)

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
	AddReferenceToHead = (x,name) ->
		x.children[0] = m "a",(name:name), x.children[0]

	IndexM = CreateHeaderM FindHeaders Mdoc

	Headers = GetHeaders Mdoc
	GetName = (headers) ->
		_.map ((x)->x.children[0]) ,headers

	ListOfNames = GetName Headers

	_.fold FoldFn ,(EditName _.head Headers) , _.tail Headers

	_.zip-with AddReferenceToHead,Headers,ListOfNames

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
		media = m "link",(rel:"stylesheet" href: "media.css")
		katex = m "link",(rel:"stylesheet" href: "katex.min.css")

		head = m "head",[CMUN,media,katex]
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
			"font-size":"15pt"
			"position":"absolute"
			"overflow-y": "auto;"

		IndexCSS =
			"top":"0"
			"left":"-20%"
			"font-size":"13pt"
			"width":"20%"
			"height":"100%"
			"-webkit-transform": "translateZ(0)"
			"position":"fixed"
			"overflow-y": "scroll"
			"overflow-x": "auto"
			# "z-index":"99"

		Index = m "div" ,(style:IndexCSS,config:config "Index"), IndexM



		doc = m "div",(class:"Print",style:styleTextBody,config:config "doc"),[Mdoc]

		body = m "body",(config:config "body"),[doc]

		html  = m "html",(style:styleMain),[head,triangleM,body,Index]



		html


	m.module document ,app



