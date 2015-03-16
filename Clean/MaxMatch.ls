
Main = {}

Main.abs = Math.abs
Main.sqrt = Math.sqrt
Main.round = Math.round

{_} = require "lodash"



# M = require "mathjs"

# Main.ClearFarAwayPoints = (List,Radius)->

# 	abs = Math.abs
# 	x = _.map List,((x)-> x[0])
# 	y = _.map List,((x)-> x[1])
# 	XCenter = M.median x
# 	YCenter = M.median y

# 	FilterFn = (Elem,Mean)->

# 		if abs(Elem - Mean ) > Radius
# 			return false
# 		else
# 			return true


	# List = _.filter List,((Elem)->FilterFn Elem[0],XCenter)
	# List = _.filter List,((Elem)->FilterFn Elem[1],YCenter)

	# return List

Main.AssignIds = (List)->
# Main.ClearFarAwayPoints

	_.each List,((x,index) -> x[2] = index)

	return 0

Main.CheckNear = (First,Second) ->

	abs = Math.abs

	lenFirst = First.length
	lenSecond = Second.length

	FinalArray = []

	ConfusedArray = []

	I = 0

	while I < lenSecond

		MainElem = Second[I]

		K = 0

		LastElem = [null,null,null,Infinity]

		PushingElem = []
		Push = false

		while K < lenFirst
			try
				CheckElem = First[K]
				total = 0
				total += abs CheckElem[0] - MainElem[0]
				total += abs CheckElem[1] - MainElem[1]
			catch
				console.log "problem : " + First[K] + " : " + MainElem
				console.log "K : " + K
				console.log "SizeOfOld : " + First.length
				console.log "SizeOfNew : " + Second.length
				throw "stop"
			if total < 3
				FinalArray.push [Second[I][0],Second[I][1],CheckElem[2]]
				Push = false
				break

			else if total < LastElem[3]

				Push = true

				cloned = CheckElem.slice 0

				cloned.push total

				PushingElem = [LastElem,cloned]

				LastElem = cloned.slice 0

			K += 1

		if Push
			ConfusedArray.push [MainElem[0],MainElem[1],PushingElem]

		I += 1


	return (FinalArray:FinalArray,ConfusedArray:ConfusedArray)

Main.FilterFn = (X,Threshold)->

	if X[2][0][3] > Threshold && X[2][1][3] > Threshold
		return false
	else
		return true

Main.CombineClosedOnes = (ConfusedArray,ListOfIds) ->

	abs = Math.abs
	min = Math.min


	I = 0
	len = ConfusedArray.length
	SizeOfListOfIds = ListOfIds.length
	while I < len

		Elem = ConfusedArray[I][2]

		Elem = _.sortBy Elem,((x)-> x[3])

		NumberOfNeighbours = 2

		K = 0

		Found = false

		while K < NumberOfNeighbours

			IdToMatch = Elem[K][2]

			J = 0

			Found = false

			while J < SizeOfListOfIds

				if IdToMatch == ListOfIds[J]

					Found = true

					break

				J += 1

			if !Found

				ConfusedArray[I][2] = IdToMatch
				ListOfIds.push IdToMatch

				break

			K += 1


		if Found == true
			ConfusedArray[I][2] = null


		I += 1

		# else
		# 	Pendulum.push ConfusedArray[I][2]

	return ListOfIds

Main.AssignIDForNextFrame = (Last,Next,Threshold = 18)->

	{FinalArray,ConfusedArray} = Main.CheckNear Last,Next
	# console.log JSON.strinFinalArray
	ConfusedArray = _.filter ConfusedArray,((X) -> Main.FilterFn X,Threshold)

	ListOfIds = _.map FinalArray,((x)-> x[2])

	Main.CombineClosedOnes ConfusedArray,ListOfIds

	CombinedFinalList = FinalArray.concat ConfusedArray

	return CombinedFinalList


reshape = (vector,Divs) ->

	len = vector.length
	I = 0
	Final = []

	while I < len
		next = I + Divs
		Final.push (vector.slice I,next)
		I = next
	return Final
