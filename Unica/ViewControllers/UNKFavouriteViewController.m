//
//  UNKFavouriteViewController.m
//  Unica
//
//  Created by vineet patidar on 06/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKFavouriteViewController.h"
#import "FavouriteCell.h"
#import "UNKInstitudeViewController.h"
#import "UNKAgentViewController.h"
#import "UNKCourseViewController.h"
#import "UNKAgentDetailsSliderViewController.h"
#import "UNKCourseDetailsViewController.h"

@interface UNKFavouriteViewController (){

    NSString *_apiNameString;
}

@end

@implementation UNKFavouriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pageNumber = 1;
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Favourite"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, kiPhoneHeight/2, self.view.frame.size.width-100, 40)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.hidden  = YES;

    [self.view addSubview:messageLabel];
    
     heartImage  = [[UIImageView alloc]initWithFrame:CGRectMake(50, kiPhoneHeight/2, 40, 40)];
    heartImage.image = [UIImage imageNamed:@"HomeFavorites"];
    [self.view addSubview:heartImage];
    heartImage.hidden = YES;

   // [self getFavouriteList:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"%@",self.title);
    
    
    
    if ([self.title isEqualToString:kAGENT]) {
        [self getFavouriteAgent:self.title];
    }
    else  if ([self.title isEqualToString:kINSTITUDE]) {
        [self getFavouriteInstitude:self.title];

    }
    else  if ([self.title isEqualToString:kCOURSES]) {
        [self getFavouriteCourse:self.title];
    }
}


