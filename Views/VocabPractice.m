//
//  VocabPractice.m
//  NCSTester
//
//  Created by Bass, Michael on 10/18/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "VocabPractice.h"

#import "SequenceEngine.h"
#import "PracticeVocabParser.h"

@interface VocabPractice()

// Vocabulary Test Elements
@property (weak, nonatomic) IBOutlet UIImageView *vocabImageBottomLeft;
@property (weak, nonatomic) IBOutlet UIImageView *vocabImageBottomRight;
@property (weak, nonatomic) IBOutlet UIImageView *vocabImageUpperLeft;
@property (weak, nonatomic) IBOutlet UIImageView *vocabImageUpperRight;

@property (weak, nonatomic) IBOutlet UIButton *vocabButtonBottomLeft;
@property (weak, nonatomic) IBOutlet UIButton *vocabButtonBottomRight;
@property (weak, nonatomic) IBOutlet UIButton *vocabButtonUpperLeft;
@property (weak, nonatomic) IBOutlet UIButton *vocabButtonUpperRight;
@property (weak, nonatomic) IBOutlet UIButton *vocabButtonBack;
@property (weak, nonatomic) IBOutlet UIButton *vocabButtonPlayAgain;

@end


@implementation VocabPractice


NSDate* responseTimeStart;
NSString* soundFile;
NSTimer* responseTimer;
int iResponseTimeInterval;

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
        
       // PracticeVocabParser* parser = [[PracticeVocabParser alloc] init];
       // NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
       // [parser loadData:rtn params:nil];
        
        super.itemList = [PracticeVocabParser parseFormFile];
        
        //super.itemList = rtn;
    }
    return [super itemList];
    
}

- (id<Engine>)engine
{
    if (![super engine]) {
        PracticeVocabParser* parser = [[PracticeVocabParser alloc] init];
        NSMutableDictionary* paramList = [[NSMutableDictionary alloc] init];
        [parser loadData:nil params:paramList];
        
        super.engine = (id<Engine>)[[SequenceEngine alloc] initwithParameterDictionary:paramList];
    }
    
    return [super engine];
}


- (void) displayItem: (NCSItem*) item
{
    self.vocabButtonUpperLeft.layer.borderColor = [UIColor clearColor].CGColor;
    self.vocabButtonUpperRight.layer.borderColor = [UIColor clearColor].CGColor;
    self.vocabButtonBottomLeft.layer.borderColor = [UIColor clearColor].CGColor;
    self.vocabButtonBottomRight.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    if(item.elements.count)
    {
        if([item getResourceCount])
        {
            for(NCSElement* e in item.elements)
            {
                if([e.ElementType isEqualToString:NCS_ELEMENT_TYPE_STEM] || [e.ElementType isEqualToString:NCS_ELEMENT_TYPE_CTX])
                {
                    for(NCSResource* r in e.resources)
                    {
                        // Look for the text resource and show text on screen
                        if([r.Type isEqualToString:NCS_RESOURCE_TEXT])
                        {
                            soundFile = [NSString stringWithString:r.Description];
                        }
                    }
                }
                
                for(NCSMap* m in e.mappings)
                {
                    for(NCSResource* r in m.resources)
                    {
                        
                        if([r.Type isEqualToString:NCS_RESOURCE_TEXT])
                        {
                            
                            
                            NSString* sImageName = [NSString stringWithFormat:@"%@.jpg", r.Description];
                            
                            UIImage* img = [UIImage imageNamed:sImageName];
                            float imgWidth = img.size.width;
                            float imgHeight = img.size.height;
                            float xPos = (self.frame.size.width - ((imgWidth * 2) + 10)) / 2;
                            
                            if([m.Position isEqualToString:@"1"])
                            {
                                self.vocabImageUpperLeft.image = img;
                                self.vocabImageUpperLeft.frame = CGRectMake(xPos, self.vocabImageUpperLeft.frame.origin.y, imgWidth, imgHeight);
                                self.vocabButtonUpperLeft.frame = self.vocabImageUpperLeft.frame;
                                self.vocabButtonUpperLeft.tag = [m.Value intValue];
                                
                                
                            }
                            else if([m.Position isEqualToString:@"2"])
                            {
                                self.vocabImageUpperRight.image = img;
                                self.vocabImageUpperRight.frame = CGRectMake(self.vocabImageUpperLeft.frame.origin.x + self.vocabImageUpperLeft.frame.size.width + 10, self.vocabImageUpperRight.frame.origin.y, imgWidth, imgHeight);
                                self.vocabButtonUpperRight.frame = self.vocabImageUpperRight.frame;
                                self.vocabButtonUpperRight.tag = [m.Value intValue];
                            }
                            else if([m.Position isEqualToString:@"3"])
                            {
                                self.vocabImageBottomLeft.image = img;
                                self.vocabImageBottomLeft.frame = CGRectMake(xPos, self.vocabImageBottomLeft.frame.origin.y, imgWidth, imgHeight);
                                self.vocabButtonBottomLeft.frame = self.vocabImageBottomLeft.frame;
                                self.vocabButtonBottomLeft.tag = [m.Value intValue];
                            }
                            else if([m.Position isEqualToString:@"4"])
                            {
                                self.vocabImageBottomRight.image = img;
                                self.vocabImageBottomRight.frame = CGRectMake(self.vocabImageBottomLeft.frame.origin.x + self.vocabImageBottomLeft.frame.size.width + 10, self.vocabImageBottomRight.frame.origin.y, imgWidth, imgHeight);
                                self.vocabButtonBottomRight.frame = self.vocabImageBottomRight.frame;
                                self.vocabButtonBottomRight.tag = [m.Value intValue];
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    // Start response timer
    responseTimeStart = [NSDate date];
    [super playSound:soundFile];
    
    
}

#pragma mark - Action Handlers Vocab Test -

- (IBAction)onVocabTestBackButton:(id)sender
{
    
}

- (IBAction)onVocabTestPlayAgainButton:(id)sender
{
    //[self toggleControlButtons:YES];
    [super playSound:soundFile];
}

- (IBAction)onVocabButtonTap:(UIButton*)sender
{
    UIButton* btn = (UIButton*)sender;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 3.5f;
    
    [self recordResponse: btn.tag];
    
}


- (void)recordResponse: (int) responseIndex
{
    NSDate* responseTimeEnd = [NSDate date];
    NSTimeInterval dateDiff = [responseTimeEnd timeIntervalSinceDate:responseTimeStart];
    
    [self.delegate processResponse:responseIndex responsetime:dateDiff];
    
}


@end

