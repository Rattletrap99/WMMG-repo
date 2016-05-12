//
//  AccountSelectVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 3/1/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AccountSelectVC.h"

@interface AccountSelectVC ()

@end

NSFetchedResultsController *accountsFRC;

@implementation AccountSelectVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myTableview.dataSource = self;
    self.myTableview.delegate = self;

    accountsFRC = [WMMGAccount MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
    
    int acctsFRCCount = (int)accountsFRC.fetchedObjects.count;
    [self.myTableview reloadData];
    
    NSLog(@"Number of accounts is %d",acctsFRCCount);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)newAccountButton:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"newAccountSegue" sender:self];
}

//-(void)prepareForPopoverPresentation:(UIPopoverPresentationController *)popoverPresentationController
//{
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"newAccountSegue"])
    {
        UIViewController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *nooAcctPPC = dvc.popoverPresentationController;
        
        
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        NewAccountVC *nooAcctVC = (NewAccountVC *)navController.topViewController;
        nooAcctVC.delegate = self;
        
        if (nooAcctPPC)
        {
            nooAcctPPC.delegate = self;
        }
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}





#pragma mark - Tableview stuff


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountsFRC.fetchedObjects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountSelectCell"];
    
    WMMGAccount *account;
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountSelectCell"];
        
        account = [accountsFRC objectAtIndexPath:indexPath];
        
        
        cell.textLabel.text = account.name;
        NSLog(@"Inside cellForRowAtIndexPath if statement");
        NSLog(@"This cell should say %@",cell.textLabel.text);
        NSLog(@"This cell number is %@",indexPath);
        
        if (account.current.boolValue == YES)
        {
            cell.textLabel.textColor = [UIColor redColor];
        }
        
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];

        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    else
    {
        account = [accountsFRC objectAtIndexPath:indexPath];
        
        
        cell.textLabel.text = account.name;
        NSLog(@"Inside cellForRowAtIndexPath else statement");

        NSLog(@"This cell should say %@",cell.textLabel.text);
        NSLog(@"This cell number is %@",indexPath);
        
        if (account.current.boolValue == YES)
        {
            cell.textLabel.textColor = [UIColor redColor];
        }
        
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
            
        }

        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;

    }
    return cell;
}




//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)thisCell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}





-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *tableViewCell in tableView.visibleCells)
    {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    
    NSLog(@"The cell text is %@",selectedCell.textLabel.text);
//    NSLog(@"The selected Account is named %@",self.selectedAccount.name);

    
    for (WMMGAccount *account in accountsFRC.fetchedObjects)
    {
        if ([account.name isEqualToString:selectedCell.textLabel.text])
        {
            account.current = @YES;
            self.selectedAccount = account;
        }
        
        else
        {
            account.current = @NO;
        }
    }
    
//    for (WMMGAccount *account in accountsFRC.fetchedObjects)
//    {
//    }
    NSLog(@"The selected Account is named %@",self.selectedAccount.name);
}



#pragma mark - Done and Cancel buttons




- (IBAction)doneButton:(UIBarButtonItem *)sender
{
    if (self.selectedAccount)
    {
            [self.delegate accountSelectVCDidSave:self.selectedAccount];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No account selected"
                                                        message:@"Please select an account or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (IBAction)cancelButton:(UIBarButtonItem *)sender
{
//    self.selectedAccount = nil;
    [self.delegate accountSelectVCDidCancel];
}



#pragma mark - New Account delegate methods


-(void) addAccountDidSave : (WMMGAccount *) brandNewAccount
{
    
//    brandNewAccount.balance = 0;
//    brandNewAccount.currentHighWaterBalance = 0;

    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    
    
    accountsFRC = [WMMGAccount MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];

    [self.myTableview reloadData];
}

-(void) addAccountDidCancel
{
//    [accountToCancel MR_deleteEntity];
//    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
//    [localContext MR_saveToPersistentStoreAndWait];

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    accountsFRC = [WMMGAccount MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
    [self.myTableview reloadData];

}


@end
