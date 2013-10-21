//
//  DCCSDataParser.m
//  NCS
//

//

#import "VocabParser.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSResource.h"
#import "NCSMap.h"
#import "XMLReader.h"
#import "ItemCalibration.h"


@interface VocabParser ()
{
    
}


@end

@implementation VocabParser

+ (NSMutableArray*) parseFormFile{
    
    NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
    BaseParser * parser = [[BaseParser alloc] init];
    
    
    NSString* formFileName =@"Picture VocabularyForm";
    
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

- (void) loadData: (NSMutableArray*) itemList params: (NSMutableDictionary*) dict
{
    _itemList = itemList;
    _parameterDictionary = dict;
    
    [self parseFormFile];
    [self parseParamFile];
}
- (void) parseParamFile
{
    NSString* formFileName;
    
    formFileName = @"Picture VocabularyParameter";

    NSError* error;
    NSString *path = [[NSBundle mainBundle] pathForResource:formFileName ofType: @"xml"];
    NSString *fileStr = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error];
    
    NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:fileStr error:&error];
    NSDictionary* paramDict = [xmlDict objectForKey:@"Calibration"];
    NSDictionary* itemsDict = [paramDict objectForKey:@"Item"];
    
    
    // NSMutableArray *myItems = [[NSMutableArray alloc] init];

        // Parse out thresholds
        for(NSDictionary* item in itemsDict)
        {
        /*
            @property (nonatomic, strong) NSString *FormItemOID;
            @property (nonatomic, strong) NSString *ItemID;
            @property (nonatomic) double A_GRM;
            @property (nonatomic) double Variance;
            @property (nonatomic) bool Administered;
         <Item FormItemOID="0007965D-84F2-48D0-BA3B-B43DBFDD1716" VariableName="LAVOC560" Slope="1" Difficulty="5.06" />
            */
            
            ItemCalibration* newItemCalibration = [[ItemCalibration alloc] init];
            
            newItemCalibration.FormItemOID = [NSString stringWithString:[item objectForKey:@"FormItemOID"]];
            newItemCalibration.ItemID = [NSString stringWithString:[item objectForKey:@"VariableName"]];
            newItemCalibration.A_GRM = [[NSString stringWithString:[item objectForKey:@"Difficulty"]] doubleValue];
            
            [_parameterDictionary setValue:newItemCalibration forKey: [NSString stringWithString:[item objectForKey:@"FormItemOID"]] ];

        }
}

- (void) parseFormFile
{
    NSString* formFileName;

    formFileName =@"Picture VocabularyForm";
    
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
