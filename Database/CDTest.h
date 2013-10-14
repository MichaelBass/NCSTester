//
//  CDTest.h
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDAssesement, CDItem;

@interface CDTest : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSDate * dateFinished;
@property (nonatomic, retain) NSDate * dateStarted;
@property (nonatomic, retain) NSString * lastItemID;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * orderNumber;
@property (nonatomic, retain) NSNumber * selectedForUpload;
@property (nonatomic, retain) NSString * testID;
@property (nonatomic, retain) NSNumber * uploaded;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * error;
@property (nonatomic, retain) CDAssesement *assesement;
@property (nonatomic, retain) NSSet *ncsItem;
@end

@interface CDTest (CoreDataGeneratedAccessors)

- (void)addNcsItemObject:(CDItem *)value;
- (void)removeNcsItemObject:(CDItem *)value;
- (void)addNcsItem:(NSSet *)values;
- (void)removeNcsItem:(NSSet *)values;

@end
