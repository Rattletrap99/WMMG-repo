//
//  SnapPicViewController.m
//  WheredMyMoneyGo
//
//  Created by Tim Jones on 4/18/15.
//  Copyright (c) 2015 Tim Jones. All rights reserved.
//

#import "SnapPicViewController.h"

@interface SnapPicViewController ()

@end

@implementation SnapPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)snapPicButton:(UIButton *)sender
{
//    _cameraView = [[CameraSessionView alloc] initWithFrame:self.view.frame];
//    _cameraView.delegate = self;
//    [self.view addSubview:_cameraView];
}


-(void)didCaptureImage:(UIImage *)image
{
    //Use the image's data that is received
    NSData *pngData = UIImagePNGRepresentation(image);
    
    //Save the image someplace, and add the path to this transaction's picPath attribute
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    
    int timestamp = [[NSDate date] timeIntervalSince1970];
    
    NSString *timeTag = [NSString stringWithFormat:@"%d",timestamp];
    
    NSString *filePath = [documentsPath stringByAppendingString:timeTag]; //Add the file name
    [pngData writeToFile:filePath atomically:YES]; //Write the file
}


//- (NSString *)documentsPathForFileName:(NSString *)name
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0];
//    
//    return [documentsPath stringByAppendingPathComponent:name];
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
