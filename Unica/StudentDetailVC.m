//
//  StudentDetailVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "StudentDetailVC.h"
#import "studentCell.h"

@interface StudentDetailVC ()
{
     NSMutableArray *headerTextArray;
    NSMutableDictionary *loginDictionary;
    __weak IBOutlet UILabel *lblEventName;
}

@end

@implementation StudentDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupInitialLayout];
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    [self loadPieChart];
    if([[self.detail valueForKey:@"interested"] boolValue]== true)
    {
        discardButton.userInteractionEnabled = false;
        [discardButton setTitle:@"EXISTING RECORD" forState:UIControlStateNormal];
        [saveButton setTitle:@"UPDATE" forState:UIControlStateNormal];
        remarkView.text = [self.detail valueForKey:@"remark"];

    }
    remarkView.layer.borderWidth = 1;
    remarkView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    if(self.isEdit!=nil)
    {
        discardButton.hidden = true;
        saveButton.hidden = true;
        remarkView.editable = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupInitialLayout{
    headerTextArray = [[NSMutableArray alloc] initWithObjects:@"Name",@"Email ID",@"Phone No",@"City",@"Country",@"Current Qualification Status",@"Course Name",@"Current Qualification Level",@"Country of Last Level of Education",@"Grades",@"Level of Interest",@"Type of Course",@"Year of Start",@"Field of Interest for Study",@"Valid Scores OR English Proficiency Level",@"Budget Preference",@"Country of Interest", nil];
}

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return headerTextArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier3  =@"signIn";
    
    
    studentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"studentCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentHeaderLabel.text = [headerTextArray objectAtIndex:indexPath.row];
    cell.outerView.layer.cornerRadius = 3;
    cell.outerView.layer.borderWidth = 1;
    cell.outerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.outerView.clipsToBounds = YES;
   
   // "student_id": "1602",
    
    
    switch (indexPath.row) {
        case 0:
            cell.detailLabel.text = [self.detail valueForKey:@"name"];
            break;
        case 1:
            cell.detailLabel.text = [self.detail valueForKey:@"email"];
            break;
        case 2:
            cell.detailLabel.text = [self.detail valueForKey:@"phone"];
            break;
        case 3:
            cell.detailLabel.text = [self.detail valueForKey:@"city"];
            break;
        case 4:
            cell.detailLabel.text = [self.detail valueForKey:@"country"];
            break;
        case 5:
            cell.detailLabel.text = [self.detail valueForKey:@"current_qualification_status"];
            break;
        case 6:
            cell.detailLabel.text = [self.detail valueForKey:@"course_name"];
            break;
        case 7:
            cell.detailLabel.text = [self.detail valueForKey:@"current_qualification_level"];
            break;
        case 8:
            cell.detailLabel.text = [self.detail valueForKey:@"country_of_last_level_of_education"];
            break;
        case 9:
            cell.detailLabel.text = [self.detail valueForKey:@"grades"];
            break;
        case 10:
            cell.detailLabel.text = [self.detail valueForKey:@"level_of_interest"];
            break;
        case 11:
            cell.detailLabel.text = [self.detail valueForKey:@"type_of_course"];
            break;
        case 12:
            cell.detailLabel.text = [self.detail valueForKey:@"year_of_start"];
            break;
        case 13:
            cell.detailLabel.text = [self.detail valueForKey:@"field_of_interest_for_study"];
            break;
        case 14:
            cell.detailLabel.text = [self.detail valueForKey:@"valid_scores"];
            break;
        case 15:
            cell.detailLabel.text = [self.detail valueForKey:@"budget_preference"];
            break;
        case 16:
            cell.detailLabel.text = [self.detail valueForKey:@"country_of_interest"];
            break;
            
        default:
            break;
    }
    return cell;
    
    
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
    
    
}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section ==0 && indexPath.row==8)
//    {
//        return 170;
//    }
//    return 50;
//}


-(void)loadPieChart
{
    // code for pie char
    NSArray *items;
    NSString * matchedStr = [self.detail valueForKey:@"match_criteria"];
    matchedStr = [matchedStr stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSInteger matched = [matchedStr integerValue];
  //  matched =1;
    NSInteger remaning = 100-[matchedStr integerValue];
   
    items = @[[PNPieChartDataItem dataItemWithValue:matched color:[UIColor colorWithRed:(46/255.0) green:(137/255.0) blue:(212/255.0) alpha:1]  description:@"Matched"],
              [PNPieChartDataItem dataItemWithValue:remaning color:[UIColor colorWithRed:(255/255.0) green:(30/255.0) blue:(0/255.0) alpha:1] description:@"Unmatched"],
              
              ];
    if(kIs_Iphone4||kIs_Iphone5)
    {
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (SCREEN_WIDTH / 2.0 - 130), 30, 140, 140) items:items];
    }
    else{
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake((CGFloat) (SCREEN_WIDTH / 2.0 - 110), 30, 140, 140) items:items];
    }
    self.pieChart.descriptionTextColor = [UIColor blackColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = YES;
    self.pieChart.showOnlyValues = YES;
    self.pieChart.innerCircleRadius =0.00;
    [self.pieChart strokeChart];
    
    lblEventName.text = [_detail valueForKey:@"attending_event"];
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    [headerView addSubview:self.pieChart];
}

- (IBAction)backButton_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addRemark{
     NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
    [dic setValue:[NSString stringWithFormat:@"%@",remarkView.text] forKey:@"remark"];
    [dic setValue:[NSString stringWithFormat:@"%@",[self.detail valueForKey:@"student_id"]] forKey:@"student_id"];
    if ([_eventName isEqualToString:@""]) {
        [dic setValue:appDelegate.addressString forKey:@"attendingEvent"];
    } else {
        [dic setValue:_eventName forKey:@"attendingEvent"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"add-student-remark.php"];

    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dic  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {

        if (!error) {

            dispatch_async(dispatch_get_main_queue(), ^{

                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];

                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];

                }else{
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

- (IBAction)discardButton_Action:(id)sender {
    [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"Are you sure you want to discard?" block:^(int index) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)saveButton_Action:(id)sender {
    
    [self addRemark];

 /*   if([Utility validateField:remarkView.text])
    {
         [self addRemark];
    }
    else
    {
        [Utility showAlertViewControllerIn:self title:kErrorTitle message:@"Please add remarks" block:^(int index) {
            
        }];
    }*/
   
}
@end
