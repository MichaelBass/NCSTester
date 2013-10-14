//
//  NCSItem.h
//  HelloEngine
//
//  Created by MSS User on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSItem : NSObject

@property (nonatomic, retain) NSString* ItemDataOID;
@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) NSString* FormItemOID;
@property (nonatomic, retain) NSString* ItemResponseOID;
@property (nonatomic, retain) NSString* Response;
@property (nonatomic, retain) NSString* ResponseTime;
@property (nonatomic, retain) NSString* ResponseDescription;
@property (nonatomic, retain) NSString* Position;
@property int Section;
@property int Order;
@property (nonatomic, retain) NSString* StyleSheet;
@property (nonatomic, retain) NSMutableArray* elements;

- (int) getResourceCount;
- (int) getMapsCount;

@end
