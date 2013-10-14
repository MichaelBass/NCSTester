//
//  NCSRange.m
//  NCS
//
//  Created by Alexander Holden on 3/18/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSRange.h"

@implementation NCSRange

@synthesize ID;
@synthesize Min;
@synthesize Max;
@synthesize criterias;

- (id)init
{
    if (self = [super init])
    {
        self.criterias = [[NSMutableArray alloc] initWithCapacity: 1];
        self.ID = @"";
        self.Min = 0;
        self.Max = 0;
    }
    return self;
}

@end
