//
//  ProgressiveSectionalEngine.m
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/29/12.
//
//

#import "ProgressiveSectionalEngine.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSMap.h"
#import "Result.h"
#import "NCSThreshold.h"
#import "NCSCriteria.h"
#import "NCSRange.h"
#import "UUID.h"

@interface ProgressiveSectionalEngine()

@property int position;
@property int section;
@property int age;
@property int score;

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
-(void)shuffle: (NSMutableArray*) sectionalItems;

@end

@implementation ProgressiveSectionalEngine

-(NSArray *) getNextSection{ return nil; }

#pragma mark - private primative properties -
@synthesize position = _position;
@synthesize section = _section;
@synthesize age = _age;
@synthesize score = _score;

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
/* @synthesize NCSParameter = _NCSParameter; */
@synthesize ParameterDictionary = _ParameterDictionary;
@synthesize ResultSetList = _ResultSetList;
@synthesize itemID = _itemID;
@synthesize finished = _finished;
@synthesize trace = _trace;

#pragma mark - private methods -
-(void)calculateSectionScore:(NCSItem*) item response:(int) response{
    
    /*
    if([self.sectionItems objectForKey:item.Section] == nil) {
        NSLog(@"Can't find section!");
        return;
    };
    */
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
    
    
    //NSLog(@"Sectional Criterias [%i]", self.sectionCriteria.count);
    
    
    
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
                [self loadSectionalCriteria: criteria];
            }
            self.range = range;
        }
        
    }
    //NSLog(@"Ranges [%i]", self.ranges.count);
    
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
-(void)setUser:(CDUser*)user{
    
    self.age = user.getUserAge;
    
    //NSLog(@"Age is %d", self.age);

    NSMutableArray *myRanges = [_ParameterDictionary  objectForKey:@"Ranges"];
    [self loadRanges : myRanges ];

}

-(float) getScore{
    
    
    return (float)self.score;

}
-(float) getError{ return 0.0;}

-(NCSItem *) getItem :(NSString*) ID{
    NCSItem* item = nil;
    
    if([ID isEqual: @""]){
        return nil;
    }
    
    for(int i = 0; i < _ItemRangeList.count; i++){
        
        if(ID == ((NCSItem*)[_ItemRangeList objectAtIndex:i]).FormItemOID){
            item = (NCSItem*)[_ItemRangeList objectAtIndex:i];
        }
    }
    
    return item;
}
-(NSString *) getNextItem{
    
    if(self.position == self.ItemRangeList.count){
        self.position = -1;
        return @"";
    }
    
    [self evaluateCriteria];
    if(self.position == -1){
        return @"";
    }
    
    NCSItem *myItem = [self.ItemRangeList objectAtIndex:self.position];
    
    self.itemID = myItem.FormItemOID;
    self.position += 1;
    
    
   // NSLog(@"Returning item: %d is %d ",myItem.Section ,myItem.Order);
    
    
    return self.itemID;
}

-(NSArray *)  processResponses: (NSArray *) responses responsetime:(double) responsetime{
    return nil;
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
    /*
     for (Result *myResult in self.ResultController.ResultList) {
     NSLog(@"%@  : %i : %f",  myResult.ItemID, myResult.Answer, myResult.ResponseTime );
     }
     */
}

/*
-(id)initwithParameterList :(NCSParameter *) paramlist{
    
    
    if(self){
        
     //  _NCSParameter  = paramlist; 
        
        [self loadSectionalThresholds : paramlist.thresholds ];
        
        return self;
    }
    return nil;
}
*/
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
- (void)shuffle: (NSMutableArray*) sectionalItems{
    NSUInteger count = [sectionalItems count];
    for (uint i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [sectionalItems exchangeObjectAtIndex:i withObjectAtIndex:n];
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

    // Determine if section should be randomized
    for (NSString* key in self.sectionItems ) {
        NCSCriteria* criteria = [self.sectionCriteria objectForKey: key ];
        if(criteria != nil ){
            if(criteria.IsItem != NO){
                // randomize section
                [self shuffle: [self.sectionItems objectForKey:key]];
                // NSLog(@"Items are randomize %@", key );
            }
        }

    }
    
    
    // Get an ordered list of Sections
    NSArray *keys = [self.sectionItems allKeys ];
 
    NSArray *sortedKeys;
    sortedKeys = [keys sortedArrayUsingComparator:^(id obj1, id obj2){ return [obj1 intValue] - [obj2 intValue];}];   

 // Load the final order Item List
for(int i = 0; i < sortedKeys.count; i++){
    
     //NSLog(@"key : %i - %@",i,[sortedKeys objectAtIndex:i]);
    
    NSMutableArray *myFinalArray = [self.sectionItems objectForKey: [sortedKeys objectAtIndex:i] ];
    for(int i = 0; i < [myFinalArray count] ; i++){
        
        NCSItem* item = [myFinalArray objectAtIndex:i];
        
        [self.ItemRangeList addObject:item];
        //NSLog(@"Loading item : %i - %i",item.Section,item.Order );
        


    }
    
}
  // set the position
    for(int i = 0; i < self.ItemRangeList.count; i++){
        
        NCSItem* item = [self.ItemRangeList objectAtIndex:i];
 //NSLog(@"Loading item : %i - %i",item.Section,item.Order );
        if(![item.ItemResponseOID isEqual: @""]){
            
            
            // Check for valid response
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

 }

/*
-(id)initwithItemList :(NSArray *) itemlist{
    if (self) {
        self.ItemList = itemlist;
        
        [self loadSectionalDictionary];

        return self;
    }
    return nil;
}
*/
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
