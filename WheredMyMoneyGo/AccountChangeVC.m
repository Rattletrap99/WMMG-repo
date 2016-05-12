//
//  AccountChangeVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AccountChangeVC.h"

@interface AccountChangeVC ()

@end

NSFetchedResultsController *accountsFRC;


@implementation AccountChangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    accountsFRC = [WMMGAccount MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    unsigned long count = accountsFRC.fetchedObjects.count;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"accountChangeCell" forIndexPath:indexPath];
    
    self.thisAccount = [accountsFRC objectAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountChangeCell"];
        
        cell.textLabel.text = self.thisAccount.name;
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    else
    {
        cell.textLabel.text = self.thisAccount.name;
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UITableViewCell *tableViewCell in tableView.visibleCells)
    {
        tableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    for (WMMGAccount *account in accountsFRC.fetchedObjects)
    {
        if ([account.name isEqualToString:selectedCell.textLabel.text])
        {
            self.selectedAccount = account;
        }
    }
}


- (IBAction)saveAccountChange:(UIBarButtonItem *)sender
{
    
    if (self.selectedAccount)
    {
        [self.delegate accountChangeDidSave:self.selectedAccount.name];
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


- (IBAction)cancelAccountChange:(UIBarButtonItem *)sender
{
    self.selectedAccount = nil;
    [self.delegate accountChangeDidCancel];
}




@end




