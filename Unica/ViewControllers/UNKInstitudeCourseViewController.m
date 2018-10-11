//
//  UNKInstitudeCourseViewController.m
//  Unica
//
//  Created by vineet patidar on 30/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKInstitudeCourseViewController.h"
#import "CourseCell.h"
#import "GKActionSheetPicker.h"
#import "GKActionSheetPickerItem.h"
#import "UNKCourseDetailsViewController.h"

@interface UNKInstitudeCourseViewController ()<GKActionSheetPickerDelegate,NSURLSessionDelegate>{
    
    NSString *sortBy;
    
}
// You have to have a strong reference for the picker
@property (nonatomic, strong) GKActionSheetPicker *picker;

@property (nonatomic, strong) NSString *basicCellSelectedString;
@property (nonatomic, strong) NSDate *dateCellSelectedDate;


@end

@implementation UNKInstitudeCourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isHude = YES;
    _filterLabel.layer.cornerRadius = 5.0;
    [_filterLabel.layer setMasksToBounds:YES];
    // Do any additional setup after loading the view.
   // [self getInstitudeCourse:self.institudeDictionary];
    sortBy = @"1";
    pageNumber = 1;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    pageNumber = 1;
}

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
        
        float reload_distance = 0;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                // _courseTable.tableFooterView = spinner;
                isHude=YES;
                [self getInstitudeCourse:self.institudeDictionary];
            }
            
        }
    }
    
    else{
        
        _courseTable.tableFooterView = nil;
    }
}
-(void)getInstitudeCourse:(NSMutableDictionary *)selectedDictionary{
    

    [self setHeadeViewData];

    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    
    if ([selectedDictionary valueForKey:Kid]) {
        [dictionary setValue:[selectedDictionary valueForKey:Kid] forKey:kinstitute_id];
    }
    else{
        [dictionary setValue:[selectedDictionary valueForKey:kinstitute_id] forKey:kinstitute_id];

    }
    
    [dictionary setValue:sortBy forKey:@"sort_by"];
    [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPage_number];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute-course.php"];
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:isHude showSystemError:isHude completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                isHude = NO;
                isLoading = NO;
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    if (pageNumber == 1 ) {
                        if (_courseArray) {
                            [_courseArray removeAllObjects];
                        }
                        _courseArray = [dictionary valueForKey:kAPIPayload];
                        
                        if(_courseArray.count==10){
                            pageNumber = 2;

                        }
                    }
                    else{
                        NSMutableArray *arr = [dictionary valueForKey:kAPIPayload];
                        
                        
                        if(arr.count > 0){
                            
                            [_courseArray addObjectsFromArray:arr];
                            
//                            NSArray * newArray =
//                            [[NSOrderedSet orderedSetWithArray:_courseArray] array];
//                            _courseArray =[[NSMutableArray alloc] initWithArray:newArray];
                        }
                        NSLog(@"%lu",(unsigned long)_courseArray.count);
                        pageNumber = pageNumber+1 ;
                    }
                    //_courseArray = [dictionary valueForKey:kAPIPayload];;
                    [_courseTable reloadData];
                    
                }
                else{
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
//                            
//                        }];
//                    });
                }
                isLoading = NO;
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
-(void)setHeadeViewData{
    
    // name
    institudeNameLabel.text = [self.institudeDictionary valueForKey:kName];
    
    // image
    if (![[self.institudeDictionary valueForKey:kinstitute_image] isKindOfClass:[NSNull class]]) {
        [_imageView sd_setImageWithURL:[NSURL URLWithString:[self.institudeDictionary valueForKey:kinstitute_image]] placeholderImage:[UIImage imageNamed:@"banner"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            NSLog(@"%@",error);
        }];
    }
    
    // like
    
  if ([[self.institudeDictionary valueForKey:kis_like]boolValue] ==true || [[self.institudeDictionary valueForKey:kIslike]boolValue] ==true) {        [_likeButton setBackgroundImage:[UIImage imageNamed:@"FavoriteTransparent"] forState:UIControlStateNormal];
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

    return [_courseArray count];
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
        
        NSString *courseName = [[_courseArray objectAtIndex:indexPath.row] valueForKey:kcourse_name];
    
            if ([Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                height = [Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
            }
            else{
                height = 0.0;
            }
 
            NSString *feeString = [self convertHtmlPlainText:[_aboutInstitudeDictionary valueForKey:kapplication_fee]];
    
            if ([Utility getTextHeight:feeString size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
                height = ([Utility getTextHeight:feeString size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20)+height;
            }
            else{
                height = 0.0+height;
            }
            
            return 90+height;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"courseCell";
    
    
    CourseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *courseName = [[_courseArray objectAtIndex:indexPath.row] valueForKey:kcourse_name];
    
    // Course  name
    if (![courseName isKindOfClass:[NSNull class]]) {
        cell.courseNameLabelHeight.constant = [Utility getTextHeight:courseName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];

        cell.courseNameLabel.text = courseName;
    }
    
    // hide
    cell.courseTopButton.hidden = YES;
    cell.applyButton.hidden = YES;
    cell.likeButton.hidden = YES;
    cell.chemarkButton.hidden = YES;
    cell.scholarshipLabel.hidden = YES;
    cell.universityNameLabel.hidden = YES;
    
    
    // Application fee
    NSString *applicationFee;
     NSString *feeString = [[_courseArray objectAtIndex:indexPath.row] valueForKey:kapplication_fee];
    
    
    if (![feeString isKindOfClass:[NSNull class]] && ![feeString isEqualToString:@""]) {
        
        applicationFee = [NSString stringWithFormat:@"Application Fee: %@(Approx:%@)",feeString,[[_courseArray objectAtIndex:indexPath.row]valueForKey:@"approx_fee"]];
    }
    else{
        applicationFee = [NSString stringWithFormat:@"Application Fee: %@(Approx:%@)",feeString,[[_courseArray objectAtIndex:indexPath.row]valueForKey:@"approx_fee"]];
    }
    
    cell.feeLabel.text = applicationFee;
    cell.feeLabelHeight.constant = 40;

    
    // profile image
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    [cell.profileImage.layer setMasksToBounds:YES];
    
    cell.courseView.layer.cornerRadius = 5.0;
    [cell.courseView.layer setMasksToBounds:YES];
    
   
    
    cell.imageBackgroundView.layer.cornerRadius = cell.imageBackgroundView.frame.size.width/2;
    cell.imageBackgroundView.layer.borderWidth =1.0;
    cell.imageBackgroundView.layer.borderColor = [UIColor blackColor].CGColor;
    [cell.imageBackgroundView.layer setMasksToBounds:YES];
    
    cell.countryName.text = [[_courseArray objectAtIndex:indexPath.row]valueForKey:kcourse_country];
    
    // cell image
    
    if (![[[_courseArray objectAtIndex:indexPath.row] valueForKey:kcountry_image] isKindOfClass:[NSNull class]]) {
        
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[[_courseArray objectAtIndex:indexPath.row] valueForKey:kcountry_image]] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if (!image) {
                cell.placeHoderImageView.image = [UIImage imageNamed:@"StepCourse"];
                cell.placeHoderImageView.hidden = NO;
            }
        }];
        
       
    }
  
    
    
    // next arraow image view
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kiPhoneWidth-70, 20, 20, 20)];
    imageView.image = [UIImage imageNamed:@"arrowNext"];
    [cell.courseView addSubview:imageView];
    
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[_courseArray objectAtIndex:indexPath.row]];
      [dict setValue:[self.institudeDictionary  valueForKey:Kid] forKey:kinstitute_id];
 [self performSegueWithIdentifier:kcourseDetailsViewController sender:dict];
}

