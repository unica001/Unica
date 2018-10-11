//
//  UNKWelcomeViewController.m
//  Unica
//
//  Created by vineet patidar on 07/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKWelcomeViewController.h"

@interface UNKWelcomeViewController ()<NSURLSessionTaskDelegate>{
    UIImagePickerControllerSourceType type;

}

@end

@implementation UNKWelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSMutableDictionary *loginInfoDictionary  = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    _profileImage.layer.cornerRadius = _profileImage.frame.size.width/2;
    _profileImage.layer.borderWidth = 5;
    _profileImage.layer.borderColor = [UIColor colorWithRed:30.0f/255.0f green:55.0f/255.0f blue:83.0f/255.0f alpha:1].CGColor;
    [_profileImage.layer setMasksToBounds:YES];
    
    // image
    if (![[loginInfoDictionary valueForKey:kProfile_image] isKindOfClass:[NSNull class]]) {
        NSString *imageUrl = [loginInfoDictionary valueForKey:kProfile_image];
        
        [_profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
                _profileImage.image = [UIImage imageNamed:@"userimageplaceholder"];
            }
        }];
        

    }
    
    _nameLabel.text = [loginInfoDictionary valueForKey:kfirstname];
    

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;

}
-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




#pragma mark - button clicked

- (IBAction)updateProfileImageButton_clicked:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Set Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload from Gallery", @"Take Camera Picture", nil];
    [sheet showInView:self.view.window];
}

- (IBAction)nextButton_clicked:(id)sender {
    
    NSMutableDictionary *_logininfo = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]] ;
    [_logininfo setValue:@"false" forKey:KwelcomeScreen];
    [kUserDefault setObject:[Utility archiveData:_logininfo] forKey:kLoginInfo];
    [self performSegueWithIdentifier:kMPStep1SegueIdentifier sender:nil];
}

#pragma mark- Actionsheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==actionSheet.cancelButtonIndex){
        return;
    }
    
    
    if(buttonIndex==0){
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    else  {
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate   = self;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:nil];
    
    
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _profileImage.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    [self methodForuploadImage:image];
  
}

#pragma mark - APIS

-(void)updateProfileImage:(NSMutableDictionary*)dictionary{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-profile-photo.php"];

    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    [Utility showAlertViewControllerIn:self title:@"Register" message:[dictionary valueForKey:kAPIMessage] block:^(int index){
                        
                        NSLog(@"%@",dictionary);
                        
                    }];
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}

#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
-(void)methodForuploadImage:(UIImage *)image
{
    
    NSMutableURLRequest *request = nil;
    NSLog(@"image upload");
    
       NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"update-profile-photo.php"];
    
    NSMutableDictionary *loginInfoDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    NSString *userID;
    
    if ([[loginInfoDictionary valueForKey:Kid] length]>0 && ![[loginInfoDictionary valueForKey:Kid] isKindOfClass:[NSNull class]]) {
         userID = [loginInfoDictionary valueForKey:Kid];
    }
    else{

        userID = [loginInfoDictionary valueForKey:kUser_id];

    }
    
    [Utility ShowMBHUDLoader];
    NSMutableData *body = [NSMutableData data];
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    // User ID
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent,@"userid"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // images
    
    if (type == UIImagePickerControllerSourceTypeCamera) {
        image = [Utility rotateImageAppropriately:image];
    }
    
    NSData *image_videoData;
    image_videoData = UIImageJPEGRepresentation(image, 1.0);
    if (image_videoData)
    {
        // image File
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"profile_image"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:image_videoData];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // Process the response
        
        if(error != nil) {
            
            NSLog(@"Error %@",[error userInfo]);
            
            [Utility hideMBHUDLoader];

        } else {
            

            [Utility hideMBHUDLoader];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&error];

            NSLog(@"%@",json);
            
            if ([[json valueForKey:@"Status"] boolValue] == true) {
                [self editProfile];
            }
            
            [Utility hideMBHUDLoader];
  
        }
        //  [hud hide:YES];
        
    }];
    
    [uploadTask resume];
    
}

-(void)editProfile{
    
    NSMutableDictionary *_loginInfo =  [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    NSString *userID;
    
    if ([[_loginInfo valueForKey:Kid] length]>0 && ![[_loginInfo valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        userID = [_loginInfo valueForKey:Kid];
    }
    else {
        userID = [_loginInfo valueForKey:Kuserid];

    }
    
    [dictionary setValue:userID forKey:kUser_id];

    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"get_profile.php"];
    
       [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
    
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [payloadDictionary setValue:userID forKey:Kuserid];
                    
                    [kUserDefault setValue:[Utility archiveData:payloadDictionary] forKey:kLoginInfo];
                 
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
            
        }
        
        
    }];
    
}
@end
