//
//  AddBusinessCardVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "AddBusinessCardVC.h"
#import "busunesCardCell.h"
#import "remarkCell.h"
#import "TOCropViewController.h"

@interface AddBusinessCardVC ()
{
     NSMutableArray *headerTextArray;
    UITextField *deligateTextField,*organisationtextField,*emailTextField,*phonetextField,*designationtextField,*locationtextField,*actiontextField,*categoryTextField,*templatetextField,*dateTextField;
    UITextView *remarktextView;
    NSArray *actions,*category,*template;
    NSMutableDictionary *loginDictionary,*categoryDictionary,*actionDicationary,*templateDictionary;
    BOOL isImageUploaded;
    __weak IBOutlet UIButton *submitButton;
    UIImage *originalImage;
    NSString *strTemplate;
    __weak IBOutlet UILabel *lblEventName;
}

@end

@implementation AddBusinessCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    actions =[[[UtilityPlist getData:KActions] valueForKey:kAPIPayload] valueForKey:@"action_lists"];
    category =[[[UtilityPlist getData:Kcategories] valueForKey:kAPIPayload] valueForKey:@"category_lists"];
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    [self setupInitialLayout];
    if(self.detailDic!=nil)
    {
        [self SetData];
        self.title = @"Edit Business Card";
        [submitButton setTitle:@"SAVE" forState:UIControlStateNormal];
    }
    if(self.carddetailDictionary != nil)
    {
        [self setdetailDic:self.carddetailDictionary];
    }
    [self getTemplateList];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self CurrentLocationIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SetData{
    
    deligateTextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"delegate_name"] value:@""];
    designationtextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"designaion"] value:@""];
    emailTextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"email"] value:@""];
     organisationtextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"org_name"] value:@""];
    locationtextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"location"] value:@""];
    
    _eventName = [self.detailDic valueForKey:@"attending_event"];
    _eventName = [_eventName stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    lblEventName.text = _eventName;
    
    
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[self.detailDic valueForKey:@"action"] value:@""]];
    
    NSArray *filtredArray = [actions filteredArrayUsingPredicate:predicate];
    if(filtredArray.count>0)
    {
        actiontextField.text = [[filtredArray objectAtIndex:0] valueForKey:@"title"];
        actionDicationary = [filtredArray objectAtIndex:0] ;
    }
    
     NSPredicate *predicate2 =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[self.detailDic valueForKey:@"category"] value:@""]];
    NSArray *filtredArray2 = [category filteredArrayUsingPredicate:predicate2];
    if(filtredArray2.count>0)
    {
        categoryTextField.text = [[filtredArray2 objectAtIndex:0] valueForKey:@"title"];
        categoryDictionary = [filtredArray2 objectAtIndex:0] ;
    }
    
    
     NSPredicate *predicate3 =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[self.detailDic valueForKey:@"template"] value:@""]];
    NSArray *filtredArray3 = [template filteredArrayUsingPredicate:predicate3];
    if(filtredArray3.count>0)
    {
        templatetextField.text = [[filtredArray3 objectAtIndex:0] valueForKey:@"title"];
        templateDictionary = [filtredArray3 objectAtIndex:0] ;
    }
    
    if([Utility replaceNULL:[self.detailDic valueForKey:@"email_date"] value:@""].length>0)
    {
        NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
        [datePickerFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *checkIn = [datePickerFormat dateFromString:[self.detailDic valueForKey:@"email_date"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        dateTextField.text = [dateFormatter stringFromDate:checkIn];
    }
//    dateTextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"email_date"] value:@""];
    
    phonetextField.text = [Utility replaceNULL:[self.detailDic valueForKey:@"mobile"] value:@""];
    
    [cardImageView sd_setImageWithURL:[NSURL URLWithString:[self.detailDic valueForKey:@"card_image"]] placeholderImage:[UIImage imageNamed:@"camera"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            cardImageView.image = [UIImage imageNamed:@"camera"];
        }
        NSLog(@"%@",error);
    }];
    cardButton.userInteractionEnabled = false;
    
    remarktextView.text = [Utility replaceNULL:[self.detailDic valueForKey:@"remarks"] value:@""];
}
-(void)setupInitialLayout{
    headerTextArray = [[NSMutableArray alloc] initWithObjects:@"Action",@"Category",@"Location",@"Remarks",@"Template",@"Date",@"Details automatically fetched from business card",@"Delegate Name",@"Organisation Name",@"Email",@"Phone No",@"Designation", nil];
    
    CGRect frame = CGRectMake(kiPhoneWidth/2+3, 8, kiPhoneWidth/2-42, 25);
    CGRect frame2 = CGRectMake(kiPhoneWidth/2+3, 8, kiPhoneWidth/2-70, 25);
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
  
    
    deligateTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    deligateTextField.textColor = [UIColor darkGrayColor];
   // deligateTextField.backgroundColor = [UIColor redColor];
    organisationtextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    organisationtextField.textColor = [UIColor darkGrayColor];
    
    emailTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    emailTextField.textColor = [UIColor darkGrayColor];
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    
    phonetextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    phonetextField.inputAccessoryView  = [self addToolBarOnKeyboard:1];
    phonetextField.textColor = [UIColor darkGrayColor];
    phonetextField.keyboardType =UIKeyboardTypeNumberPad;
    
    
    designationtextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    designationtextField.textColor = [UIColor darkGrayColor];
    
    locationtextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    locationtextField.textColor = [UIColor darkGrayColor];
    locationtextField.returnKeyType = UIReturnKeyDone;
    
    actiontextField = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    actiontextField.textColor = [UIColor darkGrayColor];
    actiontextField.userInteractionEnabled = false;
    actiontextField.placeholder = @"Select";
    //actiontextField.backgroundColor = [UIColor redColor];
    
    categoryTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    categoryTextField.textColor = [UIColor darkGrayColor];
    categoryTextField.userInteractionEnabled = false;
    categoryTextField.placeholder = @"Select";
    
    templatetextField = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    templatetextField.textColor = [UIColor darkGrayColor];
    templatetextField.userInteractionEnabled = false;
    templatetextField.placeholder = @"Select";
    
    dateTextField = [Control newTextFieldWithOptions:optionDictionary frame:frame delgate:self];
    dateTextField.textColor = [UIColor darkGrayColor];
    dateTextField.userInteractionEnabled = false;
    
    remarktextView = [[UITextView alloc] init];
    remarktextView.frame = CGRectMake(13, 39, kiPhoneWidth-45, 63);
    remarktextView.delegate = self;
    remarktextView.textColor  = [UIColor darkGrayColor];
    remarktextView.font = kDefaultFontForTextField;
    //remarktextView.backgroundColor = [UIColor redColor];
    
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 3 || indexPath.row==6)
    {
        if(indexPath.row == 3 )
        {
            static NSString *cellIdentifier3  =@"signIn8";
            
            
            remarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"remarkCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[cell.remarktextView removeFromSuperview];
            cell.remarktextView = remarktextView;
            [cell.contentView addSubview:remarktextView];
            return cell;
        }
        else
        {
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            CGRect frame = CGRectMake(10,5 , kiPhoneWidth-30, 40   );

            UILabel *lbl2 = [[UILabel alloc] initWithFrame:frame];
            lbl2.font = kDefaultFontForTextFieldMeium;
            lbl2.text = [headerTextArray objectAtIndex:indexPath.row];
            lbl2.numberOfLines = 0;
            [cell.contentView addSubview:lbl2];
           
           // cell.backgroundColor = [UIColor redColor];
            return cell;
        }
        
        
    }
    else
    {
        static NSString *cellIdentifier3  =@"signIn";
        
        busunesCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"busunesCardCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        cell.contentLabel.text = [headerTextArray objectAtIndex:indexPath.row];
         [cell.contenttextField removeFromSuperview];
        
         if (indexPath.row == 0) {
            cell.dropImageView.constant = 25;
            cell.contenttextField =actiontextField;
            
            
        }
        else if (indexPath.row == 1) {
            cell.dropImageView.constant = 25;
            cell.contenttextField =categoryTextField;
            
        }
        else if (indexPath.row == 2) {
            cell.contenttextField = locationtextField;
            
        }
        else if (indexPath.row == 4) {
           // cell.contentLabel.text = @"Select Template";
            cell.dropImageView.constant = 25;
            cell.contenttextField =templatetextField;
            if (![strTemplate isEqualToString:@""]) {
                cell.lblTemplate.hidden = false;
                cell.lblTemplate.text = strTemplate;
            }
        }
        else if (indexPath.row == 5) {
           // cell.contentLabel.text = @"Select Date";
            cell.dropImageView.constant = 25;
            cell.dropdown.image = [UIImage imageNamed:@"Calendar"];
            cell.contenttextField =dateTextField;
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kiPhoneWidth-45, 1)];
            lbl.backgroundColor = [UIColor lightGrayColor];
            [cell.contentView addSubview:lbl];
            
        }
       else if (indexPath.row == 7) {
            
            cell.contenttextField = deligateTextField;
            
        }
        else if (indexPath.row == 8) {
            cell.contenttextField = organisationtextField;
            
        }
        else if (indexPath.row == 9) {
            cell.contenttextField = emailTextField;
            
        }
        else if (indexPath.row == 10) {
            cell.contenttextField = phonetextField;
            
        }
        else if (indexPath.row == 11) {
            cell.contenttextField = designationtextField;
            
        }
        
        
        [cell.contentView addSubview:cell.contenttextField];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        if (indexPath.row == 0) {
            
            if(actions.count>0)
            {
                NSArray *items = [actions valueForKey:@"title"];
                
                self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
                    
                    NSArray *filtredArray = [actions filteredArrayUsingPredicate:predicate];
                    if(filtredArray.count>0)
                    {
                        actiontextField.text = [NSString stringWithFormat:@"%@", selected];
                        actionDicationary = [filtredArray objectAtIndex:0];
                    }
                    
                    
                } cancelCallback:nil];
                
                [self.picker presentPickerOnView:self.view];
                self.picker.title = @"Select Actions";
                [self.picker selectValue:actiontextField.text];
            }
            
            
        }
        else if (indexPath.row == 1) {
            if(category.count>0)
            {
                NSArray *items = [category valueForKey:@"title"];
                
                self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
                    
                    NSArray *filtredArray = [category filteredArrayUsingPredicate:predicate];
                    if(filtredArray.count>0)
                    {
                        categoryTextField.text = [NSString stringWithFormat:@"%@", selected];
                        categoryDictionary = [filtredArray objectAtIndex:0];
                    }
                    
                    
                } cancelCallback:nil];
                
                [self.picker presentPickerOnView:self.view];
                self.picker.title = @"Select Category";
                [self.picker selectValue:categoryTextField.text];
            }
            
            
        }
    
      else  if (indexPath.row == 4) {
          
          if(template.count>0)
          {
              NSArray *items = [template valueForKey:@"title"];
              
              self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
                  
                  NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
                  
                  NSArray *filtredArray = [template filteredArrayUsingPredicate:predicate];
                  if(filtredArray.count>0)
                  {
                      templatetextField.text = [NSString stringWithFormat:@"%@", selected];
                      templateDictionary = [filtredArray objectAtIndex:0];
                  }
                  
              } cancelCallback:nil];
              
              [self.picker presentPickerOnView:self.view];
              self.picker.title = @"Select Template";
              [self.picker selectValue:templatetextField.text];
          }
          
            
            
        }
        else if (indexPath.row == 5 ) {
            
            
            self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate date] to:[NSDate dateWithTimeIntervalSinceNow:+60*60*24*365*48] interval:5 selectCallback:^(id selected) {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                //[dateFormatter setDateFormat:@"dd/MM/yyyy"];
                [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                NSString *selectedDate = [dateFormatter stringFromDate:selected];
                
                double seconds = [selected timeIntervalSince1970];
                
                
                dateTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
                
            } cancelCallback:^{
            }];
            
            self.picker.title = @"Select Date";
            [self.picker presentPickerOnView:self.view];
            [self.picker selectDate:self.dateCellSelectedDate];
        }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==3)
    {
        return 140;
    } else if (indexPath.row == 4) {
        return 72;
    }
    else if (indexPath.row==5)
    {
        return 60;
    }
    else if (indexPath.row==6)
    {
        return 45;
    }
    return 50;
}




