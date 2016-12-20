//
//  MLNetworkService.h
//  MobileLiveDemoApp
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@interface MLNetworkService : NSObject

//Singleton
+(MLNetworkService *) sharedInstance;

//Public methods
-(void) registerUser:(NSDictionary *) params responseBlock:(void (^)(NSDictionary *userDetails,NSError *err)) finishBlock;

-(void) loginwithUserName:(NSString *) username password:(NSString*)password responseBlock:(void (^)(NSDictionary *userDetails,NSError *err)) finishBlock;
-(void) uploadPhoto:(UIImage *) photo withName:(NSString*)name responseBlock:(void (^)(BOOL isSuccess,NSError *err)) finishBlock;
-(void) getListOfPhotos:(void (^)(NSDictionary *response,NSError *err)) finishBlock;
-(void) getPhotoWithId:(NSString *) photoId responseBlock:(void (^)(NSDictionary *photo,NSError *err)) finishBlock;

@end
