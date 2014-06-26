//
//  VLViewController.m
//  VanillaLooper
//
//  Created by Daniel Cardona on 25/06/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "VLViewController.h"

@interface VLViewController ()


@end

@implementation VLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    dispatcher = [[PdDispatcher alloc]init];
    [PdBase setDelegate:dispatcher];
    
    
    /*------------ Populate array with PdFile objects ---------------------------*/
    
    
    
    self.patchArray = [[PdPatchArray alloc]initWithFileName:@"LooperGUI1.3.pd"];
    [self.patchArray makeInstancesOfPatch:3];
    self.activeLoops = [[NSMutableArray alloc]initWithObjects:
                        [NSNumber numberWithBool:NO],
                        [NSNumber numberWithBool:NO],
                        [NSNumber numberWithBool:NO],nil];
    
    
    
    if (!self.patchArray.patchFile) {
        
        NSLog(@"Failed to open patch!"); // Gracefully handle failure...
    }else{
        
        NSLog(@"Patch: %@ opened with dollarZero: %d",self.patchArray.patchFile.baseName,self.patchArray.patchFile.dollarZero);
        
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)recPressed:(id)sender {
  
    
    UIButton* thisButton =(UIButton*)sender;
    int toggle;
    if ([thisButton.titleLabel.text isEqualToString:@"Rec"]) {
        [thisButton setTitle:@"Stop" forState:UIControlStateNormal];
        toggle = 1;
        
    }else {
        [thisButton setTitle:@"Rec" forState:UIControlStateNormal];
        toggle = 0;
    }
    
    //Actual processing
    if (self.allSelected) {
        [self.patchArray sendFloat:toggle toReceiver:@"start_stop"];
    }else {
        for (NSNumber *num in self.activeLoops) {
            if ([num boolValue]) {//check wich loops are active
                [self.patchArray sendFloat:toggle toReceiver:@"start_stop" atIndex:self.loopIdx];

            }
        }

        
    }
    
    
}

- (IBAction)mutePressedDown:(id)sender {
    
    //settup UI for this button
    UIButton* thisButton =(UIButton*)sender;
    int toggle;
    if ([thisButton.titleLabel.text isEqualToString:@"Mute"]) {
        [thisButton setTitle:@"Talk" forState:UIControlStateNormal];
        toggle = 1;
        
    }else {
        [thisButton setTitle:@"Mute" forState:UIControlStateNormal];
        toggle = 0;
    }
    //Wich to mute
    if (self.allSelected) {
        
        [self.patchArray sendFloat:toggle toReceiver:@"mute" ];
        
    }else {
        [self.patchArray sendFloat:toggle toReceiver:@"mute" atIndex:self.loopIdx];
    }
    
    
}

- (IBAction)clearPressed:(id)sender {
    
    if (self.allSelected) {
        [self.patchArray sendBangToReceiver:@"clear"];
    }else {
        [self.patchArray sendBangToReceiver:@"clear" atIndex:self.loopIdx];
    }
    
}

- (IBAction)reversePressed:(id)sender {
    UIButton* thisButton =(UIButton*)sender;
    int toggle;
    if ([thisButton.titleLabel.text isEqualToString:@"Reverse"]) {
        [thisButton setTitle:@"Non Rev" forState:UIControlStateNormal];
        toggle = 1;
        
    }else {
        [thisButton setTitle:@"Reverse" forState:UIControlStateNormal];
        toggle = 0;
    }
    
    [self.patchArray sendFloat:toggle toReceiver:@"reverse" ];
}

- (IBAction)selectionPressed:(id)sender {
  
     UIButton* thisButton =(UIButton*)sender;
    if ([thisButton.titleLabel.text isEqualToString:@"Apply to All"]) {
        [thisButton setTitle:@"Apply to Selected" forState:UIControlStateNormal];
        self.allSelected = YES;
        
    }else {
        [thisButton setTitle:@"Apply to All" forState:UIControlStateNormal];
        
        self.allSelected = NO;
    }
   
}



- (IBAction)loop1Selected:(id)sender {
    self.loopIdx = 0;
    static BOOL onOff = NO;
    onOff = !onOff;
    
    [self.activeLoops replaceObjectAtIndex:0 withObject:[NSNumber numberWithBool:onOff]];
    [sender setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    
    //Button aspect
    if (onOff) {
        [sender setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }else {
        [sender setTitleColor:[UIColor colorWithRed:0 green:0 blue:150 alpha:0.7] forState:UIControlStateNormal];
    }
    
}

- (IBAction)loop2Selected:(id)sender {
    
    self.loopIdx = 1;
    static BOOL onOff = NO;
    onOff = !onOff;
    
    [self.activeLoops replaceObjectAtIndex:1 withObject:[NSNumber numberWithBool:onOff]];
   
        NSLog(@"Loop active: %@ %@ %@",self.activeLoops[0],self.activeLoops[1],self.activeLoops[2]);
   
    //Button aspect
    if (onOff) {
        [sender setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }else {
        [sender setTitleColor:[UIColor colorWithRed:0 green:0 blue:150 alpha:0.7] forState:UIControlStateNormal];
    }
}



- (IBAction)loop3Selected:(id)sender {
    self.loopIdx = 3;
    static BOOL onOff = NO;
    onOff = !onOff;
    
    [self.activeLoops replaceObjectAtIndex:2 withObject:[NSNumber numberWithBool:onOff]];
    //Button aspect
    if (onOff) {
        [sender setTitleColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    }else {
        [sender setTitleColor:[UIColor colorWithRed:0 green:0 blue:150 alpha:0.7] forState:UIControlStateNormal];
    }
    
}
@end
