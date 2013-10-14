//
//  ItemCalibration.m
//  HelloEngine
//
//  Created by MSS User on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ItemCalibration.h"


@implementation ItemCalibration

@synthesize FormItemOID = _formitemOID,
            ItemID = _ItemID , 
            A_GRM = _A_GRM,
            Variance = _Variance,
            Administered = _Administered;


-(id)initWithName:(NSString *)formitemoid itemid:(NSString *)itemid a_grm:(double ) a_grm
{
    //self = [super init];
    if (self) {
        _formitemOID = formitemoid;
        _ItemID = itemid;
        _A_GRM = a_grm;
        return self;
    }
    return nil;
}


@end
