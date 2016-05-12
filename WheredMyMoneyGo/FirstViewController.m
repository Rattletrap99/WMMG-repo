//
//  FirstViewController.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/5/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

float originalAnimBalHtConstraint;
float lastAnimBalHtConstraint;
//NSDecimalNumber * currentHighWaterBalance;


@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    [self.accountButton.layer setCornerRadius:4.0f];
//    self.accountButton.layer.borderWidth = .5f;
//    self.accountButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    [self.nooTransButton.layer setCornerRadius:4.0f];
    self.nooTransButton.layer.borderWidth = 1.0f;
    self.nooTransButton.layer.borderColor = [[UIColor redColor] CGColor];
//    self.nooTransButton.titleLabel.text = @"$ U25B6\U0000FE0E";
    
    [self.buttonBoxView.layer setCornerRadius:4.0f];
    self.buttonBoxView.layer.borderWidth = .5f;
    self.buttonBoxView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    
    
//    [self.viewTransactionsButton.layer setCornerRadius:4.0f];
//    self.viewTransactionsButton.layer.borderWidth = .5f;
//    self.viewTransactionsButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    
//    [self.addMoneyButton.layer setCornerRadius:4.0f];
//    self.addMoneyButton.layer.borderWidth = .5f;
//    self.addMoneyButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//    
//    [self.nooAccountButton.layer setCornerRadius:4.0f];
//    self.nooAccountButton.layer.borderWidth = .5f;
//    self.nooAccountButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    
    self.backgroundBar.layer.borderWidth = 1.0f;
    self.backgroundBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    
//    [self animateBalanceBar];
    
    
    self.startBalHtConstraint.priority = 250;
    self.animBalHtConstraint.priority = 750;
    
    NSString *nooTransFrame = [[NSString alloc] init];
    
    nooTransFrame = NSStringFromCGRect (self.nooTransButton.frame);
    
    NSLog(@"1 nooTransFrame = %@",nooTransFrame);
    
    NSString *balanceBarFrame = [[NSString alloc] init];
    
    balanceBarFrame = NSStringFromCGRect (self.balanceBar.frame);
    
    NSLog(@"1 balanceBarFrame = %@",balanceBarFrame);
    

    NSString *backgroundBarFrame = [[NSString alloc] init];
    
    backgroundBarFrame = NSStringFromCGRect (self.backgroundBar.frame);
    
    NSLog(@"1 backgroundBarFrame = %@",backgroundBarFrame);

    
//    self.refreshHWB = YES;
    
    
    [self.view setNeedsLayout];

}


-(void)viewWillAppear:(BOOL)animated
{
    NSPredicate *currentAccountPredicate = [NSPredicate predicateWithFormat:@"current == YES"];
    self.currentAccount = [WMMGAccount MR_findFirstWithPredicate:currentAccountPredicate];
    
    
    self.startBalHtConstraint.constant = 0;
    
    self.startBalHtConstraint.priority = 750;
    self.animBalHtConstraint.priority = 250;
    
    NSLog(@"originalAnimBalHtConstraint = %f",originalAnimBalHtConstraint);
    
    NSLog(@"self.refreshHWB = %d",self.refreshHWB);
    
}

-(void)viewDidAppear:(BOOL)animated
{
    NSString *nooTransFrame = [[NSString alloc] init];
    
    nooTransFrame = NSStringFromCGRect (self.nooTransButton.frame);
    
    NSLog(@"2 nooTransFrame = %@",nooTransFrame);
    
    NSString *balanceBarFrame = [[NSString alloc] init];
    
    balanceBarFrame = NSStringFromCGRect (self.balanceBar.frame);
    
    NSLog(@"2 balanceBarFrame = %@",balanceBarFrame);
    

    originalAnimBalHtConstraint = self.backgroundBar.frame.size.height;
    
    NSLog(@"originalAnimBalHtConstraint = %f",originalAnimBalHtConstraint);
    
    
    if ([WMMGAccount MR_countOfEntities] < 1)
    {
        NSLog(@"Number of accounts == %lu",(unsigned long)[WMMGAccount MR_countOfEntities]);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No accounts established"
                                                        message:@"Please tap 'Select or Create Account'"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        self.nooTransButton.enabled = NO;
        self.addMoneyButton.enabled = NO;
    }
    
    
    else
    {
        NSPredicate *currentAccountPredicate = [NSPredicate predicateWithFormat:@"current == YES"];
        self.currentAccount = [WMMGAccount MR_findFirstWithPredicate:currentAccountPredicate];
 
        self.currentAcctLabel.text = self.currentAccount.name;
        
        self.nooTransButton.enabled = YES;
        self.addMoneyButton.enabled = YES;

        [self animateBalanceBar];

    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Buttons


- (IBAction)newTransButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"newTransSegue" sender:self];
}

