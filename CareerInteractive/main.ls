
MAXFONTSIZE = 50
DEFAULTFONTSIZE = 4
MAXFONTSIZEFORSIDEHEADING = 30
{TC,JQ,m,_,TM} = require "./headers.js"





JQ.ajaxSetup (async:false)

Doc = (JQ.get "test.html").responseText

Doc = Doc.replace /\n|\s/g," "

ArrayOfCode =
	"Node.js"
	"node.js"
	"Javascript"
	"npm"
	"UNIX"
	"npm"
	"inc"
	"ECMAScript 6"
	"IO.js"
	"HTML5"
	"canvas"
	"Glup.js"
	"Grunt.js"
	"JSON"
	"API"
	"LiveScript"
	"CLI"
	"browserify.js"
	"HTTP"
	"static.js"
	"html"
	".js"
	"SQLite3"
	"LowDB"




T = {}
T.Doc  = Doc
_.each ArrayOfCode,(x)->
	T.Doc = eval "T.Doc.replace(/#{x}/g,'<code>#{x}</code>')"
	return
Doc = T.Doc
T = null

MDoc = eval (TC.Template Doc).toString!


GetRidOfNewLine = (Doc)->
	return _.filter Doc,(x)->
		if x[0] == "\n"
			return false
		else
			return true

KeepOnlyString = (Doc)->

	K = 0
	len = Doc.length
	while K < len
		Current = Doc[K]

		K += 1

AnchorStyle =
	*text-decoration:"none"
		color:"black"

ListOfReferences = [] # Done

ListOfFigRef = [] # Done

ListOfEquRef = []

ListOfHref = [] # Done

ListOfFigCaption = [] # Done

ListOfEqu = []

ListOfParagraph = []

ListOfCode = []

ListOfBold = []



ChangeBold = ->

	K = 0

	len = ListOfBold.length

	while K < len

		Current = ListOfBold[K]
		Current.children = [(m "span",(style:(font-size:"9pt")),Current.children[0])]

		K += 1

	return

ChangePara = ->
	K = 0

	len = ListOfParagraph.length

	while K < len

		Current = ListOfParagraph[K]
		Current.children.unshift (m "span","\u00a0")
		K += 1

	return

ReplaceCode = ->
	K = 0
	len = ListOfCode.length

	while K < len
		Current = ListOfCode[K].children[0]
		# ListOfCode[K].tag = "span"
		ListOfCode[K].attrs.style = ("font-size":"8 pt")
		K += 1

	return

ReplaceFigCaption = (Names) ->
	K = 0
	len = ListOfFigRef.length

	while K < len
		Current = ListOfFigRef[K]
		tag = Current.children[0]
		Value = _.indexOf Names,tag
		Current.children = [m "a",(href:"\#Fig.#{tag}",style:(text-decoration:"none",color:"black")),("[ figure #{Value + 1} ]")]
		K += 1

	return

CreateListOfFigCaption = ->

	Names = []
	len = ListOfFigCaption.length
	K = 0

	while K < len
		Current = ListOfFigCaption[K]
		tag = Current.attrs.tag
		Names.push tag
		Current.children.unshift (m "b","Figure #{K + 1} - ")
		Current.children = [m "a",(name:"Fig.#{tag}",style:(text-decoration:"none",color:"black")),Current.children]
		K += 1
	return Names

ReplaceRef = (Names)->


	K = 0
	len = ListOfReferences.length
	while K < len
		Current = ListOfReferences[K]
		Value = _.indexOf Names,Current.children[0]
		Current.children[0] = m "a",(href: "\#" + Current.children[0],style:(text-decoration:"none",color:"black")),"[#{Value + 1}]"
		K += 1
	return

EmptyTest = (Words)->

	Fn = (x)->
		if x == undefined or x == null
			return false
		if /\w/.test x or (typeof x) == "object"
			return true
		else
			return false
	if Words == undefined or Words.length == 0
		return false
	else
		return _.reduce (_.map Words,Fn),(x,y) -> x + y

CreateListOfHref = ->

	K = 0

	Names = []

	len = ListOfHref.length

	while K < len

		Current = ListOfHref[K]

		tag = Current.attrs.tag

		reference = Current.attrs.href

		Words = Current.children

		Row = [(m "div",(style:(float:"left")),((K + 1) + "." + "\u00a0"))]

		if tag != undefined

			Row.push [m "a",(name:tag,style:(display:"table-cell",text-decoration:"none")),Current.children]

		if reference != undefined


			Inside = m "a",(href:reference,style:(color:"\#0C9502")),reference

			# if EmptyTest Words
			# 	Row.push (m "div",inner,["\u00a0\u00a0\u00a0\u00a0",Inside])
			# else
			Row.push (m "div",(style:(display:"table-row")),[Inside])


		Current.children = [m "p",Row]

		Names.push tag
		K += 1


	return Names



SeperateByTag = (Elem) ->
	return

