//
//  BaseView.m
//  NCSTester
//
//  Created by Bass, Michael on 10/12/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "BaseView.h"


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
    NSLog(@"did tap...");
    [_delegate testViewDidFinish:self];
}

@end
