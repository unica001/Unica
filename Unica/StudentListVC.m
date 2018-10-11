//
//  StudentListVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "StudentListVC.h"
#import "viewBusinessCardCell.h"
#import "StudentDetailVC.h"
#import "filterpopView.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"


@interface StudentListVC ()
{
    NSMutableArray *studentList;
    NSMutableDictionary *loginDictionary;
    NSString *fromDate,*todate;
    UITextField *todatetextField,*fromTextField;
    UIView *overlayView;
    
}

@end

@implementation StudentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_backButton setTarget: self.revealViewController];
            [_backButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
    pageNumber =1;
    self.revealViewController.delegate = self;
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    LoadMoreData=true;
    [self getEvents:YES];
    // Do any additional setup after loading the view.
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(10, 33, kiPhoneWidth/2-48, 40);
    CGRect frame2 = CGRectMake(kiPhoneWidth/2, 33, kiPhoneWidth/2-48, 40);
    
    
    
    
    NSMutableDictionary *optionDictionary = [NSMutableDictionary dictionary];
    [optionDictionary setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    
    
    
    todatetextField = [Control newTextFieldWithOptions:optionDictionary frame:frame2 delgate:self];
    todatetextField.placeholder = @"To Date";
    todatetextField.textAlignment = NSTextAlignmentCenter;
    todatetextField.textColor = [UIColor darkGrayColor];
    todatetextField.userInteractionEnabled = false;
    todatetextField.font = kDefaultFontForTextField;
    
    fromTextField = [[UITextField alloc] initWithFrame:frame];
    fromTextField.placeholder = @"from Date";
    fromTextField.textAlignment = NSTextAlignmentCenter;
    fromTextField.textColor = [UIColor darkGrayColor];
    fromTextField.userInteractionEnabled = false;
    fromTextField.font = kDefaultFontForTextField;
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.hidden  = YES;
    
    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view delegate methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //return 5;
    return studentList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];
    
    return footerView;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"eventCell";
    
    
    viewBusinessCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"viewBusinessCardCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    //"student_id": "1",
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *detail = [studentList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [Utility replaceNULL:[detail valueForKey:@"name"] value:@""];
    cell.companyLabel.text = [Utility replaceNULL:[detail valueForKey:@"email"] value:@""];
    cell.designationLabel.text = [Utility replaceNULL:[detail valueForKey:@"current_qualification_level"] value:@""];
    
    
    cell.locationLabel.text = [Utility replaceNULL:[detail valueForKey:@"address"] value:@""];
    
    if( cell.locationLabel.text.length<=0)
    {
        cell.locationImageView.hidden =  true;
    }
    cell.userImageView.layer.borderWidth = 2;
    cell.userImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [cell.userImageView sd_setImageWithURL:[NSURL URLWithString:[detail valueForKey:@"profile_image"]] placeholderImage:[UIImage imageNamed:@"RegisterUser"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            cell.userImageView.image = [UIImage imageNamed:@"RegisterUser"];
        }
        //[activityIndicator stopAnimating];
        NSLog(@"%@",error);
    }];
    
    if([studentList objectAtIndex:indexPath.row]==[studentList objectAtIndex:studentList.count-1])
    {
        if(studentList.count>=10 && LoadMoreData==true)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self getEvents:YES];
        });
        
    }
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *idStr = [NSString stringWithFormat:@"%@",[[studentList objectAtIndex:indexPath.row] valueForKey:@"unica_code"]];
    [self getStudentDetail:idStr];
}


#pragma  mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    detailtable.tableHeaderView = spinner;
    
    pageNumber = 1;
    [detailtable setContentOffset:CGPointZero animated:YES];
    if([_searchBar.text isEqualToString:@""])
    {
        
        [self getEvents:NO];
    }
    else{
        
        [self getEvents:NO];
        
    }
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    self.navigationController.navigationBarHidden = NO;
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (_timer) {
        if ([_timer isValid]){ [
                                _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
    
}

-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    NSLog(@"%@",_searchBar.text);
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    detailtable.tableHeaderView = spinner;
    
    pageNumber = 1;
    
    if([_searchBar.text isEqualToString:@""])
    {
        
        [self getEvents:NO];
    }
    else{
        
        [self getEvents:NO];
        
    }
}
#pragma mark - APIS

-(void)getEvents:(BOOL)showHude{
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:userId forKey:@"user_id"];
    ;
    [dictionary setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [dictionary setValue:_searchBar.text forKey:@"keyword"];
    [dictionary setValue:fromDate forKey:@"from_date"];
    [dictionary setValue:todate forKey:@"to_date"];
    
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"interested-students.php"];
    
    NSString *message =@"";
    //    if(pageNumber==1)
    //    {
    //        message =@"Finding Higher Education Events Near You";
    //    }
    //    else
    //    {
    //        message =@"Finding more events near you";
    //    }
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:showHude showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isShowHude = false;
                
                detailtable.tableHeaderView = nil;
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                isLoading = NO;
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"students"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    if (pageNumber == 1 ) {
                        if (studentList) {
                            [studentList removeAllObjects];
                        }
                        studentList = [payloadDictionary valueForKey:@"students"];
                        
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"students"];
                        
                        
                        if(arr.count > 0){
                            [studentList addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:studentList] array];
                            studentList =[[NSMutableArray alloc] initWithArray:newArray];
                            ;
                        }
                        NSLog(@"%lu",(unsigned long)studentList.count);
                        pageNumber = pageNumber+1 ;
                    }
                    
                    [detailtable reloadData];
                    
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber == 1) {
                            
                            
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                            [studentList removeAllObjects];
                            [detailtable reloadData];
                        }
                        else
                        {
                            LoadMoreData = false;
                        }
                        
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
            if([error.domain isEqualToString:kUNKError]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [_searchBar resignFirstResponder];
                    
                    if (studentList) {
                        [studentList removeAllObjects];
                        [detailtable reloadData];
                    }  detailtable.tableHeaderView = nil;
                    
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    //                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                    //
                    //                    }];
                });
            }
        }
        
    }];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    StudentDetailVC *controller = segue.destinationViewController;
    controller.detail = sender;
    controller.isEdit = @"yes";
    
    
}

