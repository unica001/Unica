
#import "UNKRecordExpressionController.h"
#import "remarkCell.h"
#import "studentCell.h"

@interface UNKRecordExpressionController (){
    
    __weak IBOutlet UIImageView *cardImageView;
    NSMutableDictionary *detail;
    NSArray *actions,*category,*template;
    NSMutableArray *headerTextArray;
    NSMutableDictionary *loginDictionary,*orignalDic;
    
    NSString *actionString;
    NSString *categoryString;
    NSString *emailTemplateString;
    NSString *dateString;
    NSString *remarkTextView;
    
    NSString *actionID;
    NSString *categoryID;
    NSString *templeteID;
}

@end

@implementation UNKRecordExpressionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    actionString = @"Select Action";
    categoryString = @"Select Category";
    emailTemplateString = @"Select Email Template";
    dateString = @"Select Date";
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    actions =[[[UtilityPlist getData:KActions] valueForKey:kAPIPayload] valueForKey:@"action_lists"];
    category =[[[UtilityPlist getData:Kcategories] valueForKey:kAPIPayload] valueForKey:@"category_lists"];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [menuButton setTarget: self.revealViewController];
            [menuButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
    }
    self.revealViewController.delegate = self;
    
    
    [self setupInitialLayout];
    [self GetTemplateList];
}
-(void)viewWillAppear:(BOOL)animated{
}

-(void)setupInitialLayout{
    headerTextArray = [[NSMutableArray alloc] initWithObjects:@"Action",@"Category",@"Remarks",@"Template",@"Date", nil];
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
    if(indexPath.row == 2)
    {
            static NSString *cellIdentifier3  =@"signIn8";
        
            remarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"remarkCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.remarktextView.text = [detail valueForKey:@"remarks"];
            return cell;
        }
   
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
    
        switch (indexPath.row) {
            case 0:
                cell.detailLabel.text = actionString;
                break;
            case 1:
                cell.detailLabel.text = categoryString;
                break;
            case 3:
                cell.detailLabel.text = emailTemplateString;
                break;
            case 4:
                cell.detailLabel.text = dateString;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==2)
    {
        return 140;
    }
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0 && actions.count>0) {
        [self actiontype];
    }
    else if (indexPath.row == 1 && category.count>0) {
        [self categoryType];
    }
    else  if (indexPath.row == 3 && template.count>0) {
        [self emailTempleteType];
    }
    else if (indexPath.row == 4 ) {
        [self addDatePicker];
    }
}

-(void)actiontype{
    
    NSArray *items = [actions valueForKey:@"title"];
    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
        NSArray *filtredArray = [actions filteredArrayUsingPredicate:predicate];
        if(filtredArray.count>0)
        {
            actionString = [NSString stringWithFormat:@"%@", selected];
            actionID = filtredArray[0][@"id"];
            [tableView reloadData];

        }
    } cancelCallback:nil];
    
    [self.picker presentPickerOnView:self.view];
    self.picker.title = @"Select Actions";
    [self.picker selectValue:actionString];
}
-(void)categoryType{
    
    NSArray *items = [category valueForKey:@"title"];
    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
        NSArray *filtredArray = [category filteredArrayUsingPredicate:predicate];
        if(filtredArray.count>0)
        {
            categoryString = [NSString stringWithFormat:@"%@", selected];
            categoryID = filtredArray[0][@"id"];
            [tableView reloadData];

        }
    } cancelCallback:nil];
    
    [self.picker presentPickerOnView:self.view];
    self.picker.title = @"Select Category";
    [self.picker selectValue:categoryString];
}

-(void)emailTempleteType{
    NSArray *items = [template valueForKey:@"title"];
    self.picker = [GKActionSheetPicker stringPickerWithItems:items selectCallback:^(id selected) {
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"title == %@",selected];
        NSArray *filtredArray = [template filteredArrayUsingPredicate:predicate];
        if(filtredArray.count>0)
        {
            emailTemplateString = [NSString stringWithFormat:@"%@", selected];
            templeteID = filtredArray[0][@"id"];
            [tableView reloadData];
        }
    } cancelCallback:nil];
    
    [self.picker presentPickerOnView:self.view];
    self.picker.title = @"Select Template";
    [self.picker selectValue:emailTemplateString];
}

-(void)addDatePicker{
    self.picker = [GKActionSheetPicker datePickerWithMode:UIDatePickerModeDate from:[NSDate date] to:[NSDate dateWithTimeIntervalSinceNow:+60*60*24*365*48] interval:5 selectCallback:^(id selected) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *selectedDate = [dateFormatter stringFromDate:selected];
        
        dateString = [NSString stringWithFormat:@"%@", selectedDate];
        [tableView reloadData];

    } cancelCallback:^{
    }];
    
    self.picker.title = @"Select Date";
    [self.picker presentPickerOnView:self.view];
    [self.picker selectDate:self.dateCellSelectedDate];
}



#pragma MARK - APIs call

-(void)GetTemplateList
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"template-lists.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    template = [payloadDictionary valueForKey:@"template_lists"];
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

@end
