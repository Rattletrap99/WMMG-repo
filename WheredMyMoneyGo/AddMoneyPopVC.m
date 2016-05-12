//
//  AddMoneyPopVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 4/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AddMoneyPopVC.h"

@interface AddMoneyPopVC ()

@end

@implementation AddMoneyPopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.addedMoneyAmount.autocorrectionType = UITextAutocorrectionTypeNo;

    // Do any additional setup after loading the view.
}

- (IBAction)saveMoney:(UIBarButtonItem *)sender
{
    if (self.addedMoneyAmount.text.length > 0)
    {
        self.moneyAdded = [NSDecimalNumber decimalNumberWithString:self.addedMoneyAmount.text];
        [self.delegate moneyAddedSave:self.moneyAdded];
    }
    
    else
    {
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No amount entered"
                                                            message:@"Please enter an amount or cancel"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (IBAction)cancelMoney:(UIBarButtonItem *)sender
{
    [self.delegate moneyAddedCancel];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
