//
//  NCSCoreDataManager.m
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSCoreDataManager.h"
#import "NCSItem.h"

// CoreData Classes
#import "CDTest.h"
#import "CDItem.h"
#import "CDUser.h"
#import "CDAssesement.h"

@interface NCSCoreDataManager ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


@implementation NCSCoreDataManager

@synthesize managedObjectContext=__managedObjectContext;
@synthesize managedObjectModel=__managedObjectModel;
@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

#pragma mark - Setup -

// Defines a singleton instance of the class
+ (id)sharedInstance
{
    static NCSCoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[NCSCoreDataManager alloc] init];
    });
    return sharedInstance;
}


// Initialize class and setup coredata layer objects
- (id)init
{
    if ((self = [super init]))
    {
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil)
        {
            __managedObjectContext = [[NSManagedObjectContext alloc] init];
            [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return self;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"NCSTester" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreDataTests.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return __persistentStoreCoordinator;
}


- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (void)saveData
{
    // Save the context.
    NSError *error = nil;
    
    if (![__managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge NSString *)string;
}

#pragma mark - Database Update -

- (void)markTestCompleted:(CDTest*)test
{
    test.completed = [NSNumber numberWithInt:1];
    test.dateFinished = [NSDate date];
    [self saveContext];
}

#pragma mark - Database Add -

- (CDItem*)addItem:(NCSItem*)item test:(CDTest*)test
{
    CDItem* testItem;
    
    // Check if this item already exists
    testItem = [self findItemByID:item.FormItemOID testID:test.testID userID:test.assesement.user.ncsID];
    
    if(testItem != nil)
        return testItem;
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDItem" inManagedObjectContext:__managedObjectContext];
    testItem = (CDItem*)[NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:__managedObjectContext];
    
    testItem.formItemOID = [NSString stringWithString:item.FormItemOID];
    testItem.itemDataOID = [NSString stringWithString:item.ItemDataOID];
    testItem.itemResponseOID = [NSString stringWithString:item.ItemResponseOID];
    testItem.position = [NSString stringWithString:item.Position];
    testItem.response = [NSString stringWithString:item.Response];
    testItem.responseTime = [NSString stringWithString:item.ResponseTime];
    testItem.timeStamp = [NSDate date];
    
    [test addNcsItemObject:testItem];
    [self saveData];
    return testItem;
}

- (CDAssesement*)addAssesement:(NSArray*)instruments user:(CDUser*)user
{
    
    // Create a new instance of the entity managed by the fetched results controller.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDAssesement" inManagedObjectContext:__managedObjectContext];
    CDAssesement* cdAssesement = (CDAssesement*)[NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:__managedObjectContext];

    cdAssesement.id = [NSString stringWithString:[self GetUUID]];
    cdAssesement.creationDate = [NSDate date];
    cdAssesement.orderNumber = [NSNumber numberWithInt:[self getLastAssesementOrderNumber:user] + 1];
    
    int iOrderNum = 1;
    
    // Add individual instruments
    for(NSString* sInstrumentName in instruments)
    {

        CDTest* newTest = [self addTest:sInstrumentName orderNum:iOrderNum];
            
        if(newTest)
        {
            newTest.assesement = cdAssesement;
            [cdAssesement addTestsObject:newTest];
            ++iOrderNum;
        }

    }
    
    if(cdAssesement){
        [user addAssesementObject:cdAssesement];
    }
    
    [self saveData];
    return cdAssesement;
}

- (CDTest*)addTest:(NSString*)testID orderNum:(int)iOrderNum
{    
    // Create a new instance of the entity managed by the fetched results controller.
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDTest" inManagedObjectContext:__managedObjectContext];
    CDTest* cdTest = (CDTest*)[NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:__managedObjectContext];
    
    cdTest.name = [NSString stringWithString:testID];
    cdTest.testID = [NSString stringWithString:[self GetUUID]];
    cdTest.orderNumber = [NSNumber numberWithInt:iOrderNum];
    
    return cdTest;
}

- (BOOL)addUser:(NSString*)sID dob:(NSString*)sDOB education:(NSString*)sEducation language:(NSString*)sLanguage
{
    CDUser* newUSer = [self findUserByID:sID];
    
    // Check if user with this ID already exists and update it if found
    if(newUSer == nil)
    {
        // Create a new instance of the entity managed by the fetched results controller.
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:__managedObjectContext];
        newUSer = (CDUser*)[NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:__managedObjectContext];
        
           newUSer.uuID = [NSString stringWithString:[self GetUUID]];
    }
    
 
    newUSer.ncsID = [NSString stringWithString:sID];
    newUSer.dob = [NSString stringWithString:sDOB];
    newUSer.educationLevel = [NSString stringWithString:sEducation];
    newUSer.language = [NSString stringWithString:sLanguage];
    
    [self saveData];
    return YES;
}

- (CDUser*)createUser:(NSString*)sID dob:(NSString*)sDOB education:(NSString*)sEducation language:(NSString*)sLanguage
{
    CDUser* newUser = [self findUserByID:sID];
    
    // Check if user with this ID already exists and update it if found
    if(newUser == nil)
    {
        // Create a new instance of the entity managed by the fetched results controller.
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"CDUser" inManagedObjectContext:__managedObjectContext];
        newUser = (CDUser*)[NSEntityDescription insertNewObjectForEntityForName:[entityDescription name] inManagedObjectContext:__managedObjectContext];
        
        newUser.uuID = [NSString stringWithString:[self GetUUID]];
    }
    
    
    newUser.ncsID = [NSString stringWithString:sID];
    newUser.dob = [NSString stringWithString:sDOB];
    newUser.educationLevel = [NSString stringWithString:sEducation];
    newUser.language = [NSString stringWithString:sLanguage];
    
    [self saveData];
    return newUser;
}


#pragma mark - Database Search -

- (int)getLastAssesementOrderNumber:(CDUser*)user
{
    int iNum = 0;
    NSArray* arr = [self getAssesementsByUserID:user.ncsID];
    
    for(CDAssesement* a in arr)
    {
        if([a.orderNumber intValue] > iNum)
            iNum = [a.orderNumber intValue];
    }
    
    return iNum;
}

- (NSArray*)getAssesementsByUserID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDAssesement" findBy:[NSString stringWithFormat:@"(user.ncsID = '%@')", ID] sortBy:@"orderNumber"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray*)getAssesementsByUserUUID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDAssesement" findBy:[NSString stringWithFormat:@"(user.uuID = '%@')", ID] sortBy:@"orderNumber"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray*)getTestsByAssesementID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDTest" findBy:[NSString stringWithFormat:@"(assesement.id = '%@' AND uploaded = 0)", ID] sortBy:@"orderNumber"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray*)getAllStartedTestsForUser:(NSString*)userID
{
   NSArray* array = [self findObjects:@"CDTest" findBy:[NSString stringWithFormat:@"(assesement.user.uuID = '%@' AND dateStarted != nil)", userID] sortBy:@"orderNumber"];
 
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;

}