FindListOfHeading = (Doc,HeadingList) ->*

	len = Doc.length
	I = 0
	while I < len
		Current = Doc[I]

		if typeof Current == "string"
			I += 1
			continue
		if Current.tag[0] == "h" and Current.tag[1] != "1" and Current.tag.length < 3
			HeadingList.push [(parseInt Current.tag.slice 1),Current]

		else
			switch Current.tag
			|	"ref" =>
				ListOfReferences.push Current
			| "href" =>
				ListOfHref.push Current
			| "equ" =>
				ListOfEqu.push Current
			| "equref" =>
				ListOfEquRef.push Current
			| "figref" =>
				ListOfFigRef.push Current
			| "figcaption" =>
				ListOfFigCaption.push Current
			| "p" =>
				ListOfParagraph.push Current
			| "code"
				ListOfCode.push Current
			| "b"
				ListOfBold.push Current


			Run = FindListOfHeading Current.children,HeadingList
			K = 0
			len2 = Current.children.length
			while K < len2
				Run.next!
				K += 1

		I += 1

	return HeadingList





CreateNumberList = (HeadingList)->*

	K = 0

	len = HeadingList.length

	PreviousCurrent = 2

	List = [0]

	Curate = []

	Mod = []

	Pos = 0

	while K < len

		Current = HeadingList[K][0]
		if Current != PreviousCurrent
			if Current < PreviousCurrent
				I = 0
				len2 = PreviousCurrent - Current
				Pos -= len2
				while I <  len2
					List.pop!
					I += 1
			else
				Pos += 1
				List[Pos] = 0

			PreviousCurrent = Current

		List[Pos] += 1

		Mod.push [List[Pos],Current]

		Curate.push List.slice 0

		K += 1

	yield Curate


	return Mod

ReplaceWithNum = (NumberList,HeadingList) ->
	I = 0
	len = HeadingList.length

	Anchor =
		*text-decoration:"none"
			color:"black"
			font-family:"OpenSan"

	while I < len
		Almost = HeadingList[I][1]
		Almost.children[0] = m "a",(name:("Heading" + I),style:Anchor),(m "span",(NumberList[I].join ".") + " " + Almost.children[0])
		I += 1
	return

FontSizeBasedOnH = (Item)->
	switch Item
	| 2 =>
		FontSize = "13pt"
	| 3 =>
		FontSize = "12pt"
	| 4 =>
		FontSize = "11pt"
	| otherwise =>
		FontSize = "10pt"
	return FontSize

CreateIndexPage = (NamesList,ModList)->

	Heading = m "center",(m "div",(style:(align:"right",font-size:"15pt")),"Table Of Content")
	Doc = []
	Line = (m "div",(style:(border-width:"1px",border-style:"solid",border-color:"rgba(0,0,0,0.5)",margin:"20px")))

	Doc.push Line

	Doc.push Heading

	Doc.push Line

	len = NamesList.length
	K = 0

	Arrow = "."
	while K < len
		Cur = ModList[K]
		Size = Cur[1]
		Num = Cur[0]

		FontSize = FontSizeBasedOnH Size
		NumM = m "span",(style:(font-size:FontSize,white-space:"pre-wrap")),Num + "" + Arrow + " "
		InnerText = m "span",NamesList[K]
		FinalSyle =
			*style:
					*font-size:FontSize
						text-indent:2*(Size - 2) + "em"
						padding-bottom:"0.1%"


		Final = m "div",FinalSyle,[NumM,InnerText]
		Doc.push Final
		K += 1

	return Doc

Run = FindListOfHeading MDoc,[]

HeadingList = (Run.next!).value

Run1 = CreateNumberList HeadingList

Curate = (Run1.next!).value

Mod = (Run1.next!).value

WithOnlyNames = _.map HeadingList, (x) -> x[1].children[0]

ReplaceWithNum Curate,HeadingList

ReplaceRef CreateListOfHref!

ReplaceFigCaption CreateListOfFigCaption!

ChangePara!

ReplaceCode!

ChangeBold!

Index = (CreateIndexPage WithOnlyNames,Mod)

Jm =(tag,content = {},style = {}) -> m tag,style,content

