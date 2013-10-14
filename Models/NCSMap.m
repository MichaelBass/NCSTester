//
//  NCSMap.m
//  NCS
//
//  Created by Alexander Holden on 3/15/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSMap.h"

@implementation NCSMap

@synthesize ElementOID;
@synthesize Description;
@synthesize ItemResponseOID;
@synthesize FormItemOID;
@synthesize DataType;
@synthesize Position;
@synthesize resources;
@synthesize Value;

- (id)init
{
    if (self = [super init])
    {
        self.resources = [[NSMutableArray alloc] initWithCapacity: 1];
        self.ElementOID = @"";
        self.Description = @"";
        self.ItemResponseOID = @"";
        self.FormItemOID = @"";
        self.DataType = @"";
        self.Position = @"";
        self.Value = @"";
    }
    return self;
}


@end
