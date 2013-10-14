//
//  NCSItem.m
//  HelloEngine
//
//  Created by MSS User on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSMap.h"

@interface NCSItem()

@end

@implementation NCSItem

@synthesize ItemDataOID;
@synthesize ID;
@synthesize FormItemOID;
@synthesize ItemResponseOID;
@synthesize Response;
@synthesize ResponseTime;
@synthesize ResponseDescription;
@synthesize Position;
@synthesize Section;
@synthesize Order;
@synthesize StyleSheet;
@synthesize elements;

- (id)init
{
    if (self = [super init])
    {
        self.ID = @"";
        self.ItemDataOID = @"";
        self.FormItemOID = @"";
        self.ItemResponseOID = @"";
        self.Response = @"";
        self.ResponseTime = @"";
        self.ResponseDescription = @"";
        self.Position = @"";
        self.Section = 0;
        self.Order = 0;
        self.StyleSheet = @"";
        self.elements = [[NSMutableArray alloc] initWithCapacity: 1];
    }
    return self;
}

- (int) getResourceCount
{
    int iNumResources = 0;
    
    for(NCSElement* e in self.elements)
        iNumResources += [e getNumResources];
    
    return iNumResources;
}

- (int) getMapsCount
{
    int iNumMaps = 0;
    
    for(NCSElement* e in self.elements)
        iNumMaps += [e getNumMappings];
    
    return iNumMaps;
}

@end
