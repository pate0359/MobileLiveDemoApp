//
//  ViewController.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "MLNetworkService.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    //Get dev info from plist file
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DeveloperInfo" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    _lblName.text = dict[@"name"];
    _lblEmail.text = dict[@"email"];

    //hide view after 3 sec
    [self performSelector:@selector(hideSplashScreen) withObject:nil afterDelay:3.0];
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    NSDictionary *params = @{@"username": @"User4",
//                             @"password": @"User4",
//                             @"firstname": @"ufname",
//                             @"lastname": @"ulastname",
//                             @"phone": @"111-111-1111"
//                             };
//    
//    [[MLNetworkService sharedInstance] registerUser:params responseBlock:^(NSDictionary *userDetails, NSError *err) {
//        
//        NSLog(@"userDetails : %@",userDetails);
//        NSLog(@"err : %@",err);
//    }];
//    
//    [[MLNetworkService sharedInstance] loginwithUserName:@"User123" password:@"User123" responseBlock:^(NSDictionary *userDetails, NSError *err) {
//        
//        NSLog(@"userDetails : %@",userDetails);
//        NSLog(@"err : %@",err);
//        
//        if (!err) {
//            
//            
//            [[MLNetworkService sharedInstance] uploadPhoto:[UIImage imageNamed:@"test.jpg"] withName:@"test Image" responseBlock:^(BOOL isSuccess, NSError *err) {
//                
//                NSLog(@"isSuccess : %d",isSuccess);
//                NSLog(@"err : %@",err);
//            }];
//        
//            [[MLNetworkService sharedInstance] getListOfPhotos:^(NSDictionary *response, NSError *err) {
//                
//                
//                NSLog(@"list : %@",response);
//                NSLog(@"err : %@",err);
//                
//                [[MLNetworkService sharedInstance] getPhotoWithId:@"pht_abb9e4a8" responseBlock:^(NSDictionary *photo, NSError *err) {
//                    
//                    NSLog(@"==================================");
//                    NSLog(@"photo : %@",photo);
//                    NSLog(@"err : %@",err);
//                }];
//                
//            }];
//        }
//    }];
}
     
- (void)hideSplashScreen {
    [self performSegueWithIdentifier:@"SplashView" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
