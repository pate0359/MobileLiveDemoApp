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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[MLNetworkService sharedInstance] loginwithUserName:@"User1" password:@"User2" responseBlock:^(NSDictionary *userDetails, NSError *err) {
        
        NSLog(@"userDetails : %@",userDetails);
        NSLog(@"err : %@",err);
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
