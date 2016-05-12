//
//  AmountChangePopVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AmountChangePopVC.h"

@interface AmountChangePopVC ()

@end

@implementation AmountChangePopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAmountChange:(UIBarButtonItem *)sender
{
//    NSString *amountText;
    
    if (self.amountChangeTextField.text.length > 0)
    {
        [self.delegate amountChangeDidSave : self.amountChangeTextField.text];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No amount entered"
                                                        message:@"Please enter an amount or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    

}


- (IBAction)cancelAmountChange:(UIBarButtonItem *)sender
{
    [self.delegate amountChangeDidCancel];
}

@end
