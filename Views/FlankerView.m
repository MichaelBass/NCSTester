//
//  Flanker.m
//  NCSTester
//
//  Created by Bass, Michael on 10/18/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "FlankerView.h"

#import "ProgressiveSectionalEngine.h"
#import "FlankerDataParser.h"

@interface FlankerView()

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;
@property (weak, nonatomic) IBOutlet UIView *continueButtonContainer;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

// Flanker UI Elelments
@property (weak, nonatomic) IBOutlet UIView *flankerTestView;
@property (weak, nonatomic) IBOutlet UIImageView *flankerImage1;
@property (weak, nonatomic) IBOutlet UIImageView *flankerImage2;
@property (weak, nonatomic) IBOutlet UIImageView *flankerImage3;
@property (weak, nonatomic) IBOutlet UIImageView *flankerImage4;
@property (weak, nonatomic) IBOutlet UIImageView *flankerImage5;
@property (weak, nonatomic) IBOutlet UIButton *flankerLeftButton;
@property (weak, nonatomic) IBOutlet UIButton *flankerRightButton;

- (IBAction)onContinueButton:(id)sender;
- (IBAction)onImageButton:(id)sender;

@property (nonatomic, retain) NSString* instructionSound;

@end

@implementation FlankerView

BOOL bGoToNextStep;
BOOL elementOrderZero;
CGRect starImgPosition;
BOOL bFlashBorderLeft;
BOOL bFlashBorderRight;

NSMutableArray* flankerImages;
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
        
        //FlankerDataParser* parser = [[FlankerDataParser alloc] init];
        //NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
        //[parser loadData:rtn params:nil];
        
        //super.itemList = rtn;
        super.itemList = [FlankerDataParser parseFormFile];
        
        
    }
    return [super itemList];
    
}

- (id<Engine>)engine
{
    if (![super engine]) {
        FlankerDataParser* parser = [[FlankerDataParser alloc] init];
        NSMutableDictionary* paramList = [[NSMutableDictionary alloc] init];
        [parser loadData:nil params:paramList];
        
        super.engine = (id<Engine>)[[ProgressiveSectionalEngine alloc] initwithParameterDictionary:paramList];
    }
    
    return [super engine];
}


-(void) hideInstructions{
    
    self.continueButtonContainer.hidden = YES;
    self.continueButton.hidden = YES;
    self.flankerLeftButton.hidden = YES;
    self.flankerRightButton.hidden = YES;
    self.instructionLabel.alpha = 0;
    self.instructionLabel.hidden = YES;
    self.starImage.hidden = YES;
    
}
-(void) displayInstructions{
    
    self.continueButtonContainer.hidden = NO;
    self.continueButton.hidden = NO;
    self.flankerLeftButton.hidden = YES;
    self.flankerRightButton.hidden = YES;
    self.instructionLabel.alpha = 1;
    self.instructionLabel.hidden = NO;
    self.starImage.hidden = YES;
    
}
-(void) hideFlanker{
    self.flankerImage1.hidden= YES;
    self.flankerImage2.hidden= YES;
    self.flankerImage3.hidden= YES;
    self.flankerImage4.hidden= YES;
    self.flankerImage5.hidden= YES;
}
-(void) displayFlanker{
    
    self.flankerImage1.hidden= NO;
    self.flankerImage2.hidden= NO;
    self.flankerImage3.hidden= NO;
    self.flankerImage4.hidden= NO;
    self.flankerImage5.hidden= NO;
    self.flankerRightButton.hidden= NO;
    self.flankerLeftButton.hidden= NO;
    
}
- (void) displayItem: (NCSItem*) item
{
    
    self.flankerRightButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.flankerLeftButton.layer.borderColor = [UIColor clearColor].CGColor;
    
    [self hideFlanker];
    [self hideInstructions];
    self.starImage.hidden = YES;
    self.starImage.image = [UIImage imageNamed:@"star-white.jpg"];
    
    
    if(flankerImages == nil)
        flankerImages = [[NSMutableArray alloc] initWithObjects:self.flankerImage1, self.flankerImage2, self.flankerImage3, self.flankerImage4, self.flankerImage5, nil];
    
    int iNumFlankerImage = 0;
    
    // Determine the elements and resources in the item
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
                        if([r.Type isEqualToString:NCS_RESOURCE_TEXT] && elementOrderZero != YES)
                        {
                            // Identify this special instruction text because we need to display a star next to it
                            if ([r.Description rangeOfString:@"Keep your eyes on the star."].location != NSNotFound)
                            {
                                self.starImage.frame = CGRectMake(820, self.instructionLabel.frame.origin.y - 15, self.starImage.frame.size.width, self.starImage.frame.size.height);
                                
                                
                                self.starImage.hidden = NO;
                                self.starImage.alpha = 1;
                                self.instructionLabel.text = [r.Description stringByReplacingOccurrencesOfString:@"Keep your eyes on the star." withString:@"Keep your eyes on the star.\n"];
                            }
                            else
                                self.instructionLabel.text = r.Description;
                            
                            if([e.ElementOrder isEqualToString:@"0"])
                                elementOrderZero = YES;
                        }
                        else if([r.Type isEqualToString:NCS_RESOURCE_SOUND])
                        {
                            self.instructionSound = [NSString stringWithString: r.Description];
                        }
                        // the top image to show
                        else if([r.Type isEqualToString:NCS_RESOURCE_IMAGE])
                        {
                            r.Description = [r.Description stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                            UIImageView* imgView = [flankerImages objectAtIndex:iNumFlankerImage];
                            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", r.Description]];
                            ++iNumFlankerImage;
                        }
                    }
                }
                else if([e.ElementType isEqualToString:NCS_ELEMENT_TYPE_RESP])
                {
                    // Currently nothing is used within response element node
                }
                
                // Look for images to be displayed for this step
                for(NCSMap* m in e.mappings)
                {
                    for(NCSResource* r in m.resources)
                    {
                        if([r.Type isEqualToString:NCS_RESOURCE_TEXT])
                        {
                            if([r.Description isEqualToString:@"Left"])
                                self.flankerLeftButton.tag = [m.Description intValue];
                            else
                                self.flankerRightButton.tag = [m.Description intValue];
                        }
                    }
                }
            }
        }
    }
    
    if(iNumFlankerImage)
    {
        self.continueButtonContainer.hidden = YES;
        self.continueButton.hidden = YES;
        self.flankerLeftButton.hidden = NO;
        self.flankerRightButton.hidden = NO;
        
        if(self.instructionSound == nil || self.instructionSound.length == 0)
            self.instructionSound = @"Middle";
        
        [self animateStarAppear];
    }
    else
    {
        [self displayInstructions];
        
        self.continueButtonContainer.hidden = NO;
        self.continueButton.hidden = NO;
        self.flankerLeftButton.hidden = YES;
        self.flankerRightButton.hidden = YES;
        self.instructionLabel.alpha = 1;
        self.instructionLabel.hidden = NO;
        self.starImage.hidden = YES;
    }
    
    //[super playSound:soundFile];
    
}


