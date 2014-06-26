//
//  VLViewController.h
//  VanillaLooper
//
//  Created by Daniel Cardona on 25/06/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdDispatcher.h"
#import "PdPatchArray.h"

@interface VLViewController : UIViewController {
    PdDispatcher *dispatcher;
    
}

//@property PdDispatcher *dispatcher;
@property (strong,nonatomic)PdPatchArray *patchArray;
@property NSUInteger loopIdx;
@property NSMutableArray* activeLoops;
@property BOOL allSelected;
@property (weak, nonatomic) IBOutlet UIButton *loop1Button;
@property (weak, nonatomic) IBOutlet UIButton *loop2Button;
@property (weak, nonatomic) IBOutlet UIButton *loop3Button;


- (IBAction)recPressed:(id)sender;
- (IBAction)mutePressedDown:(id)sender;
- (IBAction)clearPressed:(id)sender;
- (IBAction)reversePressed:(id)sender;
- (IBAction)selectionPressed:(id)sender;
- (IBAction)loop1Selected:(id)sender;
- (IBAction)loop2Selected:(id)sender;
- (IBAction)loop3Selected:(id)sender;

@end