- (IBAction)backButton_Action:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButton_Action:(id)sender {
    if([self Validation])
    {
        [self addCard];
    }
}

- (IBAction)imageButton_Action:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Profile Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Upload from Gallery" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{}];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Camera Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[_profileButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // _profileImage.image = image;
    CGRect rect = CGRectMake(0,0,200,200);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    isImageUploaded= true;
    //cardImageView.image = picture1;
    originalImage =image;
    [self dismissViewControllerAnimated:YES completion:nil];
     [self presentCropViewController];
//     [self getCarddetailDic];
    
}
- (void)presentCropViewController
{
    UIImage *image = originalImage; //Load an image
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    cardImageView.image =[Utility compressImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self getCarddetailDic:image];
    [self getCarddetailDic:[Utility compressImage:image]];
    // 'image' is the newly cropped version of the original image
}
-(void)getCarddetailDic:(UIImage*)img{
    
    //NSMutableDictionary *resultsDictionary;
    dispatch_async( dispatch_get_main_queue(), ^{
        
        [Utility ShowMBHUDLoader];
    });
    NSData *imageData = UIImagePNGRepresentation(img);
    NSString *encodedString= [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSMutableDictionary *userDictionary = [[NSMutableDictionary alloc] init];
    
    [userDictionary setValue:encodedString forKey:@"image"];
    
//    NSDictionary *userDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"first title", @"title",@"1",@"blog_id", nil];//if your json structure is something like {"title":"first title","blog_id":"1"}
    if ([NSJSONSerialization isValidJSONObject:userDictionary]) {//validate it
        NSError* error;
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:userDictionary options:NSJSONWritingPrettyPrinted error: &error];
        NSURL* url = [NSURL URLWithString:@"http://103.91.90.242/cloud-api"];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
        [request setHTTPMethod:@"POST"];//use POST
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-length"];
        [request setHTTPBody:jsonData];//set data
        __block NSError *error1 = [[NSError alloc] init];
        
        //use async way to connect network
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse* response,NSData* data,NSError* error)
        {
            if ([data length]>0 && error == nil) {
                NSMutableDictionary * resultsDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility hideMBHUDLoader];
                    if(resultsDictionary.count>0)
                    {
                        [self setdetailDic:resultsDictionary];
                    }
                });
                
                NSLog(@"resultsDictionary is %@",resultsDictionary);
                
            } else if ([data length]==0 && error ==nil) {
                NSLog(@" download data is null");
            } else if( error!=nil) {
                NSLog(@" error is %@",error);
            }
        }];
    }
    
   
    
}
-(void)getTemplateList{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
   userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"template-lists.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    template = [payloadDictionary valueForKey:@"template_lists"];
                    if(self.detailDic!=nil)
                    {
                        [self SetData];
                    }
                }else{
                    strTemplate = [dictionary valueForKey:@"Message"];
                    [registerTable reloadData];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
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
-(void)addCard
{
    
    if(![Utility connectedToInternet])
    {
        [Utility hideMBHUDLoader];
        [Utility showAlertViewControllerIn:self title:@"" message:@"Internet not connected" block:^(int index){
            return;
        }];
    }
    else
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [Utility ShowMBHUDLoader];
        });
        NSMutableURLRequest *request = nil;
        NSLog(@"image upload");
        
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scan_card.php"];
        
        
        
        NSMutableData *body = [NSMutableData data];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        
        
        //** step 1 **//
        // first Name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[loginDictionary valueForKey:@"id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // missle name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[loginDictionary valueForKey:@"user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // last name
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"delegate_name"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[deligateTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Citizen Country
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"org_name"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[organisationtextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // DOB
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"email"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[emailTextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"location"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[locationtextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *actionId;
        if(actionDicationary!=nil)
        {
            actionId = [NSString stringWithFormat:@"%@",[actionDicationary valueForKey:@"id"]];
        }
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"action"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[actionId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"remarks"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[remarktextView.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *templateid;
        if(templateDictionary!=nil)
        {
            templateid = [NSString stringWithFormat:@"%@",[templateDictionary valueForKey:@"id"]];
        }
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"template"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[templateid dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *date ;
        if(dateTextField.text.length>0)
        {
            NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"dd/MM/yyyy"];
            NSDate *checkIn = [datePickerFormat dateFromString:dateTextField.text];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            date = [dateFormatter stringFromDate:checkIn];
        }
       
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"email_date"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[date dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Mobile Number
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"designaion"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[designationtextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // SkypeID
        
        //Native Language
       
        
        // Martial Status
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"mobile"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[phonetextField.text dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        if ([_eventName isEqualToString:@""]) {
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,@"attendingEvent"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[appDelegate.addressString dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        } else {
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,@"attendingEvent"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[_eventName dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        // Mobile Number
        NSString *categoryId;
        if(categoryDictionary!=nil)
        {
            categoryId = [NSString stringWithFormat:@"%@",[categoryDictionary valueForKey:@"id"]];
        }
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"category"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[categoryId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // SkypeID
        if(self.detailDic!=nil)
        {
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,@"business_card_id"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@",[self.detailDic valueForKey:@"id"]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        
        
        //profileImage
      //  if ([[dictionary valueForKey:kProfileImage] isKindOfClass:[UIImage class]]) {
            
            
            
            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(cardImageView.image)];
            if (imageData)
            {
                // image File
                [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"card_image"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            
       // }
        
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:body];
        
        
        
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
        
        defaultConfigObject.timeoutIntervalForRequest = 400;
        defaultConfigObject.timeoutIntervalForResource = 650;
        NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // Process the response
            dispatch_async( dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
            });
            
            
            if(error != nil) {
                
                
                if ((!data) || data== nil) {
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        if(![Utility connectedToInternet])
                        {
                            [Utility showAlertViewControllerIn:self title:@"" message:kErrorMsgSlowInternet block:^(int index){
                                return;
                            }];
                        }
                        else
                        {
                            return;
                        }
                    });
                    
                    
                }
                else{
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    
                    NSLog(@"Error %@",[error userInfo]);
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                        
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            NSLog(@"finished");
                            
                            
                            
                            
                        });
                        
                    }];
                    
                }
                
                
                
            }
            else {
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
                
                NSLog(@"Error %@",[error userInfo]);
                
                [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                    
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        NSLog(@"finished");
                        if(self.detailDic==nil)
                        {
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        else
                        {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        }
                        
                        
                        
                    });
                    
                }];
            }
            
        }];
        
        [uploadTask resume];
    }
}
    
    
-(BOOL)Validation
{
    if(actionDicationary==nil)
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select action" block:^(int index) {
            CGPoint buttonPosition = [actiontextField convertPoint:CGPointZero toView:registerTable];
            [Utility scrolloTableView:registerTable point:buttonPosition indexPath:nil];
            ;
        }];
        return false;
    }
   else if(categoryDictionary==nil)
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select category" block:^(int index) {
            CGPoint buttonPosition = [categoryTextField convertPoint:CGPointZero toView:registerTable];
            [Utility scrolloTableView:registerTable point:buttonPosition indexPath:nil];
            
        }];
        return false;
    }
   else if(![Utility validateField:emailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter  email" block:^(int index) {
            CGPoint buttonPosition = [emailTextField convertPoint:CGPointZero toView:registerTable];
            [Utility scrolloTableView:registerTable point:buttonPosition indexPath:nil];
            [emailTextField becomeFirstResponder];
        }];
        return false;
    }
    else  if((emailTextField.text.length>0)&&![Utility validateEmail:emailTextField.text] ){
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please enter valid email" block:^(int index) {
            CGPoint buttonPosition = [emailTextField convertPoint:CGPointZero toView:registerTable];
            [Utility scrolloTableView:registerTable point:buttonPosition indexPath:nil];
            [emailTextField becomeFirstResponder];
        }];
        return false;
    }
