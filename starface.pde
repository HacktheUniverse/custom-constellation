import processing.video.*;

//--------------------------------------------
// DON'T USE 1a = fade into black
// DON'T USE 3 = StarFaceObj.SFdraw --> star display 
// USE 1 = input the points (FacePoints)
// USE 2 = use existing input (StarFaceObj.SFsetup)
String sketchState = "1";

int canvasW = 1200;
int canvasH = 680;
float starSize = 6;
FacePoints fp = new FacePoints(this, canvasW,canvasH);
StarFaceObj sf = new StarFaceObj(this, canvasW,canvasH);

//--------------------------------------------

void setup(){

	size(canvasW, canvasH, OPENGL);
	fp.FPsetup();
}

void draw(){
	if(sketchState == "1") fp.FPdraw();
	if(sketchState == "1a") fp.FPfade();
	if(sketchState == "2") sf.SFsetup();
	if(sketchState == "3") sf.SFdraw();
}


void mouseClicked() {
	if(sketchState == "1") fp.FPmouseClicked();
	if(sketchState == "3") sf.SFmouseClicked();
}


void keyPressed(){
	if(sketchState == "1") fp.FPkeyPressed();
	if(sketchState == "3") sf.SFkeyPressed();
}


void mouseWheel(MouseEvent event){
	if(sketchState == "3") sf.SFmouseWheel(event);
}
