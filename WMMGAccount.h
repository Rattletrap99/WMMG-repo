//
//  WMMGAccount.h
//  
//
//  Created by Tim Jones on 8/11/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class WMMGTransaction;

@interface WMMGAccount : NSManagedObject

@property (nonatomic, retain) NSDecimalNumber * balance;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * replenishedDate;
@property (nonatomic, retain) NSDecimalNumber * currentHighWaterBalance;
@property (nonatomic, retain) NSSet *toTransactions;
@end

@interface WMMGAccount (CoreDataGeneratedAccessors)

- (void)addToTransactionsObject:(WMMGTransaction *)value;
- (void)removeToTransactionsObject:(WMMGTransaction *)value;
- (void)addToTransactions:(NSSet *)values;
- (void)removeToTransactions:(NSSet *)values;

@end
