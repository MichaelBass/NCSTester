//
//  IBAMView.m
//  NCSTester
//
//  Created by Bass, Michael on 10/22/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "IBAMView.h"
#import "ProgressiveSectionalEngine2.h"
#import "IBAMParser.h"

@interface IBAMView()
@property (weak, nonatomic) IBOutlet UILabel *itemLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *score;
@property (weak, nonatomic) IBOutlet UITextField *sequence;
@end

@implementation IBAMView

NSDate* responseTimeStart;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (NSMutableArray*) itemList{
    
    if(![super itemList]){

        
        
        IBAMParser* parser = [[IBAMParser alloc] init];
        NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
        [parser loadData:rtn params:nil];
        
        super.itemList = rtn;
        
        //IBAMParser* parser = [[IBAMParser alloc] init];
        //NSMutableDictionary* paramList = [[NSMutableDictionary alloc] init];
        //[parser loadData:nil params:paramList];
        
        //super.itemList = [IBAMParser parseFormFile];
        
    }
    return [super itemList];
    
}

- (id<Engine>)engine
{
    if (![super engine]) {
        IBAMParser* parser = [[IBAMParser alloc] init];
        NSMutableDictionary* paramList = [[NSMutableDictionary alloc] init];
        [parser loadData:nil params:paramList];
        
        super.engine = (id<Engine>)[[ProgressiveSectionalEngine2 alloc] initwithParameterDictionary:paramList];
    }
    
    return [super engine];
}


- (void) displayItems: (NSArray*) items
{
   
    self.items = items;
    self.itemLabel.text = ((NCSItem*) [items objectAtIndex:0]).ID;
    
    // Start response timer
    responseTimeStart = [NSDate date];
}


- (void)recordResponses: (NSArray *) responses
{
    NSDate* responseTimeEnd = [NSDate date];
    NSTimeInterval dateDiff = [responseTimeEnd timeIntervalSinceDate:responseTimeStart];
    
    [self.delegate processResponses:responses responsetime:dateDiff];
    
}

- (IBAction)onContinueButton:(id)sender
{
    NSArray* responses = @[self.score.text, self.sequence.text];
    NSLog(@"Here are the responses %d", responses.count);
    
    //NCSItem* i in responses
    
    [self recordResponses: self.items];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