# 	return



FindBestIndex = (List,LookUpVal,Pos,MaxNumberOfElementInSpace = 5) ->

	# len = List.length

	# StartRegion = 0
	# EndRegion = len
	# round = Math.round
	# while true

	# 	SizeOfRegion = EndRegion - StartRegion
	# 	if SizeOfRegion < MaxNumberOfElementInSpace
	# 		break

	# 	HalfValue = round (SizeOfRegion)/2

	# 	I = StartRegion + HalfValue
	# 	ElemVal = List[I][Pos]


	# 	if ElemVal < LookUpVal
	# 		StartRegion = I -  20
	# 	else
	# 		EndRegion = I +  19

	return [0,List.length]

# log = (X) -> console.log util.inspect X , false, null




MatchEachList = (Unique,PositionGraph,Pos)->
	NumberTooFar = 0
	len = Unique.length
	I = 0
	abs = Math.abs
	while I < len
		y = Unique[I][Pos]
		Indexes = FindBestIndex PositionGraph,y,Pos,600
		K = Indexes[0]
		total = 0
		PreviousTotal = Infinity
		MaxKFound = null
		while K < (Indexes[1])
			total = 0
			total += abs PositionGraph[K][0] - Unique[I][0]
			total += abs PositionGraph[K][1] - Unique[I][1]
			if total < PreviousTotal
				PreviousTotal = total
				MaxKFound = K
			K += 1
		# if PreviousTotal > 150
			# Unique[I][2] = "Too Far"
			# NumberTooFar  += 1
		# else if PreviousTotal < 13
			# Unique[I][2] = "Too Close"
			# NumberTooFar  += 1
		# else
		Unique[I][2] = MaxKFound
		Unique[I][3] = PreviousTotal
		Unique[I][4] = ""
		I += 1
	return


# MatchEachList First,Second,0
# MatchEachList Second,First,0
# # console.log What
# # console.log happen
# # console.log _.sortBy First,((x)-> x[2])
# # console.log Second
# # console.log First[167]
# # console.log Second[167]
# # console.log Second[8]
# # console.log Sorted

# # FindBestIndex Sorted,
# # console.log "Second:"
# # console.log Second

# len = First.length
# Graphs = [First,Second]
# CurrentIndex = 0
# CountOfLocks = 0

# while CurrentIndex < 1
# 	IndexHistory = []
# 	Switched = 0
# 	InsideIndex = CurrentIndex
# 	if Graphs[Switched%2][InsideIndex][4] == "Locked"
# 		CurrentIndex += 1
# 		continue
# 	NextIndex = Graphs[Switched%2][InsideIndex][2]
# 	Switched += 1
# 	NextNextIndex = Graphs[Switched%2][NextIndex][2]
# 	IndexHistory.push CurrentIndex

# 	while true
# 		# console.log InsideIndex
# 		# console.log NextIndex
# 		# console.log NextNextIndex
# 		# console.log CurrentIndex
# 		console.log Graphs[Switched%2][InsideIndex] , " : InsideIndex : ",[InsideIndex]
# 		console.log Graphs[(Switched + 1)%2][NextIndex] , " : NextIndex : ",[NextIndex]
# 		console.log Graphs[Switched%2][NextNextIndex] , " : NextNextIndex : ",[NextNextIndex]
# 		console.log "++++++++++++++ENDOFLOOP++++++++++++++"
# 		# if IndexHistory.length > 20
# 			# console.log IndexHistory
# 			# break
# 		# if IndexHistory.length > 4
# 		# 	console.log CurrentIndex
# 		# 	break
# 		if InsideIndex == NextNextIndex

# 				# console.log InsideIndex + ":" + Graphs[0][InsideIndex]
# 				# console.log NextIndex + ":" + Graphs[1][NextIndex]
# 				CountOfLocks += 1
# 				Graphs[(Switched)%2][NextIndex][4] = "Locked"
# 				Graphs[(Switched+1)%2][InsideIndex][4] = "Locked"