- (IBAction)switchAccountButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"selectAccountSegue" sender:self];
}


- (IBAction)addMoneyButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"addMoneyPopSegue" sender:self];
}

#pragma mark - PrepareForSegue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"newTransSegue"])
    {
        self.accountBalanceBeforeTrans = self.currentAccount.balance;
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddTransactionVC *atvc = (AddTransactionVC *)navController.topViewController;
        atvc.delegate = self;
        
        atvc.prevailingAccount = self.currentAccount;
    }
    
    else if ([[segue identifier] isEqualToString:@"selectAccountSegue"])
    {
        UINavigationController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *acctSelVC = dvc.popoverPresentationController;
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AccountSelectVC *acctSelPopVC = (AccountSelectVC *)navController.topViewController;
        
        acctSelPopVC.delegate = self;
        
        if (acctSelVC)
        {
            acctSelPopVC.delegate = self;
        }

    }
    
    else if ([[segue identifier] isEqualToString:@"addMoneyPopSegue"])
    {
        self.accountBalanceBeforeTrans = self.currentAccount.balance;
        
        UIViewController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *addMoneyPPC = dvc.popoverPresentationController;

        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddMoneyPopVC *addMoneyPopVC = (AddMoneyPopVC *)navController.topViewController;
        addMoneyPopVC.delegate = self;
        
        if (addMoneyPPC)
        {
            addMoneyPPC.delegate = self;
        }
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

#pragma mark - Add transaction delegate methods

-(void)addTransactionViewControllerDidSave : (WMMGTransaction *)newTransaction
{
    NSLog(@"newTransaction.amount = %@",newTransaction.amount);

    self.currentAccount.balance = [self.currentAccount.balance decimalNumberByAdding:newTransaction.amount];
//    self.currentAccount.currentHighWaterBalance = self.currentAccount.balance;
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];

    
    NSLog(@"newTransaction.amount = %@",newTransaction.amount);

    NSLog(@"self.currentAccount.balance = %@",self.currentAccount.balance);

    
    self.refreshHWB = NO;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{[self animateBalanceBar];}];
    [self animateBalanceBar];
}

-(void)addTransactionViewControllerDidCancel: (WMMGTransaction *) transactionToDelete
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [transactionToDelete MR_deleteEntity];
    [localContext MR_saveToPersistentStoreAndWait];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteAllTransactions:(UIButton *)sender
{
    [WMMGTransaction MR_truncateAll];
}


#pragma mark - AccountSelectVC delegate methods

-(void) accountSelectVCDidSave : (WMMGAccount *) selectedAccount
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    
    self.currentAccount = selectedAccount;
    self.currentAcctLabel.text = self.currentAccount.name;
    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:self.currentAccount.balance
                               numberStyle:NSNumberFormatterCurrencyStyle];
    
    self.cashOnHandLabel.text = balanceString;
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^
     {
         self.refreshHWB = NO;
         [self animateBalanceBar];
     }];
}



-(void) accountSelectVCDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AddMoneyPop delegate methods

-(void) moneyAddedSave : (NSDecimalNumber *) amountToAdd
{
    
    //Create new transaction in this account with the amount = amountToAdd
    
    self.depositTransaction = [WMMGTransaction MR_createEntity];
    
    self.depositTransaction.account = self.currentAccount.name;
    
    self.depositTransaction.amount = amountToAdd;
    self.depositTransaction.transDate = [NSDate date];
    self.depositTransaction.sortDate = [self sortDateForDate:self.depositTransaction.transDate];

    self.depositTransaction.category = @"Replenishment";
    
    self.depositTransaction.pointBalance = [self.currentAccount.balance decimalNumberByAdding:amountToAdd];
    
    self.currentAccount.balance = [self.currentAccount.balance decimalNumberByAdding:amountToAdd];
    
//    self.currentAccount.currentHighWaterBalance = self.currentAccount.balance;
    
    
    NSLog(@"self.currentAccount.balance = %@",self.currentAccount.balance);
    NSLog(@"currentHighWaterBalance = %@",self.currentAccount.currentHighWaterBalance);
    

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    
    NSLog(@"amountToAdd = %@",amountToAdd);
    
    

    self.currentAccount.replenishedDate = [NSDate date];
    
    
    
    
    NSLog(@"self.refreshHWB = %d",self.refreshHWB);

    
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
    self.refreshHWB = YES;
    
    [self animateBalanceBar];

}

-(void) moneyAddedCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)acctBalanceFixer:(UIButton *)sender
{
    NSFetchedResultsController *acctBalanceFixerFRC = [WMMGAccount MR_fetchAllGroupedBy:@"name" withPredicate:nil sortedBy:nil ascending:nil];
    
    for (WMMGAccount *account in acctBalanceFixerFRC.fetchedObjects)
    {
        account.balance = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:10000];
        NSString *balanceString = [NSNumberFormatter
                                   localizedStringFromNumber:self.currentAccount.balance
                                   numberStyle:NSNumberFormatterCurrencyStyle];
        NSLog(@"balanceString = %@",balanceString);
        
        self.cashOnHandLabel.text = balanceString;
    }
    
}



