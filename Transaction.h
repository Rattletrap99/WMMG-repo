//
//  Transaction.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/9/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Transaction : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSDecimalNumber * amount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * forWhat;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * paidTo;
@property (nonatomic, retain) NSString * picPath;
@property (nonatomic, retain) NSDate * transDate;
@property (nonatomic, retain) Account *toAccount;

@end
