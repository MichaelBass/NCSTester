//
//  NCSCriteria.m
//  NCS
//
//  Created by Alexander Holden on 3/18/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSCriteria.h"

@interface NCSCriteria()

@end

@implementation NCSCriteria

@synthesize Section;
@synthesize Threshold;
@synthesize Gate;
@synthesize IsItem;


- (id)init
{
    if (self = [super init])
    {
        self.Section = 0;
        self.Threshold = @"";
        self.Gate = @"";
        self.IsItem = NO;
        self.Type = 0;

    }
    return self;
}

@end
