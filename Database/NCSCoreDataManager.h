//
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

@class CDAssesement, CDUser, CDTest, NCSItem, CDItem;

@interface NCSCoreDataManager : NSObject
{
    
}

+ (id)sharedInstance;
- (void)saveData;

// DB Add
- (CDAssesement*)addAssesement:(NSArray*)instruments user:(CDUser*)user;
- (BOOL)addUser:(NSString*)sID dob:(NSString*)sDOB education:(NSString*)sEducation language:(NSString*)sLanguage;
- (CDItem*)addItem:(NCSItem*)item test:(CDTest*)test;

// DB Update
- (void)markTestCompleted:(CDTest*)test;

// DB Get
- (NSArray*)getAllUsers;
- (NSArray*)getItemsByTest:(CDTest*)test;
- (NSArray*)getTestsByAssesementID:(NSString*)ID;
- (NSArray*)getAssesementsByUserID:(NSString*)ID;
- (NSArray*)getAssesementsByUserUUID:(NSString*)ID;
- (NSArray*)getStartedTestsByAssesementID:(NSString*)ID;
- (int)getLastAssesementOrderNumber:(CDUser*)user;
- (NSArray*)getAllStartedTestsForUser:(NSString*)userID;
- (NSArray*)getTestsSelectedForUpload:(NSString*)ID;
- (CDUser*)getUserByID:(NSString*)ID;

// DB Find
- (CDUser*)findUserByID:(NSString*)sID;
- (CDItem*)findItemByID:(NSString*)sID testID:(NSString*)testID userID:(NSString*)userID;
- (CDTest*)findTestByID:(NSString*)sID userID:(NSString *)sUserID;
- (CDAssesement*)findAssesementByID:(NSString*)ID;

// Updates
- (void)updateTestDateStartedStamp:(CDTest*)test;
- (void)updateTestOrder:(CDTest*)test newOrder:(int)iOrderNum;
- (void)updateSelectionForUpload:(BOOL)bFlag test:(CDTest*)test;
- (void)updateTestUploaded:(NSString*)userID;

// Deletes
- (void)deleteAssesement:(CDAssesement*)assesement;
- (void)deleteInstrument:(CDTest*)test;

@end