//   else if(!isImageUploaded && self.detailDic==nil){
//        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please upload business card image" block:^(int index) {
//            CGPoint buttonPosition = [emailTextField convertPoint:CGPointZero toView:registerTable];
//            [Utility scrolloTableView:registerTable point:buttonPosition indexPath:nil];
//
//        }];
//        return false;
//    }
    
   
    
    return true;
}
#pragma TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    else
    {
        if (textField == deligateTextField) {
            
            [organisationtextField becomeFirstResponder];
        }
        else if (textField == organisationtextField) {
            
            [emailTextField becomeFirstResponder];
        }
        else if (textField == emailTextField) {
            
            [phonetextField becomeFirstResponder];
        }
        else if (textField == phonetextField) {
            
            [designationtextField becomeFirstResponder];
        }
        else if (textField == designationtextField) {
            
            [locationtextField becomeFirstResponder];
        }
        else if (textField == locationtextField) {
            
            [remarktextView becomeFirstResponder];
        }
        
    }
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *strQueryString;
    if((range.length == 0) && (string.length > 0)){
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        strQueryString = [NSString stringWithFormat:@"%@%@%@",strStarting,string,strEnding];
    }
    else{
        NSString *strStarting = [textField.text substringToIndex:range.location];
        NSString *strEnding = [textField.text substringFromIndex:range.location];
        if(strEnding.length > 0)
            strEnding = [strEnding substringFromIndex:range.length];
        strQueryString = [NSString stringWithFormat:@"%@%@",strStarting,strEnding];
    }
    
    if(strQueryString.length == 0){
        return YES;
    }
    
    if(textField == phonetextField )
    {
        
        
        // All digits entered
//        if (range.location == 14) {
//            return NO;
//        }
        
        /*
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"(" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@")" withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@" " withString:@""];
         strQueryString = [strQueryString stringByReplacingOccurrencesOfString:@"-" withString:@""];
         
         PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
         NSLog(@"%@",[formatter formatForUS:strQueryString]);
         
         textField.text = [formatter formatForUS:strQueryString];*/
        
        
        textField.text = phonetextField.text;
        
        
        return YES;
    }
    
   
    else {
        
        // All digits entered
        if (range.location == 50) {
            return NO;
        }
    }
    return YES;
}
-(UIToolbar *)addToolBarOnKeyboard :(NSInteger) tag{
    
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(keyboardDoneButtonPressed:)];
    doneButton.tag = tag;
    doneButton.tintColor = [UIColor lightGrayColor];
    [keyboardToolbar setItems:[NSArray arrayWithObjects:flexibleSpace, doneButton, nil]];
    
    return keyboardToolbar;
}

