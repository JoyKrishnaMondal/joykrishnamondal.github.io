

Main = {}

MaxWidth = screen.availWidth

MaxHeight = screen.availHeight

RatioOfGraph = 640/480

CorrectRatioofHeight = 1 - 0.01

CorrectRatioOfWidth = 1 - 0.02

Main.BorderColor = "\#9C9C9C"

{TM} = require "./headers.js"

Main.Init = ->

	RealHeight = CorrectRatioofHeight*window.innerHeight

	RealWidth = CorrectRatioOfWidth*window.innerWidth

	WidthOfGraph = Math.round RealHeight*RatioOfGraph

	Remaining = Math.round (RealWidth - WidthOfGraph)

	@Graph =
		*height:RealHeight
			width:WidthOfGraph
			border-style:"solid"
			border-color:@BorderColor
			border-width:"1px"
			position:"absolute"


	ButtonFont =
		*font-family:"MyButtonFont"

	@FourButton =
		*float:"left"

	BetweenGraphAndSizePad = 5
	BetweenTopGraphAndBut = 5



	@TableElm =
		*padding-bottom:"3px"
			text-align:"center"
			# width:"1000px"
			border-style:"solid"
			# border-width:"1px"
			# border-color:@BorderColor



	@TableOfInputMain =
		*top:RealHeight*(0.25)
			position:"absolute"
			left:Remaining*(1/3) + WidthOfGraph + 6

	WidthOfStatusTable = (2/3)*Remaining - 3

	WidthOfNumber = Math.round 0.4*Remaining

	HeightOfEachRow = RealHeight*0.70/15

	BetweenStatusAndInput = RealHeight*0.01

	@SideBar =
		*left:WidthOfGraph + 	BetweenGraphAndSizePad
			width:Remaining
			position:"absolute"
			font-family:"MyButtonFont"
			font-size:"15pt"


	@TableOfInput =
		*left:WidthOfGraph + BetweenGraphAndSizePad
			top:HeightOfEachRow*3 + BetweenStatusAndInput
			width:Remaining
			position:"absolute"
			font-family:"MyButtonFont"
			font-size:"15pt"

	@FirstRow = #merge _.clone @TableElm,
		*width:(2/3)*Remaining
			height:HeightOfEachRow
			text-align:"center"
			# width:"1000px"
			# border-style:"solid"
			# border-width:"1px"
			# border-color:@BorderColor

	@SecondRow = #merge _.clone @TableElm,
		*width:Remaining*(1/3)
			height:HeightOfEachRow - 1
			text-align:"center"
			text-decoration:"none"
			border-style:"none"
			outline:"none"
			display:"block"

			# border-width:"1px"
			# border-color:@BorderColor

	@SelectInner =
		*width:Remaining/3 - 3
			left:(2/3)*Remaining + 20
			height:HeightOfEachRow + 2
			padding-left:"0%"


			# text-align:"left"
			# display:"block"



	@UpperCamera =
		*top:RealHeight*(0.71 + 0.01)
			left:WidthOfGraph + BetweenGraphAndSizePad
			position:"absolute"

	@CameraName =
		*height:HeightOfEachRow
			border-style:"none"
			# border-width:"1px"
			# border-color:@BorderColor
			width:Remaining*(2/3) + 3
			float:"left"
			# font-size:"10pt"
			"display":"-webkit-box"
			"-webkit-box-pack":"center"
			"-webkit-box-align":"center"

	@CameraShell =
		*width:Remaining
			height:HeightOfEachRow + 2
			font-size:"13pt"




	@ButtonOuter =
		*padding-bottom:"3px"
			padding-left:"3px"
	@ButtonInner =
		# top:"100px"
		# left:"100px"
		*width:Remaining/3 - 2 - 3 -2
			font-family:"MyButtonFont"
			border-radius: "2px"
			# padding-bottom:"3px"
			# padding-left:"3px"
			height:0.158*RealHeight/3
			border-color:@BorderColor
			border-width:"1px"
			border-style:"solid"
			font-size:"10pt"
			"display":"-webkit-box"
			"-webkit-box-pack":"center"
			"-webkit-box-align":"center"
			"-webkit-user-select":"none"
			"-khtml-user-select":"none"
			"-moz-user-select":"none"
			"-o-user-select":"none"
			"user-select":"none"
			cursor: "default"
	@DummyClear =
		*width:Remaining
			height:"8px"
	@StatusTable =
		*border-color:@BorderColor
			border-width:"1px"
			border-style:"solid"

	@TR =
			*padding-bottom:"100px"

	@OnFocus = (Elem)->

		ChangeCSS =
				*border-color:"#0099CC"
					box-shadow:"0 0 4px outset"
					border-radius: "7px"
					border-style:"solid"

		app.StopRedraw  = true

		TM.to Elem.srcElement,0.1,ChangeCSS
		return

	@TableBlur = (Elem) ->

		ChangeCSS =
				*border-color:"rgb(255,255,255)"
					box-shadow:"0 0 0"
					border-style:"none"
		app.StopRedraw  = false
		TM.to Elem.srcElement,0.1,(ChangeCSS)
		return

	@ErrorMessage =
		*height:"20%"
			position:"absolute"
			background-color:"\#CC3300"
			box-shadow:"0 0 10px"
			width:"100%"
			border-style:"none"
			# border-color:"rgb(0,0,0)"
			# border-width:"1px"
			top:"40%"
			"-webkit-filter":"blur(2px)"
			"-moz-filter":"blur(2px)"
			left:"1%"
			z-index:"0"


	@ErrorText =
		*height:"20%"
			font-family:"MyButtonFont"
			position:"absolute"
			width:"100%"
			text-align:"center"
			font-size:"14pt"
			top:"48%"
			"-webkit-filter":"blur(0px)"
			"-moz-filter":"blur(0px)"
			z-index:"0"
			color:"rgb(255,255,255)"

	@InverseColor = (Elem)->
		TM.to Elem.srcElement,0.2,(backgroundColor:"#0099CC",color:"rgb(255,255,255)")
		return

	@BackToNormal = (Elem)->
		TM.to Elem.srcElement,0.2,(backgroundColor:"rgb(255,255,255)",color:"rgb(0,0,0)")
		return

	@ClickAnimation = (Elem)->
		ChangeCSS =
				*backgroundColor:"#4A708B"

		ChangeCSSBack =
				*backgroundColor:"#0099CC"
					color:"rgb(255,255,255)"

		TM.to Elem.srcElement,0.05,ChangeCSS

		setTimeout (->TM.to Elem.srcElement,0.2,ChangeCSSBack),50
		return

	Ratio = 1

	@DummyCanvas =
			*height:480
				width:640
				display:"none"

	@Video =
			*height:480
				width:640
				position:"absolute"
				display:"none"

	@ViewCanvas =
			*height:RealHeight
				width:WidthOfGraph
				border-style:"solid"
				border-color:@BorderColor
				border-width:"1px"
				position:"absolute"

	return

Main.Init!


window.MyCSS = Main


