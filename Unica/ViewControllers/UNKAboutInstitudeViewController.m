//
//  UNKAboutInstitudeViewController.m
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAboutInstitudeViewController.h"
#import "CourseDescriptionCell.h"


@interface UNKAboutInstitudeViewController ()

@end

@implementation UNKAboutInstitudeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _aboutTable.layer.cornerRadius = 5.0;
    [_aboutTable.layer setMasksToBounds:YES];
    
    _imageView.layer.cornerRadius = 5.0;
    [_imageView.layer setMasksToBounds:YES];
    
    
    
    isHude = YES;
  
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    if ([self.title isEqualToString:kABOUT]) {
        [self getAboutInstitude:self.institudeDictionary];
        
    }
    else if ([self.title isEqualToString:kINFO]) {
        
        [self getAboutInstitude:self.institudeDictionary];

        _infoArray = [[NSMutableArray alloc]initWithObjects:@"Location",@"Address",@"Founded In",@"Establishment",@"Institute Type",@"Estimated Cost of Living", nil];
    }
    [_aboutTable reloadData];


}

-(void)getAboutInstitude:(NSMutableDictionary *)selectedDictionary{
    
    _aboutInstitudeDictionary = selectedDictionary;
    [_aboutTable reloadData];
    
    [self setHeadeViewData];
    
   /* NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_about_detail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isHude = NO;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _aboutInstitudeDictionary = payloadDictionary;
                    
                    // like
                    
                    if ([[_aboutInstitudeDictionary valueForKey:kIslike]boolValue] ==true) {
                        [_likeButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
                    }
                    else{
                        [_likeButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                    }
                    [_aboutTable reloadData];
                    
                    [self setHeadeViewData];
                    
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
        
    }];*/
}

-(void)getInstitudeInfo:(NSMutableDictionary *)selectedDictionary{
   
    _aboutInstitudeDictionary = selectedDictionary;
    [self setHeadeViewData];
    [_aboutTable reloadData];


    
  /*  NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
   
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_detail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url params:(NSMutableDictionary *)dictionary timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isHude = NO;
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _aboutInstitudeDictionary = payloadDictionary;
                    // like
                    
                    if ([[_aboutInstitudeDictionary valueForKey:kis_like]boolValue] ==true) {
                        [_likeButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
                    }
                    else{
                        [_likeButton setImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                    }
                    [_aboutTable reloadData];
                    [self setHeadeViewData];
                    
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
        
    }];*/
}

-(void)setHeadeViewData{
    
    // name
    institudeNameLabel.text = [_aboutInstitudeDictionary valueForKey:kName];
    
    // image
    if (![[_aboutInstitudeDictionary valueForKey:kinstitute_image] isKindOfClass:[NSNull class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[_aboutInstitudeDictionary valueForKey:kinstitute_image]] placeholderImage:[UIImage imageNamed:@"banner"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@",error);
        }];
    }
    
    if ([[_aboutInstitudeDictionary valueForKey:kis_like]boolValue] ==true || [[_aboutInstitudeDictionary valueForKey:kIslike]boolValue] ==true ) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"FavoriteTransparent"] forState:UIControlStateNormal];
    }
    else{
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavoriteTransparent"] forState:UIControlStateNormal];
    }
    
}

