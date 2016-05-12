//
//  DescriptionChangeVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import       "DetailVC.h"

@class DetailVC;

@protocol DescriptionChangeDelegate <NSObject>

-(void) descriptionChangeDidSave : (NSString *) changedDescription;

-(void) descriptionChangeDidCancel;

@end




@interface DescriptionChangeVC : UIViewController

@property (nonatomic, weak) id <DescriptionChangeDelegate> delegate;


@property (weak, nonatomic) IBOutlet UITextField *descriptionChangedTextField;


@end
