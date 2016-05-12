//
//  DetailVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "DetailVC.h"

@interface DetailVC ()

@end


UINavigationController *thisNavController;
NSFetchedResultsController *accountsFRC;



BOOL amountWasChanged = NO;
NSDecimalNumber *originalTransAmount;
NSDecimalNumber *changedTransAmount;
NSDecimalNumber *transactionDelta;

double deltaForNewAccount;


@implementation DetailVC

NSString *originalAccountName;
NSString *switchedAccountName;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    NSString *formattedDateString = [dateFormatter stringFromDate:self.detailTransaction.transDate];
    
    NSNumber *invertedAmount = [NSNumber numberWithDouble:fabs([self.detailTransaction.amount doubleValue])];
    
    NSString *transAmountString = [NSNumberFormatter
                                localizedStringFromNumber:invertedAmount
                                numberStyle:NSNumberFormatterCurrencyStyle];
    
    [self.acctButton setUserInteractionEnabled:YES];
    [self.descButton setUserInteractionEnabled:YES];
    [self.amountButton setUserInteractionEnabled:YES];
    [self.catButton setUserInteractionEnabled:YES];
    
    [self.deleteTransButton.layer setCornerRadius:12.0f];
    self.deleteTransButton.layer.borderWidth = 2.0f;
    self.deleteTransButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];


    
    accountsFRC = [WMMGAccount MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];

    for (WMMGAccount *account in accountsFRC.fetchedObjects)
    {
        if ([account.name isEqualToString:self.detailTransaction.account])
        {
            self.thisAccount = account;
            originalAccountName = account.name;
        }
    }
    
    self.transTimeLabel.text = formattedDateString;
    
    if (self.detailTransaction.paidTo)
    {
        self.descriptionLabel.text = self.detailTransaction.paidTo; // Need to change this attribute from paidTo to description
    }
    
    self.amountLabel.text = transAmountString;
    
    NSLog(@"1 self.detailTransaction.amount = %@",self.detailTransaction.amount);

    
    originalTransAmount = self.detailTransaction.amount;
    
    

    self.accountLabel.text = self.detailTransaction.account;

    self.categoryLabel.text = self.detailTransaction.category;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:self.detailTransaction.picPath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    

    [self.transImageWell setImage:image];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Prepare for segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"descriptionPopSegue"])
    {

        UIViewController *controller = segue.destinationViewController;
        controller.popoverPresentationController.delegate = self;
        controller.preferredContentSize = CGSizeMake(320, 186);
        
        thisNavController = (UINavigationController *)segue.destinationViewController;
        DescriptionChangeVC *dcVC = (DescriptionChangeVC *)thisNavController.topViewController;
        dcVC.delegate = self;
    }
    
    else if ([[segue identifier] isEqualToString:@"AmountPopSegue"])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.popoverPresentationController.delegate = self;
        controller.preferredContentSize = CGSizeMake(320, 186);
        
        thisNavController = (UINavigationController *)segue.destinationViewController;
        AmountChangePopVC *acVC = (AmountChangePopVC *)thisNavController.topViewController;
        acVC.delegate = self;
    }
    
    else if ([[segue identifier] isEqualToString:@"AccountPopSegue"])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.popoverPresentationController.delegate = self;
        controller.preferredContentSize = CGSizeMake(320, 186);
        
        thisNavController = (UINavigationController *)segue.destinationViewController;
        AccountChangeVC *acCVC = (AccountChangeVC *)thisNavController.topViewController;
        acCVC.delegate = self;
    }
    
    else if ([[segue identifier] isEqualToString:@"CategoryPopSegue"])
    {
        UIViewController *controller = segue.destinationViewController;
        controller.popoverPresentationController.delegate = self;
        controller.preferredContentSize = CGSizeMake(320, 186);
        
        thisNavController = (UINavigationController *)segue.destinationViewController;
        CatSelectTVC *catCVC = (CatSelectTVC *)thisNavController.topViewController;
        catCVC.delegate = self;
    }
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Description change delegate methods

