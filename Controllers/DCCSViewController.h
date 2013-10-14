//
//  DCCSViewController.h
//  NCS
//
//  Created by Bass, Michael on 9/25/13.
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DCCSViewController : BaseViewController
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


@end
