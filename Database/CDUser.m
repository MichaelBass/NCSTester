//
//  CDUser.m
//  NCS
//  Copyright (c) 2013 NCS. All rights reserved.
//

#import "CDUser.h"
#import "CDAssesement.h"


@implementation CDUser

@dynamic uuID;
@dynamic dob;
@dynamic educationLevel;
@dynamic language;
@dynamic ncsID;
@dynamic assesement;

- (int)getUserAge
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    NSDate *date1 = [dateFormatter dateFromString:self.dob];
    NSDate *date2 = [NSDate date]; // Should produce today's date
    
    NSTimeInterval diff = [date2 timeIntervalSinceDate:date1];
    
    return (diff / 31536000);
}


@end
