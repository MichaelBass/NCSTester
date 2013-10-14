//
//  DichotomousEngine.m
//  DichotomousEngine
//
//  Created by Bass, Michael on 8/7/12.
//  Copyright (c) 2012 Bass, Michael. All rights reserved.
//



#import "DichotomousEngine.h"
#import "ItemCalibration.h"
#import "Result.h"
#import "NCSItem.h"
#import "NCSElement.h"
#import "NCSMap.h"
#import "Result.h"
#import "UUID.h"

@interface DichotomousEngine()

@property (nonatomic, strong) NSMutableArray *ItemResponseList;
@property (nonatomic, strong) NSMutableDictionary *startThetas;

@end



@implementation DichotomousEngine
/*
 @property (nonatomic, copy) NSArray *ItemList;
 @property (nonatomic, copy) NSMutableDictionary *ParameterDictionary;
 @property (nonatomic, copy) NSArray *ResultSetList;
 @property (nonatomic) double Ability;
 @property (nonatomic) double SE;
 @property (nonatomic, strong) NSString *itemID;
 @property (nonatomic) Boolean finished;
 @property (nonatomic, strong) NSString *trace;
 
 */

@synthesize ItemResponseList = _ItemResponseList;
@synthesize ResultSetList = _ResultSetList;
@synthesize itemID = _itemID;
@synthesize trace = _trace;
@synthesize ItemList = _ItemList;
@synthesize ParameterDictionary = _ParameterDictionary;
@synthesize finished = _finished;
@synthesize Ability = _Ability;
@synthesize SE = _SE;


-(NSArray *) getNextSection{ return nil; }

-(NSMutableArray*)ItemResponseList{
    
    if(!_ItemResponseList){
        
        NSMutableArray *myitemResponseList = [[NSMutableArray alloc] init];
        _ItemResponseList = myitemResponseList;
    }
    return _ItemResponseList;
}

-(float) getScore{
    
    int pos = [self.ItemResponseList count];
    
    if(pos > 0)
        --pos;
    
    if(self.ItemResponseList.count)
        return ((Result*)[self.ItemResponseList objectAtIndex: pos]).Score;
    
    return 0;
}

-(float) getError{
    
    int pos = [self.ItemResponseList count];
    
    if(pos > 0)
        --pos;
    
    if(self.ItemResponseList.count)
        return ((Result*)[self.ItemResponseList objectAtIndex: pos]).SE = self.SE;
    else
        return  0;
}
-(void)setStartItem:(NSString*)firstItemID{

}
-(void)setUser:(CDUser *)user{
 
    int age = user.getUserAge;
    self.Ability =  [[self.startThetas objectForKey:[[NSNumber numberWithInt:age] stringValue]] floatValue];
      
}

-(void)setItemList:(NSArray*) value{

    if (self) {
        _ItemList = value;
        [self checkForAdministeredItems];
    }
}

-(void)checkForAdministeredItems{

    for(int i = 0; i < _ItemList.count; i++){
        
        NCSItem *testItem = (NCSItem*)[_ItemList objectAtIndex:i];

        if(![@""  isEqual: testItem.ItemDataOID]){
            ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: testItem.FormItemOID ];
            myItemCalibration.Administered = true;

            Result *myResult = [[Result alloc] initWithName:testItem.ID answer:[testItem.Response intValue] score:self.Ability se:self.SE responsetime:[testItem.ResponseTime doubleValue]];
            
            [self.ItemResponseList addObject:myResult];
            
         }
    }
    
}


