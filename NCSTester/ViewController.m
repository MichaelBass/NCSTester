//
//  ViewController.m
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "ViewController.h"
#import "GraphView.h"

#import "MainViewController.h"
#import "BaseViewController.h"
#import "DCCSViewController.h"

#import "BaseView.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet GraphView *gv;
@property CGRect  viewRect;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) NSMutableArray *tests;
@end

@implementation ViewController



@synthesize mvController;
@synthesize bvController;

#pragma mark - test view delegate

- (void)testViewDidFinish:(UIView *)view
{
    NSInteger newIndex = view.tag + 1;
    if (newIndex > _tests.count - 1) newIndex = 0;
    
    [self loadTestAtIndex:newIndex];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    [self createTestWithName:@"MainView"];
    [self createTestWithName:@"BaseView"];
    
    [self loadTestAtIndex:0];

/*
    self.gv = [[GraphView alloc]initWithFrame:CGRectMake(5,50, self.view.bounds.size.width-10, self.view.bounds.size.height-60)];
    self.gv.backgroundColor =[UIColor whiteColor] ;
    self.gv.alpha = .8;
    [self.view addSubview:self.gv];
  
    
    
    float width = self.gv.bounds.size.width - 80;
    float height = self.gv.bounds.size.height - 80;
    float x = self.gv.bounds.origin.x + 40;
    float y = self.gv.bounds.origin.y + 40;
    
    self.viewRect = CGRectMake(x,y,width,height);
    
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  
    self.mvController = [sb instantiateViewControllerWithIdentifier:@"MainView"];
    ((MainViewController*)self.mvController).parent = self;
    self.bvController = [sb instantiateViewControllerWithIdentifier:@"BaseView"];
    ((BaseViewController*)self.mvController).parent = self;
    
    [self displayContentController:  self.mvController ];
 */
    
}

- (void)createTestWithName:(NSString*)name
{
    UIStoryboard* sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    UIView *testView = ((UIViewController*)[sb instantiateViewControllerWithIdentifier:name]).view;
    testView.frame = self.contentView.bounds;
    
    // testView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
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
    
    [self.contentView addSubview:testView];
    [self.tests addObject:testView];

    NSLog(@"content view frame %@ | bounds %@",NSStringFromCGRect(self.contentView.frame ), NSStringFromCGRect(self.contentView.bounds ));
    NSLog(@"test view frame %@ | bounds %@",NSStringFromCGRect(testView.frame ), NSStringFromCGRect(testView.bounds ));

}

- (void)loadTestAtIndex:(NSInteger)index
{
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
    
    [UIView transitionWithView:_contentView duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        fromView.hidden = YES;
        toView.hidden = NO;
    } completion:^(BOOL finished) {
        //
    }];
    
}




//https://developer.apple.com/library/ios/featuredarticles/ViewControllerPGforiPhoneOS/CreatingCustomContainerViewControllers/CreatingCustomContainerViewControllers.html
- (void) hideContentController: (UIViewController*) content
{
    [content willMoveToParentViewController:nil];
    [content.view removeFromSuperview];
    [content removeFromParentViewController];
}

- (void) displayContentController: (UIViewController*) content;
{
    [self addChildViewController:content];
 
    
    if ([content isEqual: self.mvController]){
        self.mvController = content;
        ((MainViewController*)content).parent = self;
    }
    if ([content isEqual: self.bvController]){
        self.bvController = content;
        ((BaseViewController*)content).parent = self;
    }

    content.view.frame = self.viewRect;
    [self.gv addSubview: content.view];
    [content didMoveToParentViewController:self];
}


-(void) starttransitiontoViewController: (id) delegate oldC:(UIViewController*) oldC newC:(UIViewController*) newC {
    
    if(delegate)
        self.delegate = delegate;

    if ([oldC isEqual: self.mvController]){
        [self cycleFromViewController: self.mvController toViewController:self.bvController];
    }
    if ([oldC isEqual: self.bvController]){
        [self cycleFromViewController: self.bvController toViewController:self.mvController];
    }
    
}

- (void) notifyDelegateDidFinish
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(transitionViewController)]){
        [self.delegate transitionViewController];
    }
}


- (void) cycleFromViewController: (UIViewController*) oldC
                toViewController: (UIViewController*) newC
{
 
    [oldC willMoveToParentViewController:nil];
    [self addChildViewController:newC];
    
    newC.view.frame = self.viewRect;
    
    if ([oldC isEqual: self.mvController]){
        self.bvController = newC;
        ((BaseViewController*)newC).parent = self;
        //((BaseViewController*)newC).selectedInstruments = ((MainViewController*)oldC).selectedInstruments;
        ((BaseViewController*)newC).selectedInstruments = ((MainViewController*)oldC).selectedTests;

    }
    if ([oldC isEqual: self.bvController]){
        self.mvController = newC;
        ((MainViewController*)newC).parent = self;
    }
   
    
     [self transitionFromViewController: oldC toViewController: newC
                              duration: 1.5 options:UIViewAnimationOptionAllowAnimatedContent
                            animations:^{
                                oldC.view.alpha = 0;
                                newC.view.alpha = 1;
                            }
                            completion:^(BOOL finished) {
                                [oldC removeFromParentViewController];
                                [newC didMoveToParentViewController:self];
                                [self notifyDelegateDidFinish];
                                
                                //Send message to baseview controller to start the test.
                                if ([oldC isEqual: self.mvController]){
                                    [((BaseViewController*)newC) transitionViewController];
                                }
                                
                               
                            }];
    
    
      
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
