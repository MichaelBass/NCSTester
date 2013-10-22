//
//  IBAMParser.m
//  NCS
//
//  Created by MSS User on 8/5/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "IBAMParser.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSResource.h"
#import "NCSMap.h"
#import "XMLReader.h"


#import "NCSRange.h"
#import "NCSThreshold.h"
#import "NCSCriteria.h"


@interface IBAMParser ()
{
    
}

@end


@implementation IBAMParser

+ (NSMutableArray*) parseFormFile{
    
    NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
    BaseParser * parser = [[BaseParser alloc] init];
    
    
    NSString* formFileName =@"IBAMForm";
    
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
    NSString* formFileName  =@"IBAMParameter";
    
    NSError* error;
    NSString *path = [[NSBundle mainBundle] pathForResource:formFileName ofType: @"xml"];
    NSString *fileStr = [NSString stringWithContentsOfFile: path encoding: NSUTF8StringEncoding error: &error];
    
    NSDictionary *xmlDict = [XMLReader dictionaryForXMLString:fileStr error:&error];
    NSDictionary* paramDict = [xmlDict objectForKey:@"Criterias"];
    NSDictionary* thresholdsDict = [paramDict objectForKey:@"Thresholds"];
    id thresholdArr = [thresholdsDict objectForKey:@"Threshold"];

    
    NSMutableArray *myThresholds = [[NSMutableArray alloc] init];
    NSMutableArray *myRanges = [[NSMutableArray alloc] init];
    
    
    if([thresholdArr isKindOfClass:[NSArray class]])
    {
        // Parse out thresholds
        for(NSDictionary* threshold in thresholdArr)
        {
            NCSThreshold* newThreshold = [[NCSThreshold alloc] init];
            
            newThreshold.ID = [NSString stringWithString:[threshold objectForKey:@"ID"]];
            newThreshold.Description = [NSString stringWithString:[threshold objectForKey:@"Description"]];
            newThreshold.Value = [[NSString stringWithString:[threshold objectForKey:@"Value"]] intValue];
            
            [myThresholds addObject:newThreshold];
            //[_param.thresholds addObject:newThreshold];//_parameterDictionary
            
        }
        
    }
    else
    {
        NCSThreshold* newThreshold = [[NCSThreshold alloc] init];
        
        newThreshold.ID = [NSString stringWithString:[thresholdArr objectForKey:@"ID"]];
        newThreshold.Description = [NSString stringWithString:[thresholdArr objectForKey:@"Description"]];
        newThreshold.Value = [[NSString stringWithString:[thresholdArr objectForKey:@"Value"]] intValue];
        
        [myThresholds addObject:newThreshold];
    }
    
    
    // Parse out ranges with criteria
    NSArray* rangeArr = [paramDict objectForKey:@"Range"];
    
    for(NSDictionary* range in rangeArr)
    {
        NCSRange* newRange = [[NCSRange alloc] init];
        
        newRange.ID = [NSString stringWithString:[range objectForKey:@"ID"]];
        newRange.Max = [[NSString stringWithString:[range objectForKey:@"Max"]] intValue];
        newRange.Min = [[NSString stringWithString:[range objectForKey:@"Min"]] intValue];
        
        NSArray* criteriaArr = [range objectForKey:@"Criteria"];
        
        for(NSDictionary* criteria in criteriaArr)
        {
            NCSCriteria* newCriteria = [[NCSCriteria alloc] init];
            
            if([criteria objectForKey:@"Section"]){
                newCriteria.Section = [[NSString stringWithString:[criteria objectForKey:@"Section"]] intValue];
            }
            if([criteria objectForKey:@"Threshold"]){
                newCriteria.Threshold = [NSString stringWithString:[criteria objectForKey:@"Threshold"]];
            }
            if([criteria objectForKey:@"Gate"]){
                newCriteria.Gate = [NSString stringWithString:[criteria objectForKey:@"Gate"]];
            }
            if([criteria objectForKey:@"Type"])
            {
                NSNumber* num = [criteria objectForKey:@"Type"];
                newCriteria.Type = [num intValue];
            }
            
            [newRange.criterias addObject:newCriteria];
        }
        
        [myRanges addObject:newRange];
  
    }
    
    [_parameterDictionary setValue:myRanges forKey: @"Ranges"];
    [_parameterDictionary setValue:myThresholds forKey: @"Thresholds"];
    
}


