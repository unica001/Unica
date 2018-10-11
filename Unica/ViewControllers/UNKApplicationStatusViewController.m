//
//  UNKApplicationStatusViewController.m
//  Unica
//
//  Created by vineet patidar on 07/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKApplicationStatusViewController.h"
#import "FavouriteCell.h"

@interface UNKApplicationStatusViewController (){

    UILabel  *messageLabel;
}

@end

@implementation UNKApplicationStatusViewController


-(void)viewDidLoad{
    
    [super viewDidLoad];
    
      messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kiPhoneHeight/2, self.view.frame.size.width, 40)];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = [UIColor grayColor];
    messageLabel.text = @"You have not completed any application so far";
    [messageLabel setHidden:YES];

    [self.view addSubview:messageLabel];

    
    
    isHude = YES;
    
    if ([self.incommingViewType isEqualToString:kHomeView]) {
        _backButton.image = [UIImage imageNamed:@"BackButton"];
    }
    else{
        
        SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_backButton setTarget: self.revealViewController];
                [_backButton setAction: @selector( revealToggle: )];
                _backButton.image = [UIImage imageNamed:@"menuicon"];

                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
        }
        self.revealViewController.delegate = self;
    }
    
    self.title = @"My Applications";
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getApplicationStatus:isHude];

}

#pragma  mark - APIS

-(void)getApplicationStatus:(BOOL)showHude{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
 
    
     NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-application-status.php"];
      [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                isHude = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    messageLabel.text = @"";
                    [messageLabel setHidden:YES];

                    
                    applicationStatusArray = [payloadDictionary valueForKey:@"Status"];
                    
                    if (applicationStatusArray.count ==0) {
                        messageLabel.text = @"You have not completed any application so far";
                        [messageLabel setHidden:NO];
                    }
                    
                    [_statusTable reloadData];
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                      
                        messageLabel.text = @"You have not completed any application so far";
                        [messageLabel setHidden:NO];

                        
                        
                        if (applicationStatusArray) {
                            [applicationStatusArray removeAllObjects];
                            [_statusTable reloadData];
                        }

                        
//                          [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
//                        
//                         }];
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
#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [applicationStatusArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    // set consultancy name
    NSString *_consultancyName;
    
    // address
    NSString *_address;
    
        _consultancyName =  [[applicationStatusArray objectAtIndex:indexPath.section]valueForKey:kcourse_name];
        _address = [[applicationStatusArray objectAtIndex:indexPath.section]valueForKey:kcourse_university];

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
    return 10;
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
    
    _consultancyName =  [[applicationStatusArray objectAtIndex:indexPath.section]valueForKey:kcourse_name];
    _address = [[applicationStatusArray objectAtIndex:indexPath.section]valueForKey:kcourse_university];
    
        imageUrl = [[applicationStatusArray objectAtIndex:indexPath.section] valueForKey:kAgent_logo];

    if (![_consultancyName isKindOfClass:[NSNull class]]) {
        
        cell.nameLabelHeight.constant =[Utility getTextHeight:_consultancyName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        cell.nameLabel.text = _consultancyName;
    }
    
    CGFloat height;
    {
        
        height =[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp];
        
        cell.addressLabelHeight.constant = height;
        cell._addressLabel.text = _address;
    }
    
    if (![imageUrl isKindOfClass:[NSNull class]]) {
        
        [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"StepCourse"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (error) {
                
            }
        }];
    }
    
    cell.callButton.hidden = YES;
    cell.favouriteButton.hidden = YES;
    
    // status Button
    
    UIButton *_statusButton = [[UIButton alloc]initWithFrame:CGRectMake(cell.nameLabel.frame.origin.x,(cell.frame.size.height+height)-60, 100, 30)];
    _statusButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [cell.contentView addSubview:_statusButton];
    
    _statusButton.layer.cornerRadius = 10;
    [_statusButton.layer setMasksToBounds:YES];
    
    if ([[[applicationStatusArray objectAtIndex:indexPath.section] valueForKey:kstatus] isEqualToString:@"submit"]) {
        _statusButton.backgroundColor = [UIColor colorWithRed:65.0f/255.0f green:168.0f/255.0f blue:95.0f/255.0f alpha:1.0];
        [_statusButton setTitle:[[applicationStatusArray objectAtIndex:indexPath.
                                  section] valueForKey:kstatus]  forState:UIControlStateNormal];
        
    }
    else  if ([[[applicationStatusArray objectAtIndex:indexPath.section] valueForKey:kstatus] isEqualToString:@"Rejected"]) {
        
        _statusButton.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:7.0f/255.0f blue:7.0f/255.0f alpha:1.0];
        [_statusButton setTitle:[[applicationStatusArray objectAtIndex:indexPath.section] valueForKey:kstatus] forState:UIControlStateNormal];
    }
    else {
        
        _statusButton.backgroundColor = [UIColor colorWithRed:32.0f/255.0f green:154.0f/255.0f blue:207.0f/255.0f alpha:1.0];
        [_statusButton setTitle:[[applicationStatusArray objectAtIndex:indexPath.section] valueForKey:kstatus] forState:UIControlStateNormal];
        
    }
    
    
    // make cell corner roundup
    
    cell.layer.cornerRadius = 10.0;
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.cornerRadius = 5.0;
    cell._bgView.backgroundColor = [UIColor whiteColor];
    cell._bgView.layer.borderWidth = 1.0;
    cell._bgView.layer.borderColor = kDefaultBlueColor.CGColor;
    cell._bgView.layer.cornerRadius = cell._bgView.frame.size.width/2;
    [cell.layer setMasksToBounds:YES];
    
    return  cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *storyBoard  = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UNKCourseDetailsViewController *courseViewController = [storyBoard instantiateViewControllerWithIdentifier:@"CourseDetailsViewController"];
    courseViewController.incomingViewType = kMyApplication;
    courseViewController.selectedCourseDictionary  =  [applicationStatusArray objectAtIndex:indexPath.section];
    [self.navigationController pushViewController:courseViewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma  mark - Button Clicked

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
