//
//  ProgressiveSectionalEngine.h
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/29/12.
//
//

#import <Foundation/Foundation.h>
#import "Engine.h"
/* #import "NCSParameter.h" */

@interface ProgressiveSectionalEngine : NSObject <Engine>

@property (nonatomic, copy) NSArray *ItemList; //
/* @property (nonatomic, copy) NCSParameter *NCSParameter; */
@property (nonatomic, copy) NSMutableDictionary *ParameterDictionary;
@property (nonatomic, copy) NSArray *ResultSetList; //
//@property (nonatomic) double ResponseTime;

@property (nonatomic, strong) NSString *itemID; //
@property (nonatomic) Boolean finished; //
@property (nonatomic, strong) NSString *trace; //

-(void)setStartItem:(NSString*)firstItemID; //
-(void)setUser:(CDUser*)user; //
-(float) getScore;
-(float) getError;

-(NCSItem *) getItem :(NSString *) ID; //
-(NSString *) getNextItem;  //
-(NSArray *) getNextSection;
-(NCSItem *) processResponse: (int) response responsetime: (double) responsetime; //
-(NCSItem *) processResponse: (int) response;  //
-(void) getResults; //
//-(id)initwithItemList :(NSArray *) itemlist;
/* -(id)initwithParameterList :(NCSParameter *) paramlist; */
-(id)initwithParameterDictionary:(NSMutableDictionary *)paramdictionary;
-(void)setItemList: (NSArray *) value ;
@end