-(void)getStudentDetail:(NSString*)idStr
{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
    [dic setValue:idStr forKey:@"unica_code"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-scan-code.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                        [self performSegueWithIdentifier:@"studentDetailSegue" sender:[payloadDictionary  valueForKey:@"student_detail"]];
                    });
                    
                    
                    
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
-(void)ShowOverlay{
    overlayView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8];
    overlayView.layer.cornerRadius = 5;
    
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"filterpopView" owner:self options:nil];
    
    filterpopView *popView = [nibArray objectAtIndex:0];
    popView.frame = CGRectMake(10, (kiPhoneHeight/2)-90,kiPhoneWidth-20, 155 );
    popView.layer.cornerRadius = 5;
    popView.toView.layer.cornerRadius = 3;
    popView.toView.layer.borderWidth = 1;
    popView.toView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    popView.clipsToBounds = YES;
    
    [popView addSubview:todatetextField];
    [popView addSubview:fromTextField];
    popView.fromView.layer.cornerRadius = 3;
    popView.fromView.layer.borderWidth = 1;
    popView.fromView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [popView.todateButton addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView.fromDateButton addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [popView.cancelButtton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [popView.okButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [overlayView addSubview:popView];
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    [self.window addSubview:overlayView];
    
}
- (IBAction)filterButton_Action:(id)sender {
    [_searchBar resignFirstResponder];
    [self ShowOverlay];
}
-(IBAction)calenderAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    if(tag==2)
    {
        self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:((365*70*24*60*60))] to:[NSDate dateWithTimeIntervalSinceNow:-0] interval:5
                                               selectCallback:^(id selected) {
                                                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                   [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                                   // [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                                   NSString *selectedDate = [dateFormatter stringFromDate:selected];
                                                   
                                                   todatetextField.text = [NSString stringWithFormat:@"%@", selectedDate];
                                                   
                                                   NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                                   [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                                                   todate = [dateFormatter2 stringFromDate:selected];
                                                   
                                               } cancelCallback:^{
                                               }];
        
        self.picker.title = @"Select to Date";
        [self.picker presentPickerOnView:self.view];
        [self.picker selectDate:self.dateCellSelectedDate];
        
    }
    if(tag==1)
    {
        self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate dateWithTimeIntervalSinceNow:((365*70*24*60*60))] to:[NSDate dateWithTimeIntervalSinceNow:-0] interval:5
                                               selectCallback:^(id selected) {
                                                   NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                                   [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                                                   // [dateFormatter setDateFormat:@"dd-MM-yyyy"];
                                                   NSString *selectedDate = [dateFormatter stringFromDate:selected];
                                                   
                                                   fromTextField.text = [NSString stringWithFormat:@"%@", selectedDate];
                                                   
                                                   NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
                                                   [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
                                                   fromDate = [dateFormatter2 stringFromDate:selected];
                                                   
                                               } cancelCallback:^{
                                               }];
        
        self.picker.title = @"Select from Date";
        [self.picker presentPickerOnView:self.view];
        [self.picker selectDate:self.dateCellSelectedDate];
    }
}
-(IBAction)submitAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    int tag = (int)button.tag;
    pageNumber = 1;
    if(tag==1)
    {
        [overlayView removeFromSuperview];
        todatetextField.text =todate= @"";
        fromTextField.text =fromDate= @"";
        [self getEvents:YES];
    }
    else
    {
        
        [overlayView removeFromSuperview];
        if([self Validation])
        {
            [self getEvents:YES];
        }
        
    }
}
-(BOOL)Validation{
    
    NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
    [datePickerFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [datePickerFormat dateFromString:fromDate];
    NSDate *serverDate = [datePickerFormat dateFromString:todate];
    
    if (![Utility validateField:todatetextField.text]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select to date" block:^(int index){
            
            
            
        }];
        return false;
        
    }
    else if (![Utility validateField:fromTextField.text]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select from date" block:^(int index){
            
            
            
        }];
        return false;
        
    }
    else if (![Utility compareDate:currentDate ServeDate:serverDate]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"To Date must be greater than From Date" block:^(int index){
            
            
            
        }];
        return false;
        
    }
    return true;
}
@end

