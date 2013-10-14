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
    NSString* formFileName = @"IBAMForm";
    
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
