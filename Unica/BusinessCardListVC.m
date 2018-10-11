//
//  BusinessCardListVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "BusinessCardListVC.h"
#import "viewBusinessCardCell.h"
#import "ViewBusinessCardDetailVC.h"
#import "filterpopView.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "BusinessFilterPopUP.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface BusinessCardListVC ()
{
    NSMutableArray *businessCardList, *arrSelectedAction, *arrSelectedCategory;
    NSMutableDictionary *loginDictionary;
    NSString *fromDate,*todate;
//    UIView *overlayView;
    UITextField *todatetextField,*fromTextField;
    TPKeyboardAvoidingScrollView *scrollOverLay;
    BusinessFilterPopUP *popUp;
    NSTimer *timer;
}

@end

@implementation BusinessCardListVC

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
    
    self.revealViewController.delegate = self;
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    UITextField *searchField = [_searchBar valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    searchField.backgroundColor = [UIColor whiteColor];
    
    
    messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
    messageLabel.text = @"No records found";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.hidden  = YES;
    
    messageLabel.textColor = [UIColor blackColor];
    [self.view addSubview:messageLabel];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    pageNumber =1;
    [self getEvents:YES];
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
    return businessCardList.count;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *detail = [businessCardList objectAtIndex:indexPath.row];
    cell.nameLabel.text = [Utility replaceNULL:[detail valueForKey:@"delegate_name"] value:@""];
    cell.companyLabel.text = [Utility replaceNULL:[detail valueForKey:@"org_name"] value:@""];
    cell.designationLabel.text = [Utility replaceNULL:[detail valueForKey:@"title"] value:@""];
    NSString *strLocation = [Utility replaceNULL:[detail valueForKey:@"location"] value:@""];
    NSString *strEvent = [Utility replaceNULL:[detail valueForKey:@"attending_event"] value:@""];
    strEvent = [strEvent stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if ([strEvent isEqualToString:@""]) {
        cell.locationLabel.text = strLocation;
    } else if ([strLocation isEqualToString:@""]) {
        cell.locationLabel.text = @"";
    } else {
        cell.locationLabel.text = [NSString stringWithFormat:@"%@, %@", strEvent, strLocation];
    }
    if( cell.locationLabel.text.length<=0)
    {
        cell.locationImageView.hidden =  true;
    }
    
    cell.cardView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.cardView.layer.borderWidth = 2;
    [cell.cardImageView sd_setImageWithURL:[NSURL URLWithString:[detail valueForKey:@"card_image"]] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (error) {
            cell.cardImageView.image = [UIImage imageNamed:@""];
        }
        //[activityIndicator stopAnimating];
        NSLog(@"%@",error);
    }];
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"BusinessCardDetail" sender:[[businessCardList objectAtIndex:indexPath.row] valueForKey:@"id"]];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    if (maximumOffset - currentOffset <= -40 && (businessCardList.count % 10 == 0) && businessCardList.count != 0) {
//        pageNumber += 1;
        [self getEvents:YES];
    }
}

//func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//{
//    let currentOffset = scrollView.contentOffset.y
//    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//    if maximumOffset - currentOffset <= -40 && (arrCase.count % 10 == 0) && arrCase.count != 0
//    {
//        pageIndex += 1
//        if btnNewCase.isSelected {
//            callApiNewCase()
//        } else {
//            callApiHistoryCase()
//        }
//    }
//}

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

#pragma Show scroll in table

/// Show always scroll indicator in table view
- (void)showScrollIndicator {
//    [UIView animateWithDuration:0.001 animations:^{
        [popUp.tblAction flashScrollIndicators];
        [popUp.tblCategory flashScrollIndicators];
//    }];
}

// Start timer for always show scroll indicator in table view
-(void) startTimerForShowScrollIndicator {
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showScrollIndicator) userInfo:nil repeats:true];
}

/// Stop timer for always show scroll indicator in table view
- (void)stopTimerForShowIndicator {
    [timer invalidate];
    timer = nil;
}


#pragma mark - APIS