- (void)recordResponse: (int) responseIndex
{
    NSDate* responseTimeEnd = [NSDate date];
    NSTimeInterval dateDiff = [responseTimeEnd timeIntervalSinceDate:responseTimeStart];
    
    [self.delegate processResponse:responseIndex responsetime:dateDiff];
    
}



- (void)responseTimeInterval:(NSTimer *)timer
{
    if(iResponseTimeInterval > 9)
    {
        if(responseTimer != nil)
        {
            [self invalidateResponseTimer];
        }
        
        // User failed to respond on time, move test along
        //[self.delegate setNextItem];
    }
    else
        ++iResponseTimeInterval;
}

- (void) invalidateResponseTimer
{
    if(responseTimer == nil)
        return;
    
    [responseTimer invalidate];
    responseTimer = nil;
    iResponseTimeInterval = 0;
}



- (IBAction)onContinueButton:(id)sender
{
    [self recordResponse: -1];
}


- (IBAction)onImageButton:(id)sender
{
    [self invalidateResponseTimer];
    
    UIButton* btn = (UIButton*)sender;
    btn.enabled = NO;
    
    
    self.flankerRightButton.enabled = NO;
    self.flankerLeftButton.enabled = NO;
    
    [self recordResponse: btn.tag];
    
    bGoToNextStep = YES;
    
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 3.5f;
    
    bFlashBorderLeft = NO;
    bFlashBorderRight = NO;
    bGoToNextStep = NO;
    
}


#pragma mark - Animations -

- (void) animateStarAppear
{
    
    self.flankerLeftButton.enabled = NO;
    self.flankerRightButton.enabled = NO;
    
    self.starImage.alpha = 0;
    self.starImage.hidden = NO;
    
    [UIView animateWithDuration:0.2 delay:0.8 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
     {
         self.starImage.alpha = 1;
     }
                     completion:^(BOOL finished)
     {
         [self animateInstructionLabelAppear];
     }];
}

- (void) animateInstructionLabelAppear
{
    
    self.instructionLabel.hidden = NO;
    
    [UIView animateWithDuration:0.2 delay:1 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
     {
         self.starImage.alpha = 0;
         self.instructionLabel.alpha = 1;
     }
                     completion:^(BOOL finished)
     {
         [super playSound:self.instructionSound];
         [self animateTopImageAppear];
     }];
}

- (void) animateTopImageAppear
{
    [UIView animateWithDuration:0.2 delay:1 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
     
        {
            self.instructionLabel.alpha = 0;
        }
        completion:^(BOOL finished)
        {
         self.flankerLeftButton.enabled = YES;
         self.flankerRightButton.enabled = YES;
         [self displayFlanker];
         
         // Start response timer
         responseTimeStart = [NSDate date];
         
         if(responseTimer != nil)
             [responseTimer invalidate];
         
         // Do not start the timer for practice steps
        
         //if([self.item.StyleSheet isEqualToString:NCS_DEMO_ITEM_ID] == NO)
          //   responseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(responseTimeInterval:) userInfo:nil repeats:YES];
    }];
    
 
    
}

- (void) animateLeftBorderFlashing:(UIButton*) btn
{
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 3.5f;
    
    if(bFlashBorderLeft == YES)
        [self performSelector:@selector(animateLeftBorderFlashingOff:) withObject:btn afterDelay:1];
}

- (void) animateRightBorderFlashing:(UIButton*) btn
{
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 3.5f;
    
    if(bFlashBorderRight == YES)
        [self performSelector:@selector(animateRightBorderFlashingOff:) withObject:btn afterDelay:1];
}

- (void) animateLeftBorderFlashingOff:(UIButton*) btn
{
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    btn.layer.borderWidth = 0;
    
    if(bFlashBorderLeft == YES)
        [self performSelector:@selector(animateLeftBorderFlashing:) withObject:btn afterDelay:0.5];
}

- (void) animateRightBorderFlashingOff:(UIButton*) btn
{
    btn.layer.borderColor = [UIColor clearColor].CGColor;
    btn.layer.borderWidth = 0;
    
    if(bFlashBorderRight == YES)
        [self performSelector:@selector(animateRightBorderFlashing:) withObject:btn afterDelay:0.5];
}


@end
