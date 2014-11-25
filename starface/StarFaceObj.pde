public class StarFaceObj{

	starface parentSketch;
	float canvasChosenStarSize;
	float minCanvasStarSize = 1;
	float maxCanvasStarSize = 2.5;
	float minCanvasStarAlpha = 50;
	float maxCanvasStarAlpha = 150;
	float minCanvasZ = -500;
	float maxCanvasZ = 500;
	float extraMargin = 300;
	float autorotationSpeed = 0.03;
	float scrollRotationSpeed = 0.003;

	// REAL BOUNDRIES brightest-ones.csv
	// float minStarX = -3451.3987;
	// float maxStarX = 3294.3516;
	// float minStarY = -3713.7239;
	// float maxStarY = 3009.5964;
	// float minStarZ = -670.2237;
	// float maxStarZ = 1501.8143;

	// REAL BOUNDRIES nearest15K.csv
	float minStarX = -75.7139;
	float maxStarX =  75.5999;
	float minStarY = -75.3572;
	float maxStarY =  75.3197;
	float minStarZ = -75.3176;
	float maxStarZ =  75.4815;
	float minStarAppMag =  -1.44;
	float maxStarAppMag =  13.25;
	

	//----------------------------

	boolean autorotation = false;
	boolean showText = false;
	float rotationAmount = 0;

	int canvasW;
	int canvasH;
	String[][] starData;
	String[][] inputData;
	String[][] inputData2;
	float[][] starDataCanvas;
	int[] indexes;
	//String[] lines;
	String dataFile = "data/nearest15K.csv";
	String dataFileInput = "data/input.csv";
	String dataFileInput2 = "";//../sharedData/connections_SINE.csv"; //leave empty if no connection file
	float tempVal;
	PFont font;

	StarFaceObj(starface sf, int w, int h){
		this.parentSketch = sf;
		canvasW = w;
		canvasH = h;
	}

	void SFsetup() {
		// size(canvasW, canvasH, P3D);
		canvasChosenStarSize = parentSketch.starSize;
		starData = readCsv(dataFile);
		inputData = readCsv(dataFileInput);
		if(!dataFileInput2.equals("")) inputData2 = readCsv(dataFileInput2);

		starDataCanvas = new float[starData.length][3];
		indexes = new int[inputData.length];

		//copy an array with all stars translated to canvas values
		for(int i=0; i<starData.length; i++){
			float stellarX = parseFloat(starData[i][0]);
			float stellarY = parseFloat(starData[i][1]);
			float stellarZ = parseFloat(starData[i][2]);
			starDataCanvas[i][0] = map(stellarX, minStarX,maxStarX, 0-extraMargin,canvasW+extraMargin);
			starDataCanvas[i][1] = map(stellarY, minStarY,maxStarY, 0-extraMargin,canvasH+extraMargin);
			starDataCanvas[i][2] = map(stellarZ, minStarZ,maxStarZ, minCanvasZ-extraMargin,maxCanvasZ+extraMargin);
			//println("X=" + starDataCanvas[i][0] + ", Y=" + starDataCanvas[i][1] + ", Z=" + starDataCanvas[i][2]);
		}

		// building array of chosen indexes
		for(int i=0; i<inputData.length; i++){
			println("---input point n "+i);
			float minimumValue = width*height;
			for(int j=0; j<starDataCanvas.length; j++){
				tempVal = dist(parseFloat(inputData[i][0]),parseFloat(inputData[i][1]), starDataCanvas[j][0],starDataCanvas[j][1]);
				if(tempVal < minimumValue ){
					minimumValue = tempVal;
					indexes[i] = j;
					println("dist"+minimumValue + ", j=" + j);
				}
			}
		}

		noStroke();

		//--- camera
		camera(width/2.0, height/2.0, (height/0.1) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
		
		//--- perspective
		//float cameraZ = (height/2.0) / tan(PI*30.0/360.0);
		//perspective(radians(10), width/height, cameraZ/15.0, cameraZ*15.0);

		//--- perspective
		ortho();

	    textAlign(CENTER, TOP);
	    font = createFont("Source Code Pro", 11);
	    textFont(font);
	    
	    parentSketch.sketchState = "3";
		//frameRate(5);
	}

	void SFdraw(){

		background(0);


		// // plot original input
		// fill(255,0,0);
		// for(int i=0; i<inputData.length; i++){
		// 	ellipse(parseFloat(inputData[i][0]),parseFloat(inputData[i][1]), 5, 5);
		// 	//println("X=" + parseFloat(inputData[i][0]) + ", Y=" + parseFloat(inputData[i][1]));
		// }

		fill(255);
		noFill();
		stroke(255, 120);

		// rotation
		translate(width/2, height/2);
		if(autorotation){ 
			rotateY(rotationAmount+=autorotationSpeed); 
			if( (rotationAmount % (PI*2))  < autorotationSpeed ){ 
				autorotation = false; 
				rotationAmount = 0;
			}
		}
		else{ rotateY(rotationAmount); }
		println(rotationAmount);
		translate(-width/2, -height/2);

		// plot all stars
		for(int i=0; i<starDataCanvas.length; i++){
			float thisStarSize = map(parseFloat(starData[i][6]), minStarAppMag,maxStarAppMag, minCanvasStarSize,maxCanvasStarSize);
			strokeWeight(thisStarSize);
			float thisStarAplha = map(parseFloat(starData[i][6]), minStarAppMag,maxStarAppMag, minCanvasStarAlpha,maxCanvasStarAlpha);
			stroke(255, 255, 0, thisStarAplha);
			point(starDataCanvas[i][0], starDataCanvas[i][1], starDataCanvas[i][2]);
		}
		
		// plot connections
		stroke(150);
		strokeWeight(1);
		if(!dataFileInput2.equals("")){
			for(int i=0; i<inputData2.length; i++){
				line(
					starDataCanvas[indexes[parseInt(inputData2[i][0])]][0],starDataCanvas[indexes[parseInt(inputData2[i][0])]][1],starDataCanvas[indexes[parseInt(inputData2[i][0])]][2],
					starDataCanvas[indexes[parseInt(inputData2[i][1])]][0],starDataCanvas[indexes[parseInt(inputData2[i][1])]][1],starDataCanvas[indexes[parseInt(inputData2[i][1])]][2]
					);
			}
		}

		// plot chosen stars
		stroke(255);
		strokeWeight(canvasChosenStarSize);
		for(int i=0; i<indexes.length; i++){
			float plotX = starDataCanvas[indexes[i]][0];
			float plotY = starDataCanvas[indexes[i]][1];
			float plotZ = starDataCanvas[indexes[i]][2];
			point(plotX,plotY,plotZ);
			//line(starDataCanvas[indexes[i]][0],starDataCanvas[indexes[i]][1], parseFloat(inputData[i][0]),parseFloat(inputData[i][1]));
            
			// plot star names
            if(showText==true){
            	String starName = starData[indexes[i]][17];
            	translate(plotX,plotY,plotZ);
            	rotateY(-rotationAmount);
            	text(starName, 0,0,0);
            	rotateY(rotationAmount);
            	translate(-plotX,-plotY,-plotZ);
            }
		}

	}


	void SFmouseWheel(MouseEvent event) {
		float e = event.getCount();
		rotationAmount += e*scrollRotationSpeed;
	}


	void SFmouseClicked() {
		//rotationAmount = 0;
		if(autorotation == true) autorotation = false;
		else autorotation = true;
	}


	void SFkeyPressed(){
		showText = !showText;
	}


	String[][] readCsv(String source) {
		String cellSeparator = ";";
		String[] lines = loadStrings(source);
		String[] headers = lines[0].split(cellSeparator);
		String[][] results = new String[lines.length][headers.length];

		for (int i=0; i<lines.length; i++) {
			results[i] = lines[i].split(cellSeparator);
			//println(results[i][0]);
		}
		return results;
	} 
}
