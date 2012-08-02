#include "testApp.h"

//--------------------------------------------------------------
void testApp::setup() {
    
	ofSetVerticalSync(true);
    
    activeDevice = NULL;
    
    camera.listCameras();
    camera.setDownloadFolder(ofToDataPath("photos"));
    ofAddListener(camera.deviceEvents, this, &testApp::deviceEvent);
    
    cout << "download path: " << camera.downloadPath << endl;
}

//--------------------------------------------------------------
void testApp::deviceEvent(ofxDeviceEvent &e) {

    if(e.eventType == ofxCameraKit::CK_ALL_CAMERAS_FOUND) {
        
        cout << "Listing all devices %i" << camera.devices.size() << endl;
        for(int i=0; i<camera.devices.size(); i++) {
            cout << "["<<i<<"] " << camera.devices[i]->name << endl;
            
            SimpleButton btn;
            btn.set(0, 0, 30, 30);
            buttons.push_back(btn);
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
void testApp::exit() {
}

//--------------------------------------------------------------
void testApp::update(){
    
}


//--------------------------------------------------------------
void testApp::draw(){
    
    ofSetColor(25);
    ofDrawBitmapString("click the square to open the device\nthen f to take a picture from that device", 10, 20);

    for(int i=0; i<camera.devices.size(); i++) {
        
        float sy = 100;
        buttons[i].set(10, sy+(i*30), 20, 20);
        
        buttons[i].bPressed ? ofSetColor(100, 200, 0) : ofSetColor(25);
        ofFill();
        ofRect(buttons[i].x, buttons[i].y, 20, 20);
        ofSetColor(25);
        ofDrawBitmapString(camera.devices[i]->name, 35, sy+15+(i*30));
        
        
        if(camera.devices[i]->isOpen) {
            ofDrawBitmapString("press f to take picture", 235, sy+15+(i*30));
        }
    }
    
    if(latestImage.isAllocated()) {
        float w = 500;
        float h = w * ((float)latestImage.getHeight()/(float)latestImage.getWidth());
        ofSetColor(255);
        latestImage.draw((ofGetWidth()-w)/2,
                         (ofGetHeight()-h)/2, w, h);              
    }
}

//--------------------------------------------------------------
void testApp::keyPressed(int key){
    if(key == 'f' && camera.devices.size()>0) {
        if(activeDevice) activeDevice->takePicture();    
    }
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
    for(int i=0; i<camera.devices.size(); i++) {
        if(buttons[i].inside(x, y)) {
            buttons[i].bPressed = !buttons[i].bPressed;
            ofxCameraDevice * c = camera.devices[i];
            activeDevice = c;
            if(buttons[i].bPressed) {
                c->openDevice();
            }
            else c->closeDevice();
        }
    }
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