- (void) parseFormFile
{
    NSString* formFileName;
    
    formFileName =@"IBAMForm";
    
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

- (NCSItem*) parseItem:(NSDictionary*) itemDict
{
    NCSItem* newItem = [[NCSItem alloc] init];
    
    newItem.ID = [NSString stringWithString:[itemDict objectForKey:@"ID"]];
    newItem.ItemDataOID = [NSString stringWithString:[itemDict objectForKey:@"ItemDataOID"]];
    newItem.FormItemOID = [NSString stringWithString:[itemDict objectForKey:@"FormItemOID"]];
    newItem.ItemResponseOID = [NSString stringWithString:[itemDict objectForKey:@"ItemResponseOID"]];
    newItem.Response = [NSString stringWithString:[itemDict objectForKey:@"Response"]];
    newItem.ResponseTime = [NSString stringWithString:[itemDict objectForKey:@"ResponseTime"]];
    newItem.ResponseDescription = [NSString stringWithString:[itemDict objectForKey:@"ResponseDescription"]];
    newItem.Position = [NSString stringWithString:[itemDict objectForKey:@"Position"]];
    newItem.Section = [[NSString stringWithString:[itemDict objectForKey:@"Section"]] intValue];
    newItem.Order = [[NSString stringWithString:[itemDict objectForKey:@"Order"]] intValue];
    newItem.StyleSheet = [NSString stringWithString:[itemDict objectForKey:@"StyleSheet"]];
    
    return newItem;
}

- (NCSElement*) parseElement: (NSDictionary*) elementDict
{
    NCSElement* newElement = [[NCSElement alloc] init];
    
    newElement.ElementOID = [NSString stringWithString:[elementDict objectForKey:@"ElementOID"]];
    newElement.Description = [NSString stringWithString:[elementDict objectForKey:@"Description"]];
    newElement.ElementOrder = [NSString stringWithString:[elementDict objectForKey:@"ElementOrder"]];
    //newElement.ElementType = [NSString stringWithString:[elementDict objectForKey:@"ElementType"]];
    
    return newElement;
}

- (NCSMap*) parseMap:(NSDictionary*) mapDict
{
    NCSMap* newMap = [[NCSMap alloc] init];
    
    newMap.ElementOID = [NSString stringWithString:[mapDict objectForKey:@"ElementOID"]];
    
    if([mapDict objectForKey:@"Description"] != nil){
        newMap.Description = [NSString stringWithString:[mapDict objectForKey:@"Description"]];
    }
    if([mapDict objectForKey:@"ItemResponseOID"] != nil){
        newMap.ItemResponseOID = [NSString stringWithString:[mapDict objectForKey:@"ItemResponseOID"]];
    }
    if([mapDict objectForKey:@"FormItemOID"] != nil){
        newMap.FormItemOID = [NSString stringWithString:[mapDict objectForKey:@"FormItemOID"]];
    }
    if([mapDict objectForKey:@"DataType"] != nil){
        newMap.DataType = [NSString stringWithString:[mapDict objectForKey:@"DataType"]];
    }
    if([mapDict objectForKey:@"Postion"] != nil){
        newMap.Position = [NSString stringWithString:[mapDict objectForKey:@"Position"]];
    }
    if([mapDict objectForKey:@"Value"] != nil){
        newMap.Value = [NSString stringWithString:[mapDict objectForKey:@"Value"]];
    }
    
    return newMap;
}

- (NCSResource*) parseResource: (NSDictionary*) resourceDict
{
    NCSResource* newResource = [[NCSResource alloc] init];
    
    newResource.Description = [NSString stringWithString:[resourceDict objectForKey:@"Description"]];
    
    // remove html tags if any
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"<br/>" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"<br>" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"lt;" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"&" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"br/" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"gt;" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"lt;" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"lt;" withString:@""];
    newResource.Description = [newResource.Description stringByReplacingOccurrencesOfString:@"img src='star.jpg'/" withString:@""];
    newResource.ResourceOID = [NSString stringWithString:[resourceDict objectForKey:@"ResourceOID"]];
    newResource.Type = [NSString stringWithString:[resourceDict objectForKey:@"Type"]];
    
    return newResource;
}

- (void) parseResourcesNode: (NSDictionary*) dict addToArray: (NSMutableArray*) arr
{
    NSDictionary* resourcesDict = [dict objectForKey:@"Resources"];
    
    if(resourcesDict && resourcesDict.count)
    {
        NSArray* resourcesArr = [resourcesDict objectForKey:@"Resource"];
        
        if(resourcesArr && resourcesArr.count)
        {
            // Thre returned object can be either a Dictionary or Array
            if([resourcesArr isKindOfClass:[NSArray class]])
            {
                for(NSDictionary* resource in resourcesArr)
                {
                    NCSResource* newResource = [self parseResource:resource];
                    [arr addObject:newResource];
                }
            }
            else
            {
                NCSResource* newResource = [self parseResource:(NSDictionary*)resourcesArr];
                [arr addObject:newResource];
            }
        }
    }
}

- (void) parseElementNode: (NSDictionary*) elementDict item:(NCSItem*) newItem
{
    NCSElement* newElement = [self parseElement:elementDict];
    
    // Parse Resources node under elements
    [self parseResourcesNode:elementDict addToArray:newElement.resources];
    
    // Parse Mappings node
    NSDictionary* mappingsDict = [elementDict objectForKey:@"Mappings"];
    
    
    if(mappingsDict && mappingsDict.count)
    {
        
        NSDictionary* mappingArr = [mappingsDict objectForKey:@"Map"];
        
        if(mappingArr)
        {
            NCSMap* newMap = [self parseMap:mappingArr];
            // Parse Resources node under Mappings
            [self parseResourcesNode:mappingArr addToArray:newMap.resources];
            [newElement.mappings addObject:newMap];
        }
    }
    
    [newItem.elements addObject:newElement];
}
@end
