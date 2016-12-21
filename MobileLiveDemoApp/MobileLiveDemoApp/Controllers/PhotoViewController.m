//
//  PhotoViewController.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "PhotoViewController.h"
#import "MLNetworkService.h"

@interface PhotoViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgViewPhoto;
@property (strong, nonatomic) IBOutlet UIButton *btnChooseImage;
@property (strong, nonatomic) IBOutlet UIButton *btnViewUpload;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.photoDict) {
    
        self.title = [NSString stringWithFormat:@"%@",_photoDict[@"name"]];
        _btnChooseImage.hidden = YES;
        _btnViewUpload.hidden = YES;
        
        NSString *strImageData = _photoDict[@"data"];
        if (strImageData) {
            self.imgViewPhoto.image = [self decodeBase64ToImage:strImageData];
        }
        
    }else{
        self.title = @"Upload Photo";
        _btnChooseImage.hidden = NO;
        _btnViewUpload.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options: NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

#pragma mark - Private Methods
-(void)getPhotoWithId{
    
    if (!self.photoDict) {
        return;
    }
    
    //Show network indicator on statusbar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *photoId = _photoDict[@"id"];
    [[MLNetworkService sharedInstance] getPhotoWithId:photoId responseBlock:^(NSDictionary *photo, NSError *err) {
    
        //Hide indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (err) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                                     message:@"Unable to get photo. Plase try again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        //NSLog(@"photo : %@",photo);
    }];
}

-(void)uploadPhoto{
    
    if (!self.imgViewPhoto.image) {
        return;
    }
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *imageName = [NSString stringWithFormat:@"%d",(int)timeStamp];
    
    //Show network indicator on statusbar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[MLNetworkService sharedInstance] uploadPhoto:self.imgViewPhoto.image withName:imageName responseBlock:^(BOOL isSuccess, NSError *err) {
    
        //Hide indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (err) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                                     message:@"upload failed. Please try again later."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];

            
        }else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                                     message:@"Uploaded successfully!"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok"
                                                                style:UIAlertActionStyleDefault
                                                              handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];

        }
    }];
}

#pragma mark - UIImagePickerController Methods

-(void)choosePhoto:(BOOL)isCamera{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if (isCamera) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgViewPhoto.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - Action Methods
- (IBAction)chooseImageClicked:(id)sender {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Add Photo" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self choosePhoto:YES];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self choosePhoto:NO];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:NULL];
}

- (IBAction)uploadPhotoClicked:(id)sender {
    
    [self uploadPhoto];
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
