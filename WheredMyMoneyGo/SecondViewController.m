//
//  SecondViewController.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/5/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

NSFetchedResultsController *selectedAccountFRC;
NSFetchedResultsController *transactionFRC;

FastttCamera *scaler;

WMMGTransaction * thisTransaction;

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Identifies the only possible account--has "current" attribute set to YES
    NSPredicate *accountFRCPredicate = [NSPredicate predicateWithFormat:@"current == YES"];
    
    
    
    selectedAccountFRC = [WMMGAccount MR_fetchAllSortedBy:nil ascending:YES withPredicate:accountFRCPredicate groupBy:nil delegate:nil];
    self.currentAccount = [selectedAccountFRC.fetchedObjects firstObject];
    
    self.accountLabel.text = self.currentAccount.name;
    
    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:self.currentAccount.balance
                               numberStyle:NSNumberFormatterCurrencyStyle];

    self.balanceLabel.text = balanceString;

    NSPredicate *transFRCPredicate = [NSPredicate predicateWithFormat:@"account == %@",self.currentAccount.name];
    
    transactionFRC = [WMMGTransaction MR_fetchAllGroupedBy:@"sortDate" withPredicate:transFRCPredicate sortedBy:@"transDate" ascending:NO];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [self.myTableview reloadData];


}

-(void)viewWillAppear:(BOOL)animated
{
    [self.myTableview reloadData];
}


#pragma mark - Tableview stuff

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Should be sectioned by date
//        NSLog(@"Section count is %lu",(unsigned long)[[transactionFRC sections] count]);
    
    return [[transactionFRC sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    static NSDateFormatter *formatter = nil;
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterFullStyle];
        //        [formatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    id<NSFetchedResultsSectionInfo> sectionInfo = transactionFRC.sections[section];
    WMMGTransaction *transaction = [sectionInfo.objects firstObject];
    
    NSString *sectionLabel = [formatter stringFromDate:transaction.sortDate];
    
//    NSLog(@"The sortDate is %@", transaction.sortDate);
//    NSLog(@"The sectionLabel is %@",sectionLabel);
    
    
    return sectionLabel;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[transactionFRC sections] objectAtIndex:section];
    
//    NSNumber *sectionIndex = [[transactionFRC sections] objectAtIndex:section];
    
//    NSLog(@"Number of  this section is %@",[[transactionFRC sections] objectAtIndex:section]);
//    NSLog(@"Number of transactions in this section is %lu",(unsigned long)[sectionInfo numberOfObjects]);
    
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.thisCustomCell = [tableView dequeueReusableCellWithIdentifier:@"detailCustomCell"];
    
    if (!self.thisCustomCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CustomCell" bundle:nil] forCellReuseIdentifier:@"detailCustomCell"];
        self.thisCustomCell = [tableView dequeueReusableCellWithIdentifier:@"detailCustomCell"];
    }
    
    return self.thisCustomCell;
}


// Fill in labels in custom cell
-(void)tableView:(UITableView *)tableView willDisplayCell:(CustomCell *)thisCell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    thisTransaction = [transactionFRC objectAtIndexPath:indexPath];
    
