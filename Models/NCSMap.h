//
//  NCSMap.h
//  NCS
//
//  Created by Alexander Holden on 3/15/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSMap : NSObject

@property (nonatomic, retain) NSString* ElementOID;
@property (nonatomic, retain) NSString* Description;
@property (nonatomic, retain) NSString* ItemResponseOID;
@property (nonatomic, retain) NSString* FormItemOID;
@property (nonatomic, retain) NSString* DataType;
@property (nonatomic, retain) NSString* Position;
@property (nonatomic, retain) NSString* Value;
@property (nonatomic, retain) NSMutableArray* resources;

@end
