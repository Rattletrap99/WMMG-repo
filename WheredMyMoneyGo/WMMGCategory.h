//
//  WMMGCategory.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/15/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WMMGCategory : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *toTransactions;
@end

@interface WMMGCategory (CoreDataGeneratedAccessors)

- (void)addToTransactionsObject:(NSManagedObject *)value;
- (void)removeToTransactionsObject:(NSManagedObject *)value;
- (void)addToTransactions:(NSSet *)values;
- (void)removeToTransactions:(NSSet *)values;

@end
