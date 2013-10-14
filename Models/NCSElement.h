//
//  NCSElement.h
//  NIHToolboxCognition
//
//  Created by Bass, Michael on 8/21/12.
//
//

#import <Foundation/Foundation.h>

@interface NCSElement : NSObject

@property (nonatomic, retain) NSString* ElementOID;
@property (nonatomic, retain) NSString* Description;
@property (nonatomic, retain) NSString* ElementOrder;
@property (nonatomic, retain) NSString* ElementType;
@property (nonatomic, retain) NSMutableArray* resources;
@property (nonatomic, retain) NSMutableArray* mappings;

- (int) getNumResources;
- (int) getNumMappings;

@end
