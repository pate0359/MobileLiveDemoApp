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

    //hide view after 4 sec
    [self performSelector:@selector(hideSplashScreen) withObject:nil afterDelay:4.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Methods

- (void)hideSplashScreen {
    [self performSegueWithIdentifier:@"SplashView" sender:self];
}



@end
