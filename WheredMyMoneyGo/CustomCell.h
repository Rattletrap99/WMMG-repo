//
//  CustomCell.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "WMMGTransaction.h"

@interface CustomCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *catLabel;
@property (weak, nonatomic) IBOutlet UILabel *paidToLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointBalanceLabel;



@property (strong, nonatomic) NSDate *rawTransDate;

//@property (strong, nonatomic) NSManagedObjectID *thisObjectID;

@property (strong, nonatomic) WMMGTransaction *transactionForThisCell;


@property (weak, nonatomic) IBOutlet UIImageView *snapThumbView;

@end
