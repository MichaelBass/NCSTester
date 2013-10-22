//
//  NCSViewController.h
//  NCSImagesTest
//
//  Created by Alexander Holden on 4/1/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCSViewController : UIViewController
{
    NSMutableArray* imageNamesArray;
    NSMutableArray* imagesArray;
    NSMutableArray* landingBoxesArray;
    NSMutableArray* emptyLandingBoxesArray;
}

@property (weak, nonatomic) IBOutlet UIImageView *launchpadView;

- (IBAction)onImageBox:(id)sender;

@end
 