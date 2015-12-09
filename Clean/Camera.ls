Main = {}

Main.Init = ->

	{_,Pure,MaxMatch} = require "./headers.js"

	@createObjectURL = window.URL.createObjectURL || window.webkitURL.createObjectURL

	@GetUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia

	@VideoElement = null

	@DummyCanvas = null

	@ViewCanvas = null

	@DummyCTX = null

	@ViewCTX = null

	@CurrentTimeout = null

	@UpdateStatusTimeout = null

	@List = new Uint8Array new ArrayBuffer 640*480

	@Index = new Uint32Array new ArrayBuffer 4*50000

	@PreviousListOfCentroids = []

	@HistoryX    = []
	@HistoryY    = []
	@HistoryNull = []

	@InitialSetUp = false

	@ShowOnlyCamera = false

	@TableOfInput = null

	@RefToTime = null

	@Frames = 0

	@Acum = 0

	@StatusTable = null

	@round = Math.round

	@m = null

	@HideGraphForPerformance = false

	@ListOfCamera = []

	@ShowGrid = false

	@XorYorXY = "X"

	@Division = null

	@SizeOfRect = 3

	@SetTableValues = ->

		TableOfInput = Main.TableOfInput

		Main.RowLookUp = TableOfInput[2]!
		Main.MaximumRadiusOfPin = TableOfInput[3]!
		Main.Luminosity = TableOfInput[4]!
		Main.StartId =  TableOfInput[5]!
		Main.EndId =  TableOfInput[6]!
		Main.StartX =  TableOfInput[7]!
		Main.EndX =  TableOfInput[8]!
		Main.StartY  =  TableOfInput[9]!
		Main.EndY = TableOfInput[10]!
		Main.EndFrame  = TableOfInput[11]!


		return


	@SetXorYorXY = (value)->
		Main.HideGraphForPerformance = false
		Main.ShowGrid = true
		Main.ShowOnlyCamera = false
		Main.XorYorXY = value

		return

	GetCameraId = (x,index)->

		label = x.label

		if label == ""

			label = "Camera #{index + 1}"

		(label:label,id:x.id)

	FindWebCam = (x) ->
		Main.ListOfCamera = _.map (_.filter x,(.kind == "video")),GetCameraId
		return

	@HideEverything = ->

		Main.HideGraphForPerformance = true
		Main.ViewCTX.clearRect 0,0,640,480

		return

	@GetCamera = ->

		MediaStreamTrack.getSources ((x) -> FindWebCam x) #  Globals.Webcam populated

		return

	errorFn = (e) -> console.log "Coudn't Stream from WebCam"
	linkFn = ( ->

			@VideoElement.src =  "./test2.webm"
			# VideoElement.src =  Main.createObjectURL stream
			@VideoElement.play!
			return
			).bind @

	@AttachCameraToVideoElement = (Index) ->
		options = (video:(optional:[(sourceId:@ListOfCamera[Index])]),audio:false)
		# request webcam access
		linkFn!
		return

	@InitCTX = (Ref,refCTX) ->

		Vctx = Ref.getContext "2d"

		Vctx.canvas.height = 480

		Vctx.canvas.width = 640

		Main[refCTX] = Vctx

		return

	ClearOldTimeout = ->
		if Main.CurrentTimeout != null
			clearTimeout Main.CurrentTimeout
		if Main.UpdateStatusTimeout != null
			clearTimeout Main.UpdateStatusTimeout
		return

	@AttachVideoElementToViewCanvas = ->

		ClearOldTimeout!

		Main.CurrentTimeout = setTimeout Main.AttachVideoElementToViewCanvas,35

		Main.ViewCTX.drawImage Main.VideoElement,0,0,640,480

		return

	Loop = ->

		Main.CurrentTimeout = setTimeout Loop,35

		Start = (new Date!).getTime!

		Index = Main.Index

		List = Main.List

		Dctx = Main.DummyCTX

		ctx = Main.ViewCTX

		Dctx.drawImage Main.VideoElement,0,0,640,480

		imageData = Dctx.getImageData 0,0,640,480

		Pure.WriteToList imageData.data,List # (imageData.data) -> (List)

		MaximumRadiusOfPin = Main.MaximumRadiusOfPin

		I = Pure.FindIndex List,Index,MaximumRadiusOfPin,Main.Luminosity # (List) -> (Index,I) # Sparse Index Values

		CurrentListOfCentroids = []

		Pure.ReduceRowDimensionality Index,I,CurrentListOfCentroids,Main.RowLookUp,MaximumRadiusOfPin

		NumberOfPins = CurrentListOfCentroids.length

		if  NumberOfPins > 350

			Main.StatusTable[1] NumberOfPins

			if Main.InitialSetUp

				K = MaxMatch.TrackIDs Main.PreviousListOfCentroids,CurrentListOfCentroids
				MaxMatch.KeepHistory Main.HistoryX,Main.HistoryY,Main.HistoryNull,Main.PreviousListOfCentroids
				Main.StatusTable[0] K


			else

				Main.PreviousListOfCentroids = MaxMatch.AssignIDs CurrentListOfCentroids
				MaxMatch.InitHistory Main.HistoryX,Main.HistoryY,Main.HistoryNull,Main.PreviousListOfCentroids.length
				Main.InitialSetUp = true



		if !Main.HideGraphForPerformance

			if Main.ShowOnlyCamera == false
				if Main.ShowGrid
					# Main.DrawGrid!
					Dctx.clearRect 0,0,640,480
					ctx.clearRect 0,0,640,480
					if Main.XorYorXY == "XY"
						Main.DrawXY Main.PreviousListOfCentroids
					else
						Main.DrawEachLine!

				else

					Pure.DrawOnCanvas Main.PreviousListOfCentroids,Dctx

			ctx.drawImage Main.DummyCanvas,0,0

		Main.Acum += (new Date!).getTime! - Start
		Main.Frames += 1



		return

	MeasureTime = ->

		Main.UpdateStatusTimeout = setTimeout MeasureTime,1000

		MillisecondFn = Main.StatusTable[2]

		OldTime = MillisecondFn!
		newTime =(Main.Acum/Main.Frames).toFixed 1


		if OldTime != newTime
			MillisecondFn newTime
			if app.StopRedraw == false
				Main.m.redraw!

		Main.Acum = 0
		Main.Frames = 0

		return

	@StartTracking = ->

		if Main.VideoElement.src == ""
			return
		ClearOldTimeout!
		Loop!
		MeasureTime!

		return

	@StopTracking = ->
		ClearOldTimeout!
		Main.StatusTable[2] 0
		Main.StatusTable[1] 0
		Main.AttachVideoElementToViewCanvas!
		Main.InitialSetUp = false
		return

	@ShowOnlyCameraFeed = ->
		Main.ShowGrid = false
		Main.HideGraphForPerformance = false
		Main.ShowOnlyCamera = true
		return

	@ChangeShowOnlyCamera = ->
		Main.HideGraphForPerformance = false
		Main.ShowOnlyCamera = false
		return

	@ShowOnlyPins = ->
		Main.HideGraphForPerformance = false
		Main.ShowOnlyCamera = false
		Main.ShowGrid = false
		return

	@CreateLine = (start,end,ctx) ->

		ctx.beginPath!
		ctx.moveTo start[0],start[1]
		ctx.lineTo end[0],end[1]
		ctx.stroke!

		return


	CreateGrid = (divisionsX,divisionsY,ctx) ->

		I = 0

		ResY = 480/divisionsY

		ResX = 640/divisionsX

		Start = [0,0]

		End = [640,0]

		CreateLine = Main.CreateLine

		while I < divisionsY

			CreateLine Start,End,ctx

			Start[1] += ResY
			End[1] += ResY
			I += 1

		I = 0

		Start = [0,0]

		End = [0,480]

		while I<divisionsX

			CreateLine Start,End,ctx

			Start[0] += ResX
			End[0] += ResX

			I += 1
		return


	@DrawGrid = ->

		# ClearOldTimeout!

		DC = Main.DummyCanvas

		Dctx = Main.DummyCTX

		ctx = Main.ViewCTX

		Dctx.clearRect 0,0,640,480
		ctx.clearRect 0,0,640,480


		Dctx.strokeStyle = "\#D4D4D4"

		Dctx.lineWidth = 0.5







		# ctx.drawImage Main.DummyCanvas,0,0

		return

	@DrawLine = (Dctx,Id,History,Division,EndFrame) ->
		I = 0

		while I < EndFrame
			Current = History[I][200]
			X = Current[0]
			Y = Current[1]
			Dctx.lineTo I*Division,Y
			Dctx.stroke!
			I += 1
		return


	Brown  = "\#80392E"

	@DrawXY = (PreviousListOfCentroids)->

		Dctx              =  Main.DummyCTX
		StartId           =  Main.StartId
		EndId             =  Main.EndId
		StartX            =  Main.StartX
		EndX              =  Main.EndX
		StartY            =  Main.StartY
		EndY              =  Main.EndY
		Red               = "\#C43F3F"
		Green             = "\#72C43F"

		len = PreviousListOfCentroids.length

		I = 0

		XDiff = EndX - StartX

		YDiff = EndY - StartY


		XScale = 640/XDiff

		YScale = 480/YDiff

		PixelSize = 3

		if XScale > YScale
			PixelSize = YScale*4
		else
			PixelSize = XScale*4

		Horizontal = 120/XScale

		Vertical = 100/YScale

		Dctx.strokeStyle = "\#D4D4D4"
		Dctx.lineWidth = 0.5

		CreateGrid Horizontal,Vertical,Dctx


		while I < len

			Current  =  PreviousListOfCentroids[I]
			ID       =  Current[0]
			X        =  Current[1]
			Y        =  Current[2]
			Null     =  Current[3]


			if StartId < ID < EndId and StartX < X < EndX and StartY < Y < EndY


				if Null
					Dctx.fillStyle = Red
				else
					Dctx.fillStyle = Green

				Dctx.fillRect (X - StartX)*XScale,(Y - StartY)*YScale,PixelSize,PixelSize


			I += 1

		return

	@DrawEachLine = ->


		Dctx              =  Main.DummyCTX
		ctx               =  Main.ViewCTX
		StartId           =  Main.StartId
		EndId             =  Main.EndId
		StartX            =  Main.StartX
		EndX              =  Main.EndX
		StartY            =  Main.StartY
		EndY              =  Main.EndY
		EndFrame          =  Main.EndFrame
		Dctx.lineWidth    =  1
		X                 =  0
		Y                 =  0
		# Dctx.strokeStyle  =  Brown
		Red               = "\#C43F3F"
		Green             = "\#72C43F"
		HistoryNull       = Main.HistoryNull
		ScaleFactor       = 1
		Transform         = 0

		if Main.XorYorXY == "X"
			History = Main.HistoryX
			Transform = StartX
			Diff = EndX - Transform

		if Main.XorYorXY == "Y"
			History = Main.HistoryY
			Transform = StartY
			Diff = EndY - Transform

		ScaleFactor = 480/Diff

		if History[0].length < EndFrame
			EndFrame = History[0].length

		if EndFrame > 300
			EndFrame = 300

		Division = (640/(EndFrame - 0.9))

		Dctx.strokeStyle = "\#D4D4D4"

		Dctx.lineWidth = 0.5

		Horizontal = EndFrame/4

		Vertical = 100/ScaleFactor

		CreateGrid Horizontal,Vertical,Dctx

		Dctx.lineWidth = 1

		I = StartId

		while I < EndId

			Current = History[I]

			len = Current.length

			CurrentNull = HistoryNull[I][len - 1]
			X = Main.HistoryX[I][len - 1]
			Y = Main.HistoryY[I][len - 1]

			Dctx.beginPath!

			if StartX < X < EndX and  StartY < Y < EndY
				if CurrentNull
					Dctx.strokeStyle = Red
				else
					Dctx.strokeStyle = Green

				K = 0
				while K < len
					X = (Current[K]  - Transform)*ScaleFactor
					Y = K*Division

					Dctx.lineTo Y,X

					# Dctx.beginPath!
					# Dctx.moveTo Y,X
					K += 1


				Dctx.stroke!

			I += 1

		return

	return

Main.Init!

window.Camera = Main



				# if StartX < X < EndX and StartY < Y < EndY

					# if Current[2]
					# 	Dctx.strokeStyle = "\#5CC956" # Red
					# else
					# 	Dctx.strokeStyle = "\#C65555" # Green

					# Dctx.moveTo I*Division,Previous # x,y