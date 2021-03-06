//
//  DCCSView.m
//  NCSTester
//
//  Created by Bass, Michael on 10/16/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "DCCSView.h"

#import "ProgressiveSectionalEngine.h"
#import "DCCSDataParser.h"

@interface DCCSView ()
@property (weak, nonatomic) IBOutlet UILabel *animationinstructionLabel;
@property (weak, nonatomic) IBOutlet UIView *continueButtonContainer;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIButton *leftImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIButton *rightImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIImageView *starImage;

@property (nonatomic, retain) NSString* instructionSound;

@end

@implementation DCCSView

#define NCS_DEMO_ITEM_ID        @"xsl/DCCS_Practice.xsl"

BOOL bGoToNextStep;
BOOL elementOrderZero;
CGRect starImgPosition;
BOOL bFlashBorderLeft;
BOOL bFlashBorderRight;

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
        
        //DCCSDataParser* parser = [[DCCSDataParser alloc] init];
        //NSMutableArray* rtn = [[NSMutableArray alloc] initWithCapacity:1];
        //[parser loadData:rtn params:nil];

        //super.itemList = rtn;
        super.itemList = [DCCSDataParser parseFormFile];
    }
    return [super itemList];
    
}

- (id<Engine>)engine
{
    if (![super engine]) {
        DCCSDataParser* parser = [[DCCSDataParser alloc] init];
        NSMutableDictionary* paramList = [[NSMutableDictionary alloc] init];
        [parser loadData:nil params:paramList];
        
        super.engine = (id<Engine>)[[ProgressiveSectionalEngine alloc] initwithParameterDictionary:paramList];
    }
    
    return [super engine];
}

-(void) hideInstructions{
    
    self.continueButtonContainer.hidden = YES;
    self.continueButton.hidden = YES;
    self.instructionLabel.alpha = 0;
    self.instructionLabel.hidden = YES;
    //self.starImage.hidden = YES;
    
}
-(void) displayInstructions{
    
    self.continueButtonContainer.hidden = NO;
    self.continueButton.hidden = NO;
    self.instructionLabel.alpha = 1;
    self.instructionLabel.hidden = NO;
    //self.starImage.hidden = YES;
    
}
-(void) hideDCCS{
    self.leftImageButton.hidden= YES;
    self.rightImageButton.hidden= YES;
    self.leftImage.hidden = YES;
    self.rightImage.hidden = YES;
    self.topImage.hidden = YES;
    
    self.leftImage.image = nil;
    self.rightImage.image = nil;
    
    self.rightImageButton.layer.borderColor = [UIColor clearColor].CGColor;
    self.leftImageButton.layer.borderColor = [UIColor clearColor].CGColor;
}
-(void) displayDCCS{
    
    self.leftImageButton.hidden= NO;
    self.rightImageButton.hidden= NO;
    self.leftImage.hidden = NO;
    self.rightImage.hidden = NO;
    self.topImage.hidden = NO;
}

-(void) displayDCCSButtons{
    
    self.leftImageButton.hidden= NO;
    self.rightImageButton.hidden= NO;
    self.leftImage.hidden = NO;
    self.rightImage.hidden = NO;
}

-(void) clearScreen{
    
    [self hideDCCS];
    [self hideInstructions];
    
    elementOrderZero = NO;
    self.animationinstructionLabel.text = @"";
    
}

- (void) displayItem: (NCSItem*) item
{

    int iImagesFound = 0;
    [self clearScreen];
    
    
    // Determine the elements and resources in the item
    if(item.elements.count)
    {
        if([item getResourceCount])
        {
            for(NCSElement* e in item.elements)
            {
                if([e.ElementType isEqualToString:NCS_ELEMENT_TYPE_STEM] || [e.ElementType isEqualToString:NCS_ELEMENT_TYPE_LBL])
                {
                    for(NCSResource* r in e.resources)
                    {
                        // Look for the text resource and show text on screen
                        if([r.Type isEqualToString:NCS_RESOURCE_TEXT])
                        {
                            [self parseTextResource:r];
                            
                            // if the element order is zero then the item is 'animated'
                            if([e.ElementOrder isEqualToString:@"0"]){
                                self.animationinstructionLabel.text = r.Description;
                                elementOrderZero = YES;
                            }
                        }
                        if([r.Type isEqualToString:NCS_RESOURCE_SOUND])
                        {
                            self.instructionSound = [NSString stringWithString: r.Description];
                        }
                        // the top image to show
                        if([r.Type isEqualToString:NCS_RESOURCE_IMAGE])
                        {
                            [self parseImageResource:r];
                            
                        }
                    }
                }
                
                // Look for images to be displayed for this step
                for(NCSMap* m in e.mappings)
                {
                    iImagesFound += [self parseResources: m];
                }
            }
        }
        [self renderScreen: iImagesFound];
        
        [self beginAnimation];
        
    }
}

