//
//  AddTransactionVC.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>

#import "WMMGTransaction.h"
#import "AddCategoryVC.h"

#import "WMMGCategory.h"
#import "CatSelectTVC.h"

#import "WMMGAccount.h"

#import <AVFoundation/AVFoundation.h>
#import <FastttCamera.h>



@class FirstViewController;

// Del   egate for this protocol is FirstViewController


@protocol AddTransactionViewControllerDelegate <NSObject>

-(void) addTransactionViewControllerDidSave : (WMMGTransaction *) newTransaction;

-(void) addTransactionViewControllerDidCancel : (WMMGTransaction *) transactionToDelete;

@end


@interface AddTransactionVC : UIViewController <UIPopoverPresentationControllerDelegate,FastttCameraDelegate,UITextFieldDelegate>

@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;



@property (weak, nonatomic) IBOutlet UITextField *amountField;
@property (weak, nonatomic) IBOutlet UITextField *payeeField;

@property (weak, nonatomic) IBOutlet UITextField *forWhatField;
@property (weak, nonatomic) IBOutlet UIImageView *imageWell;
@property (weak, nonatomic) UIButton *selCatButton;

@property (nonatomic, weak) id <AddTransactionViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

@property (strong, nonatomic) WMMGAccount *prevailingAccount;

@property (strong, nonatomic) WMMGTransaction *thisTransaction;

@property (weak, nonatomic) IBOutlet UIImageView *viewFinder;


@property (nonatomic, strong) FastttCamera *fastCamera;


@property (weak, nonatomic) IBOutlet UIButton *shutterButton;







//@property (nonatomic, strong) CameraSessionView *cameraView;



//@property (strong, nonatomic) FirstViewController *fvcProxy;


@end
