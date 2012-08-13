//
//  Test.h
//  Triangle
//
//  Created by Todd Vanderlin on 7/31/12.
//  Copyright (c) 2012 Interactive Design. All rights reserved.
//

#pragma once
#include "ofMain.h"


class ofxCameraDevice {

    public:
    string  name;
    ofImage icon;
    bool    isOpen, isBusy;
    bool    bOpenThenTakePicture;
    bool    bRemove;
    void *  device;
    
    ofxCameraDevice() {

        device  = NULL;
        isOpen  = false;
        bRemove = false;
        isBusy  = false;
        bOpenThenTakePicture = false;
    }
    
    void enableTethering();
    void disableTethering();
    void takePicture();
    void openDevice();
    void closeDevice();
    void removeAllImages();
};

class ofxDeviceEvent : public ofEventArgs {
public:
	
	ofxDeviceEvent() {
		device    = NULL;
		object	  = NULL;
		eventType = -1;
	}
	
	ofxCameraDevice * device;
	void   *	object;
	int			eventType;
	string		photoPath;
	string		photoName;
};

class ofxCameraKit {
    
    public:

    enum {
        CK_CAMERA_READY,
        CK_PHOTO_DOWNLOADED,
        CK_ALL_CAMERAS_FOUND,
        CK_CAMERA_REMOVED
    };
    
    ofxCameraKit();
    void listCameras();
    void setDownloadFolder(string path);
    
    string downloadPath;
    vector  <ofxCameraDevice*> devices;
    ofEvent <ofxDeviceEvent>   deviceEvents;

};