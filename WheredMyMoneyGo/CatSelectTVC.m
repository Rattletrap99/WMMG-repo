//
//  CatSelectTVC.m
//  
//
//  Created by Tim Jones on 3/12/15.
//
//

#import "CatSelectTVC.h"

@interface CatSelectTVC ()

@end

UINavigationController *thisNavController;


NSFetchedResultsController *categoriesFRC;
//WMMGCategory *thisCategory;
NSString *selectedCategoryName;


@implementation CatSelectTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;

    categoriesFRC = [WMMGCategory MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [categoriesFRC.fetchedObjects count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryTVCell"];
    
    self.thisCategory = [categoriesFRC objectAtIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categoryTVCell"];
        
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



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"nooCatSegue"])
    {
        UIViewController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *nooCatPPC = dvc.popoverPresentationController;
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddCategoryVC *nooCatVC = (AddCategoryVC *)navController.topViewController;
        nooCatVC.delegate = self;
        
        if (nooCatPPC)
        {
            nooCatPPC.delegate = self;
        }
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}



#pragma mark - Done and Cancel buttons

- (IBAction)saveSelectedCategory:(UIBarButtonItem *)sender

{
    if (self.selectedCategory)
    {
        [self.delegate categorySelectedDidSave:self.selectedCategory];
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

- (IBAction)cancelSelectedCategory:(UIBarButtonItem *)sender

{
    self.selectedCategory = nil;
    [self.delegate categorySelectedDidCancel];
}



#pragma mark - Add category delegate methods


-(void) addCategoryDidSave : (WMMGCategory *) brandNewCategory
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    
    categoriesFRC = [WMMGCategory MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];

    [self.myTableView reloadData];
    
    [thisNavController dismissViewControllerAnimated:YES completion:nil];
}

-(void) addCategoryDidCancel
{
    [thisNavController dismissViewControllerAnimated:YES completion:nil];
}




@end
