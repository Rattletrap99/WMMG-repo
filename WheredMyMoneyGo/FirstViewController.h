//
//  FirstViewController.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/5/15.
//  Copyright (c) 2015 Tim Jones. All rig   hts reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "AddTransactionVC.h"

#import "WMMGTransaction.h"
#import "WMMGAccount.h"
#import "WMMGCategory.h"
#import "AccountSelectVC.h"
#import "AddMoneyPopVC.h"


@interface FirstViewController : UIViewController <AddTransactionViewControllerDelegate,AccountSelectDelegate,AddMoneyPopVCDelegate,UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cashOnHandLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentAcctLabel;
@property (weak, nonatomic) IBOutlet UILabel *chwbLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startBalHtConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *animBalHtConstraint;


@property (weak, nonatomic) IBOutlet UIView *buttonBoxView;




@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *nooTransButton;

@property (weak, nonatomic) IBOutlet UIButton *viewTransactionsButton;

@property (weak, nonatomic) IBOutlet UIButton *addMoneyButton;

@property (weak, nonatomic) IBOutlet UIButton *nooAccountButton;


@property (weak, nonatomic) IBOutlet UIView *backgroundBar;

@property (weak, nonatomic) IBOutlet UIView *balanceBar;


@property (weak, nonatomic) WMMGTransaction *depositTransaction;

@property (weak, nonatomic) AddTransactionVC *addTransVC;
@property (weak, nonatomic) AccountSelectVC *selectAccountVC;

@property (weak, nonatomic) NSDate *moneyAddedDate;


@property BOOL refreshHWB;



@property (nonatomic, weak) id <AddTransactionViewControllerDelegate> delegate;

@property (strong, nonatomic) WMMGAccount *currentAccount;
@property (strong, nonatomic) NSString *currentAccountName;
@property (strong, nonatomic) NSDecimalNumber *accountBalanceBeforeTrans;


@end