-(void)setstartThetas{
    
    /*
     self.educationListArray = [[NSArray alloc] initWithObjects:@"none", @"preschool", @"kindergarten", @"1st grade", @"2nd grade", @"3rd grade", @"4th grade", @"5th grade", @"6th grade", @"7th grade", @"8th grade", @"9th grade", @"10th grade", @"11th grade", @"12th grade (no diploma)",@"High School Graduate", @"GED", @"Some college credit but less than1 year", @"One or more years of college, no degree", @"Associates degree (AA, AS)", @"Bachelor's degree (BA, AB, BS)", @"Masters degree (MA, MS, MEng, MEd, MSW, MBA)", @"Professional degree (e.g. MD, DDS, DVM, LLB, JD)", @"Doctorate degree (PhD, EdD)", nil];
     
     
     
     EducationLevel_1	1.5
     EducationLevel_2	1.6
     EducationLevel_3	1.7
     EducationLevel_4	1.8
     EducationLevel_5	1.9
     EducationLevel_6	2
     EducationLevel_7	2.1
     EducationLevel_8	2.2
     EducationLevel_9	2.3
     EducationLevel_10	2.4
     EducationLevel_11	2.5
     EducationLevel_12	2.6
     EducationLevel_13	2.9
     EducationLevel_14	3.3
     EducationLevel_15	4
     EducationLevel_16	3.7
     EducationLevel_17	4
     EducationLevel_18	3.9
     EducationLevel_19	4.8
     EducationLevel_20	4.5
     EducationLevel_21	5.4
     EducationLevel_22	5.7
     EducationLevel_23	7.2
     EducationLevel_24	5.8
     
     
     */ 
    /* look-up ability based on age */
   
        self.startThetas = [[NSMutableDictionary alloc] init];
        
        [self.startThetas setObject:[NSNumber numberWithFloat:-5.95] forKey:@"3"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-4.89] forKey:@"4"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-3.95] forKey:@"5"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-2.91] forKey:@"6"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-2.52] forKey:@"7"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-1.69] forKey:@"8"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-0.49] forKey:@"9"];
        [self.startThetas setObject:[NSNumber numberWithFloat:-0.17] forKey:@"10"];
        [self.startThetas setObject:[NSNumber numberWithFloat:0.79] forKey:@"11"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.42] forKey:@"12"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.93] forKey:@"13"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.45] forKey:@"14"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.65] forKey:@"15"];
        [self.startThetas setObject:[NSNumber numberWithFloat:3.16] forKey:@"16"];
        [self.startThetas setObject:[NSNumber numberWithFloat:3.1] forKey:@"17"];
        
        
        [self.startThetas setObject:[NSNumber numberWithFloat:1.5] forKey:@"none"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.6] forKey:@"preschool"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.7] forKey:@"kindergarten"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.8] forKey:@"1st grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:1.9] forKey:@"2nd grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.0] forKey:@"3rd grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.1] forKey:@"4th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.2] forKey:@"5th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.3] forKey:@"6th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.4] forKey:@"7th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.5] forKey:@"8th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.6] forKey:@"9th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:2.9] forKey:@"10th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:3.3] forKey:@"11th grade"];
        [self.startThetas setObject:[NSNumber numberWithFloat:4.0] forKey:@"12th grade (no diploma)"];
        [self.startThetas setObject:[NSNumber numberWithFloat:3.7] forKey:@"High School Graduate"];
        [self.startThetas setObject:[NSNumber numberWithFloat:4.0] forKey:@"GED"];
        [self.startThetas setObject:[NSNumber numberWithFloat:3.9] forKey:@"Some college credit but less than1 year"];
        [self.startThetas setObject:[NSNumber numberWithFloat:4.8] forKey:@"One or more years of college, no degree"];
        [self.startThetas setObject:[NSNumber numberWithFloat:4.5] forKey:@"Associates degree (AA, AS)"];
        [self.startThetas setObject:[NSNumber numberWithFloat:5.4] forKey:@"Bachelor's degree (BA, AB, BS)"];
        [self.startThetas setObject:[NSNumber numberWithFloat:5.7] forKey:@"Masters degree (MA, MS, MEng, MEd, MSW, MBA)"];
        [self.startThetas setObject:[NSNumber numberWithFloat:7.2] forKey:@"Professional degree (e.g. MD, DDS, DVM, LLB, JD)"];
        [self.startThetas setObject:[NSNumber numberWithFloat:5.8] forKey:@"Doctorate degree (PhD, EdD)"];
  }

-(id)initwithParameterDictionary :(NSMutableDictionary *) paramdictionary 
{
    if (self) {
        
        [self setstartThetas];
        
        self.ParameterDictionary = paramdictionary;
        _SE = 9.90;
        self.trace  = @"Engine has been initialized!";
        return self;
    }
    return nil;
}


-(NCSItem*) getItem :(NSString*) ID
{
    NCSItem* item = nil;
    
    if([self.ItemResponseList count] > 5){  //29){
        return nil;
    }
    
    for(int i = 0; i < _ItemList.count; i++){
        
        NCSItem *testItem = (NCSItem*)[_ItemList objectAtIndex:i];
        if([ID  isEqual: testItem.ID]){
            item = testItem;
        }

    }

    return item;
    
}

-(NSString *)getNextItem
{
    
    [self calculateItemVariance];
    
    
    double lowestVariance = 99.0;
    NSString *nextItem = @"";
 
    
    NSArray *keys = [self.ParameterDictionary allKeys ];
    for(int i = 0; i < keys.count; i++){
        NSString *formitemOID = [keys objectAtIndex:i];
        ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
        
        if(myItemCalibration.Variance < lowestVariance && myItemCalibration.Administered == FALSE){
            lowestVariance = myItemCalibration.Variance;
            
            nextItem = myItemCalibration.ItemID;
        }
    }
  /*
    for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {

        if(myItemCalibration.Variance < lowestVariance && myItemCalibration.Administered == FALSE){
            lowestVariance = myItemCalibration.Variance;
            
            nextItem = myItemCalibration.ItemID;
        }
    }
    */
    self.ItemID = nextItem;
    
    self.trace = [NSString stringWithFormat:@"%@",nextItem];
    
    return self.itemID;
    
}

