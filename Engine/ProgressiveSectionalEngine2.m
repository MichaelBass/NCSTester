//
//  ProgressiveSectionalEngine.m
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/29/12.
//
//

#import "ProgressiveSectionalEngine2.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSMap.h"
#import "Result.h"
#import "NCSThreshold.h"
#import "NCSCriteria.h"
#import "NCSRange.h"
#import "UUID.h"

@interface ProgressiveSectionalEngine2()

@property int position;
@property int section;
@property int age;
@property int score;
@property int type;


@property (nonatomic, strong) NSMutableDictionary *sectionItems;
@property (nonatomic, strong) NSMutableDictionary *sectionThresholds;
@property (nonatomic, strong) NSMutableDictionary *sectionCriteria;
@property (nonatomic, strong) NSMutableDictionary *ranges;
@property (nonatomic, strong) NCSRange* range;
@property (nonatomic, strong) NSMutableArray *ItemRangeList;
@property (nonatomic, strong) NSMutableArray *ItemResponseList;



-(void)calculateSectionScore:(NCSItem*) item response:(int) response;
-(void)loadSectionalDictionary;
-(void)loadSectionalThresholds: (NSMutableArray*) thresholds;
-(void)loadSectionalCriteria: (NCSCriteria*) criteria;
-(void)loadRanges: (NSMutableArray*) ranges;
//-(void)setSectionItem:(int) section;
-(void)evaluateCriteria;


@end

@implementation ProgressiveSectionalEngine2


#pragma mark - private primative properties -
@synthesize position = _position;
@synthesize section = _section;
@synthesize age = _age;
@synthesize score = _score;
@synthesize type = _type;

#pragma mark - private object properties -
@synthesize sectionItems = _sectionItems;
@synthesize sectionThresholds = _sectionThresholds;
@synthesize sectionCriteria = _sectionCriteria;
@synthesize ranges = _ranges;
@synthesize range = _range;
@synthesize ItemRangeList = _ItemRangeList;
@synthesize ItemResponseList = _ItemResponseList;

#pragma mark - private getters -

-(NSMutableArray*)ItemResponseList{
    
    if(!_ItemResponseList){
        
        NSMutableArray *myitemResponseList = [[NSMutableArray alloc] init];
        _ItemResponseList = myitemResponseList;
    }
    return _ItemResponseList;
}

-(NSMutableArray*)ItemRangeList{
    
    if(!_ItemRangeList){
        
        NSMutableArray *myitemRangeList = [[NSMutableArray alloc] init];
        _ItemRangeList = myitemRangeList;
    }
    return _ItemRangeList;
}
-(NSDictionary*)sectionCriteria{
    
    if(!_sectionCriteria){
        NSMutableDictionary *mysectionCriteria = [[NSMutableDictionary alloc] init];
        _sectionCriteria = mysectionCriteria;
    }
    return _sectionCriteria;
}
-(NSDictionary*)ranges{
    
    if(!_ranges){
        NSMutableDictionary *myranges = [[NSMutableDictionary alloc] init];
        _ranges = myranges;
    }
    return _ranges;
}
-(NSDictionary*)sectionThresholds{
    
    if(!_sectionThresholds){
        NSMutableDictionary *mysectionThresolds = [[NSMutableDictionary alloc] init];
        _sectionThresholds = mysectionThresolds;
    }
    return _sectionThresholds;
}
-(NSDictionary*)sectionItems{
    
    if(!_sectionItems){
        NSMutableDictionary *mysectionItems = [[NSMutableDictionary alloc] init];
        _sectionItems = mysectionItems;
    }
    return _sectionItems;
}
#pragma mark - private setter -
/*
-(void) setSectionItem:(int) section{
    
    for(int i = 0; i < self.ItemList.count; i++){
        NCSItem* item = [self.ItemList objectAtIndex:i];
        
        if(section == [item.Order intValue]){
            self.position =i;
            break;
        }
    }
}
*/

