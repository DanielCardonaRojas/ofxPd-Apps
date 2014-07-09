//
//  PdPatch.m
//  Make shure your patches all prepend $0 in thier receiving objects 
//
//  Created by Daniel Cardona on 9/06/14.
//  Copyright (c) 2014 Coco. All rights reserved.
//

#import "PdPatchArray.h"

@implementation PdPatchArray



-(void)makeInstancesOfPatch:(int)n {
    
    NSNumber *patchId;//i.e $0
    
    if (self.patchFile) {
        for (int k =1; k<=n ; k++) {
            PdFile *newPatch = [self.patchFile openNewInstance];
            [self.patches addObject: newPatch];
            patchId = [NSNumber numberWithInt:newPatch.dollarZero];
            [self.dollarZeros addObject:patchId];
        }
    }
    
}

-(void)addInstance{
    
    NSNumber *patchId;//i.e $0
    
    if (self.patchFile) {
        
        PdFile *newPatch = [self.patchFile openNewInstance];
        [self.patches addObject: newPatch];
        patchId = [NSNumber numberWithInt:newPatch.dollarZero];
        [self.dollarZeros addObject:patchId];
        
    }
    
    
    
}
-(void)sendFloat:(float)n toReceiver:(NSString *)receiverName atIndex:(NSUInteger)arrayIndex {
    
    int dollarZero;
    
    dollarZero = [[self.dollarZeros objectAtIndex:arrayIndex] intValue];
    
    [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];

    
}

-(void)sendFloat:(float)n toReceiver:(NSString *)receiverName{
    //Sends float to all patches in array regardless of thier names
    
    int dollarZero;
    
    for (NSUInteger k =0; k<[self.patches count];k++) {
        
        dollarZero = [[self.dollarZeros objectAtIndex:k] intValue];
     
            [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];

        

    }
}

-(void)sendFloat:(float)n toReceiver:(NSString *)receiverName inFilesNamed:(NSString *)patchName{
    //Sends float to all patches in array with a given name
   
    int dollarZero;
    NSString *loopPatchName;
    
    for (NSUInteger k =0; k<[self.patches count];k++) {
        
        dollarZero = [[self.dollarZeros objectAtIndex:k] intValue];
        loopPatchName = [[self.patches objectAtIndex:k] baseName];
        
        //Sends float to all patches in named the same
        if ([loopPatchName isEqualToString:patchName]) {
            [PdBase sendFloat:n toReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];
            
        }
        
    }
    
}



-(void)sendBangToReceiver:(NSString *)receiverName atIndex:(NSUInteger)arrayIndex {
    
    int dollarZero;
    
    dollarZero = [[self.dollarZeros objectAtIndex:arrayIndex] intValue];
    
    [PdBase sendBangToReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];
    
    
}

-(void)sendBangToReceiver:(NSString *)receiverName {
    
    int dollarZero;
    
    for (NSUInteger k =0; k<[self.patches count];k++) {
        
        dollarZero = [[self.dollarZeros objectAtIndex:k] intValue];
        
        [PdBase sendBangToReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];
    }
    
}

-(void)sendBangToReceiver:(NSString *)receiverName inFilesNamed:(NSString *)patchName{
    
    int dollarZero;
    NSString *loopPatchName;
    
    for (NSUInteger k =0; k<[self.patches count];k++) {
        
        dollarZero = [[self.dollarZeros objectAtIndex:k] intValue];
        loopPatchName = [[self.patches objectAtIndex:k] baseName];
        if ([loopPatchName isEqualToString:patchName]) {
            [PdBase sendBangToReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];
        }
        
    }
    
}

-(void)sendList:(NSArray *)list toReceiver:(NSString *)receiverName atIndex:(NSUInteger)arrayIndex{
    
    int dollarZero;
    
    dollarZero = [[self.dollarZeros objectAtIndex:arrayIndex] intValue];
    
    [PdBase sendList:list toReceiver:[NSString stringWithFormat:@"%d-%@",dollarZero,receiverName]];
    
    
}

-(id)initWithFileName:(NSString *)patchName {
    
    self.patchFile = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    
    
    if (self.patchFile ==nil) {
        
        NSLog(@"Couldn't open patch in PdPatchArray");
        return nil;
    }
    
    self.patches = [[NSMutableArray alloc]init];
     self.dollarZeros = [[NSMutableArray alloc]init];
    
    [self.patches addObject:self.patchFile];
    [self.dollarZeros addObject:[NSNumber numberWithInt:self.patchFile.dollarZero]];
    
    return self;
}

-(void)addPatchNamed:(NSString *)patchName{
    
    
    self.patchFile = [PdFile openFileNamed:patchName path:[[NSBundle mainBundle] resourcePath]];
    
    
    if (self.patchFile ==nil) {
        
        NSLog(@"Couldn't open patch in PdPatchArray");
    }
    

    [self.patches addObject:self.patchFile];
    [self.dollarZeros addObject:[NSNumber numberWithInt:self.patchFile.dollarZero]];
    
    
}

-(void)closeFiles{
    
    [self.patches makeObjectsPerformSelector:@selector(closeFile)];
}




@end
