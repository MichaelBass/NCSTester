//
//  NCSThreshold.m
//  NCS
//
//  Created by Alexander Holden on 3/18/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSThreshold.h"

@implementation NCSThreshold

@synthesize ID;
@synthesize Description;
@synthesize Value;
@synthesize UserValue;
- (id)init
{
    if (self = [super init])
    {
        self.ID = @"";
        self.Description = @"";
        self.Value = 0;
        self.UserValue = 0;
        self.Section = 0;
    }
    return self;
}

@end
