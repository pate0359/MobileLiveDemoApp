//
//  ListViewController.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "ListViewController.h"
#import "MLNetworkService.h"
#import "PhotoViewController.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSDictionary *photoList;
@property (strong, nonatomic) IBOutlet NSDictionary *selectedPhotoDict;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Photo List";
    
    self.photoList = [NSDictionary new];

    //Add rightbar button to add photo
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add Photo" style:UIBarButtonItemStylePlain target:self action:@selector(addPhoto:)];
    
    //Get photolist for user
    [self getPhotoList];
}

#pragma mark - Private methods
-(void)getPhotoList{
    
    //Show network indicator on statusbar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    [[MLNetworkService sharedInstance] getListOfPhotos:^(NSDictionary *response, NSError *err) {
        
        //Hide indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (err) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Failed!"
                                                                                     message:@"Unable to get photo list. Plase try again."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            return;
        }
        self.photoList = response;
        
        //Reload tableview
        [self.tableView reloadData];
    }];
}

#pragma mark - Action methods

-(IBAction)addPhoto:(id)sender
{
    self.selectedPhotoDict = nil;
    [self performSegueWithIdentifier:@"PhotoView" sender:self];
}

#pragma mark - Tableview DataSource method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.photoList.allKeys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellPhotoListID"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    //Get photo name
    NSArray* keys = [self.photoList allKeys];
    NSDictionary *dict = [self.photoList objectForKey:[keys objectAtIndex:indexPath.row]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
    
    return cell;
}

#pragma mark - Tableview Delegate method
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //Get selected photo
    NSArray* keys = [self.photoList allKeys];
    self.selectedPhotoDict = [self.photoList objectForKey:[keys objectAtIndex:indexPath.row]];
    
    [self performSegueWithIdentifier:@"PhotoView" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    PhotoViewController *controller = (PhotoViewController*) segue.destinationViewController;
    controller.photoDict = self.selectedPhotoDict;
}


@end
