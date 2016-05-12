//
//  AddMoneyPopVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 4/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewController;



@protocol AddMoneyPopVCDelegate <NSObject>

-(void) moneyAddedSave : (NSDecimalNumber *) amountToAdd;

-(void) moneyAddedCancel;

@end



@interface AddMoneyPopVC : UIViewController

@property (nonatomic, weak) id <AddMoneyPopVCDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *addedMoneyAmount;

@property (strong, nonatomic) NSDecimalNumber *moneyAdded;

@end
