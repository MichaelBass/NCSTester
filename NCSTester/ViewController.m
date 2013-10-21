//
//  ViewController.m
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "ViewController.h"
#import "Engine.h"
#import "NCSItem.h"
#import "BaseView.h"
#import "DCCSView.h"
#import "BaseParser.h"

#import "NCSCoreDataManager.h"
#import "CDUser.h"
#import "CDTest.h"
#import "CDAssesement.h"

@interface ViewController ()

@property (strong, nonatomic) CDUser* user;
@property (strong, nonatomic) CDAssesement* assessment;

@property (strong, nonatomic) NCSItem* currentItem;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSMutableArray *tests;
@property (strong, nonatomic) BaseView *currentView;

@property int testIndex;
@end

@implementation ViewController


#pragma mark - test view delegate




- (void)testViewDidFinish:(UIView *)view
{
    NSLog(@"test view did finish: %@", view);
    
    // set index to correct test
    if (self.testIndex < self.tests.count){
        self.testIndex +=1;
    }else{
        self.testIndex = 0;
    }
    
    // load test
    [self loadTestAtIndex:self.testIndex];
}


- (void) executeTestCompleted {

     // [[NCSCoreDataManager sharedInstance] markTestCompleted:self.test];
    [self testViewDidFinish:nil];
    //CDTest* t = [self.testList objectAtIndex:self.testPosition];
}



- (void) mergeSavedDataIntoItemList{

    // Iterate through items loaded from XML and attempt to
    // merge items that were saved previously into DB.
    for(NCSItem* ncsItem in self.currentView.itemList)
    {
        /*
         @implementation CDAssesement
         
         @dynamic id;
         @dynamic creationDate;
         @dynamic orderNumber;
         @dynamic user;
         @dynamic tests;
         
         @end
         
         
         CDItem* savedItem = [[NCSCoreDataManager sharedInstance] findItemByID:ncsItem.FormItemOID testID:self.test.testID userID:self.test.assesement.user.ncsID];
         
         if(savedItem != nil)
         {
         ncsItem.ItemDataOID = [NSString stringWithString:savedItem.itemDataOID];
         ncsItem.ItemResponseOID = [NSString stringWithString:savedItem.itemResponseOID];
         ncsItem.ResponseTime = [NSString stringWithString:savedItem.responseTime];
         ncsItem.Position = [NSString stringWithString:savedItem.position];
         ncsItem.Response = [NSString stringWithString:savedItem.response];
         }
         */
    }

}

- (void) processResponse:(int) response responsetime:(double) responsetime{
    
    NCSItem * myItem  = [self.currentView.engine processResponse: response responsetime:responsetime ];
    myItem.ResponseTime = [NSString stringWithFormat:@"%f", responsetime];
    myItem.Response = [NSString stringWithFormat:@"%d", response];
    
    //[[NCSCoreDataManager sharedInstance] addItem:item test:self.test];
    
    [self performSelector:@selector(setNextItem) withObject:nil afterDelay:0.5];
    
}

- (void) startTest: (BaseView *) myView{
    

    //self.test = [self.testList objectAtIndex:self.testPosition];

    //self.itemList = itemList;
    //self.myEngine = engine;
    //[self.myEngine setUser:self.currentTest.assesement.user];

    

    [myView.engine setUser:self.user];
     [self mergeSavedDataIntoItemList];
     myView.engine.ItemList = myView.itemList;

    NSLog(@"items: %d", myView.itemList.count);
    
    [self setNextItem];
    
    /*
     
     - (CDAssesement*)addAssesement:(NSArray*)instruments user:(CDUser*)user
     
     @implementation CDTest
     
     @dynamic completed;
     @dynamic dateFinished;
     @dynamic dateStarted;
     @dynamic lastItemID;
     @dynamic name;
     @dynamic orderNumber;
     @dynamic selectedForUpload;
     @dynamic testID;
     @dynamic uploaded;
     @dynamic userID;
     @dynamic score;
     @dynamic error;
     @dynamic assesement;
     @dynamic ncsItem;
     
     @end
     */
    
    //[[NCSCoreDataManager sharedInstance] updateTestDateStartedStamp:self.test];

}

