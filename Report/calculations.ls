

Calculations = ->
	#Using cubic regression for e-commerce sales worldwide to predict sales in 2020.
	x = [2013,2014,2015,2016,2017,2018,2019,2020]
	y = [1.233,1.471,1.700,1.922,2.143,2.356,null,null]
	vals = reg 'polynomial',(_.zip x , y),2
	array = vals.points
	points = __.map array, (x) -> {x:x[0],y:x[1]}
	Data = (values:points,key:"E-Commerce Sales",color:"#2ca02c")
	# console.log Data
	return Data







options = 
	scaleShowGridLines : true
	scaleGridLineColor : "rgba(0,0,0,.05)"
	scaleGridLineWidth : 1
	bezierCurve : true
	bezierCurveTension : 0.4
	pointDot : true
	pointDotRadius : 4
	pointDotStrokeWidth : 1
	pointHitDetectionRadius : 20
	datasetStroke : true
	datasetStrokeWidth : 2
	datasetFill : true
	legendTemplate : "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
data = 
	labels: [x]
	datasets:
		[
			label: "My First dataset", fillColor: "rgba(220,220,220,0.2)"
			strokeColor: "rgba(220,220,220,1)"
			pointColor: "rgba(220,220,220,1)"
			pointStrokeColor: "\#fff"
			pointHighlightFill: "\#fff"
			pointHighlightStroke: "rgba(220,220,220,1)"
			data: [65, 59, 80, 81, 56, 55, 40] 
		,
			label: "My Second dataset"
			fillColor: "rgba(151,187,205,0.2)"
			strokeColor: "rgba(151,187,205,1)"
			pointColor: "rgba(151,187,205,1)"
			pointStrokeColor: "\#fff"
			pointHighlightFill: "\#fff"
			pointHighlightStroke: "rgba(151,187,205,1)"
			data: [28, 48, 40, 19, 86, 27, 90]

		] 
	