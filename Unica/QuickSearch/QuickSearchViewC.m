//
//  QuickSearchViewC.m
//  Unica
//
//  Created by Shilpa Sharma on 03/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "QuickSearchViewC.h"
#import "courseFeeCell.h"
#import "CourseDescriptionCell.h"

@interface QuickSearchViewC ()

@end

@implementation QuickSearchViewC

#pragma mark: View Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark: Private Methods

- (void)setUpView {
    arrQuickCourse = [[NSMutableArray alloc] init];
    currentCourse = 0;
    [self apiCallQuickCourse];
}

- (void)setUpCourseData {
    courseDetailDictioanry = nil;
    courseDetailDictioanry = [[NSMutableDictionary alloc] init];
    NSDictionary *dictCourse = arrQuickCourse[currentCourse];
    courseDetailDictioanry = dictCourse[@"course_detail"];
    [self setHeaderViewData];
    [_tblViewQuickSearch reloadData];
}

-(void)setHeaderViewData{
    
    NSString *course ;
    if([courseDetailDictioanry valueForKey:ktitle])
    {
        course = [courseDetailDictioanry valueForKey:ktitle];
    }
    else
    {
        course = [courseDetailDictioanry valueForKey:kcourse_name];
    }
    CGFloat height = 0.0;
    
    // Course  name
    if (![courseName isKindOfClass:[NSNull class]] && [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]>25) {
        _courseNameHeight.constant = [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        height = [Utility getTextHeight:course size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;
        
    }
    courseName.text = course;
    
    
    NSString *instituteName ;
    if([courseDetailDictioanry valueForKey:kinstitute_name])
    {
        instituteName = [courseDetailDictioanry valueForKey:kinstitute_name];
    }
    else
    {
        instituteName = [courseDetailDictioanry valueForKey:kUnivercity_name];
    }
    
    // university name
    if (![instituteName isKindOfClass:[NSNull class]]&& [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]>20) {
        _universityNameHeight.constant = [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium];
        
        height = [Utility getTextHeight:instituteName size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]-20;
    }
    _universityName.text = instituteName;
    
    
    CGRect frame = _headerView.frame;
    frame.size.height = height+frame.size.height;
    _headerView.frame = frame;
    
    
    _countryName.text = [courseDetailDictioanry valueForKey:kCountry];
    _countryName2.text = [courseDetailDictioanry valueForKey:kCountry];
    
    //    // country image
    //    _countryImage.layer.cornerRadius = _countryImage.frame.size.width/2;
    //    [_countryImage.layer setMasksToBounds:YES];
    
    NSString *countryImage ;
    if([courseDetailDictioanry valueForKey:kcountry_image])
    {
        countryImage = [courseDetailDictioanry valueForKey:kcountry_image];
    }
    else
    {
        countryImage = [courseDetailDictioanry valueForKey:@"country_flag"];
    }
    
    if (![countryImage isKindOfClass:[NSNull class]]) {
        
        [_countryImage sd_setImageWithURL:[NSURL URLWithString:countryImage] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
    
    // chech mark image
    
    if ([[courseDetailDictioanry valueForKey:kis_eligible] boolValue]== true) {
        [_checkMarkButton setImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
    }
    
    // like
    
    if ([[courseDetailDictioanry valueForKey:kis_like]boolValue] ==true) {
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
    }
    else{
        
        
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
    }
    [_likeButton setHidden:NO];
    
    
    _imageBackgroundView.layer.cornerRadius = _imageBackgroundView.frame.size.width/2;
    _imageBackgroundView.layer.borderWidth =1.0;
    _imageBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_imageBackgroundView.layer setMasksToBounds:YES];
    
    
    _tblViewQuickSearch.layer.cornerRadius = 5.0;
    [_imageBackgroundView.layer setMasksToBounds:YES];
    
    
//    if ([[courseDetailDictioanry valueForKey:kapplied]boolValue] ==true) {
//        _applyButton.backgroundColor = [UIColor grayColor];
//        _applyButton.userInteractionEnabled = NO;
//        [_applyButton setTitle:@"Application Sent" forState:UIControlStateNormal];
//    }
//    else{
//        
//        [_applyButton addTarget:self action:@selector(applyButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
//    _applied_count = [[courseDetailDictioanry valueForKey:@"applied_count"] integerValue];
//    _apply_limit = [[courseDetailDictioanry valueForKey:@"apply_limit"] integerValue];
}

#pragma mark: IBAction Methods

- (IBAction)tapCross:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)tapInterested:(UIButton *)sender {
    [self courseInterestNotInterest:@"Y"];
}

- (IBAction)tapNotInterested:(UIButton *)sender {
    [self courseInterestNotInterest:@"N"];
}

- (IBAction)tapFav:(UIButton *)sender {
    [self courseLike];
}

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(courseDetailDictioanry.count>0)
    {
        if (section ==1) {
            return 2;
        }
        if (section ==2) {
            return [[courseDetailDictioanry valueForKey:kcharges] count]-3;
        }
        else if (section ==5){
            
            return [[courseDetailDictioanry valueForKey:kintake] count];
            
        }
        else  if (section == 4){
            
            return 0;
        }
        else  if (section == 6){
            
            return 0;//[[courseDetailDictioanry valueForKey:ktimeline] count];
        }
        
        return 1;
    }
    else
    {
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 5 ){
        return 40;
        
    }
    else if (section == 6){
        
        return 0;//40;
        
    }
    else if (section != 0) {
        return 1;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    if (section == 5 ){
        view.frame = CGRectMake(0, 0, kiPhoneWidth, 40);
        view.backgroundColor = [UIColor whiteColor];
        
        
        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kiPhoneWidth-20, 40)];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.text = @"Intakes";
        [view addSubview:headerLabel];
        
        return view;
    }
    else if (section == 6){
        view.frame = CGRectMake(0, 0, kiPhoneWidth, 0);
//        view.backgroundColor = [UIColor whiteColor];
//
//        UILabel *headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, kiPhoneWidth-40, 30)];
//        headerLabel.backgroundColor = [UIColor clearColor];
//        headerLabel.text = @"Timelines";
//        [view addSubview:headerLabel];
//
//        UIImageView *clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 20,20)];
//        clockImage.image = [UIImage imageNamed:@"Clock"];
//        [view addSubview:clockImage];
//
//        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 1)];
//        lineLabel.backgroundColor = [UIColor lightGrayColor];
//        [view addSubview:lineLabel];
        
        return view;
    }
    
    
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        //        double height = 0.0;
        
//        if (![[Utility replaceNULL:[courseDetailDictioanry valueForKey:kdescription] value:@""] isEqualToString:@""]) {
        
//            if (webview.scrollView
//                .contentSize.height>0) {
//                return webview.scrollView.contentSize.height+30;
//            }
            return 0;
//        }
//        return 40;
        
    }
    else if (indexPath.section== 7){
       /* double height = 0.0;
        
        NSString *eligibility = [courseDetailDictioanry valueForKey:keligibility_domestic_student];
        
        if (![eligibility isKindOfClass:[NSNull class]] &&  [Utility getTextHeight:eligibility size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]> 20) {
            
            height =  [Utility getTextHeight:eligibility size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
        }
        else{
            height = 0.0;
            
        }*/
        return 0;//60+height;
        
        
    }
    else if (indexPath.section== 8){
        
        double height = 0.0;
        
//        NSString *other = [courseDetailDictioanry valueForKey:kother_admission_requirement];
//
//        if (![other isKindOfClass:[NSNull class]] && [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
//            height = [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
//        }
//        else{
//            height = 0.0;
//        }
        return 0;//60+height;
        
        
    }
    else if (indexPath.section== 9){
        
//        double height = 0.0;
//
//        NSString *special = [courseDetailDictioanry valueForKey:kspecial_appl_instructions];
//
//        if ([Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]) {
//            height = [Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField]-20;
//        }
//        else{
//            height = 0.0;
//        }
        return 0;//60+height;
    }
    else if(indexPath.section==4)
    {
        return 0;
    }
    else if(indexPath.section==2)
    {
        if (indexPath.row ==0) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
            else{
                return 40;
            }
            
        }
        else if (indexPath.row ==1) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
            else{
                return 40;
            }
            
        }
        else   if (indexPath.row ==2) {
            
            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
            else{
                return 40;
            }
            
        }
        
        else  {
            
            // cell.textLabel.text = [NSString stringWithFormat:@"Tution Fee Breakup : %@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] ];
//            if([Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField]>40)
//                return [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-140, CGFLOAT_MAX) font:kDefaultFontForTextField];
//            else{
//                return 40;
//            }
            return 0;
            
        }
    }
    else
        return 40;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 1 ){
        
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Duration :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Duration :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Duration :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kduration]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kduration]  ];
                cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
                
            }
            
        }
        else  {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Average processing time :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Average processing time :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Average processing time :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time] ];
                
                cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
                
            }
        }
        
        return cell;
    }
    else if (indexPath.section ==2){
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Tution Fee : ";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Tution Fee : " size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Tution Fee : " size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee] ];
                
            }
            
        }
        else if (indexPath.row ==1) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Application Fee :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Application Fee :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Application Fee :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kapplication_fee] ];
                
                
                
            }
        }
        else   if (indexPath.row ==2) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] isKindOfClass:[NSNull class]]) {
                
                cell.headinLabel.text = @"Living Cost :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Living Cost :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Living Cost :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kliving_cost] ];
                
            }
        }
        
      /*  else  if (indexPath.row ==3 ) {
            
            cell.headinLabel.text = @"Tution Fee Breakup :";
            CGRect lblFrame1 =cell.headinLabel.frame;
            lblFrame1.size.width =[Utility getTextWidth:@"Tution Fee Breakup :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell.headinLabel.frame= lblFrame1;
            cell.headingWidthConstant.constant = [Utility getTextWidth:@"Tution Fee Breakup :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            float hight = [Utility getTextHeight:[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
            if(hight<30)
                hight=30;
            
            cell.descHeightConstant.constant = hight;
            
            CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
            
            cell.descLabel.frame=lblFrame;
            cell.descLabel.numberOfLines=0;
            cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
            //[cell.descLabel sizeToFit];
            cell.descLabel.text =[NSString stringWithFormat:@"%@",[[courseDetailDictioanry valueForKey:kcharges] valueForKey:ktution_fee_breakup] ];
            
            
        }*/
        
        return  cell;
        
    }
    
    if (indexPath.section == 3){
        
        
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        
        if (indexPath.row ==0) {
            
            if (![[[courseDetailDictioanry valueForKey:kcharges] valueForKey:kcourse_level] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Program Level :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Program Level :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Program Level :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kcourse_level]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+40), CGFLOAT_MAX) font:kDefaultFontForTextFieldMeium]+5;
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+40), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                
                NSString* myString =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kcourse_level]];
                
                NSMutableAttributedString * tempString = [[NSMutableAttributedString alloc] initWithString:myString];
                
                
                [tempString addAttributes:@{NSFontAttributeName : kDefaultFontForTextFieldMeium,
                                            NSForegroundColorAttributeName : [UIColor darkGrayColor]}
                                    range:NSMakeRange(0, myString.length)];
                cell.descLabel.attributedText = tempString;
                //cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kduration]  ];
                
                cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
                
            }
            
        }
        
        
        
        
        
        return cell;
    }
    
    if (indexPath.section == 4){
        
        /* static NSString *cellIdentifier = @"cell";
         
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.font = [UIFont systemFontOfSize:14];
         cell.textLabel.textColor = [UIColor colorWithRed:121.0f/255.0f green:138.0f/255.0f blue:152.0f/255.0f alpha:1.0];
         cell.textLabel.numberOfLines = 2;
         
         
         if (indexPath.row==0) {
         cell.imageView.image = [UIImage imageNamed:@"Clock"];
         cell.textLabel.text = [NSString stringWithFormat:@"Submission Deadline : %@",[courseDetailDictioanry valueForKey:kprocessing_time]];
         }*/
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Clock"];
        
        if (indexPath.row ==0) {
            
            if (![[courseDetailDictioanry valueForKey:kprocessing_time] isKindOfClass:[NSNull class]]) {
                cell.headinLabel.text = @"Submission Deadline :";
                CGRect lblFrame1 =cell.headinLabel.frame;
                lblFrame1.size.width =[Utility getTextWidth:@"Submission Deadline :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                cell.headinLabel.frame= lblFrame1;
                cell.headingWidthConstant.constant = [Utility getTextWidth:@"Submission Deadline :" size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
                float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
                if(hight<30)
                    hight=30;
                
                cell.descHeightConstant.constant = hight;
                
                CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
                
                cell.descLabel.frame=lblFrame;
                cell.descLabel.numberOfLines=0;
                cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
                //[cell.descLabel sizeToFit];
                cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time]  ];
                
                
                
            }
            
        }
        return cell;
    }
    
    else if (indexPath.section == 5){
        
        /*static NSString *cellIdentifier = @"cell";
         
         UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
         if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         }
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.font = [UIFont systemFontOfSize:14];
         cell.textLabel.textColor = [UIColor colorWithRed:121.0f/255.0f green:138.0f/255.0f blue:152.0f/255.0f alpha:1.0];
         cell.textLabel.numberOfLines = 2;
         
         cell.imageView.image = [UIImage imageNamed:@"Calendar"];
         
         
         
         if ([[courseDetailDictioanry valueForKey:kintake] count]>0) {
         
         cell.textLabel.text = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]];
         
         
         }
         return  cell;*/
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
        
        if ([[courseDetailDictioanry valueForKey:kintake] count]>0) {
            cell.headinLabel.text = [NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]];
            CGRect lblFrame1 =cell.headinLabel.frame;
            lblFrame1.size.width =[Utility getTextWidth:[NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell.headinLabel.frame= lblFrame1;
            cell.headingWidthConstant.constant = [Utility getTextWidth:[NSString stringWithFormat:@"%@",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:kintake] objectAtIndex:indexPath.row]valueForKey:kmessage]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            /*  float hight = [Utility getTextHeight:[courseDetailDictioanry valueForKey:kprocessing_time]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
             if(hight<30)
             hight=30;
             
             cell.descHeightConstant.constant = hight;
             
             CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
             
             cell.descLabel.frame=lblFrame;
             cell.descLabel.numberOfLines=0;
             cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
             //[cell.descLabel sizeToFit];
             cell.descLabel.text =[NSString stringWithFormat:@"%@",[courseDetailDictioanry valueForKey:kprocessing_time]  ];*/
            cell.descLabel.hidden=YES;
        }
        
        return cell;
        
        
    }
    
    else if (indexPath.section == 6){
        
        static NSString *cellIdentifier  =@"timeLineCell";
        courseFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"courseFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.headinLabel.textColor = [UIColor grayColor];
        cell.descLabel.textColor = [UIColor grayColor];
        cell.descLabel.numberOfLines=0;
        cell.iconImageView.image =[UIImage imageNamed:@"Calendar"];
        cell.iconImageView.hidden = YES;
        cell.imageWidth.constant = 0;
        cell.imageX_Axis.constant = 0;
        cell.headingLaelX_Axis.constant = 0;
        if ([[courseDetailDictioanry valueForKey:ktimeline] count]>0) {
            
            cell.headinLabel.text = [NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]];
            
            CGRect lblFrame1 =cell.headinLabel.frame;
            
            lblFrame1.origin.x = 14;
            lblFrame1.size.width =[Utility getTextWidth:[NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            cell.headinLabel.frame= lblFrame1;
            
            CGFloat lblWidth = [Utility getTextWidth:[NSString stringWithFormat:@"%@ :",[Utility replaceNULL:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kName]  value:@""]] size:CGSizeMake(kiPhoneWidth-20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            cell.headingWidthConstant.constant = lblWidth;
            
            
            float hight = [Utility getTextHeight:[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kValue]  size:CGSizeMake(kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), CGFLOAT_MAX) font:kDefaultFontForTextField];
            
            if(hight<30)
                hight=30;
            
            cell.descHeightConstant.constant = hight;
            
            CGRect lblFrame = CGRectMake(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+5,3.5, kiPhoneWidth-(cell.headinLabel.frame.origin.x+cell.headinLabel.frame.size.width+20), hight);
            
            cell.descLabel.textAlignment = NSTextAlignmentRight;
            cell.descLabel.frame=lblFrame;
            cell.descLabel.numberOfLines=0;
            cell.descLabel.lineBreakMode = NSLineBreakByWordWrapping;
            //[cell.descLabel sizeToFit];
            cell.descLabel.text =[[[courseDetailDictioanry valueForKey:ktimeline] objectAtIndex:indexPath.row]valueForKey:kValue];
            
        }
        return cell;
        
    }
    
    static NSString *cellIdentifier  =@"descriptionCell";
    CourseDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseDescriptionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
 /*   if (indexPath.section ==0) {
//        cell.headerLabel.text = @"Description";
//
//        if (![[Utility replaceNULL:[courseDetailDictioanry valueForKey:kdescription] value:@""] isEqualToString:@""]) {
//
////            [cell.contentView addSubview:webview];
//        }
        
    }
    
    else if (indexPath.section== 7){
        
        cell.headerLabel.text = @"Eligibility";
        NSString *description =  [courseDetailDictioanry valueForKey:keligibility_domestic_student];
        
        // Eligibility Domestic Student
        if (![description isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:description size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = description;
        }
        
    }
    else if (indexPath.section== 8){
        
        cell.headerLabel.text = @"Other Requirements";
        NSString *other = [courseDetailDictioanry valueForKey:kother_admission_requirement];
        
        // Other  Admission Requirement
        if (![other isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:other size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = other;
        }
        
    }
    else if (indexPath.section== 9){
        
        cell.headerLabel.text = @"Special Application Instructions";
        NSString *special = [courseDetailDictioanry valueForKey:kspecial_appl_instructions];
        
        // Special Appl Instructions
        
        if (![special isKindOfClass:[NSNull class]]) {
            cell._descriptionLabelHeight.constant = [Utility getTextHeight:special size:CGSizeMake(kiPhoneWidth -20, CGFLOAT_MAX) font:kDefaultFontForTextField];
            cell._descriptionLabel.text = special;
        }
    }*/
    return  cell;
}


