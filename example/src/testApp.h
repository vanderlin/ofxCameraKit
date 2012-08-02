#pragma once
#include "ofMain.h"
#include "ofxCameraKit.h"

class SimpleButton : public ofRectangle {
  public:
    SimpleButton() {
        bPressed = false;
    }
    bool bPressed;  
};

class testApp : public ofBaseApp{
	
public:
	void setup();
	void update();
	void draw();
	
	void exit();

	void keyPressed(int key);
	void keyReleased(int key);
	void mouseMoved(int x, int y );
	void mouseDragged(int x, int y, int button);
	void mousePressed(int x, int y, int button);
	void mouseReleased(int x, int y, int button);
	void windowResized(int w, int h);
	void dragEvent(ofDragInfo dragInfo);
	void gotMessage(ofMessage msg);		
    void deviceEvent(ofxDeviceEvent &e);
    
    vector <SimpleButton> buttons;
    ofxCameraKit          camera;
    ofxCameraDevice *     activeDevice;
    ofImage               latestImage;
};

