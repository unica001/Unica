//
//  UNKEventDetailsViewController.m
//  Unica
//
//  Created by ramniwas on 02/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKEventDetailsViewController.h"
#import "EventDetailCell.h"
#import "UNKEventViewController.h"
@interface UNKEventDetailsViewController (){
    NSMutableDictionary *dictLogin;
}

@end

@implementation UNKEventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    _imageView.hidden = YES;
    registerButton.hidden = YES;
    
    _eventDetailTable.hidden = YES;
    if ([self.incomingViewType isEqualToString:kNotifications]) {
        
      SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {  SWRevealViewController *revealViewController = self.revealViewController;
            if ( revealViewController )
            {
                [_backButton setTarget: self.revealViewController];
                [_backButton setAction: @selector( revealToggle: )];
                [_backButton setImage:[UIImage imageNamed:@"menuicon"]];
                [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
            }
            
        }
        self.revealViewController.delegate = self;
    }
    else{
        [_backButton setImage:[UIImage imageNamed:@"BackButton"]];
        // SWReveal delegates
        
    }
    [self eventDetails];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
}



#pragma mark - APIS

-(void)eventDetails{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
   
        [dictionary setValue:[self.evenDictionary valueForKey:kevent_id] forKey:kevent_id];
    //[dictionary setValue:@"" forKey:kevent_id];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
       
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"event-detail.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"Event Details" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _eventDetailTable.hidden = NO;

                _eventDetailDictionary = [dictionary valueForKey:kAPIPayload];
                    _imageView.hidden = NO;
                    registerButton.hidden = NO;
                    
                    [self loadInitialData];
     
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

-(void)loadInitialData{
    
    NSString *isRegister;
    if ([_eventDetailDictionary valueForKey:@"isRegistered"]) {
        isRegister = [_eventDetailDictionary valueForKey:@"isRegistered"];
    }
    else{
//    NSMutableDictionary *dict = [[_evenDictionary valueForKey:@"event_participate"] objectAtIndex:0];
        
    isRegister = [_evenDictionary valueForKey:@"isRegistered"];
    }
    
    self.title = [_eventDetailDictionary valueForKey:kevent_name];

    
    if ([isRegister boolValue]  == true) {
        [registerButton setBackgroundColor:[UIColor grayColor]];
        registerButton.userInteractionEnabled = YES;
          [registerButton setTitle:@"Registered" forState:UIControlStateNormal];
    }
    else{
            [registerButton setBackgroundColor:kDefaultBlueColor];
            registerButton.userInteractionEnabled = YES;
    }
    
   
    // load image
    NSString *urlString = [_eventDetailDictionary valueForKey:kevent_image];
    
    if (![urlString isKindOfClass:[NSNull class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    [_eventDetailTable reloadData];
}


#pragma mark - Table view delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section ==0) {
        return 1;
    }
    else  if (section ==1) {
        return 3;
    }
    
    return [[_eventDetailDictionary valueForKey:kevent_participate] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    if (indexPath.section == 0) {
    //description
    NSString*description = [_eventDetailDictionary valueForKey:kevent_description];

    if ( [Utility getTextHeight:description size:CGSizeMake(kiPhoneWidth-30, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        height =([Utility getTextHeight:description size:CGSizeMake(kiPhoneWidth - 30, CGFLOAT_MAX) font:kDefaultFontForTextField]-40);
    }
    else{
        height = 0;
    }
    return 40+height;
    }
    else  if (indexPath.section == 1 && indexPath.row==0) {
        //event_location
        NSString*eventlocation = [_eventDetailDictionary valueForKey:kevent_location];
        
        if ( [Utility getTextHeight:eventlocation size:CGSizeMake(kiPhoneWidth-55, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
            height =([Utility getTextHeight:eventlocation size:CGSizeMake(kiPhoneWidth - 55, CGFLOAT_MAX) font:kDefaultFontForTextField]-20);
        }
        else{
            height = 0;
        }
        return 40+height;
    }

    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section== 0) {
        return 30;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    NSString *headerText;
    view.frame = CGRectMake(0, 0, kiPhoneWidth, 50);
    UILabel *headerLabel = [[UILabel alloc]init];
    headerLabel.frame = CGRectMake(10, 0, kiPhoneWidth-20, 50);

    if (section== 0) {
        headerText = @"Description";
        view.frame = CGRectMake(0, 0, kiPhoneWidth, 30);
        headerLabel.frame = CGRectMake(10, 0, kiPhoneWidth-20, 30);


    }
    else  if (section== 1) {
        headerText = @"Location";
    }
    else  if (section== 2) {
        headerText = @"Participating Institutions with country";
    }
    
    view.backgroundColor = [UIColor whiteColor];
   
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.numberOfLines = 2;
    headerLabel.text = headerText;
    [view addSubview:headerLabel];
    
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
    footerView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];
    
    return footerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"eventDetailCell";
    
    
    EventDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"EventDetailCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
    // description
    NSString*description = [_eventDetailDictionary valueForKey:kevent_description];

    if (![description isKindOfClass:[NSNull class]]) {
        cell.nameLabelHeight.constant =[Utility getTextHeight:description size:CGSizeMake(kiPhoneWidth - 30, CGFLOAT_MAX) font:kDefaultFontForTextField];
        cell.nameLabel.text = description;
//        cell.nameLabel.backgroundColor = [UIColor redColor];
        cell.logoImageWidth.constant = 0;

    }
    }
  else if (indexPath.section == 1 ) {
        //event_location
    if (indexPath.row==0) {
    NSString*eventlocation = [_eventDetailDictionary valueForKey:kevent_location];
      
      if (![eventlocation isKindOfClass:[NSNull class]]) {
          cell.nameLabelHeight.constant =[Utility getTextHeight:eventlocation size:CGSizeMake(kiPhoneWidth - 55, CGFLOAT_MAX) font:kDefaultFontForTextField];
          cell.nameLabel.text = eventlocation;
          cell.logoImageView.image = [UIImage imageNamed:@"Location"];
          if(cell.nameLabelHeight.constant>40)
          {
              cell.iconTopSpaceconstant.constant=2;
          }
          else{
              cell.nameLabelHeight.constant=40;
          }

      }
    }
    else   if (indexPath.row==1) {
        NSString*eventdate = [NSString stringWithFormat:@"%@",[_eventDetailDictionary valueForKey:kevent_date]];
        eventdate = [eventdate stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
         eventdate = [eventdate stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        cell.nameLabel.text = eventdate;
    }
    else   if (indexPath.row==2) {
        NSString*eventtime = [_eventDetailDictionary valueForKey:
                              kevent_time];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",eventtime];
        cell.logoImageView.image = [UIImage imageNamed:@"Clock"];

    }
    }
  else if (indexPath.section == 2) {
      NSString*name = [[[_eventDetailDictionary valueForKey:kevent_participate] objectAtIndex:indexPath.row] valueForKey:kName];
      NSString*countryname = [[[_eventDetailDictionary valueForKey:kevent_participate] objectAtIndex:indexPath.row] valueForKey:kcountry_name];
      
      cell.nameLabel.text = [NSString stringWithFormat:@"\u2022 %@, %@",name,countryname];
      cell.logoImageWidth.constant = 0;
  }
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

#pragma mark - button delegate method

- (IBAction)backButton_clicked:(id)sender {
    NSArray *navigation = [self.navigationController viewControllers];
    UIView *view = [navigation objectAtIndex:navigation.count-2];
    
    if([view isKindOfClass:[UNKEventViewController class]])
    {
        if ([self.incomingViewType isEqualToString:kNotifications]) {
            [kUserDefault setValue:@"yes" forKey:@"loadList"];
        }

        [kUserDefault setValue:@"yes" forKey:@"showHudEventDetail"];
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)registerButton_clicked:(id)sender {
    
    
    
    NSString *isRegister  = [_eventDetailDictionary valueForKey:@"isRegistered"];

    
    if ([isRegister boolValue]  == true) {
        
        [Utility showAlertViewControllerIn:self title:@"" message:@"Already Registered." block:^(int index){
            
        }];
        
    }
    
    else{
    [Utility showAlertViewControllerIn:self withAction:@"CANCEL" actionTwo:@"YES" title:@"" message:@"Are you sure, You want to register for this event" block:^(int index){
        
        if (index == 1) {
            [self registredAPIS:YES eventID:[_eventDetailDictionary valueForKey:kevent_id]];
        }
    }];
        
        
    }
}

-(void)registredAPIS:(BOOL)showHude eventID:(NSString*)eventID{
    
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
    }
    
    [dictionary setValue:eventID forKey:kevent_id];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-event-register.php"];
    
 [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        
                        [self.evenDictionary setValue:@"1" forKey:@"isRegistered"];
                        [self eventDetails];

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


@end
