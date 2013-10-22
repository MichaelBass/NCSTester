//
//  NCSViewController.m
//  NCSImagesTest
//
//  Created by Alexander Holden on 4/1/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NCSViewController.h"
#import "NCSBox.h"

@interface NCSViewController ()

@end

@implementation NCSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    imageNamesArray = [[NSMutableArray alloc] initWithCapacity:18];
    
    [imageNamesArray addObject:@"baby.png"];
    [imageNamesArray addObject:@"ball.png"];
    [imageNamesArray addObject:@"butterfly.png"];
    [imageNamesArray addObject:@"catch.png"];
    [imageNamesArray addObject:@"dog.png"];
    [imageNamesArray addObject:@"feed the ducks.png"];
    [imageNamesArray addObject:@"flower.png"];
    [imageNamesArray addObject:@"get the duck food.png"];
    [imageNamesArray addObject:@"kite.png"];
    [imageNamesArray addObject:@"lay out the blanket.png"];
    [imageNamesArray addObject:@"monkey bars.png"];
    [imageNamesArray addObject:@"Open the basket.png"];
    [imageNamesArray addObject:@"put a coin in the dispenser.png"];
    [imageNamesArray addObject:@"Read a book.png"];
    [imageNamesArray addObject:@"Ride the bike.png"];
    [imageNamesArray addObject:@"Row the boat.png"];
    [imageNamesArray addObject:@"sandbox.png"];
    [imageNamesArray addObject:@"sidewalk.png"];
    
    imagesArray = [[NSMutableArray alloc] initWithCapacity:18];
    landingBoxesArray = [[NSMutableArray alloc] initWithCapacity:18];
    emptyLandingBoxesArray = [[NSMutableArray alloc] initWithCapacity:18];
    
    // Left Landing Zones
    for(int i = 0; i < 6; ++i)
    {
        [self addLandingBox:20 yCoord:14 + (100 * i) tag:i];
    }
    
    // Right Landing Zones
    for(int i = 0; i < 6; ++i)
    {
        [self addLandingBox:894 yCoord:14 + (100 * i) tag:10 + i];
    }

    // Center Landing Zones
    for(int i = 0; i < 6; ++i)
    {
        [self addLandingBox:145 + (125 * i) yCoord:633 tag:20 + i];
    }
    
    // First row image boxes
    for(int i = 0; i < 4; ++i)
    {
        [self addImageBox:174 + (190 * i) yCoord:35 imageIndex:i tag:i];
    }

    // second row image boxes
    for(int i = 0; i < 4; ++i)
    {
        [self addImageBox:174 + (190 * i) yCoord:156 imageIndex:4 + i tag:10 + i];
    }
    
    // third row image boxes
    for(int i = 0; i < 4; ++i)
    {
        [self addImageBox:174 + (190 * i) yCoord:271 imageIndex:8 + i tag:2 + i];
    }
    
    // fourth row image boxes
    for(int i = 0; i < 4; ++i)
    {
        [self addImageBox:174 + (190 * i) yCoord:387 imageIndex:12 + i tag:3 + i];
    }
    
    // fifth row image boxes
    for(int i = 0; i < 2; ++i)
    {
        [self addImageBox:365 + (190 * i) yCoord:505 imageIndex:16 + i tag:4 + i];
    }
}

- (void)addLandingBox:(int)XCoord yCoord:(int)YCoord tag:(int)iTag
{
    NCSBox* box = [[NCSBox alloc] init];
    [box setImage:[UIImage imageNamed:@"DropZone.png"] forState:UIControlStateNormal];
    box.tag = iTag;
    box.frame = CGRectMake(XCoord, YCoord, 110, 85);
    [box addTarget:self action:@selector(onLandingBox:) forControlEvents:UIControlEventTouchUpInside];
    [landingBoxesArray addObject:box];
    [self.view addSubview:box];

}

