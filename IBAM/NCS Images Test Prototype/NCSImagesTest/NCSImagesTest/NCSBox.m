//
//  NCSBox.m
//  NCSImagesTest
//
//  Created by Alexander Holden on 4/1/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "NCSBox.h"

#define AXE_ROTATION_MIN        -0.17
#define AXE_ROTATION_MAX        0.17
#define AXE_ROTATION_MAX_DELAY  2
#define AXE_ROTATION_SPEED      0.2

@implementation NCSBox

@synthesize bSelected;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)rotateBox
{
    if([self randomInt] == 0)
        [self rotateObjectLeft];
    else
        [self rotateObjectRight];
}
- (int) randomInt
{
    return arc4random() % 2;
}

float randomFloat(float Min, float Max)
{
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(Max-Min)+Min;
}

- (void) rotateObjectRight
{
    //double d = randomFloat(0, AXE_ROTATION_MAX_DELAY);
    double rAngle = randomFloat(AXE_ROTATION_MIN, AXE_ROTATION_MAX);
    
    [UIView animateWithDuration:AXE_ROTATION_SPEED delay:0 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^(void)
     {
         self.transform = CGAffineTransformMakeRotation(rAngle);
     }
    completion:^(BOOL finished)
     {
    
     }];
}

- (void) rotateObjectLeft
{
    //double d = randomFloat(0, AXE_ROTATION_MAX_DELAY);
    double rAngle = randomFloat(AXE_ROTATION_MIN, AXE_ROTATION_MAX);
    
    [UIView animateWithDuration:AXE_ROTATION_SPEED delay:0 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut animations:^(void)
     {
         self.transform = CGAffineTransformMakeRotation(rAngle);
     }
    completion:^(BOOL finished)
     {
    
     }];
}


@end
