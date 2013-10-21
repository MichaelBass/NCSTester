//
//  BaseViewController.m
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "BaseViewController.h"
#import "DCCSViewController.h"



@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    float width = self.view.bounds.size.width -40;
    float height = self.view.bounds.size.height -40 ;
    float x = self.view.bounds.origin.x ;
    float y = self.view.bounds.origin.y ;
    
    self.viewRect = CGRectMake(x,y,width,height);
    
    
    self.selectedInstruments = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


# pragma mark - ViewControllerNavigation Delegate -
- (void) transitionViewController{
    
    self.currentTest =  [self.selectedInstruments objectAtIndex:0];
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id c = [sb instantiateViewControllerWithIdentifier:self.currentTest.name];
    
   // ((BaseUIViewController*)c).test = t;
   // ((BaseUIViewController*)c).testList = self.testList;
   // ((BaseUIViewController*)c).testPosition = self.testPosition;
    
    [self.navigationController pushViewController:c animated:YES];
 
    UIView *content = ((DCCSViewController*)c).view;
    content.frame = self.viewRect;
    [self.view addSubview: content];

    
    NSLog(@"Start displaying content %@", self.currentTest.name);
   
}

-(IBAction)onStartButton:(id)sender
{
    //[self.parent starttransitiontoViewController: self oldC:self newC:self];
}

- (void)saveItem:(NCSItem*)item
{
    //[[NCSCoreDataManager sharedInstance] addItem:item test:self.test];
}

- (void) loadData
{

    if(self.itemList == nil){
        self.itemList = [[NSMutableArray alloc] initWithCapacity:1];
    }
    if(self.paramList == nil){
        self.paramList = [[NSMutableDictionary alloc] init];
    }
    [self.itemList removeAllObjects];
    [self.paramList removeAllObjects];
    
}

- (void)mergeSavedDataIntoItemList
{
    // Iterate through items loaded from XML and attempt to
    // merge items that were saved previously into DB.
    for(NCSItem* ncsItem in self.itemList)
    {
        /*
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

- (void)startTest
{
    
    //self.test = [self.testList objectAtIndex:self.testPosition];
    [self loadData];
    //[[NCSCoreDataManager sharedInstance] updateTestDateStartedStamp:self.test];
    self.testPosition +=1;
    
}

-(void)setNextItem
{
    NSString *sCurrentItem = [self.myEngine getNextItem];
    self.currentItem  = [self.myEngine getItem:sCurrentItem];
    
    // If next item is nil we are done with test
    // Save data and mark test complete.
    if(self.currentItem == nil)
    {
        //self.bPaused = YES;
        [self executeTestCompleted];
    }
    
}

- (void) executeTestCompleted
{
    
    /*
    [[NCSCoreDataManager sharedInstance] markTestCompleted:self.test];
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    
    if(self.testList.count == self.testPosition){
        id c = [sb instantiateViewControllerWithIdentifier:@"TestListView"];
        [self.navigationController pushViewController:c animated:YES];
        //[self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    [self removeTestNavigation];
    
    CDTest* t = [self.testList objectAtIndex:self.testPosition];
    
    id c = [sb instantiateViewControllerWithIdentifier:t.name];
    ((BaseUIViewController*)c).test = t;
    ((BaseUIViewController*)c).testList = self.testList;
    ((BaseUIViewController*)c).testPosition = self.testPosition;
    [self.navigationController pushViewController:c animated:YES];
  */
    [self startTest];
    
}

#pragma mark - SwipeView -
- (void)swiped:(UISwipeGestureRecognizer *)gesture
{
}

-(void)addHiddenAdminGesture:(UIView*) view{

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
