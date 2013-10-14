//
//  NCSRange.h
//  NCS
//
//  Created by Alexander Holden on 3/18/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCSRange : NSObject

@property (nonatomic, retain) NSString* ID;
@property int Min;
@property int Max;
@property (nonatomic, retain) NSMutableArray* criterias;

@end
