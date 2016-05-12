//
//  AddCategoryVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/19/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AddCategoryVC.h"
#import "WMMGCategory.h"

@interface AddCategoryVC ()


@end


@implementation AddCategoryVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nooCatTextField.autocorrectionType = UITextAutocorrectionTypeNo;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveCategory:(UIBarButtonItem *)sender
{
    if (self.nooCatTextField.text.length < 1)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New category not identified"
                                                        message:@"Please enter a name for the new category or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        self.brandNewCategory = [WMMGCategory MR_createEntity];
        self.brandNewCategory.name = [self.nooCatTextField.text uppercaseString];
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        [localContext MR_saveToPersistentStoreAndWait];

        
        [self.delegate addCategoryDidSave:self.brandNewCategory];
    }
}

- (IBAction)cancelCategory:(UIBarButtonItem *)sender
{
    [self.delegate addCategoryDidCancel];
}


@end