#pragma mark Api call

- (void)apiCallQuickCourse {
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"quick_find_course.php"];
    
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dict, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dict valueForKey:kAPICode] integerValue]== 200) {
                    arrQuickCourse = [dict valueForKey:kAPIPayload];
                    [self setUpCourseData];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([[dict valueForKey:@"Message"] isEqualToString:@"No Records found"]) {
                            [self dismissViewControllerAnimated:true completion:nil];
                        }
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


-(void)courseLike {
    
    NSString *likeString ;
    if ([courseDetailDictioanry valueForKey:kis_like]) {
        likeString  = [courseDetailDictioanry valueForKey:kis_like];
    } else{
        likeString  = [courseDetailDictioanry valueForKey:kis_like];
    }
    NSString *message;
    
    if ([likeString boolValue] == 0) {
        likeString = @"true";
        message = @"Adding this to your Favourites";
        
    }
    else{
        likeString = @"false";
        message = @"Removing this from your Favourites ";
    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    if(![courseDetailDictioanry valueForKey:ktitle])
    {
        [dictionary setValue:[courseDetailDictioanry valueForKey:kcourse_id] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[courseDetailDictioanry valueForKey:Kid] forKey:kcourse_id];
    }
    
    
    
    [dictionary setValue:likeString forKey:kstatus];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student_like_course.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:message params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    if ([likeString boolValue] ==true) {
                        [_likeButton setBackgroundImage:[UIImage imageNamed:@"Favorite"] forState:UIControlStateNormal];
                        [courseDetailDictioanry setValue:likeString forKey:kis_like];
                    }
                    else if ([likeString boolValue] ==false) {
                        [_likeButton setBackgroundImage:[UIImage imageNamed:@"UnFavorite"] forState:UIControlStateNormal];
                        [courseDetailDictioanry setValue:likeString forKey:kis_like];
                    }
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


-(void)courseInterestNotInterest:(NSString *)interested {
    
//    NSString *likeString ;
//    if ([courseDetailDictioanry valueForKey:kis_like]) {
//        likeString  = [courseDetailDictioanry valueForKey:kis_like];
//    } else{
//        likeString  = [courseDetailDictioanry valueForKey:kis_like];
//    }
//    NSString *message;
//
//    if ([likeString boolValue] == 0) {
//        likeString = @"true";
//        message = @"Adding this to your Shortlist";
//
//    }
//    else{
//        likeString = @"false";
//        message = @"Removing this from your Favourites ";
//    }
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    if(![courseDetailDictioanry valueForKey:ktitle])
    {
        [dictionary setValue:[courseDetailDictioanry valueForKey:kcourse_id] forKey:kcourse_id];
    }
    else{
        [dictionary setValue:[courseDetailDictioanry valueForKey:Kid] forKey:kcourse_id];
    }
    [dictionary setValue:interested forKey:@"interested"];
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"interested_student_course.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    if (currentCourse == ([arrQuickCourse count] - 1)) {
                        [self apiCallQuickCourse];
                    } else {
                        currentCourse = currentCourse + 1;
                        [self setUpCourseData];
                    }
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