- (void)addImageBox:(int)XCoord yCoord:(int)YCoord imageIndex:(int)iImageIndex tag:(int)iTag
{
    NCSBox* emptybox = [[NCSBox alloc] init];
    [emptybox setImage:[UIImage imageNamed:@"DropZone.png"] forState:UIControlStateNormal];
    emptybox.tag = iTag;
    [emptybox addTarget:self action:@selector(onEmptyImageBox:) forControlEvents:UIControlEventTouchUpInside];
    emptybox.frame = CGRectMake(XCoord, YCoord, 110, 85);
    [emptyLandingBoxesArray addObject:emptybox];
    [self.view addSubview:emptybox];
    
    NCSBox* box = [[NCSBox alloc] init];
    [box setImage:[UIImage imageNamed:[imageNamesArray objectAtIndex:iImageIndex]] forState:UIControlStateNormal];
    box.tag = iTag;
    [box addTarget:self action:@selector(onImageBox:) forControlEvents:UIControlEventTouchUpInside];
    box.frame = CGRectMake(XCoord, YCoord, 110, 85);
    
    [imagesArray addObject:box];
    [self.view addSubview:box];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Box Management -

- (void)selectBox:(NCSBox*) box
{
    [self animateBoxSelection:box];
}

- (void)unselectBox:(NCSBox*) box
{
    box.frame = CGRectMake(box.frame.origin.x + 5, box.frame.origin.y + 5, 110, 85);
    box.layer.borderColor = [UIColor clearColor].CGColor;
    box.layer.borderWidth = 0;
    box.bSelected = NO;
}

- (void)unselectAllBoxes: (NSArray*)boxesArray
{
    for(NCSBox* box in boxesArray)
    {
        if(box.bSelected == YES)
        {
            [self unselectBox:box];
        }
    }
}

- (void)moveImageToLandingBox
{
    // Locate selected image box and selected landing box
    for(NCSBox* imgBox in imagesArray)
    {
        if(imgBox.bSelected)
        {
            for(NCSBox* landingBox in landingBoxesArray)
            {
                if(landingBox.bSelected)
                {
                    [self animateBoxMove:imgBox moveToBox:landingBox];
                    return;
                }
            }
        }
    }
}

- (void)moveImageFromLandingBox
{
    // Locate selected image box and selected landing box
    for(NCSBox* imgBox in imagesArray)
    {
        if(imgBox.bSelected)
        {
            for(NCSBox* landingBox in emptyLandingBoxesArray)
            {
                if(landingBox.bSelected)
                {
                    [self animateBoxMove:imgBox moveToBox:landingBox];
                    return;
                }
            }
        }
    }
}

#pragma mark - Action Handles -

- (void)onLandingBox:(id)sender
{
    [self unselectAllBoxes: landingBoxesArray];
    
    NCSBox* box = (NCSBox*)sender;
    
    if(box.bSelected == NO)
    {
        [self selectBox:box];
        [self moveImageToLandingBox];
        [self unselectAllBoxes:emptyLandingBoxesArray];
    }
    else
    {
        [self unselectBox:box];
    }
}

- (void)onEmptyImageBox:(id)sender
{
    [self unselectAllBoxes: emptyLandingBoxesArray];
    
    NCSBox* box = (NCSBox*)sender;
    
    if(box.bSelected == NO)
    {
        [self selectBox:box];
        [self moveImageFromLandingBox];
        [self unselectAllBoxes:landingBoxesArray];
    }
    else
    {
        [self unselectBox:box];
    }
}

- (IBAction)onImageBox:(id)sender
{
    [self unselectAllBoxes: imagesArray];
    
    NCSBox* box = (NCSBox*)sender;
 
    [box removeFromSuperview];
    [self.view addSubview:box];
    
    if(box.bSelected == NO)
    {
        [self selectBox:box];
        [self unselectAllBoxes:landingBoxesArray];
        [self unselectAllBoxes:emptyLandingBoxesArray];
    }
    else
    {
        [self unselectBox:box];
    }
}

#pragma mark - Animations -

- (void) animateBoxSelection:(NCSBox*) box
{
    [UIView animateWithDuration:0.2 delay:0 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
     {
         box.frame = CGRectMake(box.frame.origin.x - 10, box.frame.origin.y - 10, box.frame.size.width + 20, box.frame.size.height + 20);
         box.layer.borderColor = [UIColor redColor].CGColor;
         box.layer.borderWidth = 3.5f;
         box.bSelected = YES;
     }
    completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 delay:0 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
          {
              box.frame = CGRectMake(box.frame.origin.x + 5, box.frame.origin.y + 5, box.frame.size.width - 10, box.frame.size.height - 10);
          }
        completion:^(BOOL finished)
          {
              
          }];
     }];
}

- (void) animateBoxMove:(NCSBox*) box moveToBox:(NCSBox*) moveToBox
{
    [UIView animateWithDuration:0.4 delay:0 options: UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn animations:^(void)
     {
         box.frame = CGRectMake(moveToBox.frame.origin.x + 5, moveToBox.frame.origin.y + 5, 110, 85);
     }
    completion:^(BOOL finished)
     {
         [self unselectAllBoxes:imagesArray];
         [self unselectAllBoxes:landingBoxesArray];
         [self unselectAllBoxes:emptyLandingBoxesArray];
     }];
}

@end
