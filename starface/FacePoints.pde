import processing.video.*;

public class FacePoints{

	starface parentSketch;
	Capture cam;
	IntList xPoints = new IntList();
	IntList yPoints = new IntList();
	boolean confirm = false;
	String outputFile = "data/input.csv";
	int startingAt;
	int transitionDuration = 500;
	int transitionColor = color(0,30);
	int strColor = color(255,255,0);
	float pointSize;
	int W;
	int H;


	FacePoints(starface sf, int w, int h){
		this.parentSketch = sf;
		this.W = w;
		this.H = h;
	}


	public void FPsetup() {

		pointSize = parentSketch.starSize;
		String[] cameras = Capture.list();
		if (cameras == null) {
			println("Failed to retrieve the list of available cameras, will try the default...");
			cam = new Capture(parentSketch, 640, 480);
			// cam = new Capture(this, 640, 480);
		}
		if (cameras.length == 0) {
			println("There are no cameras available for capture.");
			exit();
		}
		else {
			println("Available cameras:");
			for (int i = 0; i < cameras.length; i++) {
				println(cameras[i]);
			}
			String cameraName = cameras[0].substring(5,cameras[0].indexOf(','));
			String paramName = "name="+ cameraName +",size="+ W +"x"+ H +",fps=" +25;
			println(paramName);
			// cam = new Capture(parentSketch, cameras[0]);
			// cam = new Capture(parentSketch, W,H, 25, cameraName);
			cam = new Capture(parentSketch, paramName);
			// "name=FaceTime HD Camera,size=1280x720,fps=30"
			cam.start();

		}

		fill(255);
		noStroke();
	}

	public void FPmouseClicked(){
		xPoints.append(mouseX);
		yPoints.append(mouseY);
	}

	public void FPkeyPressed(){

		if(xPoints.size() > 0){
			String lines[] = new String[xPoints.size()]; 
			for (int i = 0; i < xPoints.size(); i++){
				lines[i] = ""+ xPoints.get(i) +";"+ yPoints.get(i) +";0"; 
			}
			saveStrings(outputFile, lines);
			println("yo! ");
			confirm = true;
			cam.stop();
			parentSketch.sketchState = "1a";
			startingAt = millis();//store the current time
		}
	}

	public void FPdraw() {
		if (cam.available() == true) {
			cam.read();
		}
		pushMatrix(); 
		translate(width,0);
		scale(-1,1); 
		image(cam, 0, 0);
		filter(GRAY);
		popMatrix(); 

		for (int i = 0; i < xPoints.size(); i++){
			fill(255); noStroke();
			ellipse(xPoints.get(i), yPoints.get(i), pointSize, pointSize); 
			stroke(strColor); noFill();
			ellipse(xPoints.get(i), yPoints.get(i), pointSize+6, pointSize+6); 
		}

		if(confirm == true){
			FPconfirmation();
			confirm = false;
		}
	}

	public void FPfade() {
		if( (millis() - startingAt) < transitionDuration){
			fill(transitionColor);
			rect(0,0, width, height);
			fill(255);
			for (int i = 0; i < xPoints.size(); i++){
				ellipse(xPoints.get(i), yPoints.get(i), pointSize, pointSize); 
			}
		}
		else parentSketch.sketchState = "2";
	}

	public void FPconfirmation(){

		int startingAt = millis();//store the current time
		int wait = 500;

		fill(255);
		rect(10,10, width-20,height-20);
		
		fill(0);
		PFont font = createFont("Source Code Pro", 50);
	    textAlign(CENTER, CENTER);
	    textFont(font);

	    // delay
		while(millis() - startingAt <= wait){
			// wait
		}
	}
}











