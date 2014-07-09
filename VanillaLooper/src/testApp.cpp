/*
 * Copyright (c) 2011 Dan Wilcox <danomatika@gmail.com>
 *
 * BSD Simplified License.
 * For information on usage and redistribution, and for a DISCLAIMER OF ALL
 * WARRANTIES, see the file, "LICENSE.txt," in this distribution.
 *
 * See https://github.com/danomatika/ofxPd for documentation
 *
 */
#include "testApp.h"

#include <Poco/Path.h>

//--------------------------------------------------------------
void testApp::setup() {

	// the number of libpd ticks per buffer,
	// used to compute the audio buffer len: tpb * blocksize (always 64)
	#ifdef TARGET_LINUX_ARM
		// longer latency for Raspberry PI
		int ticksPerBuffer = 32; // 32 * 64 = buffer len of 2048
		int numInputs = 0; // no built in mic
	#else
		int ticksPerBuffer = 8; // 8 * 64 = buffer len of 512
		int numInputs = 1;
	#endif

	// setup OF sound stream
	ofSoundStreamSetup(2, numInputs, this, 44100, ofxPd::blockSize()*ticksPerBuffer, 3);

	// setup the app core
	//core.setup(2, numInputs, 44100, ticksPerBuffer);
    ofSetFrameRate(60);
	ofSetVerticalSync(true);
	//ofSetLogLevel(OF_LOG_VERBOSE);
    
	// double check where we are ...
	cout << ofFilePath::getCurrentWorkingDirectory() << endl;
    
	if(!pd.init(2, numInputs, 44100, ticksPerBuffer)) {
		OF_EXIT_APP(1);
	}
    pd.start();//Turn dsp on
    //Open Patches and instances
    
  // patch = pd.openPatch("pd/LooperVanillaiOS.pd");
	//cout << patch << endl;
    
    for(int i = 0; i < 2; ++i) {
		Patch p = pd.openPatch("pd/LooperVanillaiOS.pd");
		instances.push_back(p);
	}
    patchIdx = 0;
    //set frame buffer
    
    fbo.allocate(ofGetWidth(), ofGetWidth()/2);
   /* fbo.begin();
    ofBackground(255, 255, 255);
    fbo.end();*/
    
    
}

//--------------------------------------------------------------
void testApp::update() {
    ofBackground(100, 100, 100);
    pd.readArray(instances[patchIdx].dollarZeroStr()+"-looper", scopeArray);
    
    fbo.begin();
    draw1();
    fbo.end();

}

//--------------------------------------------------------------
void testApp::draw() {
	
    ofBackground(255,255,255);
    ofSetColor(255,255, 255);
    if (patchIdx == 0) {
        fbo.draw(0, 0);
    }else {
        fbo.draw(0,ofGetHeight()/(patchIdx+1));
        
    }
	
    
    
	/*ofSetColor(0, 255, 0);
	ofSetRectMode(OF_RECTMODE_CENTER);
	float x = 0, y = ofGetHeight()/2;
	float w = ofGetWidth() / (float) scopeArray.size(), h=fbo.getHeight()/2;//h = ofGetHeight()/2;
	for(int i = 0; i < scopeArray.size()-1; ++i) {
		ofLine(x, y+scopeArray[i]*h, x+w, y+scopeArray[i+1]*h);
		x += w;
	}*/
}

void testApp::draw1(){
    ofBackground(ofColor::gray);
	ofSetColor(0, 255, 0);
	//ofSetRectMode(OF_RECTMODE_CENTER);
	float x = 0, y = fbo.getHeight()/2;
	float w = fbo.getWidth() / (float) scopeArray.size(), h=fbo.getHeight()/2;//h = ofGetHeight()/2;
	for(int i = 0; i < scopeArray.size()-1; ++i) {
		ofLine(x, y+scopeArray[i]*h, x+w, y+scopeArray[i+1]*h);
		x += w;
	}
}

//--------------------------------------------------------------
void testApp::exit() {
	
}

//--------------------------------------------------------------
void testApp::keyPressed(int key) {

    static int recordToggle = 0;
    static int reverseToggle = 0;
    static int muteToggle = 0;
   // static int patchIdx =0;
    if(key == '1'){patchIdx =0; cout<<"loop 1 active"<<endl;}
    if(key == '2'){patchIdx=1;cout<<"loop 2 active"<<endl;}
    
    switch (key) {
        case 's'://start/stop recording
            recordToggle = (recordToggle +1)%2;
            pd.sendFloat(instances[patchIdx].dollarZeroStr()+"-start_stop", recordToggle);
            break;
        case 'c'://clear loop
            
            pd.sendBang(instances[patchIdx].dollarZeroStr()+"-clear");
           
            break;
        case 'r':
             reverseToggle = (reverseToggle +1)%2;
            pd.sendFloat(instances[patchIdx].dollarZeroStr()+"-reverse",reverseToggle);
            break;
        case 'm':
            muteToggle = (muteToggle+1)%2;
            pd.sendFloat(instances[patchIdx].dollarZeroStr()+"-mute", muteToggle);
            break;
        default:
            break;
    }
}

//--------------------------------------------------------------
void testApp::mouseMoved(int x, int y) {}

//--------------------------------------------------------------
void testApp::mouseDragged(int x, int y, int button) {}

//--------------------------------------------------------------
void testApp::mousePressed(int x, int y, int button) {}

//--------------------------------------------------------------
void testApp::mouseReleased(int x, int y, int button) {}

//--------------------------------------------------------------
void testApp::windowResized(int w, int h) {
    fbo.allocate(w, h/2);
    fbo.begin();
    ofBackground(255, 255, 255);
    fbo.end();
    
}

//--------------------------------------------------------------
void testApp::audioReceived(float * input, int bufferSize, int nChannels) {
	//core.audioReceived(input, bufferSize, nChannels);
    pd.audioIn(input, bufferSize, nChannels);
}

//--------------------------------------------------------------
void testApp::audioRequested(float * output, int bufferSize, int nChannels) {
	//core.audioRequested(output, bufferSize, nChannels);
    pd.audioOut(output, bufferSize, nChannels);
}
