//
//  ViewControllerNavigation.h
//  NCSTester
//
//  Created by Bass, Michael on 10/3/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ViewControllerNavigationDelegate <NSObject>
- (void) transitionViewController;
@end