#pragma mark - public properties -
@synthesize ItemList = _ItemList;
@synthesize ParameterDictionary = _ParameterDictionary;
@synthesize ResultSetList = _ResultSetList;
@synthesize itemID = _itemID;
@synthesize finished = _finished;
@synthesize trace = _trace;

#pragma mark - private methods -
-(void)calculateSectionScore:(NCSItem*) item response:(int) response{
    

    if(response == 0 ){
        //NSLog(@"wrong answer don't update the criteria");
        return;
    }
    self.score +=1;

    
    NCSCriteria* criteria = [self.sectionCriteria objectForKey:[[NSNumber numberWithInt:item.Section] stringValue]];
    if(criteria != nil)
    {
        NCSThreshold* threshold = [self.sectionThresholds objectForKey:criteria.Threshold];
        if(threshold != nil)
        {
            
            
            
            if(threshold.UserValue > 0 && threshold.Section != item.Section){
                //Reset count to this section
                //NSLog(@"old/new threshold section %d - %d",threshold.Section,item.Section);
                threshold.UserValue = 0;
                
            }
            

            // Start counting correct answers and marking section
            if(threshold.UserValue == 0){
                threshold.Section = item.Section;
                //NSLog(@"Setting the threshold section to %d", threshold.Section);
            }
            
            threshold.UserValue += 1;
            //NSLog(@"Updating user correct answers to %@  -  %i",threshold.Value,threshold.UserValue);
            
        }
        
    }
    
}
-(void)loadSectionalThresholds :(NSMutableArray*) thresholds{
    for(NCSThreshold* threshold in thresholds)
    {
        if([self.sectionThresholds objectForKey:threshold.ID] == nil)
        {
            [self.sectionThresholds setValue:threshold forKey: threshold.ID];
        }
        else
        {
            [self.sectionThresholds setValue:threshold forKey: threshold.ID];
        }
        
    }
    //NSLog(@"Sectional Thresholds [%i]", self.sectionThresholds.count);
    
}
-(void)loadSectionalCriteria: (NCSCriteria*) criteria;{
    
    if([self.sectionCriteria objectForKey:[[NSNumber numberWithInt:criteria.Section] stringValue]] == nil)
    {
        [self.sectionCriteria setValue:criteria forKey: [[NSNumber numberWithInt:criteria.Section] stringValue] ];
    }
    else
    {
        [self.sectionCriteria setValue:criteria forKey: [[NSNumber numberWithInt:criteria.Section] stringValue] ];
    }
    
    
  // NSLog(@"Criteria [%i][%i][%@][%@]", criteria.Section, criteria.Type, criteria.Threshold, criteria.Gate );
    
    
    
}
-(void)loadRanges :(NSMutableArray*) ranges{
    
    for(NCSRange* range in ranges)
    {
        
        int _Max = range.Max ;
        int _Min = range.Min ;
        
        if(self.age >= _Min && self.age <= _Max){
            
            
            if([self.ranges objectForKey:range.ID] == nil)
            {
                [self.ranges setValue:range forKey: range.ID];
            }
            else
            {
                [self.ranges setValue:range forKey: range.ID];
            }
            
            for(NCSCriteria* criteria in range.criterias){
                if(criteria.Type == self.type){
                    [self loadSectionalCriteria: criteria];
                }
            }
            
            self.range = range;
        }
        
    }
//    NSLog(@"Ranges [%i]", self.ranges.count);
//    NSLog(@"Sectional Criterias [%i]", self.sectionCriteria.count);
    
}
-(void)evaluateCriteria{
    
    bool f = false;
    
    while(!f){
        
        NCSItem *myItem = [self.ItemRangeList objectAtIndex:self.position];
                
        NCSCriteria* criteria = [self.sectionCriteria objectForKey:[[NSNumber numberWithInt:myItem.Section] stringValue]];
        
        if(criteria == nil){
            f= true;
        }
        else
        {
            NCSThreshold* threshold = [self.sectionThresholds objectForKey:criteria.Threshold];
            if(threshold == nil){
                
                
                // check for gated criteria - end of test condition
                if(![criteria.Gate isEqual: @""]){
                    NCSThreshold* thresholdGate = [self.sectionThresholds objectForKey:criteria.Gate];
                    if(thresholdGate){
                        if(thresholdGate.UserValue < thresholdGate.Value ){
                            self.position = -1;
                            f=true;
                            break;
                        }
                    }
                   
                }
                
                f= true;
            }
            else
            {
      
                if(threshold.UserValue >= threshold.Value ){
  
                    // finish the current section before skipping over other sections
                    if( myItem.Section == threshold.Section){
                         f = true;
                        break;
                    }
                    
                    self.position += 1;
                    
                    //end of form
                    if(self.position == self.ItemRangeList.count){
                        self.position = -1;
                        f=true;
                    }
                    
                }else{
                    f= true;
                }
            }
            
        }
    }
    
}
#pragma mark - public methods -
-(void)setStartItem:(NSString*)firstItemID{
    self.position = [firstItemID intValue];
    int iPos = 0;
    
    // Locate item in the list with this ID
    for(NCSItem* i in self.ItemRangeList)
    {
        if([i.FormItemOID isEqualToString:firstItemID])
        {
            self.position = iPos;
            break;
        }
        
        ++iPos;
    }
}

