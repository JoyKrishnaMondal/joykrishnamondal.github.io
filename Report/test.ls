
nv = require "./nvd3/nv.d3.min.js"

d3 = require "d3"


MyChart = {}

MyChart.CreateSimpleChart = (data,element) ->

 nv.addGraph ->

  chart = nv.models.lineChart!
  .margin (left: 100)
  .useInteractiveGuideline true
  .transitionDuration 350
  .showLegend true
  .showYAxis true
  .showXAxis true
  console.log d3
  chart.xAxis
  .axisLabel 'Time (ms)'
  .tickFormat d3.format ',r'
  chart.yAxis
  .axisLabel 'Voltage (v)'
  .tickFormat d3.format '.02f'

  nv.utils.windowResize -> chart.update!

  d3.select element
    .datum data

  chart

module.exports = MyChart

# #   var myData = sinAndCos();   //You need data...

# #   d3.select('#chart svg')    //Select the <svg> element you want to render the chart in.
# #       .datum(myData)         //Populate the <svg> element with chart data...
# #       .call(chart);          //Finally, render the chart!

# #   //Update the chart when window resizes.
#
#
# });
# /**************************************
#  * Simple test data generator
#  */
# function sinAndCos() {
#   var sin = [],sin2 = [],
#       cos = [];

#   //Data is represented as an array of {x,y} pairs.
#   for (var i = 0; i < 100; i++) {
#     sin.push({x: i, y: Math.sin(i/10)});
#     sin2.push({x: i, y: Math.sin(i/10) *0.25 + 0.5});
#     cos.push({x: i, y: .5 * Math.cos(i/10)});
#   }

#   //Line chart data should be sent as an array of series objects.
#   return [
#     {
#       values: sin,      //values - represents the array of {x,y} data points
#       key: 'Sine Wave', //key  - the name of the series.
#       color: '#ff7f0e'  //color - optional: choose your own line color.
#     },
#     {
#       values: cos,
#       key: 'Cosine Wave',
#       color: '#2ca02c'
#     },
#     {
#       values: sin2,
#       key: 'Another sine wave',
#       color: '#7777ff',
#       area: true      //area - set to true if you want this line to turn into a filled area chart.
#     }
#   ];
# }
