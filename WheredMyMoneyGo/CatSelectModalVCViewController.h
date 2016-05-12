//
//  CatSelectModalVCViewController.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/15/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "WMMGCategory.h"

@class AddTransactionVC;

//Delegate for this protocol is AddTransactionVC

@protocol SelectedCategoryDelegate <NSObject>

-(void) categorySelectedDidSave : (NSString *) selectedCategory;
-(void) categorySelectedDidCancel;

@end



@interface CatSelectModalVCViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *catSelectTableview;

@property (nonatomic, weak) WMMGCategory *thisCategory;

@property (nonatomic, weak) id <SelectedCategoryDelegate> catSelectDelegate;

@property (nonatomic, weak) NSString * selectedCategory;
@end