- (void) setNextItem{

    NSString *sCurrentItem = [self.currentView.engine getNextItem];
    self.currentItem  = [self.currentView.engine getItem:sCurrentItem];

    
    // If next item is nil we are done with test
    // Save data and mark test complete.
    if(self.currentItem == nil)
    {
        //self.bPaused = YES;
        [self executeTestCompleted];
    }else{
        [self.currentView displayItem: self.currentItem];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"view did load...");
    
    self.tests = [[NSMutableArray alloc] initWithCapacity:1];
    
    // self
    self.view.backgroundColor = [UIColor blackColor];
    
    // content view
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor blackColor];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.contentView];
    
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.96 constant:0.0];
    [self.view addConstraint:cn];
    
    cn = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.96 constant:0.0];
    [self.view addConstraint:cn];
    
    cn = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    
    cn = [NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    
    [self initWithMetaData:_data[@"tests"] userid:_data[@"user"] dob:_data[@"dob"] education:_data[@"education"] language:_data[@"language"]];
}

- (void) initWithMetaData:(NSArray*)instruments userid:(NSString*)userid dob:(NSString*)sDOB education:(NSString*)sEducation language:(NSString*)sLanguage {

    self.user = [[NCSCoreDataManager sharedInstance] createUser:userid dob:sDOB education:sEducation language:sLanguage];

    self.assessment = [[NCSCoreDataManager sharedInstance] addAssesement:instruments user:self.user ];
    
    for(CDTest* test in self.assessment.tests)
    {
        [self createTestWithName:test.name];
    }
    
    [self loadTestAtIndex:0];

}

- (id)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _data = data;
        NSLog(@"tests: %@", _data[@"tests"]);
        NSLog(@"dob: %@", _data[@"dob"]);
    }
    return self;
}

/*
- (void) initWithData {

    self.user = [[NCSCoreDataManager sharedInstance] getUserByID:@"0F2092CD-1EA1-4321-A145-0CFCFF63A61D"];
     [self createTestWithName:@"DCCS"];
     [self createTestWithName:@"VocabPractice"];
     [self createTestWithName:@"Flanker"];
     [self createTestWithName:@"Vocab"];
     [self createTestWithName:@"MainView"];
     [self createTestWithName:@"BaseView"];
    
    NSArray* instruments = [NSArray arrayWithObjects:@"BaseView", @"VocabPractice", @"Vocab", nil];
    self.assessment = [[NCSCoreDataManager sharedInstance] addAssesement:instruments user:self.user ];
    
    for(CDTest* test in self.assessment.tests)
    {
        [self createTestWithName:test.name];
    }
    
    [self loadTestAtIndex:0];
}
*/

- (void)createTestWithName:(NSString*)name
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UIView *testView = ((UIViewController*)[sb instantiateViewControllerWithIdentifier:name]).view;
    testView.frame = self.contentView.bounds;
    
    // testView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:testView];
    [self.tests addObject:testView];
    
    testView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cn = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    cn = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    cn = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    cn = [NSLayoutConstraint constraintWithItem:testView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0.0];
    [self.view addConstraint:cn];
    
    testView.tag = [self.tests count];
    testView.hidden = YES;
    testView.clipsToBounds = YES;
    testView.layer.cornerRadius = 10.0;

    /*
    NSLog(@"content view frame %@ | bounds %@",NSStringFromCGRect(self.contentView.frame ), NSStringFromCGRect(self.contentView.bounds ));
    NSLog(@"test view frame %@ | bounds %@",NSStringFromCGRect(testView.frame ), NSStringFromCGRect(testView.bounds ));
     */
}

- (void)loadTestAtIndex:(NSInteger)index
{
    NSLog(@"load test at index: %d", index);
    
    BaseView *fromView;
    BaseView *toView;
    
    if (index == 0) {
        fromView = self.tests[self.tests.count-1];
    } else {
        fromView = self.tests[index-1];
    }
    toView = self.tests[index];
    
    fromView.delegate = nil;
    toView.delegate = self;
    
    self.currentView = toView;
    
    [UIView transitionWithView:_contentView duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        fromView.hidden = YES;
        toView.hidden = NO;
    } completion:^(BOOL finished) {
        //
        [toView onStartFormButton:nil];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