- (void)setUser:(CDUser *)user
{
    self.age = user.getUserAge;
    self.type = 1;
    
    NSMutableArray *myRanges = [_ParameterDictionary  objectForKey:@"Ranges"];
    [self loadRanges : myRanges ];

}

-(float) getScore{
    
    
    return (float)self.score;

}
-(float) getError{ return 0.0;}

-(NCSItem *) getItem :(NSString*) ID{
    return nil;
}
-(NSArray *) getNextSection{

    
    NSArray *rtn = nil;
    
    if(self.position == self.ItemRangeList.count){
        self.position = -1;
        return rtn;
    }
    
    //[self evaluateCriteria];
    if(self.position == -1){
        return rtn;
    }
    
    rtn = (NSArray *)[self.ItemRangeList objectAtIndex:self.position];
    self.position += 1;
    
    return rtn;


}

-(NSString *) getNextItem{
    
    if(self.position == self.ItemRangeList.count){
        self.position = -1;
        return @"";
    }
    
    //[self evaluateCriteria];
    if(self.position == -1){
        return @"";
    }
 
    self.position += 1;
    
    return [NSString stringWithFormat:@"%d",self.position];
}
-(NCSItem *) processResponse:(int)response{
    
    NCSItem* item =[self getItem:self.itemID];
    
    [self calculateSectionScore: item response:response];
 
    item.Response = [NSString stringWithFormat:@"%i", response];
    item.ItemDataOID = [UUID generateUuidString];
    
    for(NCSElement* e in item.elements)
    {
        for(NCSMap* m in e.mappings)
        {
            if( [ m.Description isEqualToString:[[NSNumber numberWithInt:response] stringValue]] ){
                item.ItemResponseOID = m.ItemResponseOID;
                item.Response = m.Value;
                item.ResponseDescription = m.Description;
                break;
            }
        }
    }

    [self.ItemResponseList addObject:item];
    item.Position = [[NSNumber numberWithInt:self.ItemResponseList.count] stringValue];

    return item;
    
}



-(NSArray *)  processResponses: (NSArray *) responses responsetime:(double) responsetime{
    
    
    for(NCSItem* i in responses)
    {
         i.ResponseTime = [NSString stringWithFormat:@"%f", responsetime];
         i.ItemDataOID = [UUID generateUuidString];

        [self.ItemResponseList addObject:i];
        i.Position = [[NSNumber numberWithInt:self.ItemResponseList.count] stringValue];
 
        
        for(NCSElement* e in i.elements)
        {
            if(e.mappings.count>0){
                NCSMap* m = [e.mappings objectAtIndex:0];
                i.ItemResponseOID = m.ItemResponseOID;
                i.ResponseDescription = m.Description;
            }
        }
        
        
        
    }
    return responses;
    
}

