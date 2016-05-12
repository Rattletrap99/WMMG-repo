//
//  DescriptionChangeVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "DescriptionChangeVC.h"

@interface DescriptionChangeVC ()

@end

@implementation DescriptionChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.descriptionChangedTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveDescChange:(UIBarButtonItem *)sender
{
    if (self.descriptionChangedTextField.text.length > 0)
    {
        [self.delegate descriptionChangeDidSave : self.descriptionChangedTextField.text];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No description entered"
                                                        message:@"Please enter a a description or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    
}


- (IBAction)cancelDescChange:(UIBarButtonItem *)sender
{
    [self.delegate descriptionChangeDidCancel];
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
