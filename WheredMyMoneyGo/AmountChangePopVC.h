//
//  AmountChangePopVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "DetailVC.h"

@class DetailVC;


@protocol AmountChangeDelegate <NSObject>

-(void) amountChangeDidSave : (NSString *) changedAmount;

-(void) amountChangeDidCancel;

@end



@interface AmountChangePopVC : UIViewController

@property (nonatomic, weak) id <AmountChangeDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *amountChangeTextField;


@end
