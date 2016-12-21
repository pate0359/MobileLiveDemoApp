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
        
        //Show network indicator on statusbar
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
        [[MLNetworkService sharedInstance] loginwithUserName:self.txtUsername.text password:self.txtPassword.text responseBlock:^(NSDictionary *userDetails, NSError *err) {
            
            //Hide indicator
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (err) {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                                         message:@"Authorazation failed. Please try again."
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
                return;
            }
            
            [self performSegueWithIdentifier:@"ListView" sender:self];
            
        }];
    }else{
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Input Error!"
                                                                                 message:@"Please provide both username and password."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
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
