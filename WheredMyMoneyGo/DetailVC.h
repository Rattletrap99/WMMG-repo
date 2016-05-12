//
//  DetailVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "WMMGTransaction.h"
#import "WMMGAccount.h"

#import "DescriptionChangeVC.h"
#import "AmountChangePopVC.h"
#import "AccountChangeVC.h"
#import "CatSelectTVC.h"
#import "WMMGAccount.h"


@class SecondViewController;

@protocol DetailVCDelegate <NSObject>

-(void) detailVCDidSave : (WMMGTransaction *) editedTransaction : (WMMGAccount *) account;
-(void) detailVCDidCancel;
-(void) detailVCDidDeleteTransaction : (WMMGTransaction *) transToDelete : (WMMGAccount *) accountWithChangedBalance;

@end




@interface DetailVC : UIViewController <DescriptionChangeDelegate,AmountChangeDelegate,AccountChangeDelegate,SelectedCategoryDelegate,UIPopoverPresentationControllerDelegate>

@property (strong,nonatomic) CustomCell *thisCustomCell;

@property (strong,nonatomic) WMMGTransaction *detailTransaction;

@property (strong,nonatomic) WMMGAccount *thisAccount;

@property (nonatomic, weak) id <DetailVCDelegate> delegate;


#pragma mark - Labels

@property (weak, nonatomic) IBOutlet UILabel *transTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *transImageWell;



#pragma mark - Buttons

@property (weak, nonatomic) IBOutlet UIButton *descButton;

@property (weak, nonatomic) IBOutlet UIButton *amountButton;

@property (weak, nonatomic) IBOutlet UIButton *acctButton;

@property (weak, nonatomic) IBOutlet UIButton *catButton;


@property (weak, nonatomic) IBOutlet UIButton *deleteTransButton;



@end