-(void)getEvents:(BOOL)showHude{
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:userId forKey:@"user_id"];
    [dictionary setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    [dictionary setValue:_searchBar.text forKey:@"keyword"];
    [dictionary setValue:fromDate forKey:@"from_date"];
    [dictionary setValue:todate forKey:@"to_date"];
    
    NSError *error;
    if (arrSelectedCategory.count > 0) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrSelectedCategory options:NSJSONWritingPrettyPrinted error:&error];
        NSString *categoryString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dictionary setValue:categoryString forKey:@"category"];
    }
    if (arrSelectedAction.count > 0) {
        NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arrSelectedAction options:NSJSONWritingPrettyPrinted error:&error];
        NSString *intetestString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
        [dictionary setValue:intetestString forKey:@"intetestLabel"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scan_card_view.php"];
    
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
                    
                    int counter = (int)([[payloadDictionary valueForKey:@"scan_card"] count] % 10 );
                    if(counter>0)
                    {
                        LoadMoreData = false;
                    }
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    if (pageNumber == 1 ) {
                        if (businessCardList) {
                            [businessCardList removeAllObjects];
                        }
                        businessCardList = [payloadDictionary valueForKey:@"scan_card"];
                        
                        pageNumber = 2;
                    }
                    else{
                        NSMutableArray *arr = [payloadDictionary valueForKey:@"scan_card"];
                        
                        
                        if(arr.count > 0){
                            [businessCardList addObjectsFromArray:arr];
                            NSArray * newArray =
                            [[NSOrderedSet orderedSetWithArray:businessCardList] array];
                            businessCardList =[[NSMutableArray alloc] initWithArray:newArray];
                            ;
                        }
                        NSLog(@"%lu",(unsigned long)businessCardList.count);
                        pageNumber = pageNumber+1 ;
                    }
                     dispatch_async(dispatch_get_main_queue(), ^{
                    [detailtable reloadData];
                         
                     });
                    
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (pageNumber == 1) {
                            
                            
                            messageLabel.text = @"No records found";
                            messageLabel.hidden = NO;
                            
                            [businessCardList removeAllObjects];
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
                    
                    if (businessCardList) {
                        [businessCardList removeAllObjects];
                        [detailtable reloadData];
                    }  detailtable.tableHeaderView = nil;
                    
                    messageLabel.text = @"";
                    [messageLabel setHighlighted:YES];
                    
                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
        
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"BusinessCardDetail"])
    {
        ViewBusinessCardDetailVC *controller = segue.destinationViewController;
        controller.businessCardId = sender;
    }
    
    
    
    
}
//-(void)ShowOverlay{
//    overlayView =[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
//    overlayView.layer.cornerRadius = 5;
//
//    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"filterpopView" owner:self options:nil];
//
//    filterpopView *popView = [nibArray objectAtIndex:0];
//    popView.frame = CGRectMake(10, (kiPhoneHeight/2)-90,kiPhoneWidth-20, 155 );
//    popView.layer.cornerRadius = 5;
//    popView.clipsToBounds = YES;
//    popView.toView.layer.cornerRadius = 3;
//    popView.toView.layer.borderWidth = 1;
//    popView.toView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//    [popView addSubview:todatetextField];
//    [popView addSubview:fromTextField];
//    popView.fromView.layer.cornerRadius = 3;
//    popView.fromView.layer.borderWidth = 1;
//    popView.fromView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//     [popView.todateButton addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
//    [popView.fromDateButton addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    [popView.cancelButtton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
//    [popView.okButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
//
//    [overlayView addSubview:popView];
//
//    //[self.view addSubview:overlayView];
//    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
//    [self.window addSubview:overlayView];
//}

