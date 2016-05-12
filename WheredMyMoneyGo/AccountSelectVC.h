//
//  AccountSelectVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 3/1/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMGAccount.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "NewAccountVC.h"

@class FirstViewController;


// First VC is the delegate for this protocol

@protocol AccountSelectDelegate <NSObject>

-(void) accountSelectVCDidSave : (WMMGAccount *) selectedAccount;

-(void) accountSelectVCDidCancel;

@end




@interface AccountSelectVC : UIViewController <UIPopoverPresentationControllerDelegate,UITableViewDataSource,UITableViewDelegate,NewAccountDelegate>


//@property (weak, nonatomic) IBOutlet UIButton *createAccountButton;

@property (nonatomic, weak) id <AccountSelectDelegate> delegate;

@property (nonatomic, weak) WMMGAccount *selectedAccount;

@property (weak, nonatomic) IBOutlet UITableView *myTableview;


@end