-(void) descriptionChangeDidSave : (NSString *) changedDescription
{
    self.descriptionLabel.text = changedDescription;
    [thisNavController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.descriptionLabel.text.length > 0)
    {
        self.detailTransaction.paidTo = self.descriptionLabel.text; //Establishes change in desc, if any
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No description associated with this transaction"
                                                        message:@"Please enter a description"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    //Establishes change in desc, if any
//    self.detailTransaction.paidTo = self.descriptionLabel.text;

    
    [self.descButton setUserInteractionEnabled:NO];
    [self.amountButton setUserInteractionEnabled:NO];
    [self.acctButton setUserInteractionEnabled:NO];
    [self.catButton setUserInteractionEnabled:NO];
}

-(void) descriptionChangeDidCancel
{
    [thisNavController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Amount change delegate methods

-(void) amountChangeDidSave:(NSString *)changedAmount
{
    if (changedAmount == nil)
    {
        [thisNavController dismissViewControllerAnimated:YES completion:nil];
    }
    
    else
    {
        
        self.amountLabel.text = changedAmount;
        
        changedTransAmount = [NSDecimalNumber decimalNumberWithString : changedAmount];
        
        NSLog(@"2 self.detailTransaction.amount = %@",self.detailTransaction.amount);

        NSLog(@"changedAmount = %@",changedAmount);
        NSLog(@"changedTransAmount = %@",changedTransAmount);

        //Establishes change in amount, if any
        transactionDelta = [[self detailTransAmtAbsVal:self.detailTransaction.amount] decimalNumberBySubtracting:changedTransAmount];
        
        
        NSLog(@"transactionDelta = %@",transactionDelta);
        
        self.detailTransaction.amount = changedTransAmount;

        NSLog(@"self.detailTransaction.amount = %@",self.detailTransaction.amount);


        self.thisAccount.balance = [self.thisAccount.balance decimalNumberByAdding: transactionDelta];
        
        NSLog(@"* self.thisAccount.balance = %@",self.thisAccount.balance);

        [self.descButton setUserInteractionEnabled:NO];
        [self.amountButton setUserInteractionEnabled:NO];
        [self.acctButton setUserInteractionEnabled:NO];
        [self.catButton setUserInteractionEnabled:NO];

        
        
        
        NSLog(@"3 detailTransaction.amount is %@",self.detailTransaction.amount);
        
        // Inverts the transaction amount
        
//        NSDecimalNumber * invertedMultiplier = [NSDecimalNumber decimalNumberWithString:@"-1"];
        
//        self.thisTransaction.amount = [self.thisTransaction.amount decimalNumberByMultiplyingBy:invertedMultiplier];
        
//        Figure this out.

        
        
        
    }
    
    [thisNavController dismissViewControllerAnimated:YES completion:nil];

}

-(void) amountChangeDidCancel
{
    [thisNavController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Account change delegate methods

-(void) accountChangeDidSave:(NSString *)changedAccountName
{
    self.accountLabel.text = changedAccountName; //This is a NSSTring
    
    // Transfer self.detailTransaction to account that matches the label
    self.detailTransaction.account = self.accountLabel.text;
    
    self.detailTransaction.amount = [self detailTransAmtAbsVal:self.detailTransaction.amount];
    
    
    // Adjust the balance in both accounts
    // Get both accounts via FRC
    
    for (WMMGAccount *accountInQuestion in accountsFRC.fetchedObjects)
    {
        if ([accountInQuestion.name isEqualToString:originalAccountName])
        {
            NSLog(@"self.detailTransaction.amount = %@",self.detailTransaction.amount);
            
            
            
            accountInQuestion.balance = [accountInQuestion.balance decimalNumberByAdding:self.detailTransaction.amount];
            
            
            
        }
        
        else if ([accountInQuestion.name isEqualToString:changedAccountName])
        {
            
            NSLog(@"self.detailTransaction.amount = %@",self.detailTransaction.amount);
            
            accountInQuestion.balance = [accountInQuestion.balance decimalNumberBySubtracting:self.detailTransaction.amount];
            
            
        }
    }
    
    
    
    
    
    [self.descButton setUserInteractionEnabled:NO];
    [self.amountButton setUserInteractionEnabled:NO];
    [self.catButton setUserInteractionEnabled:NO];
    [self.acctButton setUserInteractionEnabled:NO];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) accountChangeDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Category selected delegate methods

-(void) categorySelectedDidSave:(WMMGCategory *)selectedCategory
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];

    self.categoryLabel.text = selectedCategory.name; //This is a NSSTring
    self.detailTransaction.category = selectedCategory.name;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [self.descButton setUserInteractionEnabled:NO];
    [self.amountButton setUserInteractionEnabled:NO];
    [self.acctButton setUserInteractionEnabled:NO];
    [self.catButton setUserInteractionEnabled:NO];
}

-(void) categorySelectedDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Save or cancel this transaction

- (IBAction)saveModdedTrans:(UIBarButtonItem *)sender
{
    
    
    NSLog(@"self.account = %@",self.thisAccount.name);

    NSLog(@"self.detailTransaction.amount = %@",self.detailTransaction.amount);
    
    [self.delegate detailVCDidSave:self.detailTransaction : self.thisAccount];
}


- (IBAction)cancelTransChanges:(UIBarButtonItem *)sender
{
    [self.delegate detailVCDidCancel];
}


- (NSDecimalNumber *)detailTransAmtAbsVal:(NSDecimalNumber *)num
{
    if ([num compare:[NSDecimalNumber zero]] == NSOrderedAscending)
    {
        // Number is negative. Multiply by -1
        NSDecimalNumber * negativeOne = [NSDecimalNumber decimalNumberWithMantissa:1
                                                                          exponent:0
                                                                        isNegative:YES];
        return [num decimalNumberByMultiplyingBy:negativeOne];
        
    } else
    
    {
        return num;
    }
}


#pragma mark - Delete transaction button


- (IBAction)deleteTransAction:(UIButton *)sender
{
    
    NSString *alertTitle = @"Are you sure you want to delete this transaction?";
    NSString *alertMessage = @"This action cannot be undone";
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
//                                       NSLog(@"Cancel action");
                                   }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSDecimalNumber * invertedMultiplier = [NSDecimalNumber decimalNumberWithString:@"-1"];
                                   
                                   self.detailTransaction.amount = [self.detailTransaction.amount decimalNumberByMultiplyingBy:invertedMultiplier];
                                   
                                   NSLog(@"Original self.detailTransaction.amount = %@",self.detailTransaction.amount);

                                   self.thisAccount.balance = [self.thisAccount.balance decimalNumberByAdding : self.detailTransaction.amount];
                                   
                                   
                                       if (self.thisAccount.currentHighWaterBalance < self.thisAccount.balance)
                                       {
                                           self.thisAccount.currentHighWaterBalance = self.thisAccount.balance;
                                       }
                                   
                                       else if (self.thisAccount.currentHighWaterBalance >= self.thisAccount.balance)
                                       {
                                           self.thisAccount.currentHighWaterBalance = self.thisAccount.currentHighWaterBalance;
                                       }

                                   
                                   
                                   
                                   NSLog(@"self.thisAccount.balance = %@",self.thisAccount.balance);

                                   
                                   [self.delegate detailVCDidDeleteTransaction : self.detailTransaction : self.thisAccount];
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

@end
