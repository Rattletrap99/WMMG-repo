//
//  CatSelectModalVCViewController.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/15/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "CatSelectModalVCViewController.h"




@interface CatSelectModalVCViewController ()




@end

NSFetchedResultsController *categoriesFRC;
WMMGCategory *thisCategory;
NSString *selectedCategoryName;

@implementation CatSelectModalVCViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    AddTransactionVC *addTransVC = [[AddTransactionVC alloc]init];
    
//    self.del
    
    categoriesFRC = [WMMGCategory MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:nil groupBy:nil delegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"There are %lu categories",(unsigned long)categoriesFRC.fetchedObjects.count);
    
    unsigned long count = categoriesFRC.fetchedObjects.count;
    
    return count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popoverCell"];
    
//    NSLog(@"The name of the category is %@",thisCategory.name);
    self.thisCategory = [categoriesFRC objectAtIndexPath:indexPath];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popoverCell"];
        
        cell.textLabel.text = self.thisCategory.name;
        NSLog(@"The name in the label should be %@",cell.textLabel.text);
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    
    else
    {
        cell.textLabel.text = self.thisCategory.name;
        NSLog(@"The name in the label should be %@",cell.textLabel.text);
        
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.selectedCategory = selectedCell.textLabel.text;
    NSLog(@"The selected category is named %@",self.selectedCategory);
    
}


#pragma mark - Save and Cancel buttons

- (IBAction)saveSelectedCategory:(UIBarButtonItem *)sender

{
    [self.catSelectDelegate categorySelectedDidSave:self.selectedCategory];
    NSLog(@"The selected category is named %@",self.selectedCategory);

}

- (IBAction)cancelSelectedCategory:(UIBarButtonItem *)sender

{
    [self.catSelectDelegate categorySelectedDidCancel];

}











/*


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
