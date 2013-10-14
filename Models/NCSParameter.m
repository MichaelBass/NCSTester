//
//  NCSParameter.m
//  NCS
//
//  Created by Alexander Holden on 3/18/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSParameter.h"

@implementation NCSParameter

@synthesize thresholds;
@synthesize ranges;

- (id)init
{
    if (self = [super init])
    {
        self.thresholds = [[NSMutableArray alloc] initWithCapacity: 1];
        self.ranges = [[NSMutableArray alloc] initWithCapacity: 1];
    }
    return self;
}

@end
