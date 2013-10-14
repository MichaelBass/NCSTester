//
//  BaseView.h
//  NCSTester
//
//  Created by Bass, Michael on 10/12/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TestViewDelegate;


@interface BaseView : UIView

@property (weak, nonatomic) id <TestViewDelegate> delegate;
-(IBAction)onStartFormButton:(id)sender;

@end

@protocol TestViewDelegate
@required
- (void)testViewDidFinish:(UIView *)view;
@end
