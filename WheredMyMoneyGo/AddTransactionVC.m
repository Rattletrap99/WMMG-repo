//
//  AddTransactionVC.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 2/6/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "AddTransactionVC.h"

@interface AddTransactionVC ()

@end

@implementation AddTransactionVC

NSString *filePath;
NSData *pngData;

NSString *timeTag;


- (void)viewDidLoad
{
    [super viewDidLoad];
    CatSelectTVC *catSelVC = [[CatSelectTVC alloc]init];
    catSelVC.delegate = self;
    //    self.accountLabel.text = self.fvcProxy.currentAccount.name;
    
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterFullStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.amountField.delegate = self;
    self.payeeField.delegate = self;
    self.forWhatField.delegate = self;
    
    self.amountField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.payeeField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.forWhatField.autocorrectionType = UITextAutocorrectionTypeNo;

    _fastCamera = [FastttCamera new];
    self.fastCamera.delegate = self;
    
    
    
    
    
    [self fastttAddChildViewController:self.fastCamera];
    [self.fastCamera.view setFrame:self.viewFinder.frame];
    
    NSLog(@"%@", NSStringFromCGRect(self.viewFinder.frame));
    
    self.shutterButton.layer.backgroundColor = [[UIColor redColor] CGColor];
    [self.shutterButton.layer setCornerRadius:self.shutterButton.frame.size.width/2.0f];
    self.shutterButton.layer.borderWidth = 3.0f;
    self.shutterButton.layer.borderColor = [[UIColor whiteColor] CGColor];

    self.viewFinder.layer.borderWidth = .5f;
    self.viewFinder.layer.borderColor = [[UIColor darkGrayColor] CGColor];

    self.imageWell.layer.borderWidth = .5f;
    self.imageWell.layer.borderColor = [[UIColor darkGrayColor] CGColor];

    
    
    
    NSString *rectString = NSStringFromCGRect(self.viewFinder.frame);
    
    NSLog(@"ViewFinder.frame == %@",rectString);

    
}


//********************************

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = segue.identifier;
    
    if ([identifier isEqualToString:@"CatSelectSegue"])
    {
        UIViewController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *catSelPPC = dvc.popoverPresentationController;
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        CatSelectTVC *selCatVC = (CatSelectTVC *)navController.topViewController;
        selCatVC.delegate = self;
        
        if (catSelPPC)
        {
            catSelPPC.delegate = self;
        }
    }
    
    else if ([identifier isEqualToString:@"newCatSegue"])
    {
        UIViewController *dvc = segue.destinationViewController;
        UIPopoverPresentationController *catNewPPC = dvc.popoverPresentationController;
        
        
        NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
        
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        AddCategoryVC *addCatVC = (AddCategoryVC *)navController.topViewController;
        addCatVC.delegate = self;
        WMMGCategory *addedCategory = (WMMGCategory *)[WMMGCategory MR_createInContext:localContext];
        addCatVC.brandNewCategory = addedCategory;
        
        if (catNewPPC)
        {
            catNewPPC.delegate = self;
        }
    }
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}


#pragma mark - Save or Cancel thisTransaction