- (NSDate *)sortDateForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    
    
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *beginningOfDayText = [formatter stringFromDate:beginningOfDay];
    
    NSLog(@"The sortDate should be %@",beginningOfDayText);
    
    return beginningOfDay;
}

#pragma mark - animateBalanceBar

-(void) animateBalanceBar
{
//    [self.view setNeedsLayout];
    
    self.startBalHtConstraint.priority = 250;
    self.animBalHtConstraint.priority = 750;
    
    [self.view setNeedsLayout];
    
    
    NSLog(@"Going into formula--self.animBalHtConstraint.constant should be %f",self.animBalHtConstraint.constant);
    
    
    
    if (self.refreshHWB) // i.e., YES, meaning coming from Add money
    {
        self.currentAccount.currentHighWaterBalance = self.currentAccount.balance;
    }
    
    else // i.e., NO, coming from anywhere else
    {
        self.currentAccount.currentHighWaterBalance = self.currentAccount.currentHighWaterBalance;
    }

    
    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:self.currentAccount.balance
                               numberStyle:NSNumberFormatterCurrencyStyle];
    
    self.cashOnHandLabel.text = balanceString;
    
    NSString *chwbString = [NSNumberFormatter
                            localizedStringFromNumber:self.currentAccount.currentHighWaterBalance
                            numberStyle:NSNumberFormatterCurrencyStyle];
    
    self.chwbLabel.text = chwbString;

    
    
    
    float a; // Length of animated constraint

    NSDecimalNumber * b; // Max length of constraint (originalAnimBalHtConstraint)

    NSDecimalNumber * c; // CurrentHWB - Balance
    
    NSDecimalNumber * d; // CurrentHWB
    
    float e; // Spacing
    
//    NSDecimalNumber * f;
    
    a = self.backgroundBar.frame.size.height;
    
    NSLog(@"self.currentAccount.balance = %@",self.currentAccount.balance);
    NSLog(@"self.currentAccount.currentHighWaterBalance = %@",self.currentAccount.currentHighWaterBalance);
    
//    e = 20;


    b = [[NSDecimalNumber alloc] initWithFloat:originalAnimBalHtConstraint]; // Removed  + e
    c = [self.currentAccount.currentHighWaterBalance decimalNumberBySubtracting:self.currentAccount.balance];
    
    NSLog(@"1 c = %@",c);
    
    d = self.currentAccount.currentHighWaterBalance;
    
    c = [c decimalNumberByDividingBy:d];
    
    NSLog(@"b = %@",b);
    NSLog(@"2 c = %@",c);
    NSLog(@"d = %@",d);
    NSLog(@"e = %f",e);
    

    
    
    
    NSLog(@"self.currentAccount.balance should be %@",self.currentAccount.balance);
    
    NSLog(@"self.currentAccount.currentHighWaterBalance should be %@",self.currentAccount.currentHighWaterBalance);
   
    
    NSLog(@"1 self.animBalHtConstraint.constant should be %f",self.animBalHtConstraint.constant);

    float red = 0.0/255.0;
    float yellow = 60.0/255.0;
    
//    NSLog(@"red",);
    
    
    
    NSLog(@"red = %f",red);
    NSLog(@"yellow = %f",yellow);
    NSLog(@"c = %f",[c floatValue]);

    float hue;
    hue = [c floatValue] * (red - yellow) + yellow;
    
    NSLog(@"hue = %f",hue);

    
    
    
    
    float saturation;
    saturation = 1.0;
    
    float alpha;
    alpha =  1.0;
    
    UIColor *color = [UIColor colorWithHue:hue
                                saturation:saturation
                                brightness:1.0
                                     alpha:alpha];
    
    NSLog(@"color %@",color);

    
    self.balanceBar.backgroundColor = color;
    self.cashOnHandLabel.textColor = color;
    
    
    self.animBalHtConstraint.constant = (a * [c floatValue]); // Removed  + e

//    if (self.animBalHtConstraint.constant < e)
//    {
//        self.animBalHtConstraint.constant = e;
//    }
    
    
    NSLog(@"2 self.animBalHtConstraint.constant should be %f",self.animBalHtConstraint.constant);
    
    NSLog(@"Coming out of formula--self.animBalHtConstraint.constant should be %f",self.animBalHtConstraint.constant);
    
    
    
    [UIView animateWithDuration:.8
                          delay:0.0
         usingSpringWithDamping:.2
          initialSpringVelocity:.5
                        options:UIViewAnimationOptionTransitionNone animations:^{
                            [self.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                         //Completion Block
                     }];

}

@end













