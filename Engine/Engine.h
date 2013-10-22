//
//  Engine.h
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/12/12.
//
//

#import <Foundation/Foundation.h>
#import "NCSItem.h"
#import "NCSParameter.h"
#import "CDUser.h"

@protocol Engine <NSObject>
@required
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic) Boolean finished;
@property (nonatomic, strong) NSString *trace;
@property (nonatomic, copy) NSArray *ItemList;

@property (nonatomic, copy) NSArray *ResultSetList;

-(void)setStartItem:(NSString*)firstItemID;
-(NCSItem *) getItem :(NSString *) ID;
-(NCSItem *) processResponse: (int) response;
-(NCSItem *) processResponse: (int) response responsetime:(double) responsetime;

-(NSArray *)  processResponses: (NSArray *) responses responsetime:(double) responsetime;

-(float) getScore;
-(float) getError;

-(NSString *) getNextItem;
-(NSArray *) getNextSection;
-(void) getResults;
-(void)setItemList: (NSArray *) value ;
/* -(id)initwithParameterList :(NCSParameter *) paramlist; */
-(id)initwithParameterDictionary:(NSMutableDictionary *)paramdictionary;

@optional
-(void)setUser:(CDUser *)user;
@property (nonatomic) BOOL sectional;
@end