- (IBAction)saveTransaction:(UIBarButtonItem *)sender
{
    
    self.thisTransaction = [WMMGTransaction MR_createEntity];
    self.thisTransaction.account = self.prevailingAccount.name;
//    self.thisTransaction.category = self.categoryLabel.text;
    
    NSLog(@"thisTransaction.category is %@",self.thisTransaction.category);
    
    // This line logs self.thisTransaction.category
//    NSLog(@"(AddTransVC 2) The selected category is named %@",self.thisTransaction.category);
    
    
    if (self.amountField.text.length > 0 && self.imageWell.image)
    {
        self.thisTransaction.amount = [NSDecimalNumber decimalNumberWithString:self.amountField.text locale:NSLocale.currentLocale];
        
        NSLog(@"1 thisTransaction.amount is %@",self.thisTransaction.amount);

        // Inverts the transaction amount
        
        NSDecimalNumber * invertedMultiplier = [NSDecimalNumber decimalNumberWithString:@"-1"];
        
        self.thisTransaction.amount = [self.thisTransaction.amount decimalNumberByMultiplyingBy:invertedMultiplier];
        
        
        
        NSLog(@"2 thisTransaction.amount is %@",self.thisTransaction.amount);

        
        [self assembleAndSaveTransaction];

    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transaction record incomplete"
                                                        message:@"Must enter an amount and snap picture"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
}

-(void) assembleAndSaveTransaction
{
    self.thisTransaction.transDate = [NSDate date];
    self.thisTransaction.paidTo = self.payeeField.text;
    
    self.thisTransaction.forWhat = self.forWhatField.text;
    self.thisTransaction.sortDate = [self sortDateForDate:self.thisTransaction.transDate];
    
    [pngData writeToFile:filePath atomically:YES]; //Write the file
    
    self.thisTransaction.picPath = timeTag; // not filePath
    
    
    self.thisTransaction.pointBalance = [self.prevailingAccount.balance decimalNumberByAdding:self.thisTransaction.amount];
    
    [self.view endEditing:YES];
    
    
    [self.delegate addTransactionViewControllerDidSave : self.thisTransaction];

    
}


- (IBAction)cancelTransaction:(UIBarButtonItem *)sender
{
    NSLog(@"Number of transactions at cancelTransaction in AddTransVC is %lu",(unsigned long)[WMMGTransaction MR_countOfEntities]);;
    
    [self.delegate addTransactionViewControllerDidCancel : self.thisTransaction];
}


#pragma mark - New category delegate methods

-(void)addCategoryDidSave:(WMMGCategory *)brandNewCategory
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [localContext MR_saveToPersistentStoreAndWait];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)addCategoryDidCancel:(WMMGCategory *)categoryToDelete
{
    [categoryToDelete MR_deleteEntity];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Category selected delegate methods

-(void) categorySelectedDidSave : (WMMGCategory *) selectedCategory
{
    // This line assigns the selected category.name to the actual transaction.category
    //    self.thisTransaction.category = selectedCategory.name;
    
    // This line displays the selected category's name in the label
    self.categoryLabel.text = selectedCategory.name;
    
    // This line correctly logs the category eg, "(AddTransVC 1) The selected category is named EATING OUT"
//    NSLog(@"(AddTransVC 1) The selected category is named %@",selectedCategory.name);
    
    
    
    // ********************* How can self.thisTransaction.category == (null)? It's assigned the proper name (passed in successfully by delegation) in the first line of this method. **************************
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


-(void) categorySelectedDidCancel
{
    //    [forgetCategory MR_deleteEntity];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - Miscellaneous methods


// Gives beginning of this day
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

- (IBAction)deleteAllCategories:(UIButton *)sender
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    [WMMGTransaction MR_truncateAllInContext:localContext];
    [localContext MR_saveToPersistentStoreAndWait];
    
    NSLog(@"Number of accounts is %lu",(unsigned long)[WMMGAccount MR_countOfEntities]);
    NSLog(@"Number of transactions is %lu",(unsigned long)[WMMGTransaction MR_countOfEntities]);
    NSLog(@"Number of categories is %lu",(unsigned long)[WMMGCategory MR_countOfEntities]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)snapPicButton:(UIButton *)sender
{
//    _fastCamera = [FastttCamera new];
//    self.fastCamera.delegate = self;
//    
//    [self fastttAddChildViewController:self.fastCamera];
//    [self.fastCamera.view setFrame:self.viewFinder.frame];
//    
//    //    CGRect vfRect = self.viewFinder.frame;
//    
//    NSString *rectString = NSStringFromCGRect(self.viewFinder.frame);
//    
//    NSLog(@"ViewFinder.frame == %@",rectString);
}


- (IBAction)pictureButtonTapped:(UIButton *)sender
{
    
    [self.fastCamera takePicture];
    //    self.fastCamera = nil;
//    [self.fastCamera.cam didFinishScalingCapturedImage];
}



// Delegate method to get image, scale it to fit the viewfinder, save it, and record the filepath

- (void)cameraController:(FastttCamera *)cameraController didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage;
{
    //Use the image's data that is received
    pngData = UIImagePNGRepresentation(capturedImage.scaledImage);
    
    NSLog(@"1 The size of pngData should be %lu",(unsigned long)pngData.length);
    
    //Save the image someplace, and add the path to this transaction's picPath attribute
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    

    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    timeTag = [NSString stringWithFormat:@"%d",timestamp];
    
    filePath = [documentsPath stringByAppendingPathComponent:timeTag]; //Add the file name
    
    
    NSLog(@"1 The picture was saved at %@",filePath);
    
    //    cameraController = nil;
    
    [self.imageWell setImage:capturedImage.scaledImage];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}



@end
