//
//  ViewController.h
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

@interface ViewController : UIViewController<TestViewDelegate>

@property (strong, nonatomic) NSDictionary *data;

- (id)initWithData:(NSDictionary *)data;

- (void)initWithDebugData;

- (void)initWithMetaData: (NSArray*)instruments userid:(NSString*)userid dob:(NSString*)sDOB education:(NSString*)sEducation language:(NSString*)sLanguage;

@end
