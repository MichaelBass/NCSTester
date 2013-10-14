//
//  CDItem.h
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTest;

@interface CDItem : NSManagedObject

@property (nonatomic, retain) NSString * formItemOID;
@property (nonatomic, retain) NSString * itemDataOID;
@property (nonatomic, retain) NSString * itemResponseOID;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * response;
@property (nonatomic, retain) NSString * responseTime;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) CDTest *ncsTest;

@end
