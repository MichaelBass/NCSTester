//
//  DCCSDataParser.h
//  NCS

//

#import <Foundation/Foundation.h>
#import "BaseParser.h"

@interface VocabParser: BaseParser
{
    NSMutableArray* _itemList;
    NSMutableDictionary* _parameterDictionary;
}

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict;

+ (NSMutableArray*) parseFormFile;

@end
