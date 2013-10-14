//
//  IBAMParser.h
//  NCS
//
//  Created by MSS User on 8/5/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseParser.h"

@interface IBAMParser : BaseParser
{
    NSMutableArray* _itemList;
    NSMutableDictionary* _parameterDictionary;
}

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict;

@end

