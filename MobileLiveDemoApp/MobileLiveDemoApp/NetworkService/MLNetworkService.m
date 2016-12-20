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
}
@end

@implementation MLNetworkService

#define BASE_URL @"http://mobilelive.getsandbox.com"

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
        self->manager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    }
    return self;
}


-(NSError *) errObjectWithMsg:(NSString *) msg
{
    if(!msg) msg = [NSString stringWithFormat:@"%@",msg];
    NSError *err = [NSError errorWithDomain:@"MobileLive" code:-1 userInfo:@{NSLocalizedDescriptionKey: msg}];
    return err;
}

NSString *postUrl(NSString *url)
{
    return [NSString stringWithFormat:@"%@/%@",BASE_URL,url];
}

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
    
    //Network Reachability
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        NSError *error = [self errObjectWithMsg:@"Network not rechable."];
        fBlock(error);
        return;
    }
    
    [manager POST:postUrl(@"users") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for error
        NSDictionary *dictError=[responseObject objectForKey:@"error"];
        if (dictError) {
            
            NSString *msg = nil;
            if (!dictError[@"message"]) {
                msg = dictError[@"message"];
            }else{
                msg = @"Invalid response from server.";
            }
            
            NSError *err = [self errObjectWithMsg:msg];
            fBlock(err);
            return;
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
    
    //Network Reachability
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]) {
        
        NSError *error = [self errObjectWithMsg:@"Network not rechable."];
        fBlock(error);
        return;
    }
    
    NSDictionary *params = @{@"username": username,
                            @"password": password
                             };
    
    [manager POST:postUrl(@"users") parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for error
        NSDictionary *dictError=[responseObject objectForKey:@"error"];
        if (dictError) {
            
            NSString *msg = nil;
            if (!dictError[@"message"]) {
                msg = dictError[@"message"];
            }else{
                msg = @"Invalid response from server.";
            }
            
            NSError *err = [self errObjectWithMsg:msg];
            fBlock(err);
            return;
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

-(void) uploadPhoto:(UIImage *) photo withName:(NSString*)name responseBlock:(void (^)(BOOL isSuccess,NSError *err)) finishBlock{
    
}

-(void) getListOfPhotos:(void (^)(NSArray *photos,NSError *err)) finishBlock{
    
}

-(void) getPhotoWithId:(NSString *) photoId responseBlock:(void (^)(UIImage *image,NSError *err)) finishBlock{
    
}

@end
