//
//  Result.h
//  HelloEngine
//
//  Created by MSS User on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Result : NSObject

@property (nonatomic, strong) NSString *ItemID;
@property (nonatomic) int Answer;
@property (nonatomic) double Score;
@property (nonatomic) double SE;
@property (nonatomic) double ResponseTime;

-(id)initWithName:(NSString *)itemid answer:(int)answer score:(double ) score se:(double) se responsetime:(double) responsetime;
-(id)initWithName:(NSString *)itemid answer:(int)answer responsetime:(double) responsetime;


@end

