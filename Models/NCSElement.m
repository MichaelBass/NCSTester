//
//  NCSElement.m
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/21/12.
//
//

#import "NCSElement.h"

@interface NCSElement()

@end

@implementation NCSElement

@synthesize ElementOID;
@synthesize Description;
@synthesize ElementOrder;
@synthesize ElementType;
@synthesize resources;
@synthesize mappings;

- (id)init
{
    if (self = [super init])
    {
        self.resources = [[NSMutableArray alloc] initWithCapacity: 1];
        self.mappings = [[NSMutableArray alloc] initWithCapacity: 1];
        self.ElementOID = @"";
        self.Description = @"";
        self.ElementOrder = @"";
        self.ElementType = @"";
    }
    return self;
}

- (int) getNumResources
{
    return self.resources.count;
}

- (int) getNumMappings
{
    return self.mappings.count;
}

@end
