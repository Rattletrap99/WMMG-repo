//
//  SecondViewController.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/5/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "CustomCell.h"
#import "WMMGTransaction.h"
#import "WMMGAccount.h"
#import "DetailVC.h"
#import <FastttCamera.h>

#import <AVFoundation/AVFoundation.h>

@interface SecondViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,DetailVCDelegate>

@property (strong,nonatomic) CustomCell *thisCustomCell;


@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;

@property (strong, nonatomic) WMMGAccount *currentAccount;

@property (strong, nonatomic) WMMGTransaction *transactionOfInterest;

@property (weak, nonatomic) IBOutlet UITableView *myTableview;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;







@end

