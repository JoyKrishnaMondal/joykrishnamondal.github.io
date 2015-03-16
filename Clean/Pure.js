var Main = {};

Main.ReduceRowDimensionality = function(Index,LastIndexOfIndex,ListOfCentroids,RowLookUp,MaxRadiusOfPin) {

	var x;
	var y;
	var LoCL;
	var XY;
	var Current;
	var temp;
	var found = false;
	var floor = Math.floor;
	var abs = Math.abs;
	var round = Math.round;

	temp = [Index[0]%640,floor(Index[0]/640),1];

	ListOfCentroids.push(temp);

		for (var I = 1;I<LastIndexOfIndex;)
		{

			x = Index[I]%640;

			y = floor(Index[I]/640);

			temp = 0;

			LoCL = ListOfCentroids.length;

			for (var k = 0;;)
			{

				Current = LoCL - k - 1;


				if (Current < 0) // Used for breaking loop when List of Centroids is not big enough
				{
					break;
				}

				XY = ListOfCentroids[Current]; // get the current value for List of centroids to analyse

				if (abs(y - XY[1])> RowLookUp) // If we moved More than 3 rows up the ListOfCentroids Chain
				{
					found = false; // If we enter this state it means the loop hasn't found an centers
					break;
				}
				//#       #       #       #  Not Sure that this part does #       #       #       #

				// else if ((x - XY[0]) < -10)
				// {
				// 	ListOfCentroids.push([x,y,1]);
				// 	break;
				// }
				//#       #       #       #  Not Sure that this part does #       #       #       #

				else if(abs(XY[0] - x) < MaxRadiusOfPin)
				{
					found = true;
					temp = ListOfCentroids[Current][2] + 1;

					ListOfCentroids[Current] = [round((x + XY[0]*(temp - 1))/(temp)),round((y + XY[1]*(temp - 1))/(temp)),temp];

					break;
				}
				found = false;
				k += 1;
			}

			if (!found)
			{
				ListOfCentroids.push([x,y,1]);
			}


			I += 1


		}
};

Main.FindIndex = function(List,Index,MaxRadiusOfPin,Luminosity){

		var I = 0|0;

		var PreviousIndex = 0|0;

		var IndexStore = [];

		var Diff = 0|0;

		var Acum = 0|0;

		var len = 0|0;

		var LastOneWasLum = false;


		for (var x = 0;x<(640*480 - 1);)
			{
					if (List[x]>Luminosity)
						{

							Diff = x - PreviousIndex;

							if (Diff < 1.1 && Diff > -1.1)
							{
								IndexStore.push(x);
							}
							PreviousIndex = x;
							LastOneWasLum = true;
						}

					else if(LastOneWasLum)
					{
						LastOneWasLum = false;

						len = IndexStore.length;

						if (len > 1 && len < MaxRadiusOfPin)
						{
							for (var K = 0; K < len ;)
								{
									Acum += IndexStore.pop();
									K += 1;
								}

								Index[I] = Acum/len;

								Acum = 0;

								I += 1;
						}
						else
						{
							for (var K = 0; K < len ;)
								{
									IndexStore.pop();
									K += 1;
								}
						}


					}
					x += 1;

			}


		return I;
	};

Main.WriteToList = function(imageData,List){

		var average = 0;
		var N = 0;
		for (var x = 0;x<(640*480*4);)
		{

				List[N] = (imageData[x] + imageData[x + 1] + imageData[x + 2] )/3;

				x += 4;
				N += 1;
			}};

Main.BackOperations = function(imageData,List){
	var value = 0;
	var y = 0;
	var x = 0
		for (; y<(640*480) ;)
		{
			value = List[y];
			imageData[x] = value;
			imageData[x + 1] = value;
			imageData[x + 2] = value;
			imageData[x + 3] = 255;
			y += 1;
			x += 4;
		}};

Main.DrawOnCanvas = function(ListOfCentroids,ctx){

	ctx.font = "6px Verdana";
	ctx.fillStyle = "#00FF2F";
	if (ListOfCentroids == undefined)
		{
			return
		}
	var Last = ListOfCentroids.length;
	var Center;
	for (var I = 0;I<Last;)
	{
		Center = ListOfCentroids[I];

			if (Center[3] == true )
		{
			ctx.fillStyle = "#FF0000";
			ctx.fillText(Center[0],Center[1],Center[2]);
			ctx.fillStyle = "#00FF2F";
		}
		else
		{
			ctx.fillText(Center[0],Center[1],Center[2]);
		}

		I += 1;
	}

};

Main.XYto1DArray = function(ListOfXY){

	var len = ListOfXY.length;
	var Vector = [];

	for (var I = 0;I<len;)
		{
			Vector.push(Math.round(ListOfXY[I][0])*640 + ListOfXY[I][1]);
			I += 1;
		}

		return Vector;
}

Main.DrawIndexOnPixel = function(IndexBuffer,ImageData,BufferLength){

	var ArrayPos;
	var len = ImageData.length;
	for (var I =0;I<len;)
	{
		ImageData[I] = 0;
		I += 1;
	}

	for (var I = 0;I<BufferLength;)
	{
		ArrayPos = IndexBuffer[I];
		ImageData[ArrayPos] = 255;


		I += 1;
	}

};

// Main.CheckID = function(Previous,Next)
// {
// 	// Previous = [#,#,1]
// 	// Next = [1,2,#]

// 	var len = Previous.length;
// 	var NextLen = Next.length;
// 	var IdElem;
// 	var PosElem;
// 	var abs = Math.abs;
// 	var total = 0;
// 	var LastMaxTotal = Infinity;

// 	var IdElemClone = [0,0];

// 	var TwoStore = [];

// 		PosElem = Next[K];

// 		LastMaxTotal = Infinity;

// 		for(var I = 0;I<NextLen;)
// 		{
// 			IdElem = Previous[I];

// 			total = 0;
// 			total += abs(IdElem[0] - PosElem[0]);
// 			total += abs(IdElem[1] - PosElem[1]);

// 			if(total < LastMaxTotal)
// 			{
// 				IdElemClone[0] = PosElem[0];
// 				IdElemClone[1] = PosElem[1];
// 				LastMaxTotal = total;
// 			}

// 			I += 1;

// 		}

// 		Previous[K][0] = IdElemClone[0];
// 		Previous[K][1] = IdElemClone[1];

// 		K += 1;
// 	}

// };


module.exports = Main
