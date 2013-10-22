//
//  DebugViewController.h
//  NCSTester
//
//  Created by Mike Rose on 10/21/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DebugViewController : UIViewController

@property (strong, nonatomic) NSDictionary *data;

@property (strong, nonatomic) IBOutlet UILabel *testsLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;
@property (strong, nonatomic) IBOutlet UILabel *dobLabel;
@property (strong, nonatomic) IBOutlet UILabel *educationLabel;
@property (strong, nonatomic) IBOutlet UILabel *languageLabel;

@end