//    thisCell.thisObjectID = thisTransaction.objectID;
    
    thisCell.transactionForThisCell = thisTransaction;
    thisCell.catLabel.text = thisTransaction.category;
    thisCell.paidToLabel.text = thisTransaction.paidTo;
    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:thisCell.transactionForThisCell.pointBalance
                               numberStyle:NSNumberFormatterCurrencyStyle];

    thisCell.pointBalanceLabel.text = balanceString;
    
    
    if ([thisCell.catLabel.text isEqualToString:@"Replenishment"])
    {
        thisCell.amountLabel.textColor = [UIColor colorWithRed:0.000f green:0.639f blue:0.023f alpha:1.00f];
    }
    
    else
    {
        thisCell.amountLabel.textColor = [UIColor redColor];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:thisTransaction.picPath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    
    

    [thisCell.snapThumbView setImage:image];

    
    NSNumber *invertedAmount = [NSNumber numberWithDouble:fabs([thisTransaction.amount doubleValue])];
    
//    NSDecimalNumber *invertedAmount = [NSDecimalNumber decimalNumberWithDecimal:thisTransaction.amount];

    
    NSString *transAmtString = [NSNumberFormatter
                               localizedStringFromNumber:invertedAmount
                               numberStyle:NSNumberFormatterCurrencyStyle];

    
    if (thisTransaction.amount > 0)
    {
        thisCell.amountLabel.text = transAmtString;
    }
    
    else if (thisTransaction.amount == 0)
    {
        thisCell.amountLabel.text = @"";
    }
    
    
    // Assigns the transDate as a property of the cell
    
    thisCell.rawTransDate = thisTransaction.transDate;
    
//    NSLog(@"willDisplayCell--thisTransaction.transDate = %@",thisTransaction.transDate);
//    NSLog(@"willDisplayCell--thisCustomCell.rawTransDate = %@",self.thisCustomCell.rawTransDate);
//
//    
//    NSLog(@"The amount for this transaction should be %@",[thisTransaction.amount stringValue]);
    
    // Convert date object to desired output format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *formattedDateString = [dateFormatter stringFromDate:thisTransaction.transDate];
    
    thisCell.dateLabel.text = formattedDateString;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Send to detail page, show account details, make amount and account editable
    
    CustomCell *cell = (CustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"didSelectRowAtIndexPath--thisCustomCell.rawTransDate = %@",self.thisCustomCell.rawTransDate);
    
    
    self.transactionOfInterest = cell.transactionForThisCell;
    NSLog(@"didSelectRowAtIndexPath--self.transactionOfInterest.transDate = %@",self.transactionOfInterest.transDate);
    
    NSLog(@"didSelectRowAtIndexPath--self.transactionOfInterest.amount = %@",self.transactionOfInterest.amount);

    
    [self performSegueWithIdentifier:@"segueToDetailVC" sender:self];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"segueToDetailVC"])
    {
    UINavigationController *navController = [segue destinationViewController];
    DetailVC *dVC = (DetailVC *)navController.topViewController;

    dVC.delegate = self;
    dVC.detailTransaction = self.transactionOfInterest;
    }
}

#pragma mark - DetailVC delegate methods


-(void) detailVCDidSave : (WMMGTransaction *) editedTransaction : (WMMGAccount *) account
{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    
    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:self.currentAccount.balance
                               numberStyle:NSNumberFormatterCurrencyStyle];
    
    
    
    self.balanceLabel.text = balanceString;
    
    
    
    NSLog(@"editedTransaction.amount = %@",editedTransaction.amount);
    
    NSLog(@"Balance for this account is %@",balanceString);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.myTableview reloadData];
//    });
    
    [self refreshData];
}

-(void) detailVCDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) detailVCDidDeleteTransaction : (WMMGTransaction *) transToDelete : (WMMGAccount *) accountWithChangedBalance
{
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    

    [transToDelete MR_deleteEntity];
    
    
    
    
    
    
    
    
    [localContext MR_saveToPersistentStoreAndWait];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    

//    if(accountWithChangedBalance.ba)
//    {
//        
//    }
    

    NSString *balanceString = [NSNumberFormatter
                               localizedStringFromNumber:self.currentAccount.currentHighWaterBalance
                               numberStyle:NSNumberFormatterCurrencyStyle];
    
    self.balanceLabel.text = balanceString;
    
    [self refreshData];

}



-(void) refreshData
{
    NSPredicate *transFRCPredicate = [NSPredicate predicateWithFormat:@"account == %@",self.currentAccount.name];
    
    transactionFRC = [WMMGTransaction MR_fetchAllGroupedBy:@"sortDate" withPredicate:transFRCPredicate sortedBy:@"transDate" ascending:NO];
    
    [self.myTableview reloadData];
}


#pragma mark - Misc


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