#pragma mark - button clicked

- (IBAction)filterButton_clicked:(id)sender {
    
    NSArray *items = @[@"Low to High", @"High to Low"];
    
    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        
        self.basicCellSelectedString = (NSString *)selected;
        if ([self.basicCellSelectedString isEqualToString:@"Low to High"]) {
            sortBy = @"1";
        }
        else{
            sortBy = @"2";
        }
        pageNumber=1;
        _filterLabel.text = [NSString stringWithFormat:@"%@", selected];
         [self getInstitudeCourse:self.institudeDictionary];

        
    } cancelCallback:nil];
    
    [self.picker presentPickerOnView:self.view];
    self.picker.title = @"Filter";
    [self.picker selectValue:self.basicCellSelectedString];
}

- (IBAction)messageButton_clicked:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MessagePopViewController *messageView = [storyBoard instantiateViewControllerWithIdentifier:@"MessagePopViewController"];
    messageView.dictionary = self.institudeDictionary;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messageView];
    [self presentViewController:nav animated:YES completion:nil];

}

- (IBAction)likeButtonClicked:(id)sender {
    [self institudeLike:self.institudeDictionary];
}



-(NSString*)convertHtmlPlainText:(NSString*)HTMLString{
    
    NSData *HTMLData = [HTMLString dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:HTMLData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:NULL error:NULL];
    NSString *plainString = attrString.string;
    return plainString;
}



#pragma course like

-(void)institudeLike:(NSMutableDictionary*)courseDictionary{
    
    NSString *likeString;
    NSString *message;
    
    
    if ([[courseDictionary valueForKey:kis_like] boolValue] == true || [[courseDictionary valueForKey:kIslike] boolValue] == true
        ) {
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
    
    if ([self.institudeDictionary  valueForKey:Kid]) {
        [dictionary setValue:[self.institudeDictionary  valueForKey:Kid] forKey:kinstitute_id];
    }
    else{
        [dictionary setValue:[self.institudeDictionary  valueForKey:kinstitute_id] forKey:kinstitute_id];
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
                        
                        if (![self.incomingViewType isEqualToString:kFavourite]) {
                            AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                            [appDelegate getFavouriteList:@"student-fav-institutes.php" :kINSTITUDE];
                        }
                        [self.institudeDictionary setValue:likeString forKey:kIslike];
                        
                       
                    }
                    
                    
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
        
    }];

}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:kcourseDetailsViewController]) {
         UNKCourseDetailsViewController *courseDetails = segue.destinationViewController;
         courseDetails.selectedCourseDictionary = sender;
         
     }
 }
 


@end