# 				break
# 		else
# 			# IndexPairs.push InsideIndex
# 			# IndexPairs.push NextIndex
# 			# IndexPairs.push NextNextIndex
# 			InsideIndex = NextIndex
# 			IndexHistory.push NextIndex

# 			# Switched += 1
# 			NextIndex = Graphs[Switched%2][InsideIndex][2]

# 			Switched +=	 1
# 			NextNextIndex = Graphs[Switched%2][NextIndex][2]




# 		# if NextNextIndex == CurrentIndex && Switched/2 == 1
# 		# if InsideIndex == CurrentIndex # Curcular Dependencies
# 			# CurrentIndex += 1
# 			# break


# 		# console.log CurrentIndex
# 		# console.log NextIndex
# 		# console.log "__OutOfLoop__"
# 	# I = 0
# 	# # I =
# 	# console.log IndexHistory
# 	# Switched = 1
# 	# _.each IndexHistory,((x)->
# 	# 	Switched += 1
# 	# 	console.log Graphs[Switched%2][x]
# 	# 	)
# 	CurrentIndex += 1


# # console.log IndexHistory
# # console.log Second
# # console.log First

# # console.log Second[198]

# # console.log First.length
# # console.log Foundirst
# # console.log CountOfLocks
# # res = Main.AssignIDForNextFrame First,Second
# acum = 0
# for K from 0 to 10000
# 	start = now!
# 	I = 0
# 	len = 10000

# 	while I < len

# 		I += 1


# 	I = 0
# 	while I < len

# 		I += 1

# 	end  = now!
# 	acum += end - start

# console.log acum/1000 + " Milliseconds"

ForEachElem = (ElemIndex,First,Second,Range,JumpAmount) ->
	# Warning! - JumpAmount should not be greater than Range, or else we will get stuck in infinite Loop

	Elem = First[ElemIndex]


	InitialI = ElemIndex

	x = Elem[0]

	y = Elem[1]

	abs = Math.abs

	SecondLen = Second.length

	XLowerBound = x - Range

	XUpperBound = x + Range

	if InitialI >= SecondLen

		InitialI = SecondLen - 1


	XValueAtSecond = Second[InitialI][0]



	Amount = JumpAmount



	if XValueAtSecond < XLowerBound


		while XValueAtSecond <= XLowerBound
			InitialI += Amount

			XValueAtSecond = Second[InitialI][0]

	if XValueAtSecond > XUpperBound

		while XValueAtSecond >= XUpperBound
			InitialI -= Amount
			XValueAtSecond = Second[InitialI][0]


	LowestDistance = Infinity

	LowestDistanceIndex = 0

	Total = 0

	I = InitialI

	while (XLowerBound <=  XValueAtSecond <= XUpperBound) and (0 < I)

		Total += abs Second[I][1] - y

		Total += abs Second[I][0] - x

		if Total < LowestDistance

			LowestDistance = Total

			LowestDistanceIndex = I

		Total = 0
		I -= 1
		XValueAtSecond = Second[I][0]


	I = InitialI + 1

	Total = 0

	while (XLowerBound <=  XValueAtSecond <= XUpperBound ) and (I < SecondLen)

		Total += abs Second[I][1] - y

		Total += abs Second[I][0] - x

		if Total < LowestDistance

			LowestDistance = Total

			LowestDistanceIndex = I

		Total = 0
		I += 1
		XValueAtSecond = Second[I][0]


	return [LowestDistanceIndex,LowestDistance]

LookUpElem = (First,Elem,TestNull = false)->
	len = First.length
	I = 0
	MaxTotal  = Infinity
	Index = null
	while I < len

		if First[I] == undefined
			I += 1
			continue
		Total = 0
		Total += Math.abs Elem[0] - First[I][0]
		Total += Math.abs Elem[1] - First[I][1]

		if Total < MaxTotal
			if TestNull == true and (First[I][3] == null)
				I += 1
				continue
			MaxTotal = Total
			Index = I

		I += 1

	return Index