-(void)keyboardDoneButtonPressed:(UIBarButtonItem*) sender{
    
    [phonetextField resignFirstResponder];
    
}
-(void)setdetailDic:(NSMutableDictionary*)dic{
    
    deligateTextField.text = [Utility replaceNULL:[dic valueForKey:@"NAME"] value:@""];
     emailTextField.text = [Utility replaceNULL:[dic valueForKey:@"EMAIL"] value:@""];
     organisationtextField.text = [Utility replaceNULL:[dic valueForKey:@"ORGANIZATION"] value:@""];
     phonetextField.text = [Utility replaceNULL:[dic valueForKey:@"MOBILE"] value:@""];
     designationtextField.text = [Utility replaceNULL:[dic valueForKey:@"DESIGNATION"] value:@""];
     deligateTextField.text = [Utility replaceNULL:[dic valueForKey:@"NAME"] value:@""];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSLog(@"%@",appDelegate.addressString);
    locationtextField.text = appDelegate.addressString;
    cardImageView.image = self.compressedcardImage;
    
    
    
}
#pragma mark - CLLocation Manager

/****************************
 * Function Name : - CurrentLocationIdentifier
 * Create on : - 23th Nov 2016
 * Developed By : - Ramniwas
 * Description : - This method for get user current location
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)CurrentLocationIdentifier {
    if (!locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 100;
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        
        [locationManager requestWhenInUseAuthorization];
        
    }
    
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    currentLocation = [locations objectAtIndex:0];
    [locationManager stopUpdatingLocation];
    
    self.lat = (double) currentLocation.coordinate.latitude;
    self.lon = (double)  currentLocation.coordinate.longitude;
    
    if (geocoder) {
        [geocoder cancelGeocode];
    }
    geocoder = [[CLGeocoder alloc] init] ;
    
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             //             NSString *area = [placemark.addressDictionary objectForKey:@"SubAdministrativeArea"];
             //             NSString *nameString = [placemark.addressDictionary valueForKey:@"Name"];
             
             NSString *city = [placemark.addressDictionary objectForKey:@"City"];
             
             NSString *country = [placemark.addressDictionary objectForKey:@"Country"];
             
             NSString *address = [NSString stringWithFormat:@"%@",city];
             
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.addressString = address;
             locationtextField.text = address;
             
         }
         else{
             NSLog(@"Geocode failed with error %@", error);
             AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             appDelegate.addressString = @"";
         }
     }];
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    NSString * message=nil;
    switch (status) {
            
        case kCLAuthorizationStatusRestricted:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tap on setting to enable location services!";
            
            break;
            
        case kCLAuthorizationStatusNotDetermined:
            message=@"Location services are required for this app, please authorize this application to use location service. Please tlease tap on setting to enable location services!";
            
            break;
        case kCLAuthorizationStatusDenied:
            message=@"Location services are off. Please tap on setting to enable location services!";
            
            
            break;
            
        case kCLAuthorizationStatusAuthorizedAlways:
            
            break;
            
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            
            break;
            
            
        default:
            
            
            break;
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    self.lat = 0;
    self.lon = 0;
    // NSLog(@"location off");
    NSString *message=nil;
    if ([error domain] == kCLErrorDomain)
    {
        switch ([error code]){
            case kCLErrorDenied:
                
                break;
                
            default:
                message=@"No GPS coordinates are available. Please take the device outside to an open area.";
                break;
        }
    }
    
    [self CurrentLocationIdentifier];
    
    
}
@end
