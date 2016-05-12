//
//  CategoryChangeVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "WMMGCategory.h"

//#import "DetailVC.h"

@class DetailVC;


@protocol CategoryChangeDelegate <NSObject>

-(void) categoryChangeDidSave : (NSString *) changedCategoryName;

-(void) categoryChangeDidCancel;

@end


@interface CategoryChangeVC : UITableViewController

@property (nonatomic, weak) id <CategoryChangeDelegate> delegate;


@property (nonatomic, weak) WMMGCategory *thisCategory;

@property (nonatomic, weak) WMMGCategory *selectedCategory;


@end
