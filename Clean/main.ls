
{m,_,TM,merge} = require "./headers.js"

CombineFn = (ListFn) ->
	return (Elem)->
		I = 0
		Len = ListFn.length
		while I < Len
			Fn = ListFn[I]
			Fn Elem
			I += 1
		return

app = {}

CSS = window.MyCSS

# config = (Name)->
# 	Ob = (E,isInitialited)->
# 		if isInitialited == false
# 			app[Name] = E

# 	return Ob


VideoConfig = (Elem,isInitialited)->

	if isInitialited == false
		Camera.VideoElement = Elem

	return

CanvasConfig = (ElemName,CTX) ->

	Ob = (E,isInitialited) ->
		if isInitialited == false
			Camera[ElemName] = E
			Vctx = E.getContext "2d"
			Vctx.canvas.height = 480
			Vctx.canvas.width = 640
			Camera[CTX] = Vctx
		return

	return Ob

InitFn = (Fn)->
	Ob = (E,isInitialited)->
		if isInitialited == false
			Fn!
	return Ob

app.SetProperty = (name) ->
	return ((Elem,isInitialited) ->
				if !isInitialited
					@[name] = Elem
					Camera[name] = Elem

				return).bind @

app.TableOfInput = {}


app.TableOfInput.Names  =
	"IP"
	"Port"
	"Row Look Up (pixels)"
	"Maximum radius of pin (pixels)"
	"Luminosity [0-255]"
	"ID From"
	"ID To"
	"X Min [0-640]"
	"X Max [0-640]"
	"Y Min [0-480]"
	"Y Max [0-480]"
	"Frames to show"


app.TableOfInput.Values =
	"122.0.0.1"
	4001
	6
	6
	190
	0
	500
	200
	300
	200
	300
	300

app.StopRedraw = false

app.controller = ->

	@TableOfInput = [[(m.prop Item[1]),(m.prop Item[0])] for Item in _.zip app.TableOfInput.Values,app.TableOfInput.Names]

	Camera.TableOfInput = [Item[1] for Item in @TableOfInput]

	Camera.SetTableValues!
	@NumberOfCamera = m.prop 0
	@SelectedCameraIndex = m.prop 0
	@StatusTable = {}

	@StatusTable.Names =
		"Number Of pins lost"
		"Number of pins being tracked"
		"Time (Millisecond)"


	@StatusTable.Values = [ m.prop Item for Item in [0,0,0]]

	Camera.StatusTable = @StatusTable.Values

	Camera.m = m

	First = true


	return

ChooseCamera = (Elem,SelectedCameraIndex) ->

	value = parseInt Elem.target.value.slice 7

	SelectedCameraIndex String value


	return


SelectCamera = (NumberOfCamera,SelectedCameraIndex)->

	options = []


	if NumberOfCamera == 0
			options.push (m "option",(selected:""), "click find camera")

	for I from 1 to NumberOfCamera
		if I == SelectedCameraIndex!
			options.push (m "option",(selected:""), "Camera " + I)
		else
			options.push (m "option", "Camera " + I)

	R =
		*m "div",(style:CSS.CameraShell),
			*m "div",(style:CSS.CameraName),"Choose Camera"
				m "select",(style:CSS.SelectInner,onchange:( (Elem)-> ChooseCamera Elem,SelectedCameraIndex)),options

	return R

EachRow  = (Interior,Style = {})-> m "td",(style:Style),Interior


StatusTable = (TableOfInput) ->

	BodyContent = [(m "tr",(style:CSS.TR),[(EachRow Item[0],CSS.FirstRow), (EachRow Item[1]!,CSS.SecondRow)]) for Item in (_.zip TableOfInput.Names,TableOfInput.Values)]

	Body = m "tbody",(style:(display:"block",overflow:"auto")),BodyContent

	*m "table",(style:CSS.StatusTable),Body