-(NCSItem *) processResponse:(int)response responsetime:(double)responsetime{
    
    NCSItem* item =[self getItem:self.itemID];
    
    [self calculateSectionScore: item response:response];
    
    item.ResponseTime = [NSString stringWithFormat:@"%f", responsetime];
    
    item.Response = [NSString stringWithFormat:@"%i", response];
    item.ItemDataOID = [UUID generateUuidString];
    
    for(NCSElement* e in item.elements)
    {
        for(NCSMap* m in e.mappings)
        {
            if( [ m.Description isEqualToString:[[NSNumber numberWithInt:response] stringValue]] ){
                item.ItemResponseOID = m.ItemResponseOID;
                item.Response = m.Value;
                item.ResponseDescription = m.Description;
                break;
            }
        }
    }

    [self.ItemResponseList addObject:item];
    item.Position = [[NSNumber numberWithInt:self.ItemResponseList.count] stringValue];
    
    return item;
    
}
-(void) getResults{
    for (NCSItem* myResult in self.ItemResponseList) {
        NSLog(@"%@  : %@ : %@ %@  ",  myResult.ID, myResult.Response, myResult.Position, myResult.ItemResponseOID );
    }
}

-(id)initwithParameterDictionary:(NSMutableDictionary *)paramdictionary{
    
    
    if(self){
        
        _ParameterDictionary  = paramdictionary;
        NSMutableArray *myThreholds = [_ParameterDictionary  objectForKey:@"Thresholds"];
        [self loadSectionalThresholds : myThreholds ];
        
        return self;
    }
    return nil;
}

-(void)setItemList:(NSArray *) value{
    //NSLog(@"setting the Item List ");
    if (self) {
        _ItemList = value;
        [self loadSectionalDictionary];
    }
}

-(void)loadSectionalDictionary{

    
 // Load all items into sectional Array
 for(int i = 0; i < self.ItemList.count; i++){
 
     NCSItem* item = [self.ItemList objectAtIndex:i];
     NSString* key =  [[NSNumber numberWithInt:item.Section] stringValue];
 
     
     if([self.sectionCriteria  objectForKey: [[NSNumber numberWithInt:item.Section] stringValue] ] == nil){
         //Only load sections that have criterias
         continue;
     };
     
     
     if([self.sectionItems objectForKey:key] == nil) {// First item in section
         NSMutableArray *myArray = [[NSMutableArray alloc] init];
         [myArray addObject:item];
 
         [self.sectionItems setValue:myArray forKey: key];
 
     }else{
 
         NSMutableArray *myArray = [self.sectionItems  objectForKey:key];
         [myArray addObject:item];
         [self.sectionItems setValue:myArray forKey: key];
 
     }
     
 }
    
    
    // Get an ordered list of Sections
    NSArray *keys = [self.sectionItems allKeys ];
 
    NSArray *sortedKeys;
    sortedKeys = [keys sortedArrayUsingComparator:^(id obj1, id obj2){ return [obj1 intValue] - [obj2 intValue];}];   

    // Load the final ordered Item Array List
    for(int i = 0; i < sortedKeys.count; i++){
        NSMutableArray *myFinalArray = [self.sectionItems objectForKey: [sortedKeys objectAtIndex:i] ];
        [self.ItemRangeList addObject:myFinalArray];
    }

    // set the position for restart -- todo make this work by section
    self.position = 0;
    /*
    for(int i = 0; i < self.ItemRangeList.count; i++){
        
        NCSItem* item = [self.ItemRangeList objectAtIndex:i];
        if(![item.ItemResponseOID isEqual: @""]){
            
            
            for(NCSElement* e in item.elements)
            {
                for(NCSMap* m in e.mappings)
                {
                    if( [ m.ItemResponseOID isEqualToString:item.ItemResponseOID] ){
                        [ self calculateSectionScore:item response:[ m.Description intValue]];
                        self.position = (i + 1);
                        break;
                    }
                }
            }
  
            
        }
    }
     */

 }


-(id)init{
    self = [super init];
    if (self) {
        
        self.position = 0;
        self.score = 0;
        
        NSLog(@"Engine has been initialized!");
        
        return self;
    }
    return nil;
}
@end
