//
//  LoginViewController.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "LoginViewController.h"
#import "MLNetworkService.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Action Methods

- (IBAction)btnSignInClicked:(id)sender {
    
    if (![self.txtUsername.text isEqualToString:@""] && ![self.txtPassword.text isEqualToString:@""]) {
        
        [[MLNetworkService sharedInstance] loginwithUserName:self.txtUsername.text password:self.txtPassword.text responseBlock:^(NSDictionary *userDetails, NSError *err) {
            
            NSLog(@"userDetails : %@",userDetails);
            NSLog(@"err : %@",err);
            if (err) {
                
                return;
            }
            
            [self performSegueWithIdentifier:@"ListView" sender:self];
            
        }];
    }
}

#pragma mark - UITextField Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
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
