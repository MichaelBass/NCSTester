//
//  ViewController.h
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerNavigation.h"
#import "BaseView.h"

@interface ViewController : UIViewController<TestViewDelegate>

@property (strong, nonatomic) UIViewController *mvController;
@property (strong, nonatomic) UIViewController *bvController;

@property (nonatomic, assign) id <ViewControllerNavigationDelegate> delegate;

-(void) starttransitiontoViewController: (id) delegate oldC:(UIViewController*) oldC newC:(UIViewController*) newC;


@end
