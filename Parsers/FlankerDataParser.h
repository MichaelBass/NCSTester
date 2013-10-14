//
//  FlankerDataParser.h
//  NCS
//

#import <Foundation/Foundation.h>
#import "BaseParser.h"

@interface FlankerDataParser : BaseParser
{
    NSMutableArray* _itemList;
    NSMutableDictionary* _parameterDictionary;
}

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict;

@end
