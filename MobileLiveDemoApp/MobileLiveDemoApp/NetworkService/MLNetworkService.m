//
//  MLNetworkService.m
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import "MLNetworkService.h"

@interface MLNetworkService ()
{
    AFHTTPSessionManager *manager;
    AFNetworkReachabilityManager *managerServerReachability;
    BOOL serverReachabilityStatusReceived;
}
@end

@implementation MLNetworkService

#define BASE_URL @"http://mobilelive.getsandbox.com"

#pragma mark - Initialization
+(MLNetworkService *) sharedInstance
{
    static MLNetworkService *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MLNetworkService alloc] init];
    });
    return sharedInstance;
}

-(id) init
{
    self = [super init];
    if (self) {
        self->manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        
        //Defining Reachability manager for Server
        serverReachabilityStatusReceived = NO;
        AFNetworkReachabilityManager *reachabilityMgr = [AFNetworkReachabilityManager managerForDomain:[NSString stringWithFormat:@"%@",@"mobilelive.getsandbox.com"]];
        [reachabilityMgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            serverReachabilityStatusReceived = YES;
            NSLog(@"%@",AFStringFromNetworkReachabilityStatus(status));
        }];
        self->managerServerReachability =  reachabilityMgr;
        [reachabilityMgr startMonitoring];
    }
    return self;
}

#pragma mark - Rechability methods
-(NSError *) checkServerReachability
{
    //Assume server is reachable until Reachability status has been received
    if (!serverReachabilityStatusReceived) {
        return nil;
    }
    
    if (managerServerReachability.reachableViaWiFi || managerServerReachability.reachableViaWWAN) {
        return nil;
    }else {
        return [self errObjectWithMsg:@"Server not reachable"];
    }
}

#pragma mark - Helper methods

-(NSError *) errObjectWithMsg:(NSString *) msg
{
    if(!msg) msg = [NSString stringWithFormat:@"%@",msg];
    NSError *err = [NSError errorWithDomain:@"MobileLive" code:-1 userInfo:@{NSLocalizedDescriptionKey: msg}];
    return err;
}