-(void) calculateItemVariance{
    
    double defaultTargetProbabilityCorrect = 0.5;
    double NoiseRange =0.0;
    double ThetaTarget;
    
    ThetaTarget = self.Ability - log(defaultTargetProbabilityCorrect/(1-defaultTargetProbabilityCorrect));
    ThetaTarget = ThetaTarget + rand() * 2 * NoiseRange - NoiseRange;
    
    
    NSArray *keys = [self.ParameterDictionary allKeys ];
    for(int i = 0; i < keys.count; i++){
        NSString *formitemOID = [keys objectAtIndex:i];
        ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
       // NSLog(@" %f - %f", myItemCalibration.A_GRM ,ThetaTarget );
        myItemCalibration.Variance = ABS(myItemCalibration.A_GRM - ThetaTarget);
    }
    
    //for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {
     //   NSLog(@" %f - %f", myItemCalibration.A_GRM ,ThetaTarget );
     //   myItemCalibration.Variance = ABS(myItemCalibration.A_GRM - ThetaTarget);
      //  NSLog(@"My Item Variance is %f", myItemCalibration.Variance );
    //}
    
}

- (int) getCorrectAnswers
{
    
    int _rtn = 0;
    
    for (Result *myResult in self.ItemResponseList) {
        if( myResult.Answer == 1){
            _rtn += 1;
        }
    }
    
    
    return _rtn;
    
}

- (double) estimateTheta:(int)response responsetime:(double)responsetime
{
    double ThetaEst = self.Ability;
    
    
    int iteration =0;
    bool converged = false;
    
    int _MaxNumIterations = 30;
    double Convergence = 0.005;
    double MaxStepChange = 1.0;
    double MaxTheta = 99.0;
    double MinTheta = -99.0;
    
    
    Result *myResult = [[Result alloc] initWithName:self.itemID answer:response score:self.Ability se:self.SE responsetime:responsetime];

    [self.ItemResponseList addObject:myResult];
    
    int _correctAnswered = [self getCorrectAnswers];
    
    
    if(_correctAnswered == 0 ){
        
        
        self.Ability = self.Ability - MaxStepChange;
        
        if(self.Ability < MinTheta){
            self.Ability = MinTheta;
        }

        NSArray *keys = [self.ParameterDictionary allKeys ];
        for(int i = 0; i < keys.count; i++){
            NSString *formitemOID = [keys objectAtIndex:i];
            ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
            
            if([self.itemID isEqual: myItemCalibration.ItemID]){
                myItemCalibration.Administered = true;
            }
        }
        
        /*
        for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {
            if(self.itemID == myItemCalibration.ItemID){
                myItemCalibration.Administered = true;
            }
        }
        */
        
        //update this items scores
        int pos = [self.ItemResponseList count];
        
        ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).Score = self.Ability;
        ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).SE = self.SE;
        
        return self.Ability;
        
    }
    
    
    if(_correctAnswered == [self.ItemResponseList count]){
        
        self.Ability = self.Ability + MaxStepChange;
        
        if(self.Ability > MaxTheta){
            self.Ability = MaxTheta;
        }

        
        NSArray *keys = [self.ParameterDictionary allKeys ];
        for(int i = 0; i < keys.count; i++){
            NSString *formitemOID = [keys objectAtIndex:i];
            ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
            if([self.itemID isEqual: myItemCalibration.ItemID]){
                myItemCalibration.Administered = true;
            }
        }
        /*
        for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {
            if(self.itemID == myItemCalibration.ItemID){
                myItemCalibration.Administered = true;
            }
        }
        */
        
        //update this items scores
        int pos = [self.ItemResponseList count];
               
        ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).Score = self.Ability;
        ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).SE = self.SE;        
        
        return self.Ability;
        
    }
    
    double info = 0.0;
    
    do {
        double SumScore = 0.0;
        double SumProbability = 0.0;
        
        double Probability =0.0;
        
        for (int i=0 ; i < [self.ItemResponseList count]; i++) {
            
            NSString * ItemIndex =   ((Result*)[self.ItemResponseList objectAtIndex: i]).ItemID;
            
            int ResponseIndex = ((Result*)[self.ItemResponseList objectAtIndex: i]).Answer;
            
            // refactor to make controller access by key
            double Item_A_GRM = 0.0;

            NSArray *keys = [self.ParameterDictionary allKeys ];
            for(int i = 0; i < keys.count; i++){
                NSString *formitemOID = [keys objectAtIndex:i];
                ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
                if([ItemIndex isEqual: myItemCalibration.ItemID]){
                    Item_A_GRM = myItemCalibration.A_GRM;
                }
            }
            /*
            for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {
                if(ItemIndex == myItemCalibration.ItemID){
                    Item_A_GRM = myItemCalibration.A_GRM;
                }
            }
            */
            
            Probability = 1 / (1 + exp((-1) * (ThetaEst - Item_A_GRM )));
            info = info + Probability * (1 - Probability);
            SumScore = SumScore + ResponseIndex;
            SumProbability = SumProbability + Probability;
            
        }
        
        
        double change = (SumScore - SumProbability) / ((-1) * info);
        if (abs(change) <= Convergence) {
            converged = true;
        }
        if (abs(change) > MaxStepChange) {
            change = (change >= 0) ? MaxStepChange : ((-1) * MaxStepChange);
        }
        ThetaEst = ThetaEst - change;
        
        iteration++;
        
        
        
    } while ((iteration <= _MaxNumIterations) && (!converged));
    
    
    if (abs(ThetaEst - self.Ability) > MaxStepChange) {
        int sign = (ThetaEst - self.Ability < 0) ? -1 : 1;
        self.Ability = self.Ability + sign * MaxStepChange;
    }
    else {
        self.Ability = ThetaEst;
        self.SE =  1 / sqrt(info);
    }
    
    int pos = [self.ItemResponseList count];
    
    ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).Score = self.Ability;
    ((Result*)[self.ItemResponseList objectAtIndex: pos -1]).SE = self.SE;
 
    
    NSArray *keys = [self.ParameterDictionary allKeys ];
    for(int i = 0; i < keys.count; i++){
        NSString *formitemOID = [keys objectAtIndex:i];
        ItemCalibration *myItemCalibration = [self.ParameterDictionary objectForKey: formitemOID ];
        if([self.itemID isEqual: myItemCalibration.ItemID]){
            myItemCalibration.Administered = true;
        }
    }
    /*
    for (ItemCalibration *myItemCalibration in self.ParameterDictionary) {
        if(self.itemID == myItemCalibration.ItemID){
            myItemCalibration.Administered = true;
        }
    }
    */
    return ThetaEst;
    
}

