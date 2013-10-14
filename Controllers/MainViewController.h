//
//  MainViewController.h
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ViewControllerNavigation.h"

#import "BaseViewController.h"

@interface MainViewController : UIViewController<ViewControllerNavigationDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDataSource, UITableViewDelegate>
-(IBAction)onStartButton:(id)sender;


@property (strong, nonatomic) IBOutlet UITextField *UserID;
@property (strong, nonatomic) IBOutlet UIPickerView *education;
@property (strong, nonatomic)          NSArray *educationArray;

@property (strong, nonatomic) IBOutlet UIPickerView *language;
@property (strong, nonatomic)          NSArray *languageArray;

@property (nonatomic, retain) NSArray* instrumentDefinitions;
@property (nonatomic, retain) NSMutableArray* selectedInstruments;
@property (nonatomic, retain) NSArray* selectedTests;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ViewController *parent;

@end
