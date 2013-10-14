//
//  CDUser.h
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDAssesement;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSString * uuID;
@property (nonatomic, retain) NSString * dob;
@property (nonatomic, retain) NSString * educationLevel;
@property (nonatomic, retain) NSString * language;
@property (nonatomic, retain) NSString * ncsID;
@property (nonatomic, retain) NSSet *assesement;

-(int)getUserAge;

@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addAssesementObject:(CDAssesement *)value;
- (void)removeAssesementObject:(CDAssesement *)value;
- (void)addAssesement:(NSSet *)values;
- (void)removeAssesement:(NSSet *)values;

@end
