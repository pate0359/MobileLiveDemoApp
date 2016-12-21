//
//  MobileLiveDemoAppTests.m
//  MobileLiveDemoAppTests
//
//  Created by Nignesh on 2016-12-20.
//  Copyright © 2016 patel.nignesh2108@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AFNetworking.h"

@interface MobileLiveDemoAppTests : XCTestCase

@end

@implementation MobileLiveDemoAppTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testUserLogin
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"user login request"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://mobilelive.getsandbox.com"]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = @{@"username": @"User1",
                             @"password": @"User1"
                             };
    
    [manager POST:@"http://mobilelive.getsandbox.com/users/login" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for status code
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = httpResponse.statusCode;
            //HTTP statuscode must be 200
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
            
            NSString *coockie = [[httpResponse allHeaderFields] valueForKey:@"Set-Cookie"];
            [[NSUserDefaults standardUserDefaults] setObject:coockie forKey:@"Set-Cookie"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //responseObject is nill
        XCTAssert(responseObject, @"responseObject nil");
        
        [expectation fulfill];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //Error object is nill
        XCTAssertNil(error, @"login error %@", error);
    }];
    
    //Request should complete in 60 secs
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}

- (void)testRegisterUser
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"user resgistration request"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://mobilelive.getsandbox.com"]];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSDictionary *params = @{@"username": @"testUser",
                             @"password": @"12345",
                             @"firstname": @"Test Fname",
                             @"lastname": @"Test Lname",
                             @"phone": @"111-212-1223"
                             };
    
    [manager POST:@"http://mobilelive.getsandbox.com/users" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for status code
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = httpResponse.statusCode;
            //HTTP statuscode must be 200
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
        }
        
        //responseObject is nill
        XCTAssert(responseObject, @"responseObject nil");
        
        [expectation fulfill];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //Error object is nill
        XCTAssertNil(error, @"login error %@", error);
    }];
    
    //Request should complete in 60 secs
    [self waitForExpectationsWithTimeout:60.0 handler:nil];

}

- (void)testUploadPhoto
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous user login request"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://mobilelive.getsandbox.com"]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    //Session-id nil
    XCTAssert([[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"], @"session-id nil");

    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"cookie"];
    
    UIImage *photo = [UIImage imageNamed:@"test.jpg"];
    NSString *strImage = [UIImagePNGRepresentation(photo) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary *params = @{@"name": @"testPhoto",
                             @"data": strImage
                             };
    
    [manager POST:@"http://mobilelive.getsandbox.com/v2/photos" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for status code
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = httpResponse.statusCode;
            //HTTP statuscode must be 200
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
        }
        //responseObject is nill
        XCTAssert(responseObject, @"responseObject nil");
        
        [expectation fulfill];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //Error object is nill
        XCTAssertNil(error, @"login error %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}

- (void)testGetListOfPhotos
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"asynchronous user login request"];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://mobilelive.getsandbox.com"]];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //Session-id nil
    XCTAssert([[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"], @"session-id nil");
    
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Set-Cookie"] forHTTPHeaderField:@"cookie"];
    
    [manager GET:@"http://mobilelive.getsandbox.com/v2/photos" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //Check for status code
        if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
            
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
            NSInteger statusCode = httpResponse.statusCode;
            //HTTP statuscode must be 200
            XCTAssertEqual(statusCode, 200, @"status code was not 200; was %ld", (long)statusCode);
        }
        //responseObject is nill
        XCTAssert(responseObject, @"responseObject nil");
        
        [expectation fulfill];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //Error object is nill
        XCTAssertNil(error, @"login error %@", error);
    }];
    
    [self waitForExpectationsWithTimeout:60.0 handler:nil];
}

@end
