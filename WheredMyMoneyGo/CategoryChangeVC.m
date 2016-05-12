//
//  CategoryChangeVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 5/14/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "CategoryChangeVC.h"

@interface CategoryChangeVC ()

@end

NSFetchedResultsController *categoriesFRC;


@implementation CategoryChangeVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    categoriesFRC = [WMMGCategory MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    unsigned long count = categoriesFRC.fetchedObjects.count;
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryChangeCell" forIndexPath:indexPath];
    
    self.thisCategory = [categoriesFRC objectAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"accountChangeCell"];
        
        cell.textLabel.text = self.thisCategory.name;
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    else
    {
        cell.textLabel.text = self.thisCategory.name;
        
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
    
    
    for (WMMGCategory *category in categoriesFRC.fetchedObjects)
    {
        if ([category.name isEqualToString:selectedCell.textLabel.text])
        {
            self.selectedCategory = category;
        }
    }
}


- (IBAction)saveCategoryChange:(UIBarButtonItem *)sender
{
    
    if (self.selectedCategory)
    {
        [self.delegate categoryChangeDidSave:self.selectedCategory.name];
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No category selected"
                                                        message:@"Please select a category or cancel"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    
}


- (IBAction)cancelCategoryChange:(UIBarButtonItem *)sender
{
    self.selectedCategory = nil;
    [self.delegate categoryChangeDidCancel];
    
}



@end
