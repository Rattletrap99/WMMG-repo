//
//  SnapPicViewController.h
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 4/18/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CameraSessionView.h"
#import "WMMGTransaction.h"

@class AddTransactionVC;



@protocol snapPicDelegate <NSObject>

-(void) picSnapped : (WMMGTransaction *) transactionWithPic;
-(void) cameraCancelled;

@end



@interface SnapPicViewController : UIViewController

//@property (nonatomic, strong) CameraSessionView *cameraView;

@property (nonatomic, strong) WMMGTransaction *thisTransaction;

@property (nonatomic, weak) id <snapPicDelegate> delegate;


@end