NSString *requestUrl(NSString *url)
{
    return [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

#pragma mark - Networkcall

-(void) registerUser:(NSDictionary *) params responseBlock:(void (^)(NSDictionary *userDetails,NSError *err)) finishBlock{
    
    NSMutableDictionary *userDetails=[NSMutableDictionary new];
    
    //Setting up finish block
    void (^fBlock)(NSError *err) = ^(NSError *err){
        if (err) { //Failed
            finishBlock(userDetails,err);
        }else { //Success
            finishBlock(userDetails,nil);
        }
    };    
    
    //Server Reachability
    NSError *reachabilityErr = [self checkServerReachability];
    if (reachabilityErr) {
        fBlock(reachabilityErr);
        return;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:requestUrl(@"users") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Get session-id from HTTP response headers
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"allHeaderFields - %@" ,[r allHeaderFields]);
            
            NSString *coockie = [[r allHeaderFields] valueForKey:@"Set-Cookie"];
            [[NSUserDefaults standardUserDefaults] setObject:coockie forKey:@"Set-Cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        userDetails[@"id"] = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
        userDetails[@"object"] = [NSString stringWithFormat:@"%@",responseObject[@"object"]];
        userDetails[@"username"] = [NSString stringWithFormat:@"%@",responseObject[@"username"]];
        userDetails[@"firstname"] = [NSString stringWithFormat:@"%@",responseObject[@"firstname"]];
        userDetails[@"lastname"] = [NSString stringWithFormat:@"%@",responseObject[@"lastname"]];
        userDetails[@"phone"] = [NSString stringWithFormat:@"%@",responseObject[@"phone"]];
        userDetails[@"created_at"] = [NSString stringWithFormat:@"%@",responseObject[@"created_at"]];
        userDetails[@"updated_at"] = [NSString stringWithFormat:@"%@",responseObject[@"updated_at"]];
        
        fBlock(nil);

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fBlock(error);
    }];
    
}

-(void) loginwithUserName:(NSString *) username password:(NSString*)password responseBlock:(void (^)(NSDictionary *userDetails,NSError *err)) finishBlock{
    
    NSMutableDictionary *userDetails=[NSMutableDictionary new];
    
    //Setting up finish block
    void (^fBlock)(NSError *err) = ^(NSError *err){
        if (err) { //Failed
            finishBlock(userDetails,err);
        }else { //Success
            finishBlock(userDetails,nil);
        }
    };
    
    ///Server Reachability
    NSError *reachabilityErr = [self checkServerReachability];
    if (reachabilityErr) {
        fBlock(reachabilityErr);
        return;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = @{@"username": username,
                            @"password": password
                             };
    
    [manager POST:requestUrl(@"users/login") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Get session-id from HTTP response headers
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
            NSLog(@"allHeaderFields - %@" ,[r allHeaderFields]);
            
            NSString *coockie = [[r allHeaderFields] valueForKey:@"Set-Cookie"];
            
            [[NSUserDefaults standardUserDefaults] setObject:coockie forKey:@"Set-Cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        userDetails[@"id"] = [NSString stringWithFormat:@"%@",responseObject[@"id"]];
        userDetails[@"object"] = [NSString stringWithFormat:@"%@",responseObject[@"object"]];
        userDetails[@"username"] = [NSString stringWithFormat:@"%@",responseObject[@"username"]];
        userDetails[@"firstname"] = [NSString stringWithFormat:@"%@",responseObject[@"firstname"]];
        userDetails[@"lastname"] = [NSString stringWithFormat:@"%@",responseObject[@"lastname"]];
        userDetails[@"phone"] = [NSString stringWithFormat:@"%@",responseObject[@"phone"]];
        userDetails[@"created_at"] = [NSString stringWithFormat:@"%@",responseObject[@"created_at"]];
        userDetails[@"updated_at"] = [NSString stringWithFormat:@"%@",responseObject[@"updated_at"]];
        
        fBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"Set-Cookie"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        fBlock(error);
    }];
}

-(void) uploadPhoto:(UIImage *) photo withName:(NSString*)name responseBlock:(void (^)(BOOL isSuccess,NSError *err)) finishBlock{
 
    //NSMutableDictionary *userDetails=[NSMutableDictionary new];
    __block BOOL isSuccess = NO;
    
    //Setting up finish block
    void (^fBlock)(NSError *err) = ^(NSError *err){
        if (err) { //Failed
            finishBlock(isSuccess,err);
        }else { //Success
            finishBlock(isSuccess,nil);
        }
    };
    
    ///Server Reachability
    NSError *reachabilityErr = [self checkServerReachability];
    if (reachabilityErr) {
        fBlock(reachabilityErr);
        return;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]){
        
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"cookie"];
    }
    
    NSString *strImage = [self encodeToBase64String:photo];
    NSDictionary *params = @{@"name": name,
                             @"data": strImage
                             };
    
    [manager POST:requestUrl(@"v2/photos") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        isSuccess = YES;
        fBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        isSuccess = NO;
        fBlock(error);
    }];
}

-(void) getListOfPhotos:(void (^)(NSDictionary *response,NSError *err)) finishBlock{
    
    __block NSDictionary *response=[NSDictionary new];
    
    //Setting up finish block
    void (^fBlock)(NSError *err) = ^(NSError *err){
        if (err) { //Failed
            finishBlock(response,err);
        }else { //Success
            finishBlock(response,nil);
        }
    };
    
    //Server Reachability
    NSError *reachabilityErr = [self checkServerReachability];
    if (reachabilityErr) {
        fBlock(reachabilityErr);
        return;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //NSLog(@"coockies - %@" ,[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]);
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]){
    
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"cookie"];
    }
    
    [manager GET:requestUrl(@"v2/photos") parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            response =  (NSDictionary*) responseObject;
            fBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fBlock(error);
    }];
}

-(void) getPhotoWithId:(NSString *) photoId responseBlock:(void (^)(NSDictionary *photo,NSError *err)) finishBlock{
    
    __block NSDictionary *response=[NSDictionary new];
    
    //Setting up finish block
    void (^fBlock)(NSError *err) = ^(NSError *err){
        if (err) { //Failed
            finishBlock(response,err);
        }else { //Success
            finishBlock(response,nil);
        }
    };
    
    //Server Reachability
    NSError *reachabilityErr = [self checkServerReachability];
    if (reachabilityErr) {
        fBlock(reachabilityErr);
        return;
    }
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //NSLog(@"coockies - %@" ,[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]);
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"]){
        
        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"cookie"];
    }
    
    [manager GET:requestUrl([NSString stringWithFormat:@"v2/photos/%@",photoId]) parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            response =  (NSDictionary*) responseObject;
            fBlock(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        fBlock(error);
    }];
}

@end