-(NSArray *) processResponses: (NSArray *) responses responsetime:(double) responsetime{
    
    return nil;
    
}

- (NCSItem*) processResponse:(int)response
{
    
    
    
    NCSItem *myItem = [self getItem:self.itemID];
    myItem.ItemDataOID = [UUID generateUuidString];
    myItem.Position = [[NSNumber numberWithInt:[self.ItemResponseList count]] stringValue];
    
    
    int answer = 0;
    
    for(NCSElement* e in myItem.elements)
    {
        for(NCSMap* m in e.mappings)
        {
            if( [ m.Description isEqualToString:[[NSNumber numberWithInt:response] stringValue]] ){
                myItem.ItemResponseOID = m.ItemResponseOID;
                myItem.Response = m.Value;
                
                if ([m.Value isEqual:@"1"]){
                    answer = 1;
                }
                
                myItem.ResponseDescription = m.Description;
                break;
            }
        }
    }

    [self estimateTheta: answer responsetime:0.0];
    
    return myItem;
    
}
- (NCSItem*) processResponse:(int)response responsetime:(double)responsetime
{


    
    NCSItem *myItem = [self getItem:self.itemID];
    myItem.ItemDataOID = [UUID generateUuidString];
    myItem.Position = [[NSNumber numberWithInt:[self.ItemResponseList count]] stringValue];
 
    
    int answer = 0;
    
    for(NCSElement* e in myItem.elements)
    {
        for(NCSMap* m in e.mappings)
        {
            if( [ m.Value isEqualToString:[[NSNumber numberWithInt:response] stringValue]] ){
                myItem.ItemResponseOID = m.ItemResponseOID;
                myItem.Response = m.Value;
                
                if ([m.Value isEqual:@"1"]){
                    answer = 1;
                }
                
                myItem.ResponseDescription = m.Description;
                break;
            }
        }
    }

    [self estimateTheta: answer responsetime:responsetime ];
    return myItem;
    
}

-(void) getResults
{
    for (Result *myResult in self.ItemResponseList) {
        NSLog(@"%@  : %i : %f  : %f : %f",  myResult.ItemID, myResult.Answer,myResult.Score, myResult.SE, myResult.ResponseTime );
    } 
    
}

-(NSArray *)ResultSetList{

    return [self.ItemResponseList copy];
}
@end