-(void) beginAnimation{
    
    // If element order 0 wasnt found continue as usual
    
    if(elementOrderZero == NO)
    {
        if(self.leftImage.image){
            [self animateStarAppear];
        }
    }else {
        [self animateCorrectAnswer];
    }
    
    
}

-(void) animateCorrectAnswer{
    
    /*
     Animate the correct answer for user.
     Animation will stop when user selects the correct answer.
     
     */
    
    // Enable only the correct button
    if(self.leftImageButton.tag == 1)
    {
        self.rightImageButton.enabled = NO;
        self.leftImageButton.enabled = YES;
        bFlashBorderLeft = YES;
        [self animateLeftBorderFlashing:self.leftImageButton];
    }
    else if(self.rightImageButton.tag == 1)
    {
        self.leftImageButton.enabled = NO;
        self.rightImageButton.enabled = YES;
        bFlashBorderRight = YES;
        [self animateRightBorderFlashing:self.rightImageButton];
    }
    
    if(responseTimer != nil)
        [responseTimer invalidate];
}

-(void) renderScreen:(int) iImagesFound{
    
    self.leftImageButton.enabled = YES;
    self.rightImageButton.enabled = YES;
    
    // Enable buttons only if we found all three images
    if(iImagesFound > 1 && elementOrderZero == YES){
        [self displayDCCS];
    }
    
    if(iImagesFound == 0){
        [self displayInstructions];
    }
    
}

-(void) parseTextResource: (NCSResource*) resource
{
    // Identify this special instruction text because we need to display a star next to it
    if ([resource.Description rangeOfString:@"Keep your eyes on the star."].location != NSNotFound)
    {
        //self.starImage.frame = CGRectMake(720, self.instructionLabel.frame.origin.y - 15, self.starImage.frame.size.width, self.starImage.frame.size.height);
        //self.starImage.hidden = NO;
        //self.starImage.alpha = 1;
        self.instructionLabel.text = [resource.Description stringByReplacingOccurrencesOfString:@"Keep your eyes on the star." withString:@"Keep your eyes on the star.\n"];
    }
    else{
        
        self.instructionLabel.text = resource.Description;
        
    }
}

-(void) parseImageResource: (NCSResource*) resource
{
    resource.Description = [resource.Description stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
    self.topImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", resource.Description]];
    
}

- (int) parseResources: (NCSMap* ) map
{
    
    /*
     Loop through all the resources and look for image ones.
     Assign the navigation images based on the map.description (i.e. 1 or 0)
     */
    
    
    int rtn = 0;
    
    for(NCSResource* r in map.resources)
    {
        if([r.Type isEqualToString:NCS_RESOURCE_IMAGE])
        {
            if([map.Value isEqualToString:@"1"])
            {
                r.Description = [r.Description stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                self.leftImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", r.Description]];
                self.leftImageButton.tag = [map.Description intValue];
            }
            else
            {
                r.Description = [r.Description stringByReplacingOccurrencesOfString:@".jpg" withString:@""];
                self.rightImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", r.Description]];
                self.rightImageButton.tag = [map.Description intValue];
            }
            ++rtn;
        }
    }
    
    
    return rtn;
    
}


#pragma mark - Animations -

- (void) animateStarAppear
{
    
    self.leftImageButton.enabled = NO;
    self.rightImageButton.enabled = NO;
    [self displayDCCSButtons];
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
         self.leftImageButton.enabled = YES;
         self.rightImageButton.enabled = YES;
         [self displayDCCS];
         
         // Start response timer
         responseTimeStart = [NSDate date];
         
         if(responseTimer != nil)
             [responseTimer invalidate];
         
         // Do not start the timer for practice steps
         if([self.item.StyleSheet isEqualToString:NCS_DEMO_ITEM_ID] == NO)
             responseTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(responseTimeInterval:) userInfo:nil repeats:YES];
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

/*
- (void)setItem:(NCSItem *)item
{
    [super setItem:item];
    //
    if(item == nil){
        [self.delegate executeTestCompleted];
        return;
    }
    [self performSelector:@selector(setNextItem) withObject:nil afterDelay:0.5];
    
}
*/


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
    
    
    self.rightImageButton.enabled = NO;
    self.leftImageButton.enabled = NO;
    
    [self recordResponse: btn.tag];
    
    bGoToNextStep = YES;
    
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 3.5f;
    
    bFlashBorderLeft = NO;
    bFlashBorderRight = NO;
    bGoToNextStep = NO;
    
}



@end
