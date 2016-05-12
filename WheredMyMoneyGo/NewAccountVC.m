//
//  NewAccountVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 3/1/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "NewAccountVC.h"

@interface NewAccountVC ()

@end

@implementation NewAccountVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nooAccountTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveAccount:(UIBarButtonItem *)sender

{
    if (self.nooAccountTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New account not identified"
                                                        message:@"Please enter a name for the new account or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else if (self.openingBalanceTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No opening balance specified"
                                                        message:@"Please enter an opening for the new account or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    
    else
    {
        self.brandNewAccount = [WMMGAccount MR_createEntity];
        self.brandNewAccount.name = [self.nooAccountTextField.text uppercaseString];
        
        self.brandNewAccount.balance = [NSDecimalNumber decimalNumberWithString:self.openingBalanceTextField.text];
        self.brandNewAccount.currentHighWaterBalance = self.brandNewAccount.balance;
        [self.delegate addAccountDidSave:self.brandNewAccount];
    }
}



- (IBAction)cancelNewAccount:(UIBarButtonItem *)sender
{
    
    [self.delegate addAccountDidCancel];

}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