- (NSArray*)getStartedTestsByAssesementID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDTest" findBy:[NSString stringWithFormat:@"(assesement.id = '%@' AND dateStarted != nil AND uploaded = 0)", ID] sortBy:@"orderNumber"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray*)getTestsSelectedForUpload:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDTest" findBy:[NSString stringWithFormat:@"(assesement.id = '%@' AND dateStarted != nil AND uploaded = 0 AND selectedForUpload = 1)", ID] sortBy:@"orderNumber"];

    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (NSArray*)getItemsByTest:(CDTest*)test
{
    NSArray* array = [self findObjects:@"CDItem" findBy:[NSString stringWithFormat:@"(ncsTest.testID = '%@' AND ncsTest.assesement.user.ncsID = '%@')", test.testID, test.assesement.user.ncsID] sortBy:@"formItemOID"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return array;
}

- (CDUser*)getUserByID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDUser" findBy:[NSString stringWithFormat:@"(uuID = '%@')", ID] sortBy:@"uuID"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return [array objectAtIndex:0];
}

- (NSArray*)getAllUsers
{
    return [self getAllObjects:@"CDUser"];
}

- (CDTest*)findTestByID:(NSString*) sTestID userID:(NSString*)sUserID
{
    NSArray* array = [self findObjects:@"CDTest" findBy:[NSString stringWithFormat:@"(testID = '%@' AND user.ncsID = '%@')", sTestID, sUserID] sortBy:@"testID"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return [array objectAtIndex:0];
}

- (CDAssesement*)findAssesementByID:(NSString*)ID
{
    NSArray* array = [self findObjects:@"CDAssesement" findBy:[NSString stringWithFormat:@"(id = '%@')", ID] sortBy:@"creationDate"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return [array objectAtIndex:0];
}

#pragma  mark - Database Searches -

- (CDUser*)findUserByID:(NSString*)sID
{
    NSArray* array = [self findObjects:@"CDUser" findBy:[NSString stringWithFormat:@"(ncsID = '%@')", sID] sortBy:@"ncsID"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return [array objectAtIndex:0];
}


- (CDItem*)findItemByID:(NSString*)sID testID:(NSString*)testID userID:(NSString*)userID
{
    NSArray* array = [self findObjects:@"CDItem" findBy:[NSString stringWithFormat:@"(formItemOID = '%@' AND ncsTest.testID = '%@' AND ncsTest.assesement.user.ncsID = '%@')", sID, testID, userID] sortBy:@"formItemOID"];
    
    if (array == nil || array.count == 0)
    {
        return nil;
    }
    
    return [array objectAtIndex:0];
}

- (NSArray*)getAllObjects:(NSString*)entityName
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    /*
     NSNumber *minimumSalary = ...;
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(lastName LIKE[c] 'Worsley') AND (salary > %@)", minimumSalary];
     [request setPredicate:predicate];
     
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
     [request setSortDescriptors:@[sortDescriptor]];
     */
    
    NSError *error;
    NSArray *array = [__managedObjectContext executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
       NSLog(@"Get records error occured: %@, %@", error, [error userInfo]);
    }
    
    return array;
}

- (NSArray*)findObjects:(NSString*)entityName findBy:(NSString*)sQry sortBy:(NSString*)sortQry
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:__managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:sQry];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortQry ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [__managedObjectContext executeFetchRequest:request error:&error];
    
    if (array == nil || array.count == 0)
    {
        //NSLog(@"Get records error occured: %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return array;
}

#pragma mark - Update Operations -

- (void)updateSelectionForUpload:(BOOL)bFlag test:(CDTest*)test
{
    test.selectedForUpload = [NSNumber numberWithBool:bFlag];
    [self saveContext];
}

- (void)updateTestDateStartedStamp:(CDTest*)test
{
    if(test.dateStarted == nil)
    {
        test.dateStarted = [NSDate date];
        [self saveData];
    }
}

- (void)updateTestUploaded:(NSString*)userID
{
    NSArray* assesmentArr = [[NCSCoreDataManager sharedInstance] getAssesementsByUserUUID:userID];
    
    for(CDAssesement* a in assesmentArr)
    {
        NSArray* testArr = [[NCSCoreDataManager sharedInstance] getTestsSelectedForUpload:a.id];
        
        for(CDTest* t in testArr)
        {
            t.uploaded = [NSNumber numberWithBool:YES];
        }
    }

    [self saveContext];
}

- (void)updateTestOrder:(CDTest*)test newOrder:(int)iOrderNum
{
    test.orderNumber = [NSNumber numberWithInt:iOrderNum];
    [self saveContext];
}

#pragma mark - Delete Operations -

- (void)deleteAssesement:(CDAssesement*)assesement
{
    [__managedObjectContext deleteObject:assesement];
    [self saveData];
}

- (void)deleteInstrument:(CDTest*)test
{
    [__managedObjectContext deleteObject:test];
    [self saveData];
}

@end
