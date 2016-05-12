//
//  NewAccountVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 3/1/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMGAccount.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@class AccountSelectVC;

// Delegate for this protocol is AccountSelectVC

@protocol NewAccountDelegate <NSObject>

-(void) addAccountDidSave : (WMMGAccount *) brandNewAccount;

-(void) addAccountDidCancel;

@end



@interface NewAccountVC : UIViewController

@property (nonatomic, weak) id <NewAccountDelegate> delegate;

@property (nonatomic, weak) WMMGAccount *brandNewAccount;



@property (weak, nonatomic) IBOutlet UITextField *nooAccountTextField;
//@property (nonatomic, weak) NSString *nooAccountName;

@property (weak, nonatomic) IBOutlet UITextField *openingBalanceTextField;

@end
