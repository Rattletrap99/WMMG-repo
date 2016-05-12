//
//  AddCategoryVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/19/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMMGCategory.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>


//#import "AddTransactionVC.h"

@class CatSelectTVC;


// Delegate for this protocol is AddTransactionVC

@protocol AddCategoryDelegate <NSObject>

-(void) addCategoryDidSave : (WMMGCategory *) brandNewCategory;

-(void) addCategoryDidCancel;

@end




@interface AddCategoryVC : UIViewController



@property (nonatomic, weak) id <AddCategoryDelegate> delegate;

@property (nonatomic, weak) WMMGCategory *brandNewCategory;

@property (weak, nonatomic) IBOutlet UITextField *nooCatTextField;



@end