# Main.TrackIDs = (First,Second) ->

	First =  _.sortBy First,((x) -> x[0] )
	Second = _.sortBy Second,((x) -> x[0] )

	_.each First,((x,index)->
		# next = ForEachElem index,First,Second,170,1
		next = LookUpElem Second,x
		x[2] = next
		x[3] = null
		return

		)

	_.each Second,((x,index)->

		next = LookUpElem First,x
		x[2] = next
		x[3] = null
		return
		)



	len = First.length
	I = 0

	Graph = [First,Second]
	PredictiveIndex = []
	while I < len
		List = []
		Switched = 0
		NextGraph = (Switched + 1)%2
		CurrentIndex = I
		if Graph[Switched][CurrentIndex][3] != null
			I += 1
			continue
		nextIndex = Graph[Switched][CurrentIndex][2]
		NextNextIndex = Graph[NextGraph][nextIndex][2]


		K = 0
		while true
			if K > 2000
				console.log "This Array"
				return
			K += 1
			if NextNextIndex == CurrentIndex

				p1 = Graph[NextGraph][nextIndex]
				p2 = Graph[Switched][CurrentIndex]

				p1[2] = p1[0]
				p1[3] = p1[1]

				p2[2] = p2[0]
				p2[3] = p2[1]

				p1[0] = p2[2]
				p1[1] = p2[3]

				p2[0] = p1[2]
				p2[1] = p1[3]


				break

			else

				Switched = NextGraph
				NextGraph = (Switched + 1)%2
				List.push [CurrentIndex,NextGraph]


				CurrentIndex = nextIndex

				nextIndex = Graph[Switched][CurrentIndex][2]
				NextNextIndex = Graph[NextGraph][nextIndex][2]


		len2 = List.length

		if len2 > 0
			K = 0
			OdOrEv = len2%2
			if OdOrEv == 1
				PredictiveIndex.push (List.shift!)

			len2 -= 1

			while K < len2

				Top = List.pop!
				Bottom = List.pop!

				p1 = Graph[Top[1]][Top[0]]
				p2 = Graph[Bottom[1]][Bottom[0]]

				p1[2] = p1[0]
				p1[3] = p1[1]

				p2[2] = p2[0]
				p2[3] = p2[1]

				p1[0] = p2[2]
				p1[1] = p2[3]

				p2[0] = p1[2]
				p2[1] = p1[3]


				K += 2
		I += 1

	len = PredictiveIndex.length

	I = 0

	while I < len

		Elem = First[PredictiveIndex[I][0]]

		Close = LookUpElem First,Elem, true

		CloseElem = First[Close]

		Vx = CloseElem[0] - CloseElem[2]

		Vy = CloseElem[1] - CloseElem[3]

		Elem[2] = Elem[0]
		Elem[3] = Elem[1]

		Elem[0] = Elem[2]  + Vx
		Elem[1] = Elem[3]  + Vy

		I += 1

	return First

Main.AssignIds = (List) ->
	_.each List,(x,index)->
		x[4] = index
		return






Main.AssignIDs = (First)->

	len = First.length
	I = 0

	List = []
	List
	while I < len
		ID = I

		x = First[I][0]
		y = First[I][1]


		List.push [ID,x,y,null,null,null,x,y]

		I += 1

	return List




# _.each (_.zip First,Second),((x,index)-> console.log "#{index} : [#{x[0]}] | [#{x[1]}]")




Main.FindStart = (Index,LowerBound,Second,JumpAmount)->

	I = Index

	len = Second.length

	if !(I < len )
		I = len - 1
	SecondInitialX = Second[I][0]
	# console.log LowerBound
	if SecondInitialX < LowerBound

		while SecondInitialX <= LowerBound
			# console.log "I : #{I}"
			# console.log "SecondLenInitialX : #{SecondInitialX}"
			I += JumpAmount
			# console.log I
			# console.log len
			if I < len
				SecondInitialX = Second[I][0]

			else
				return len - 1

	else
		while SecondInitialX >= LowerBound
			I -= JumpAmount
			if I < 0
				return 0
			SecondInitialX = Second[I][0]

	return I

