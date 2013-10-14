//
//  CDAssesement.h
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTest, CDUser;

@interface CDAssesement : NSManagedObject

@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSDate * creationDate;
@property (nonatomic, retain) NSNumber * orderNumber;
@property (nonatomic, retain) CDUser *user;
@property (nonatomic, retain) NSSet *tests;
@end

@interface CDAssesement (CoreDataGeneratedAccessors)

- (void)addTestsObject:(CDTest *)value;
- (void)removeTestsObject:(CDTest *)value;
- (void)addTests:(NSSet *)values;
- (void)removeTests:(NSSet *)values;

@end
