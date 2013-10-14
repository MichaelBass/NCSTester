//
//  ItemCalibration.h
//  HelloEngine
//
//  Created by MSS User on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>


@interface ItemCalibration : NSObject

@property (nonatomic, strong) NSString *FormItemOID;
@property (nonatomic, strong) NSString *ItemID;
@property (nonatomic) double A_GRM;
@property (nonatomic) double Variance;
@property (nonatomic) bool Administered;

-(id)initWithName:(NSString *)formitemoid itemid:(NSString *)itemid a_grm:(double ) a_grm;


@end