/****************************
 * Function Name : -  getFavouriteAgent
 * Create on : - 5 April 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get favourite course data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)getFavouriteAgent:(NSString *)title{
    
    if (_favouriteArray) {
        [_favouriteArray removeAllObjects];
    }
    self.title = title;
    pageNumber = 1;

    if ([self.title isEqualToString:kAGENT]) {
        NSMutableDictionary *dict = (NSMutableDictionary *)[UtilityPlist getData:kAGENT];
        NSLog(@"%@",dict);
        if ([dict isKindOfClass:[NSDictionary class]]) {
            _favouriteArray = [dict valueForKey:Kagent];
            [_favouriteTabel reloadData];

            _apiNameString = @"student-fav-agents.php";
            [self getFavouriteList:NO];

        }
        else{
            _apiNameString = @"student-fav-agents.php";
            [self getFavouriteList:NO];
        }
    }
    
    

}

/****************************
 * Function Name : -  getFavouriteCourse
 * Create on : - 5 April 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get favourite course data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)getFavouriteCourse:(NSString *)title{
    
    pageNumber = 1;
    self.title = title;
    
    if (_favouriteArray) {
        [_favouriteArray removeAllObjects];
    }
    
     if ([self.title isEqualToString:kCOURSES]) {
        NSMutableArray *array = (NSMutableArray *)[UtilityPlist getData:kCOURSES];
        if ([array isKindOfClass:[NSMutableArray class]]) {
            _favouriteArray = array;
            [_favouriteTabel reloadData];
            
            _apiNameString = @"student-fav-courses.php";
            [self getFavouriteList:NO];
        }
        else {
            _apiNameString = @"student-fav-courses.php";
            [self getFavouriteList:NO];
        }
    }
    
 
}

/****************************
 * Function Name : -  getFavouriteInstitude
 * Create on : - 5 April 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get favourite Institude data
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (void)getFavouriteInstitude:(NSString *)title{
    
    if (_favouriteArray) {
        [_favouriteArray removeAllObjects];
    }
    self.title = title;
    pageNumber = 1;
     if ([self.title isEqualToString:kINSTITUDE]) {
        NSMutableDictionary *dict = (NSMutableDictionary *)[UtilityPlist getData:kINSTITUDE];
         if ([dict isKindOfClass:[NSDictionary class]]) {
            _favouriteArray = [dict valueForKey:kinstitute];
             NSArray * newArray =
             [[NSOrderedSet orderedSetWithArray:_favouriteArray] array];
             _favouriteArray =[[NSMutableArray alloc] initWithArray:newArray];
             
            [_favouriteTabel reloadData];

            _apiNameString = @"student-fav-institutes.php";
            [self getFavouriteList:NO];
        }
        else{
            _apiNameString = @"student-fav-institutes.php";
            [self getFavouriteList:NO];
        }
    }
}

#pragma  mark - APIS

-(void)getFavouriteList:(BOOL)showHude{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }

    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,_apiNameString];
        
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    isLoading = NO;
                    if (pageNumber == 1 ) {
                        if (_favouriteArray) {
                            [_favouriteArray removeAllObjects];
                        }
                        
                        // check incoming view type
                        
                        if ([self.title isEqualToString:kAGENT]) {
                            _favouriteArray = [payloadDictionary valueForKey:Kagent];
                        }
                        else if ([self.title isEqualToString:kCOURSES]) {
                            _favouriteArray = [dictionary valueForKey:kAPIPayload];
                        }
                        else if ([self.title isEqualToString:kINSTITUDE]) {
                            _favouriteArray = [payloadDictionary valueForKey:kinstitute];
                        }
                        if(_favouriteArray.count>=10)
                        {
                            pageNumber = 2;
                        }
                        
                    }
                    else{
                        
                        // check incoming view type
                        NSMutableArray *arr;
                        
                        if ([self.title isEqualToString:kAGENT]) {
                            arr = [payloadDictionary valueForKey:Kagent];
                        }
                        else if ([self.title isEqualToString:kCOURSES]) {
                            arr = [dictionary valueForKey:kAPIPayload];;
                        }
                        else if ([self.title isEqualToString:kINSTITUDE]) {
                            arr = [payloadDictionary valueForKey:kinstitute];
                        }
                        
                        if(arr.count > 0){
                            [_favouriteArray addObjectsFromArray:arr];
                            
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:_favouriteArray] array];
                            _favouriteArray =[[NSMutableArray alloc] initWithArray:newArray];

                        }
                        
                        NSLog(@"%lu",(unsigned long)_favouriteArray.count);
                        if(arr.count>=10)
                        {
                            pageNumber = pageNumber+1 ;
                        }
                        
                    }
                    
                    // save data in plist
                    
                    if ([self.title isEqualToString:kAGENT]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kAGENT];
                    }
                    else if ([self.title isEqualToString:kCOURSES]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kCOURSES];
                    }
                    else if ([self.title isEqualToString:kINSTITUDE]) {
                        [UtilityPlist saveData:payloadDictionary fileName:kINSTITUDE];

                    }
                 
                    [_favouriteTabel reloadData];
                    
                    messageLabel.text = @"";
                    heartImage.hidden = YES;
                    
                    
                }else{
                    
                    _favouriteTabel.tableFooterView = nil;
                    if ([self.title isEqualToString:kAGENT]) {
                        messageLabel.text = @"Like agents to add as favourite.";
                    }
                    else if ([self.title isEqualToString:kCOURSES]) {
                        messageLabel.text = @"Like courses to add as favourite.";
                    }
                    else if ([self.title isEqualToString:kINSTITUDE]) {
                       messageLabel.text = @"Like institutes to add as favourite.";
                        
                    }
                    messageLabel.hidden = NO;
                    
                    heartImage.hidden = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber ==1) {
                            
                            
                            if (_favouriteArray) {
                                [_favouriteArray removeAllObjects];
                                [_favouriteTabel reloadData];
                            }
                                                   }
                        
                      //  [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                       // }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                messageLabel.text = @"";
                heartImage.hidden = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}
#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_favouriteArray.count>0)
    {
        return [_favouriteArray count];
    }
    else
    {
        return 0;
    }
  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_favouriteArray.count>0)
    {
        return 1;
    }
    else
    {
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_favouriteArray.count>0)
    {
        double height = 0.0;
        
        // set consultancy name
        NSString *_consultancyName;
        
        // address
        NSString *_address;
        
        if ([self.title isEqualToString:kAGENT]) {
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAgent_consultancy_name];
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAddress];
            
        }
        else if ([self.title isEqualToString:kCOURSES]) {
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kcourse_name];
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kUnivercity_name];
        }
        else if ([self.title isEqualToString:kINSTITUDE]) {
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kinstitute_name];
            
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAddress];
        }
        
        
        if ( [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
            
            height = [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForApp]-20;
        }
        else {
            height = 0;
        }
        
        
        if ( [Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth- 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium] >20) {
            
            height = ([Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth-120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20)+height;
        }
        else {
            height = 0+height;
        }
        
        return 100+height;
    }
    else
    {
        return 0;
    }

   
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];    return footerView;

}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellIdentifier  =@"favouriteCell";
    
    
    FavouriteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"FavouriteCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set consultancy name
    NSString *_consultancyName;
    
    // address
    NSString *_address;
    
    NSString *imageUrl;
    
    if(_favouriteArray.count>0)
    {
        if ([self.title isEqualToString:kAGENT]) {
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAgent_consultancy_name];
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAddress];
            
            imageUrl = [[_favouriteArray objectAtIndex:indexPath.section] valueForKey:kAgent_logo];
            
            
            // call button
            cell.callButton.tag = indexPath.section;
            [cell.callButton addTarget:self action:@selector(callButton_Clicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.callButton setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
            cell.callButton.tag = indexPath.section;
            
            // hide call button if string blank
            NSString *phonenumberString = [[_favouriteArray objectAtIndex:indexPath.section] valueForKey:kAgent_number];
            
            NSLog(@"%@",phonenumberString);
            
            if (!(phonenumberString.length>0) || [phonenumberString isKindOfClass:[NSNull class]]) {
                
                cell.callButton.hidden = YES;
            }
            
        }
        else if ([self.title isEqualToString:kCOURSES]) {
            
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kcourse_name];
            
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kUnivercity_name];
            
            imageUrl = [[_favouriteArray objectAtIndex:indexPath.section] valueForKey:kcourse_image];
            
            cell.callButton.hidden = YES;
        }
        else if ([self.title isEqualToString:kINSTITUDE]) {
            
            _consultancyName =  [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kinstitute_name];
            
            _address = [[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kAddress];
            
            imageUrl = [[_favouriteArray objectAtIndex:indexPath.section] valueForKey:kinstitute_image];
            cell.callButton.hidden = YES;
            
        }
        
        if (![_consultancyName isKindOfClass:[NSNull class]]) {
            
            cell.nameLabelHeight.constant =[Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
            
            cell.nameLabel.text = _consultancyName;
        }
        
        
        if (![_address isKindOfClass:[NSNull class]]) {
            
            cell.addressLabelHeight.constant =[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp];
            
            cell._addressLabel.text = _address;
        }
        
        
        // favorite Button
        
        cell.favouriteButton.tag = indexPath.section;
        [cell.favouriteButton addTarget:self action:@selector(favouriteButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.favouriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
        
        //    if ([[[_favouriteArray objectAtIndex:indexPath.section]valueForKey:kIslike] boolValue] == true) {
        //        [cell.favouriteButton setImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
        //    }
        //    else{
        
        // }
        
        // profile image
        cell._bgView.layer.cornerRadius = cell._bgView.frame.size.width/2;
        [cell._bgView.layer setMasksToBounds:YES];
        
        
        
        
        if (![imageUrl isKindOfClass:[NSNull class]]) {
            
            
            [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                if (error) {
                    
                }
                NSLog(@"%@",error);
            }];
        }
        
    }
   
    
   
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(_favouriteArray.count>0)
    {
        if ([self.title isEqualToString:kAGENT]) {
            //        [self performSegueWithIdentifier:kAgentSegueIdentifier sender:kHomeView];
            
            NSInteger index = indexPath.row;
            
            [self getAboutAgent:[_favouriteArray objectAtIndex:indexPath.section]];
            
            
        }
        else if ([self.title isEqualToString:kCOURSES]) {
            
            
            [self performSegueWithIdentifier:kcourseDetailsViewController sender:[_favouriteArray objectAtIndex:indexPath.section]];
            
        }
        else if ([self.title isEqualToString:kINSTITUDE]) {
            //        [self performSegueWithIdentifier:kInstitudeSegueIdentifer sender:[_favouriteArray objectAtIndex:indexPath.section]];
            
            if ([Utility connectedToInternet]) {
                [self getInstitudeDetails:[_favouriteArray objectAtIndex:indexPath.section]];
            }
            else{
                [Utility showAlertViewControllerIn:self title:@"" message:kErrorMsgNoInternet block:^(int index){
                    
                }];
            }
            
        }

    }
    
    }


#pragma mark - Scrol view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
    if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 10;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
               // _favouriteTabel.tableFooterView = spinner;
                
                [self getFavouriteList:YES];
            }
            
        }
    }
    
    else{
        
        _favouriteTabel.tableFooterView = nil;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma  mark - Button Clicked
/****************************
 * Function Name : - Button Action
 * Create on : - 5 April 2017
 * Developed By : -  Ramniwas Patidar
 * Description : - This fucntion are used for get clicke event of button clicked
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

-(void)callButton_Clicked:(UIButton *)clicked{
    
        NSString *phonenumberString = [[_favouriteArray objectAtIndex:clicked.tag] valueForKey:kAgent_number];
        
        if ([phonenumberString isEqual:[NSNull class]]) {
            return;
        }
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:phonenumberString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(void)favouriteButton_clicked:(UIButton *)sender{
    
    if(_favouriteArray.count>0)
    {
        
        NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
            [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
        }
        else{
            [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
        }
        [dictionary setValue:@"false" forKey:kstatus];
        
        
        NSString *url;
        
        if ([self.title isEqualToString:kAGENT]) {
            
            [dictionary setValue:[[_favouriteArray objectAtIndex:sender.tag]  valueForKey:kAgent_id] forKey:kAgent_id];
            url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_agent.php"];
        }
        else  if ([self.title isEqualToString:kCOURSES]) {
            [dictionary setValue:[[_favouriteArray objectAtIndex:sender.tag]  valueForKey:kcourse_id] forKey:kcourse_id];
            url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student_like_course.php"];
            
        }
        else  if ([self.title isEqualToString:kINSTITUDE]) {
            [dictionary setValue:[[_favouriteArray objectAtIndex:sender.tag]  valueForKey:kinstitute_id] forKey:kinstitute_id];
            url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-like_institute.php"];
            
        }
        NSString *message = @"Removing this from your Favourites";
        
        
        [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
            
            if (!error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                        
                        
                        [_favouriteArray removeObjectAtIndex:sender.tag];
                        [_favouriteTabel reloadData];
                        
                        NSMutableDictionary *favDict = [[NSMutableDictionary alloc]init];
                        
                        
                        if ([self.title isEqualToString:kAGENT]) {
                            
                            [favDict setValue:_favouriteArray forKey:Kagent];
                            [UtilityPlist saveData:favDict fileName:kAGENT];
                            
                        }
                        else if ([self.title isEqualToString:kCOURSES]) {
                            
                            [favDict setValue:_favouriteArray forKey:kCOURSES];
                            [UtilityPlist saveData:favDict fileName:kCOURSES];
                            
                        }
                        else if ([self.title isEqualToString:kINSTITUDE]) {
                            [favDict setValue:_favouriteArray forKey:kinstitute];
                            [UtilityPlist saveData:favDict fileName:kINSTITUDE];
                        }
                        
                        if (_favouriteArray.count==0) {
                            heartImage.hidden = NO;
                            if ([self.title isEqualToString:kAGENT]) {
                                messageLabel.text = @"Like agents to add as favourite.";
                            }
                            else if ([self.title isEqualToString:kCOURSES]) {
                                messageLabel.text = @"Like courses to add as favourite.";
                            }
                            else if ([self.title isEqualToString:kINSTITUDE]) {
                                messageLabel.text = @"Like institutes to add as favourite.";
                                
                            }
                            messageLabel.hidden = NO;
                        }
                        
                    }else{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"Removed from Favourites" block:^(int index) {
                                
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
    }


-(void)getAboutAgent:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_detail.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self performSegueWithIdentifier:kAgentDetailSegueIdentifier sender:payloadDictionary];
                    
                    
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


#pragma get institude details
-(void)getInstitudeDetails:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_detail.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self performSegueWithIdentifier:kInstitudeSegueIdentifer sender:payloadDictionary];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
      if ([segue.identifier isEqualToString:kInstitudeSegueIdentifer]) {
        UNKInstitudeViewController *institudeViewController = segue.destinationViewController;
        institudeViewController.institudeDictionary = sender;
          institudeViewController.incomingViewType = kFavourite;
          institudeViewController.favouriteArray = _favouriteArray;
        
    }
      else if ([segue.identifier isEqualToString:kAgentDetailSegueIdentifier]) {
          UNKAgentDetailsSliderViewController *agentDetailController = segue.destinationViewController;
          agentDetailController.agentDictionary = sender;
          agentDetailController.incomingViewType = kFavourite;
          agentDetailController.favouriteArray = _favouriteArray;

      }
    

      else if ([segue.identifier isEqualToString:kcourseDetailsViewController]){
          UNKCourseDetailsViewController *courseDetails = segue.destinationViewController;
          courseDetails.selectedCourseDictionary = sender;
          courseDetails.incomingViewType = kFavourite;
          courseDetails.favouriteArray = _favouriteArray;

      }
}


@end
