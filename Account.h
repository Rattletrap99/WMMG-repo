//
//  Account.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/9/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Transaction;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *toTransactions;
@end

@interface Account (CoreDataGeneratedAccessors)

- (void)addToTransactionsObject:(Transaction *)value;
- (void)removeToTransactionsObject:(Transaction *)value;
- (void)addToTransactions:(NSSet *)values;
- (void)removeToTransactions:(NSSet *)values;

@end