app.PopulateCameraList = (RefToCameraNumber)->


	Camera.GetCamera!

	PromisedCall = ->

		NumberOfCameras = Camera.ListOfCamera.length
		RefToCameraNumber NumberOfCameras

		if NumberOfCameras > 0

			Camera.AttachCameraToVideoElement 1

			Camera.InitCTX Camera.ViewCanvas,"ViewCTX"

			Camera.InitCTX Camera.DummyCanvas,"DummyCTX"

			Camera.AttachVideoElementToViewCanvas!

		return

	setTimeout PromisedCall,100

	return

app.ShowOnlyCamera = (Value) ->

	Camera.ShowOnlyCamera = Value

	return


InitialConditionTable = (TableOfInput) ->

	ChangeFn = (Elem,E) ->

		Value = parseFloat E.target.value

		if Value != NaN
				Elem Value
				Camera.SetTableValues!

			# TM.to app.ErrorBox,1,(opacity:1,z-index:1)
			# setTimeout (TM.to app.ErrorBox,1,(opacity:0,z-index:-1)),500
			# Elem Value
		return

	SecondCol = (Item,Index) -> (m "input",(style:CSS.SecondRow,value:Item!, onchange:((E) -> ChangeFn Item,E),onfocus:CSS.OnFocus,onblur:CSS.TableBlur))

	BodyContent = [ m "tr",[(EachRow (Item[0])!,CSS.FirstRow), (SecondCol (Item[1]),Index)] for Item,Index in TableOfInput]

	Body = m "tbody",(style:(display:"block",overflow:"auto")),BodyContent

	*m "table",Body

ButtonHTML = (Name,Fn)->

	InnerDivJson =
		*onclick:(CombineFn [CSS.ClickAnimation,Fn])
			onmouseenter:CSS.InverseColor
			onmouseleave:CSS.BackToNormal
			style:CSS.ButtonInner

	m "div",
	(m "div",(style:CSS.ButtonOuter),
		(m "div",InnerDivJson,Name))

app.view = (ctrl) ->

	m "html",
	*m "head",
		*m "link",(href:"normalize.css",rel:"stylesheet",type:"text/css")
			m "link",(href:"MyCss.css",rel:"stylesheet",type:"text/css")
		m "body",(style:(align:"center")),
		*m "video" ,(style:(CSS.Video),config:VideoConfig,autoplay:"")
			m "canvas",(style:(CSS.DummyCanvas),config:(CanvasConfig "DummyCanvas","DummyCTX"))
			m "div",(style:CSS.Graph),
					*m "canvas",(style:(CSS.ViewCanvas),config:(CanvasConfig "ViewCanvas","ViewCTX"))
			m "div",(style:CSS.SideBar),
				SelectCamera ctrl.NumberOfCamera!,ctrl.SelectedCameraIndex
				InitialConditionTable ctrl.TableOfInput
				StatusTable ctrl.StatusTable
				m "div",(style:CSS.DummyClear)
				m "div",(style:CSS.FourButton),
					*ButtonHTML "Find Camera",(-> app.PopulateCameraList ctrl.NumberOfCamera)
						ButtonHTML "Camera Feed",(-> Camera.ShowOnlyCameraFeed!)
						ButtonHTML "Feed with Pin ID",(-> Camera.ShowOnlyPins!)
						ButtonHTML "X-Y Graph",(-> Camera.SetXorYorXY "XY")
				m "div",(style:CSS.FourButton),
					*ButtonHTML "X-t Graph",(-> Camera.SetXorYorXY "X")
						ButtonHTML "Y-t Graph",(-> Camera.SetXorYorXY "Y")
						ButtonHTML "Start Tracking",(-> Camera.StartTracking!)
						ButtonHTML "Stop Tracking",(-> Camera.StopTracking!)
				m "div",(style:CSS.FourButton),
					*ButtonHTML "Start Port Buffer"
						ButtonHTML "Stop Port Buffer"
						ButtonHTML "Hide Graph/Feed",(-> Camera.HideEverything!)
						ButtonHTML "View Docs"


window.app = app
m.module document,app