- (void)showOverLayNewFilter {
    scrollOverLay =[[TPKeyboardAvoidingScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    scrollOverLay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
    scrollOverLay.layer.cornerRadius = 5;
    
    UIButton *btn = (UIButton *)[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = [[UIScreen mainScreen] bounds];
    btn.titleLabel.text = @"";
    [btn addTarget:self action:@selector(tapCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"BusinessFilterPopUP" owner:self options:nil];
    
    popUp = [nibArray objectAtIndex:0];
    popUp.frame = CGRectMake(10, (kiPhoneHeight/2)-211,kiPhoneWidth-20, 422);
    popUp.layer.cornerRadius = 5;
    popUp.clipsToBounds = YES;
    popUp.viewFromDate.layer.cornerRadius = 3;
    popUp.viewFromDate.layer.borderWidth = 1;
    popUp.viewFromDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    popUp.viewToDate.layer.cornerRadius = 3;
    popUp.viewToDate.layer.borderWidth = 1;
    popUp.viewToDate.layer.borderColor = [UIColor lightGrayColor].CGColor;

    CGRect frame = CGRectMake(10, popUp.viewFromDate.frame.origin.y+5, popUp.viewFromDate.frame.size.width - 40, 40);
    CGRect frame2 = CGRectMake(kiPhoneWidth/2, popUp.viewToDate.frame.origin.y+5, popUp.viewToDate.frame.size.width - 40, 40);
    
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
    fromTextField.placeholder = @"From Date";
    fromTextField.textAlignment = NSTextAlignmentCenter;
    fromTextField.textColor = [UIColor darkGrayColor];
    fromTextField.userInteractionEnabled = false;
    fromTextField.font = kDefaultFontForTextField;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *dateFrom = [dateFormatter2 dateFromString:fromDate];
    NSDate *dateTo = [dateFormatter2 dateFromString:todate];
    
    fromTextField.text = [dateFormatter stringFromDate:dateFrom];
    todatetextField.text = [dateFormatter stringFromDate:dateTo];
    [self updateArrayValues];
    
    [popUp addSubview:todatetextField];
    [popUp addSubview:fromTextField];

    [popUp.btnFromDate addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];
    [popUp.btnToDate addTarget:self action:@selector(calenderAction:) forControlEvents:UIControlEventTouchUpInside];

    [popUp.btnClearAll addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
    [popUp.btnApply addTarget:self action:@selector(applyAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self showScrollIndicator];
    [self startTimerForShowScrollIndicator];
//    popUp.tblAction.contentOffset = CGPointMake(0, 5);
    
    [scrollOverLay addSubview:btn];
    [scrollOverLay addSubview:popUp];
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    [self.window addSubview:scrollOverLay];
    [popUp.tblAction reloadData];
    [popUp.tblCategory reloadData];
    
}

- (void)updateArrayValues {
    
    for (int i =0; i < popUp.arrAction.count; i++) {
        NSMutableDictionary *dictAction = [popUp.arrAction[i] mutableCopy];
        if (arrSelectedAction.count > 0) {
            for (int j =0; j < arrSelectedAction.count; j++) {
                if (dictAction[@"id"] == arrSelectedAction[j]) {
                    [dictAction setObject:@"true" forKey:@"isSelected"];
                    break;
                } else {
                    [dictAction setObject:@"false" forKey:@"isSelected"];
                }
            }
        } else {
            [dictAction setObject:@"false" forKey:@"isSelected"];
        }
        popUp.arrAction[i] = dictAction;
    }
    for (int i =0; i < popUp.arrCategory.count; i++) {
        NSMutableDictionary *dictCategory = [popUp.arrCategory[i] mutableCopy];
        if (arrSelectedCategory.count > 0) {
            for (int j =0; j < arrSelectedCategory.count; j++) {
                if (dictCategory[@"id"] == arrSelectedCategory[j]) {
                    [dictCategory setObject:@"true" forKey:@"isSelected"];
                    break;
                } else {
                    [dictCategory setObject:@"false" forKey:@"isSelected"];
                }
            }
        } else {
            [dictCategory setObject:@"false" forKey:@"isSelected"];
        }
        popUp.arrCategory[i] = dictCategory;
    }
    [popUp.tblCategory reloadData];
    [popUp.tblAction reloadData];
}

- (IBAction)filterButton_Action:(id)sender {
    [_searchBar resignFirstResponder];
    [self showOverLayNewFilter];
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
-(IBAction)clearAction:(id)sender{
    pageNumber = 1;
    [scrollOverLay removeFromSuperview];
//    [self stopTimerForShowIndicator];
    todatetextField.text =todate= @"";
    fromTextField.text =fromDate= @"";
    [popUp resetArrayValues];
    arrSelectedAction = nil;
    arrSelectedCategory = nil;
    [self getEvents:YES];
}

-(IBAction)applyAction:(id)sender {
    pageNumber =  1;
    [scrollOverLay removeFromSuperview];
//    [self stopTimerForShowIndicator];
    if (popUp.arrAction.count > 0) {
        arrSelectedAction = [[NSMutableArray alloc] init];
        for (int i = 0; i < popUp.arrAction.count ; i++) {
            NSDictionary *dict = popUp.arrAction[i];
            if ([dict[@"isSelected"] isEqualToString:@"true"]) {
                [arrSelectedAction addObject: dict[@"id"]];
            }
        }
    }
    
    if (popUp.arrCategory.count > 0) {
        arrSelectedCategory = [[NSMutableArray alloc] init];
        for (int i = 0; i < popUp.arrCategory.count ; i++) {
            NSDictionary *dict = popUp.arrCategory[i];
            if ([dict[@"isSelected"] isEqualToString:@"true"]) {
                [arrSelectedCategory addObject:dict[@"id"]];
            }
        }
    }
    
    if ([self Validation]) {
        [self getEvents:YES];
    }
}
- (void)tapCancel:(UIButton *)sender {
    [scrollOverLay removeFromSuperview];
//    [self stopTimerForShowIndicator];
}

-(BOOL)Validation{
    
    NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
    [datePickerFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [datePickerFormat dateFromString:fromDate];
    NSDate *serverDate = [datePickerFormat dateFromString:todate];
    
    if (![Utility validateField:fromTextField.text] && ![Utility validateField:todatetextField.text] && arrSelectedAction.count == 0 && arrSelectedCategory.count == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select atleast one filter" block:^(int index){
        }];
        return false;
    } else if ([Utility validateField:fromTextField.text] && [Utility validateField:todatetextField.text] && ![Utility compareDate:currentDate ServeDate:serverDate]) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"To Date must be greater than From Date" block:^(int index){
        }];
        return false;
    } else if(![Utility connectedToInternet]) {
        [Utility showAlertViewControllerIn:self title:@"" message:@"Please check internet connection" block:^(int index){
            return;
        }];
    }
    return true;
}
@end
