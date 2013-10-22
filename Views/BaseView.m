//
//  BaseView.m
//  NCSTester
//
//  Created by Bass, Michael on 10/12/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "BaseView.h"
#import "BaseParser.h"

@interface BaseView ()

@end

@implementation BaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // self
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            }
    return self;
}

-(IBAction)onStartFormButton:(id)sender
{
    //NSLog(@"did tap BaseView...");
 
    // clear the model data
    /*
    if(self.itemList == nil){
        self.itemList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    if(self.paramList == nil){
        self.paramList = [[NSMutableDictionary alloc] init];
    }
    [self.itemList removeAllObjects];
    [self.paramList removeAllObjects];
    */
    
    //- (void) startTest:(id<Engine>) engine itemList:(NSMutableArray*)itemList;
    [_delegate startTest: self];
}

/*
- (NSMutableArray*) itemList{
    return _itemList;
}

- (id<Engine>) engine{
    return _engine;
}
*/

- (void) displayItem: (NCSItem*) item
{

}
- (void) displayItems: (NSArray*) items{

}
-(IBAction)onFinishFormButton:(id)sender
{
   // NSLog(@"did Finish...");
    [_delegate testViewDidFinish:self];
}
/*
-(IBAction)onSetNextItemButton:(id)sender
{
    NSLog(@"did setNextItem...");
    [_delegate setNextItem];
}


- (void)setItem:(NCSItem *)item
{
    _item = item;
    
    NSLog(@"item set!");
    if(_item == nil){
        [self.delegate executeTestCompleted];
        return;
    }
    [self performSelector:@selector(setNextItem) withObject:nil afterDelay:0.5];
}
*/
-(IBAction)onexecuteTestCompletedButton:(id)sender
{
    NSLog(@"did completeTest...");
    [_delegate executeTestCompleted];
}


#pragma mark - Sound and Delegates -

- (void) playSound: (NSString*) soundFileName
{
    // Check sound file validity.
    if(soundFileName == nil || soundFileName.length == 0)
        return;
    
    // Check if file name contain extention
    NSString* finalFileName = soundFileName;
    
    if([soundFileName hasSuffix:@".mp3"])
        finalFileName = [soundFileName substringToIndex:soundFileName.length - 4];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:finalFileName ofType:@"mp3"];
    NSData *soundData = [NSData dataWithContentsOfFile:filePath];
    
    if (soundData)
    {
        // Init audio player
        NSError* error;
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:soundData error:&error];
        self.audioPlayer.volume = 1.0;
        self.audioPlayer.delegate = self;
        [self.audioPlayer play];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    /*
     if(bGoToNextStep)
     {
     bFlashBorderLeft = NO;
     bFlashBorderRight = NO;
     bGoToNextStep = NO;
     [self performSelector:@selector(setNextItem) withObject:nil afterDelay:0.5];
     }
     */
}


@end
