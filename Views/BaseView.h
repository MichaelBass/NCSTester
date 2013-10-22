//
//  BaseView.h
//  NCSTester
//
//  Created by Bass, Michael on 10/12/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "NCSItem.h"
#import "Engine.h"

@protocol TestViewDelegate;


@interface BaseView : UIView<AVAudioPlayerDelegate>

@property (strong, nonatomic) NCSItem* item;
@property (strong, nonatomic) NSArray* items;
@property (weak, nonatomic) id <TestViewDelegate> delegate;

@property (strong, nonatomic) id<Engine> engine;
@property (nonatomic, retain) NSMutableArray* itemList;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;


- (IBAction)onStartFormButton:(id)sender;
- (void) playSound: (NSString*) soundFileName;
- (void) displayItem: (NCSItem*) item;
- (void) displayItems: (NSArray*) items;
@end

@protocol TestViewDelegate
@required
- (void) testViewDidFinish:(UIView *)view;
- (void) executeTestCompleted;
- (void) startTest:(BaseView *)view;
- (void) processResponse:(int) response responsetime:(double) responsetime;
- (void) processResponses:(NSArray*) responses responsetime:(double) responsetime;
@end


