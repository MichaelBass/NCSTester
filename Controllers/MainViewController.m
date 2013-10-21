//
//  MainViewController.m
//  NCSTester
//
//  Created by Bass, Michael on 10/2/13.
//  Copyright (c) 2013 MSS. All rights reserved.
//

#import "MainViewController.h"
#import "GraphView.h"
#import "DCCSViewController.h"

#import "NCSCoreDataManager.h"
#import "CDUser.h"
#import "CDAssesement.h"
#import "CDTest.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.educationArray = [[NSArray alloc] initWithObjects:@"none", @"preschool", @"kindergarten", @"1st grade", @"2nd grade", @"3rd grade", @"4th grade", @"5th grade", @"6th grade", @"7th grade", @"8th grade", @"9th grade", @"10th grade", @"11th grade", @"12th grade (no diploma)",@"High School Graduate", @"GED", @"Some college credit but less than1 year", @"One or more years of college, no degree", @"Associates degree (AA, AS)", @"Bachelor's degree (BA, AB, BS)", @"Masters degree (MA, MS, MEng, MEd, MSW, MBA)", @"Professional degree (e.g. MD, DDS, DVM, LLB, JD)", @"Doctorate degree (PhD, EdD)", nil];

     self.languageArray  = [[NSArray alloc] initWithObjects:@"Engish",@"Spanish", nil];
 
     self.instrumentDefinitions  = [[NSArray alloc] initWithObjects:@"DCCS",@"Flanker",@"Picture Vocabulary Practice",@"Picture Vocabulary", nil];

    self.selectedInstruments = [[NSMutableArray alloc] initWithCapacity:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - ViewControllerNavigation Delegate -
- (void) transitionViewController{}

-(IBAction)onStartButton:(id)sender
{

   // [[NCSCoreDataManager sharedInstance] addUser:@"test01" dob:@"4/10/1997" education:@"11th grade" language:@"English"];
    
   //CDUser* user = [[NCSCoreDataManager sharedInstance] getUserByID:@"0F2092CD-1EA1-4321-A145-0CFCFF63A61D"];
  
    //CDUser* user = [[NCSCoreDataManager sharedInstance] getUserByID:@"test01"];
    
    /*
    if(user != nil){
        NSLog(@"Who am I: %@",user.uuID);
        NSLog(@"How many forms will I take %d", [self.selectedInstruments count] );
    }
    
    for(NSString* sInstrumentName in [self.selectedInstruments copy])
    {
        NSLog(@"I will take these forms: %@",sInstrumentName);
    }
    */
    
    //CDAssesement* assessment = [[NCSCoreDataManager sharedInstance] addAssesement:[self.selectedInstruments copy] user:user];
    
   // NSLog(@"This is the assessment: %@",assessment.id);
    NSArray* tests =  [[NCSCoreDataManager sharedInstance] getTestsByAssesementID:@"B584C3C9-E0DA-4C0F-901D-EA0030D00D66"];
    
    self.selectedTests = tests;
    

    //DCCSViewController *newC = [[DCCSViewController alloc] init];
    
 //[self.parent starttransitiontoViewController: self oldC:self newC:newC];
}

# pragma mark - UIPicker View Delegate/Datasource -
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
  
    if(pickerView.tag == 0){
        return 24;
    }
    else{
        return 2;
    }
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
 
    if(pickerView.tag == 0){
        return [self.educationArray objectAtIndex:row];
    }
    else{
       return [self.languageArray objectAtIndex:row];
    }

    
}


#pragma mark - Table View Delegate/Datasource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.instrumentDefinitions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:16];
        cell.textLabel.text = @"Unavailable";
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    

    NSString* sName = [self.instrumentDefinitions objectAtIndex:indexPath.row];
    cell.textLabel.text = sName;
        
        if([self.selectedInstruments containsObject:sName]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSString* sName = [self.instrumentDefinitions objectAtIndex:indexPath.row];
    
    [self.selectedInstruments addObject:sName];

    [self.tableView reloadData];
}

@end
