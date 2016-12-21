//
//  RegisterViewController.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "MLNetworkService.h"

@interface RegisterViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtUsername;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstname;
@property (strong, nonatomic) IBOutlet UITextField *txtLastname;
@property (strong, nonatomic) IBOutlet UITextField *txtPhone;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"New User";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods

- (IBAction)signupClicked:(id)sender {
    
    if ([self.txtUsername.text isEqualToString:@""] || [self.txtPassword.text isEqualToString:@""] || [self.txtFirstname.text isEqualToString:@""] || [self.txtLastname.text isEqualToString:@""] || [self.txtPhone.text isEqualToString:@""]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Input Error!"
                                                                                 message:@"All fields are required."
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //Show network indicator on statusbar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSDictionary *params = @{@"username": self.txtUsername.text,
                             @"password": self.txtPassword.text,
                             @"firstname": self.txtFirstname.text,
                             @"lastname": self.txtLastname.text,
                             @"phone": self.txtPhone.text
                             };
    
    [[MLNetworkService sharedInstance] registerUser:params responseBlock:^(NSDictionary *userDetails, NSError *err) {
        
        //Hide indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (err) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                                     message:@"Unable to register user. Please try again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
         
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                                     message:@"User register successfully!"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
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
