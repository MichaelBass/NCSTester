//
//  BaseParser.h
//  NCSTester
//
//  Created by Bass, Michael on 10/4/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSResource.h"
#import "NCSMap.h"
@interface BaseParser : NSObject

- (void) parseElementNode: (NSDictionary*) elementDict item:(NCSItem*) newItem;
- (void) parseResourcesNode: (NSDictionary*) dict addToArray: (NSMutableArray*) arr;
- (NCSResource*) parseResource: (NSDictionary*) resourceDict;
- (NCSMap*) parseMap:(NSDictionary*) mapDict;
- (NCSElement*) parseElement: (NSDictionary*) elementDict;
- (NCSItem*) parseItem:(NSDictionary*) itemDict;

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict;

@end