Main.FindClosestElem = (Index,Range,First,Second)->

	abs = @abs
	sqrt = @sqrt
	round = @round

	Elem = First[Index]

	ElemXVal = Elem[1]
	ElemYVal = Elem[2]

	LowerBoundX = ElemXVal - Range
	UpperBoundX = ElemXVal + Range

	I = @FindStart Index,LowerBoundX,Second,3

	CurrentXVal = Second[I][0]

	MaxTotal = Infinity
	len = Second.length

	while CurrentXVal <= UpperBoundX and I < len

		CurrentXVal = Second[I][0]
		CurrentYVal = Second[I][1]

		if (not (Second[I][2] == null))

			Total = 0
			e1 = (ElemXVal - CurrentXVal)
			e2 = (ElemYVal - CurrentYVal)
			Total = sqrt (e1*e1 + e2*e2)

			# Total = pow Total,0.5
			if Total < 4
				Elem[4] = CurrentXVal
				Elem[5] = CurrentYVal
				return [I,round Total]


			if Total < MaxTotal
				EndIndex = I
				MaxTotal = round Total

		I += 1


	return [EndIndex,MaxTotal]

Main.FindBestMatch = (First,Second)->

	len = First.length
	K = 0
	Range = 17
	while K < len
		First[K][3] = Main.FindClosestElem K,Range,First,Second

		K += 1

	return

Main.FrontCheck = (Base0,Base1,Second) ->
	if Base0[4] != null
		return

	ID0 = Base0[3][0]
	ID1 = Base1[3][0]

	if ID0 != ID1
		Elem = Second[ID0]
		Base0[4] = Elem[0]
		Base0[5] = Elem[1]

	return

Main.EdgeCheck = (IndexMain,IndexSecond,Sorted,Second)->

	Base0 = Sorted[IndexMain]
	Base1 = Sorted[IndexSecond]
	@FrontCheck Base0,Base1,Second
	return

Main.UniqueCheck = (Sorted,Second) ->

	len = Sorted.length

	# Main.EdgeCheck 0,1,Sorted,Second
	Main.EdgeCheck len - 1,len - 2,Sorted,Second

	len -= 2

	I = 0

	while I < len

		NumberOfSame = 1

		Base  = Sorted[I]

		Next = Sorted[I + 1]

		IDBase = Base[3][0]

		IDNext = Next[3][0]

		if IDBase == IDNext
			IndexWithLow = I
			# if Base[4] != null
			# 	console.log "Algorithm Threshold set too High!"
			# 	I += 1
			# 	continue
			Distance = Base[3][1]

			while IDBase == IDNext

				MovingIndexId = I + NumberOfSame
				if MovingIndexId > len + 1
					break
				Elem = Sorted[MovingIndexId]

				IDNext = Elem[3][0]

				CurrentDistance = Elem[3][1]

				if CurrentDistance < Distance

					IndexWithLow = MovingIndexId

				Elem = Sorted[IndexWithLow]

				if Elem[4] == null

					FromElem = Second[Elem[3][0]]
					Elem[4] = FromElem[0]
					Elem[5] = FromElem[1]

				NumberOfSame += 1

			I += NumberOfSame - 2

		else if Base[4] == null
			Elem = Second[Base[3][0]]
			Base[4] = Elem[0]
			Base[5] = Elem[1]


		I += 1

	return

Main.Switch = (Sorted)->

	len = Sorted.length

	I = 0
	K = 0

	while I < len

		Elem = Sorted[I]
		X = Elem[4]

		if X

			Elem[3] = null
			Elem[1] = X
			Elem[2] = Elem[5]

		else

			Elem[3] = true
			Elem[1] = Elem[6]
			Elem[2] = Elem[7]
			K += 1

		Elem[4] = null
		Elem[5] = null

		I += 1

	return K

Main.SetHome = (Index,First)->


	Elem = First[Index]
	if Elem[1] == null
		Elem[1] = Elem[6]
		Elem[2] = Elem[7]
		Elem[3] = true

	return

