//
//  ConnectionManager.h
//  WebServiceBlocks
//
//  Created by ios on 11/8/16.
//  Copyright © 2016 Naren. All rights reserved.
//

/***************************\ *
 * Class Name : - ConnectionManager
 * Create on : - 8th Nov 2016
 * Developed By : - Naren Gairola
 * Description : - Network manager class having a singleton object.
 * Organisation Name :- Sirez
 * version no :- 1.0
 * Modified By :- Vineet kumar Patidar
 * Modified Date :-
 * Modified Reason :-
 * \***************************/

#import <Foundation/Foundation.h>
#define KAppName @"UNICA"

typedef void (^kResultBlock)(NSDictionary *dictionary, NSError *error);

@interface ConnectionManager : NSObject

+(ConnectionManager *)sharedInstance;

- (void)sendPOSTRequestForURL:(NSString *)strUrl message:(NSString*)message params:(NSMutableDictionary*)paramsDict timeoutInterval:(NSTimeInterval)timeoutInterval showHUD:(BOOL)showHUD showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

- (void)sendGETRequestForURL:(NSString *)url params:(NSMutableDictionary*)paramsData timeoutInterval:(NSTimeInterval)timeoutInterval showSystemError:(BOOL)showSystemError completion:(kResultBlock)completion;

//-(void)uploadImageToS3WithThumbnail:(UIImage *)image fileName:(NSString *)fileName completion:(kResultBlock)completion;
//-(void)uploadImageToS3:(UIImage *)image fileName:(NSString *)fileName completion:(kResultBlock)completion;
- (void)ShowMBHUDLoader;
- (void)hideMBHUDLoader;

@end
