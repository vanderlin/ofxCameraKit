#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup() {
    
    ofBackground(0);
	ofSetVerticalSync(true);
    activeDevice = NULL;
    
    camera.listCameras();
    camera.setDownloadFolder(ofToDataPath("photos"));
    ofAddListener(camera.deviceEvents, this, &testApp::deviceEvent);

    flash = 0;
    timeSinceLastFire = -3;
    threshold = 0.2;
    
    // turn on sound stream
    int bufferSize = 256;
    volume         = 0;
    soundStream.listDevices();
    soundStream.setup(this, 0, 2, 44100, bufferSize, 4);
    soundStream.start();
}

//--------------------------------------------------------------
void testApp::deviceEvent(ofxDeviceEvent &e) {

    if(e.eventType == ofxCameraKit::CK_ALL_CAMERAS_FOUND) {
        
        cout << "Listing all devices %i" << camera.devices.size() << endl;
        for(int i=0; i<camera.devices.size(); i++) {
            cout << "["<<i<<"] " << camera.devices[i]->name << endl;
            activeDevice = camera.devices[i];
            activeDevice->openDevice();
            activeDevice->enableTethering();
            
        }
        
    }
    
    if(e.eventType == ofxCameraKit::CK_CAMERA_REMOVED) {
        if(activeDevice == e.device->device) {
            activeDevice = NULL;
        }
    }
    
    if(e.eventType == ofxCameraKit::CK_CAMERA_READY) {
        e.device->enableTethering();
    }
    
    
    if(e.eventType == ofxCameraKit::CK_PHOTO_DOWNLOADED) {
        printf("downloading: %s", e.photoPath.c_str());
        latestImage.loadImage(e.photoPath);
    }
    
}

//--------------------------------------------------------------
void testApp::audioIn(float * input, int bufferSize, int nChannels){	
	
	float curVol = 0.0;
	
	// samples are "interleaved"
	int numCounted = 0;	
    
	//lets go through each sample and calculate the root mean square which is a rough way to calculate volume	
	for (int i = 0; i < bufferSize; i++){
		float left	= input[i*2]*0.5;
		float right	= input[i*2+1]*0.5;
        
		curVol += left  * left;
		curVol += right * right;
		numCounted+=2;
	}
	
	//this is how we get the mean of rms :) 
	curVol /= (float)numCounted;
	
	// this is how we get the root of rms :) 
	curVol = sqrt( curVol );
	volume = curVol;
    
}

//--------------------------------------------------------------
void testApp::exit() {
}

//--------------------------------------------------------------
void testApp::update() {
    
    float fireTime = ofGetElapsedTimef() - timeSinceLastFire;
    if(volume > threshold) {
        
        if(fireTime > 1.5 && activeDevice) {
            printf("Fire Camera!\n");   
            flash = 1;
            timeSinceLastFire = ofGetElapsedTimef();
            activeDevice->takePicture();
        }
    }
    flash *= 0.98f;
}


//--------------------------------------------------------------
void testApp::draw(){
    
    ofEnableAlphaBlending();
    ofFill();
    ofSetColor(255, flash*255);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    

    if(latestImage.isAllocated()) {
        float w = ofGetWidth();
        float h = w * ((float)latestImage.getHeight()/(float)latestImage.getWidth());
        ofSetColor(255);
        latestImage.draw((ofGetWidth()-w)/2,
                         (ofGetHeight()-h)/2, w, h);              
    }
    
    
    // what is the volume
    ofSetColor(225);
    string info = "Volume: "+ofToString(volume)+"\nThreshold: "+ofToString(threshold)+"\n";
    if(activeDevice) {
        info += activeDevice->name + " connected";
    }
    ofDrawBitmapString(info, 20, 20);
    
    
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if(key == ' ' && camera.devices.size()>0) {
        if(activeDevice) activeDevice->takePicture();    
    }
    if(key == 'f') ofToggleFullscreen();
    
    if(key == OF_KEY_UP) threshold += 0.03;
    if(key == OF_KEY_DOWN) threshold -= 0.03;
}

//--------------------------------------------------------------
void testApp::keyReleased(int key){
	
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y ){
	
}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button){
}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button){
}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button){
	
}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h){
	
}

//--------------------------------------------------------------
void testApp::gotMessage(ofMessage msg){
	
}

//--------------------------------------------------------------
void testApp::dragEvent(ofDragInfo dragInfo){ 
	
}