#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     if ([self.title isEqualToString:kINFO]) {
         return [_infoArray count];
     }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    
     if ([self.title isEqualToString:kINFO]) {
         
     NSString *location = [_aboutInstitudeDictionary valueForKey:klocation];
         if (indexPath.row ==0) {
             
             if ([Utility getTextHeight:location size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                 height = [Utility getTextHeight:location size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
             }
             else{
                 height = 0.0;
             }
             return 60+height;
             
         }
         else if (indexPath.row == 1){
             
             
             NSString *address = [_aboutInstitudeDictionary valueForKey:kAddress];
             
             if ([Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                 height = ([Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20);
             }
             else{
                 height = 0.0;
             }
             
             return 60+height;
             
         }
         
         return 60;

     
     }
     else if ([self.title isEqualToString:kABOUT]){
     
         NSString *special = [self convertHtmlPlainText:[_aboutInstitudeDictionary valueForKey:kabout]];
         if (indexPath.row ==0) {
             
             if ([Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                 height = [Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
             }
             else{
                 height = 0.0;
             }
             return 60+height;
             
         }
         else if (indexPath.row == 1){
             
             
             NSString *why = [self convertHtmlPlainText:[_aboutInstitudeDictionary valueForKey:kwhy]];
             
             if ([Utility getTextHeight:why size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                 height = ([Utility getTextHeight:why size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20);
             }
             else{
                 height = 0.0;
             }
             
             return 60+height;
             
         }

     }

      return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"descriptionCell";
    CourseDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseDescriptionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.title isEqualToString:kABOUT]) { // about view
        
        if (indexPath.row == 0) {
            cell.headerLabel.text = @"About";
            NSString *about = [self convertHtmlPlainText:[_aboutInstitudeDictionary valueForKey:kabout]];
            
            // About
            if (![about isKindOfClass:[NSNull class]]) {
                cell._descriptionLabelHeight.constant = [Utility getTextHeight:about size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell._descriptionLabel.text = about;
            }
        }
        else if (indexPath.row == 1){
            
            cell.headerLabel.text = @"Why?";
            NSString *why = [self convertHtmlPlainText:[_aboutInstitudeDictionary valueForKey:kwhy]];
            
            //why
            if (![why isKindOfClass:[NSNull class]]) {
                cell._descriptionLabelHeight.constant = [Utility getTextHeight:why size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell._descriptionLabel.text = why;
            }
            
        }
    }
    
    else if ([self.title isEqualToString:kINFO]){
        
        
        cell.headerLabel.text = [_infoArray objectAtIndex:indexPath.row];
        
        if (indexPath.row == 0) {
            NSString *location = [_aboutInstitudeDictionary valueForKey:klocation];
            // About
            if (![location isKindOfClass:[NSNull class]]) {
                cell._descriptionLabelHeight.constant = [Utility getTextHeight:location size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell._descriptionLabel.text = location;
            }
        }
        else if (indexPath.row == 1){
            NSString *address = [_aboutInstitudeDictionary valueForKey:kAddress];
            //address
            if (![address isKindOfClass:[NSNull class]]) {
                cell._descriptionLabelHeight.constant = [Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell._descriptionLabel.text = address;
            }
            
        }
        else if (indexPath.row == 2){
            //founded
            
            NSString *founded = [_aboutInstitudeDictionary valueForKey:kfounded];
            cell._descriptionLabel.text = founded;
            
        }
        else if (indexPath.row == 3){
            //estimatecost
            NSString *estimatecost = [_aboutInstitudeDictionary valueForKey:kestablish];
            cell._descriptionLabel.text = estimatecost;
            
        }
        else if (indexPath.row == 4){
            NSString *institutetype = [_aboutInstitudeDictionary valueForKey:kinstitutetype];
            cell._descriptionLabel.text = institutetype;
        }
        else if (indexPath.row == 5){
            NSString *estimatecost = [_aboutInstitudeDictionary valueForKey:kestimatecost];
            cell._descriptionLabel.text = estimatecost;
        }
    }
    
    return  cell;
}



-(NSString*)convertHtmlPlainText:(NSString*)HTMLString{
    
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
    NSString *plainString = attrString.string;
    return plainString;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - button clicked

- (IBAction)messageButton_clicked:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessagePopViewController *messageView = [storyBoard instantiateViewControllerWithIdentifier:@"MessagePopViewController"];
    messageView.dictionary = self.institudeDictionary;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messageView];
    [self presentViewController:nav animated:YES completion:nil];}

- (IBAction)likeButtonClicked:(id)sender {
    [self institudeLike:_aboutInstitudeDictionary];
}

-(void)institudeLike:(NSMutableDictionary*)aboutInstitudeDictionary{
    
    NSString *likeString;
    NSString *message;
    
    
    if ([[aboutInstitudeDictionary valueForKey:kis_like]boolValue] == true || [[aboutInstitudeDictionary valueForKey:kIslike]boolValue] ==true ) {
        
        
        likeString = @"false";
        message = @"Removing this from your Favourites ";

        
    }
    else{
        
        likeString = @"true";
        message = @"Adding this to your Favourites";
        
    }
    
   
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    
    [dictionary setValue:likeString forKey:kstatus];
    
    if ([aboutInstitudeDictionary  valueForKey:Kid]) {
        [dictionary setValue:[aboutInstitudeDictionary  valueForKey:Kid] forKey:kinstitute_id];
    }
    else{
     [dictionary setValue:[aboutInstitudeDictionary  valueForKey:kinstitute_id] forKey:kinstitute_id];
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_institute.php"];
    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    
                    if (![self.incomingViewType isEqualToString:kFavourite]) {
                        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                        [appDelegate getFavouriteList:@"student-fav-institutes.php" :kINSTITUDE];
                    }
                    if ([self.institudeDictionary valueForKey:kis_like]) {
                        [self.institudeDictionary setValue:likeString forKey:kis_like];
                    }
                    else{
                        
                        if ([self.incomingViewType isEqualToString:kFavourite]) {
                            NSMutableDictionary *favDict = [[NSMutableDictionary alloc]init];
                            [_favouriteArray removeObject:self.institudeDictionary];
                            [favDict setValue:_favouriteArray forKey:kinstitute];
                            [UtilityPlist saveData:favDict fileName:kINSTITUDE];
                            
                        }
                        
                          [self.institudeDictionary setValue:likeString forKey:kIslike];
                        
                       
                      
                    }
                    
                    
                    [self setHeadeViewData];
                    [_aboutTable reloadData];
                    
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
