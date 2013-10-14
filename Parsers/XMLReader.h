//
//  XMLReader.h
//  NCS
//
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
