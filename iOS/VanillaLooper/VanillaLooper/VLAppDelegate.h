//
//  VLAppDelegate.h
//  VanillaLooper
//
//  Created by Daniel Cardona on 25/06/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@interface VLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic,readonly) PdAudioController *audioController;


@end
