
MAXFONTSIZE = 50
DEFAULTFONTSIZE = 20
MAXFONTSIZEFORSIDEHEADING = 30
{TC,JQ,m,_,TM} = require "./headers.js"





JQ.ajaxSetup (async:false)

Doc = (JQ.get "test.html").responseText

Doc = Doc.replace /\n|\s/g," "

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



ReplaceFigCaption = (Names) ->
	K = 0
	len = ListOfFigRef.length

	while K < len

		Current = ListOfFigRef[K]
		tag = Current.children[0]
		Value = _.indexOf Names,tag
		Current.children = [m "a",(href:"\#Fig.#{tag}",style:(text-decoration:"none",color:"black")),(m "b"," Figure #{Value + 1}")]
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

	Doc = GetRidOfNewLine Doc

	len = Doc.length

	I = 0


	while I < len
		Current = Doc[I]
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


			if (typeof Current.children[0]) == "object"
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

	while I < len
		Almost = HeadingList[I][1]
		Almost.children[0] = m "a",(name:("Heading" + I),style:Anchor),(m "span",(NumberList[I].join ".") + " " + Almost.children[0])
		I += 1
	return

FontSizeBasedOnH = (Item)->
	Max = MAXFONTSIZEFORSIDEHEADING
	Min = Max - 10
	switch Item
	| 2 =>
		FontSize = Max - 2
	| 3 =>
		FontSize = Max - 8
	| 4 =>
		FontSize = Max - 10
	| otherwise =>
		FontSize = Min
	return FontSize

Run = FindListOfHeading MDoc,[]

HeadingList = (Run.next!).value

Run1 = CreateNumberList HeadingList

Curate = (Run1.next!).value

Mod = (Run1.next!).value

WithOnlyNames = _.map HeadingList, (x) -> x[1].children[0]

ReplaceWithNum Curate,HeadingList

ReplaceRef CreateListOfHref!

ReplaceFigCaption CreateListOfFigCaption!

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


CreateIndexPage = (NamesList,ModList)->

	Heading = m "center",(m "div",(style:(align:"right",font-size:MAXFONTSIZE)),"Table Of Content")
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
		NumM = m "span",(style:(font-size:FontSize - 2,white-space:"pre-wrap")),Num + "" + Arrow + " "
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

# (CreateIndexPage WithOnlyNames,Mod)

app.Width = window.innerWidth
app.Height = window.innerHeight

triangleShape =
		width:"0"
		height:"0"
		top:"45%"
		border-top: "#{app.Height*0.06}px solid transparent"
		border-bottom: "#{app.Height*0.06}px solid transparent"
		border-left: "#{app.Height*0.06}px solid rgb(0,0,0)"
		opacity:0.4
		position:"fixed"
		z-index: 2
		cursor:"pointer"

app.view = (ctrl)->

	TriangleClick = ->

		Val = [0,21]

		Rotation = [360,180]

		Signal = ctrl.SideBarHidden

		TM.to app.SideBar,0.5,(margin-left:"#{-Val[(Signal+1)%2] - 0.4}%")
		Amount = Val[(Signal)%2]
		TM.to app.LatexDoc,0.5,(margin-left:"#{Amount + 5}%",width:"#{100 - Amount - 10 + 3*Signal}%")
		TM.to app.InnerTriangle,0.5,(rotation:Rotation[Signal%2])

		TM.to app.InnerTriangle,0.2,(opacity:1)
		setTimeout (->TM.to app.InnerTriangle,0.5,(opacity:0.4)),200
		TM.to app.OuterTriangle,0.5,(margin-left:"#{Val[(Signal)%2] + 0.5*Signal}%")

		ctrl.SideBarHidden = not ctrl.SideBarHidden

		return

	FullCSS =
		*style:
				# *border-style:"solid"
					# border-width:"1px"
					height:"99.7%"
					width:"99.7%"
					position:"absolute"

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
												height:"99.8%"
												width:"100%"
												margin-left:"0"
												overflow:"auto"
					m "div",
							*style:
									*margin-left:"5%"
										margin-right:"5%"
										height:"99.8%"
										width:"90%"
										text-align:"justify"
										font-family:"Computer Modern Serif"
								config:config "LatexDoc",
							MDoc
					Jm "div",(Jm "div",{},(config:(config "InnerTriangle"),style:triangleShape)),
						*config:(config "OuterTriangle")
							style:
									*margin-left:"0"
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