Main.FindGaps = (Sorted)->

	len = Sorted.length - 1
	K = 2

	List = []

	Previous = Sorted[0][3][0] # First
	Next = Sorted[1][3][0] # Next
	# Previous = Sorted[0]
	# Next = Sorted[1]

	while K < len

		Diff = Next - Previous

		Diff -= 1
		if Diff > 0
			N = 1
			while Diff
				List.push Previous + 1*N
				N += 1
				Diff -= 1

		K += 1
		Previous = Next
		Next = Sorted[K][3][0]
	return List

Main.FindNulls =(Sorted)->
	len = Sorted.length
	K = 0
	List = []
	while K < len

		if Sorted[K][4] == null

			List.push K
		K += 1
	return List

Main.TestLeftOver = (ListOfAnon,ListOfNulls,First,Second)->
	len1 = ListOfNulls.length
	K = 0
	list = []
	len2 = ListOfAnon.length
	while K < len1
		Total = 0
		Elem = First[ListOfNulls[K]]
		# console.log Elem
		total = 0
		I = 0
		sqrt = @sqrt
		LowTotal = Infinity
		LowestID = 0

		while I < len2
			Elem2 = Second[ListOfAnon[I]]
			# console.log Elem2
			CurrentX = Elem[1] - Elem2[0]
			CurrentY = Elem[2] - Elem2[1]
			Total = sqrt (CurrentX*CurrentX + CurrentY*CurrentY)
			if Total < LowTotal
				LowTotal = Total
				LowestID = I
			I += 1
		list.push [LowestID,@round LowTotal]
		K += 1
	console.log _.sortBy (_.zip ListOfNulls,list),(x)->x[1][1]
	return


Main.TrackIDs = (First,Second)->


	# First = AssignIDs First
	First = _.sortBy First,(x)->x[1]

	Second = _.sortBy Second,(x)->x[0]

	# _.each First,(x,index)-> console.log "#{index}:[#{x}]"
	# _.each Second,(x,index)-> console.log "#{index}:[#{x}]"

	@FindBestMatch First,Second

	Sorted = _.sortBy First,(x)-> x[3][0]

	Main.UniqueCheck Sorted,Second

	# console.log Sorted
	# ListOfNulls = @FindNulls Sorted
	# ListOfAnon = @FindGaps Sorted
	# Sorted = _.sortBy First,(x)-> x[4]
	# _.each Sorted,(x,index)-> Main.SetHome index,Sorted

	return Main.Switch Sorted


Main.KeepHistory = (HistoryX,HistoryY,HistoryNull,Cloned)->

	lenC = Cloned.length
	lenH = History.length

	Cloned = Sorted = _.sortBy Cloned,((x)->x[0])

	I = 0

	while I < lenC
		Each = Cloned[I]
		(HistoryX[I]).push Each[1]
		(HistoryY[I]).push Each[2]
		(HistoryNull[I]).push Each[3]
		I += 1

	if HistoryX[0].length > 300
		I = 0
		while I < lenC
			HistoryX[I].shift!
			HistoryY[I].shift!
			(HistoryNull[I]).shift!
			I += 1

	return

Main.InitHistory = (HistoryX,HistoryY,HistoryNull,len) ->

	I = 0

	while I < len
		HistoryX[I] = []
		HistoryY[I] = []
		HistoryNull[I] = []
		I += 1

	return

# fs = require "fs"
# I = 1

# History = []


# First = JSON.parse fs.readFileSync "#{I}.txt"

# ClonedFirst = Main.AssignIDs First



# for I from 1 to 7

# 	Second = JSON.parse fs.readFileSync "#{I}.txt"

# 	Main.TrackIDs ClonedFirst,Second

# 	Main.KeepHistory History,ClonedFirst



# console.log _.map History

















# Main.acum = 0

# for I from 0 to 100
	# start = Main.now!
# Main.TrackIDs ClonedFirst, Second
	# Main.acum += Main.now! - start



# console.log Main.abs(Main.acum/100)

# console.log _.sortBy Sorted,(x)-> x[4]
# _.each Sorted,(x,index)-> console.log index + ":" + JSON.stringify x


module.exports = Main







