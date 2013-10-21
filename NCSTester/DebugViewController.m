//
//  DebugViewController.m
//  NCSTester
//
//  Created by Mike Rose on 10/21/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "DebugViewController.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateInterface];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    [self updateInterface];
}

- (void)updateInterface
{
    NSLog(@"data: %@", _data);
    
    _testsLabel.text = _data[@"tests"];
    _userLabel.text = _data[@"user"];
    _dobLabel.text = _data[@"dob"];
    _educationLabel.text = _data[@"education"];
    _languageLabel.text = _data[@"language"];
}

@end
