//
//  WMMGTransaction.h
//  
//
//  Created by Tim Jones on 7/28/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WMMGAccount, WMMGCategory;

@interface WMMGTransaction : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * forWhat;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * paidTo;
@property (nonatomic, retain) NSString * picPath;
@property (nonatomic, retain) NSDate * sortDate;
@property (nonatomic, retain) NSDate * transDate;
@property (nonatomic, retain) NSDecimalNumber * pointBalance;
@property (nonatomic, retain) WMMGAccount *toAccount;
@property (nonatomic, retain) WMMGCategory *toCategory;

@end
