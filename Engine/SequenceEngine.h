//
//  SequenceEngine.h
//  SequenceEngine
//
//  Created by Bass, Michael on 8/7/12.
//  Copyright (c) 2012 Bass, Michael. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Engine.h"

@interface SequenceEngine : NSObject <Engine>

@property (nonatomic, copy) NSArray *ItemList;
@property (nonatomic, copy) NSMutableDictionary *ParameterDictionary;
@property (nonatomic, copy) NSArray *ResultSetList;
//@property (nonatomic) double Ability;
//@property (nonatomic) double SE;
@property (nonatomic, strong) NSString *itemID;
@property (nonatomic) Boolean finished;
@property (nonatomic, strong) NSString *trace;


-(id)initwithParameterDictionary:(NSMutableDictionary *)paramdictionary;
-(void)setItemList: (NSArray *) value ;

-(NSString *) getNextItem;
-(NSArray *) getNextSection;
-(NCSItem *) getItem :(NSString *) ID;

-(NCSItem *) processResponse: (int) response;
-(NCSItem *) processResponse: (int) response responsetime: (double) responsetime;

-(void) getResults;


-(void)setStartItem:(NSString*)firstItemID; //
-(void)setUserAge:(int)age; //

-(float) getScore;
-(float) getError;


@end