CreateSideBar = (NamesList,ModList)->
	Color = ["rgb(234,234,234)","rgb(255,255,255)"]
	BorderColor = ["rgb(240,240,240)","rgb(255,255,255)"]
	NumColor = "rgb(0,0,0)"
	len = NamesList.length
	K = 0
	Doc = []
	Arrow = "."
	Width = window.innerWidth

	while K < len
		Cur = ModList[K]
		Size = Cur[1]
		Num = Cur[0]

		FontSize = FontSizeBasedOnH Size

		NumLet = Jm "span",Num,
			*style:
					*border-color:"rgb(200,200,200)"
						background-color:NumColor
						padding-left:"3px"
						color:"rgb(255,255,255)"
						border-style:"solid"
						border-width:"0.5px"
						padding-right:"3px"
						margin-right:"3px"
						width:"100px"

		InnerText = Jm "span","" + NamesList[K]

		NumM = Jm "span",[NumLet,InnerText],
			*style:
					*display:"table-row"
						font-size:FontSize - 2
						white-space:"pre-wrap"


		Margin = (Size - 2)*0.004*Width + 5
		FinalSyle =
			*style:
					*font-size:FontSize
						margin-left:Margin
						width:(Width*0.2 - Margin)
						margin-top:0.005*Width
						margin-bottom:0.005*Width
						background-color:Color[K%2]
						border-style:"solid"
						border-width:"1px"
						border-color:BorderColor[(K)%2]
						cursor:"pointer"
						text-decoration:"none"
		AnchorTag =
				*href:("#" + "Heading" + K)
					style:
						text-decoration:"none"
						color:"black"



		Final = m "div",FinalSyle, (m "a",AnchorTag,[NumM])
		Doc.push Final
		K += 1

	return Doc





app = {}

config = (Name)->
	return (Elem,isInit)->
		if isInit == false
			app[Name] = Elem
		return


app.controller = ->
	@SideBarHidden = true
	return

Width = window.innerWidth

app.Width = window.innerWidth
app.Height = window.innerHeight

triangleShape =
		width:"0"
		height:"0"
		top:"45%"
		border-top: "#{app.Height*0.04}px solid transparent"
		border-bottom: "#{app.Height*0.04}px solid transparent"
		border-left: "#{app.Height*0.04}px solid rgb(0,0,0)"
		opacity:0.4
		position:"fixed"
		z-index: 2
		cursor:"pointer"

app.view = (ctrl)->

	TriangleClick = ->

		Val = [0,21]

		Rotation = [360,180]

		Latex = [5,25]

		Signal = ctrl.SideBarHidden

		TM.to app.SideBar,0.8,(margin-left:"#{-Val[(Signal+1)%2] - 0.4}%")

		Amount = Val[(Signal)%2]

		# TM.to app.LatexDoc,0.8,(margin-left:"#{Amount + 5}%",width:"#{100 - Amount - 10 + 3*Signal}%")

		TM.to app.LatexDoc,0.8,(margin-left:"#{Latex[Signal%2]}%")

		TM.to app.InnerTriangle,0.8,(rotation:Rotation[Signal%2])

		TM.to app.InnerTriangle,0.2,(opacity:1)
		setTimeout (->TM.to app.InnerTriangle,0.8,(opacity:0.4)),200
		TM.to app.OuterTriangle,0.8,(margin-left:"#{Val[(Signal)%2] + 0.5*Signal}%")

		ctrl.SideBarHidden = not ctrl.SideBarHidden

		return

	FullCSS =
		*style:
					height:"99.7%"
					width:"99.7%"
					position:"absolute"
					margin-left:"0px"
					margin-right:"0px"

	m "html",
	*m "head",
			*m "link",(rel:"stylesheet",type:"text/css",href:"./Serif/cmun-serif.css")
				m "link",(rel:"stylesheet",type:"text/css",href:"MyCss.css")
				# m "script",(type:"text/javascript",src:"./MathJax/MathJax.js?config=TeX-AMS-MML_HTMLorMML")
		m "div",FullCSS,
				*m "div",
						*style:
								*float:"left"
									height:"99.9%"
									width:"21.4%"
									position:"fixed"
									margin-left:"-25%"
							config:config "SideBar",
						*Jm "div",(CreateSideBar WithOnlyNames,Mod),
									*style:
											*font-family:"OpenSan"
												background-color:"rgb(255,255,255)"
												height:"99.8%"
												width:"100%"
												margin-left:"0"
												overflow:"auto"
					m "div",
							*style:
									# *margin-left:"25mm"
										# margin-right:"25mm"
										# margin-top:"25mm"
										# margin-bottom:"25mm"
									# *height:"100%"
									*width:"90%"
										margin-left:"5%"
										margin-right:"5%"
										text-align:"justify"
										line-height:"1.5em"
										font-family:"Computer Modern Serif"
								config:config "LatexDoc",
							[MDoc]
							# [(CreateIndexPage WithOnlyNames,Mod)]
					Jm "div",(Jm "div",{},(config:(config "InnerTriangle"),style:triangleShape)),
						*config:(config "OuterTriangle")
							style:
									*margin-left:"0cm"
										position:"absolute"
							onclick:TriangleClick


m.module document,app

mediaQueryList = window.matchMedia 'print'

WhenPrint = (mql)->
	if mql.matches
		app.InnerTriangle.style.opacity = 0
	else
		app.InnerTriangle.style.opacity = 0.4
	return

mediaQueryList.addListener WhenPrint


window.onbeforeprint = ->
	app.InnerTriangle.style.opacity = 0
	return
window.onafterprint = ->
	app.InnerTriangle.style.opacity = 0.4
	return
