//
//  CatSelectTVC.h
//  
//
//  Created by Tim Jones on 3/12/15.
//
//

#import <UIKit/UIKit.h>
#import <MagicalRecord/CoreData+MagicalRecord.h>
#import "WMMGCategory.h"
#import "AddCategoryVC.h"

@class AddTransactionVC;


//Delegate for this protocol is AddTransactionVC

@protocol SelectedCategoryDelegate <NSObject>

-(void) categorySelectedDidSave : (WMMGCategory *) selectedCategory;
-(void) categorySelectedDidCancel;

@end

@interface CatSelectTVC : UIViewController <AddCategoryDelegate,UIPopoverPresentationControllerDelegate,UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, weak) WMMGCategory *thisCategory;

@property (nonatomic, weak) id <SelectedCategoryDelegate> delegate;

@property (nonatomic, weak) WMMGCategory * selectedCategory;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
