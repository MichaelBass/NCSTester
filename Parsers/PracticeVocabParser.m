//
//  DCCSDataParser.m
//  NCS
//
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "PracticeVocabParser.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSResource.h"
#import "NCSMap.h"
#import "XMLReader.h"
#import "ItemCalibration.h"

@interface PracticeVocabParser ()
{
    
}
@end

@implementation PracticeVocabParser


- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict
{
    _itemList = itemList;
    _parameterDictionary = dict;
    
    [self parseFormFile];
    
}

+ (NSMutableArray*) parseFormFile{

    NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
    BaseParser * parser = [[BaseParser alloc] init];
    
    
    NSString* formFileName =@"Picture Vocabulary PracticeForm";
    
    NSError* error;
    NSString *path = [[NSBundle mainBundle] pathForResource:formFileName ofType: @"xml"];
    NSString *fileStr = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error];
    
    NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:fileStr error:&error];
    
    NSDictionary* formDict = [xmlDict objectForKey:@"Form"];
    NSDictionary* itemsDict = [formDict objectForKey:@"Items"];
    NSArray* itemsArr = [itemsDict objectForKey:@"Item"];
    
    for(NSDictionary* itemDict in itemsArr)
    {
        // Parse item
        NCSItem* newItem = [parser parseItem:itemDict];
        
        // Parse item elements
        NSDictionary* elementsDict = [itemDict objectForKey:@"Elements"];
        NSArray* elementsArr = [elementsDict objectForKey:@"Element"];
        
        // Thre returned object can be either a Dictionary or Array
        if([elementsArr isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* element in elementsArr)
            {
                [parser parseElementNode:element item:newItem];
            }
        }
        else
        {
            [parser parseElementNode:(NSDictionary*)elementsArr item:newItem];
        }
        
        [rtn addObject:newItem];
    }
    
    return rtn;

}


- (void) parseFormFile
{
    NSString* formFileName =@"Picture Vocabulary PracticeForm";

    NSError* error;
    NSString *path = [[NSBundle mainBundle] pathForResource:formFileName ofType: @"xml"];
    NSString *fileStr = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error];
    
    NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:fileStr error:&error];
    
    NSDictionary* formDict = [xmlDict objectForKey:@"Form"];
    NSDictionary* itemsDict = [formDict objectForKey:@"Items"];
    NSArray* itemsArr = [itemsDict objectForKey:@"Item"];
    
    for(NSDictionary* itemDict in itemsArr)
    {
        // Parse item
        NCSItem* newItem = [self parseItem:itemDict];
        
        // Parse item elements
        NSDictionary* elementsDict = [itemDict objectForKey:@"Elements"];
        NSArray* elementsArr = [elementsDict objectForKey:@"Element"];
        
        // Thre returned object can be either a Dictionary or Array
        if([elementsArr isKindOfClass:[NSArray class]])
        {
            for(NSDictionary* element in elementsArr)
            {
                [self parseElementNode:element item:newItem];
            }
        }
        else
        {
            [self parseElementNode:(NSDictionary*)elementsArr item:newItem];
        }
        
        [_itemList addObject:newItem];
    }

}



@end
