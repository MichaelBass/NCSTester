//
//  BaseViewController.h
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"
#import "ViewControllerNavigation.h"
#import "Engine.h"

#import "CDTest.h"
@interface BaseViewController : UIViewController<ViewControllerNavigationDelegate, AVAudioPlayerDelegate>


@property (strong, nonatomic) ViewController *parent;
@property (nonatomic, retain) NSArray* selectedInstruments;
@property (nonatomic, retain) NSMutableArray* itemList;
@property (nonatomic, retain) NSMutableDictionary* paramList;

@property (nonatomic, retain) CDTest* currentTest;

@property (nonatomic, retain) id <Engine> myEngine;
@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

@property (strong, nonatomic) NCSItem* currentItem;


@property CGRect  viewRect;

@property int testPosition;

- (void) executeTestCompleted;
- (void) loadData;
- (void) mergeSavedDataIntoItemList;
- (void) startTest;
- (void) setNextItem;
- (void)saveItem:(NCSItem*)item;


-(IBAction)onStartButton:(id)sender;
- (void) transitionViewController;

- (void)addHiddenAdminGesture:(UIView*) view;

- (void) playSound: (NSString*) soundFileName;

@end
