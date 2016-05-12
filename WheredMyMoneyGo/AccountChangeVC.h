//
//  AccountChangeVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMMGAccount.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>


//#import "DetailVC.h"

@class DetailVC;


@protocol AccountChangeDelegate <NSObject>

-(void) accountChangeDidSave : (NSString *) changedAccountName;

-(void) accountChangeDidCancel;

@end


@interface AccountChangeVC : UITableViewController

@property (nonatomic, weak) id <AccountChangeDelegate> delegate;

@property (nonatomic, weak) WMMGAccount *thisAccount;

@property (nonatomic, weak) WMMGAccount *selectedAccount;


@end
