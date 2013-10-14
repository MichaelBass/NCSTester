//
//  NCSResource.m
//  NCS
//
//  Created by Alexander Holden on 3/15/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSResource.h"

@implementation NCSResource

@synthesize ResourceOID;
@synthesize Description;
@synthesize Type;

- (id)init
{
    if (self = [super init])
    {
        self.ResourceOID = @"";
        self.Description = @"";
        self.Type = @"";
    }
    return self;
}

@end
