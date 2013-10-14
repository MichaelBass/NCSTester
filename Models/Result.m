//
//  Result.m
//  HelloEngine
//
//  Created by MSS User on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Result.h"


@implementation Result

@synthesize ItemID = _ItemID,
Answer = _answer , 
Score = _score,
ResponseTime = _ResponseTime,
SE = _se;


-(id)initWithName:(NSString *)itemid answer:(int)answer score:(double ) score se:(double) se responsetime:(double)responsetime
{
    if (self) {
        _ItemID = itemid;
        _answer = answer;
        _score = score;
        _se = se;
        _ResponseTime = responsetime;
        return self;
    }
    return nil;
}

-(id)initWithName:(NSString *)itemid answer:(int)answer responsetime:(double)responsetime
{
    if (self) {
        _ItemID = itemid;
        _answer = answer;
        _ResponseTime = responsetime;
        return self;
    }
    return nil;
}

@end

