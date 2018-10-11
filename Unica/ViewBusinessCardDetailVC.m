//
//  ViewBusinessCardDetailVC.m
//  Unica
//
//  Created by Meenkashi on 4/6/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "ViewBusinessCardDetailVC.h"
#import "studentCell.h"
#import "remarkCell.h"
#import "AddBusinessCardVC.h"

@interface ViewBusinessCardDetailVC ()
{
    
    __weak IBOutlet UITableView *detaialTable;
    __weak IBOutlet UIImageView *cardImageView;
    NSMutableDictionary *detail;
    NSArray *actions,*category,*template, *country;
    NSMutableArray *headerTextArray;
    NSMutableDictionary *loginDictionary,*orignalDic;
    __weak IBOutlet UILabel *lblEventName;
    
}

@end


@implementation ViewBusinessCardDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    actions =[[[UtilityPlist getData:KActions] valueForKey:kAPIPayload] valueForKey:@"action_lists"];
    category =[[[UtilityPlist getData:Kcategories] valueForKey:kAPIPayload] valueForKey:@"category_lists"];
    country = [[UtilityPlist getData:KCountryList] valueForKey:@"countries"];
    [self setupInitialLayout];
    
        //dispatch_async(dispatch_get_main_queue(), ^{
    
    
    
       // });
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self GetTemplateList];
    [self getDetail];
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)setupInitialLayout{
    headerTextArray = [[NSMutableArray alloc] initWithObjects:@"Action",@"Category", @"Country",@"Location",@"Remarks",@"Template",@"Date",@"Details automatically fetched from business card",@"Delegate Name",@"Organisation Name",@"Email",@"Phone No",@"Designation", nil];
    
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
    if(indexPath.row == 4 || indexPath.row==7)
    {
        if(indexPath.row == 4 )
        {
            static NSString *cellIdentifier3  =@"signIn8";
            
            
            remarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"remarkCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //[cell.remarktextView removeFromSuperview];
            cell.remarktextView.text = [detail valueForKey:@"remarks"];
            cell.remarktextView.editable = false;
            return cell;
        }
        else
        {
            static NSString *simpleTableIdentifier = @"SimpleTableItem";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            }
            
            CGRect frame = CGRectMake(10,5 , kiPhoneWidth-30, 40);
            
            UILabel *lbl2 = [[UILabel alloc] initWithFrame:frame];
            lbl2.font = kDefaultFontForTextFieldMeium;
            lbl2.text = [headerTextArray objectAtIndex:indexPath.row];
             lbl2.numberOfLines = 0;
            [cell.contentView addSubview:lbl2];
            
            // cell.backgroundColor = [UIColor redColor];
            return cell;
        }
        
        
    }
    else
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
        
        
        switch (indexPath.row) {
            case 0:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"action"] value:@""];
                 break;
            case 1:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"category"] value:@""];
                
                break;
            case 2:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"country"] value:@""];
                
                break;
            case 3:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"location"] value:@""] ;
                break;
           case 5:
                cell.detailLabel.text = [Utility replaceNULL:[detail valueForKey:@"template"] value:@""];
                break;
            case 6:
            {
                if([Utility replaceNULL:[detail valueForKey:@"email_date"] value:@""].length>0)
                {
                    NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
                    [datePickerFormat setDateFormat:@"yyyy-MM-dd"];
                    NSDate *checkIn = [datePickerFormat dateFromString:[detail valueForKey:@"email_date"]];
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
                    cell.detailLabel.text = [dateFormatter stringFromDate:checkIn];
                }
//                cell.detailLabel.text = [NSString stringWithFormat:@"%@",[detail valueForKey:@"email_date"]];
                break;
                
            }
                
            case 8:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"delegate_name"] value:@""];
                break;
                
            case 9:
                cell.detailLabel.text = [Utility replaceNULL:[detail valueForKey:@"org_name"] value:@""];
                break;
            case 10:
                cell.detailLabel.text = [Utility replaceNULL:[detail valueForKey:@"email"] value:@""];
                break;
            case 11:
                cell.detailLabel.text = [Utility replaceNULL:[detail valueForKey:@"mobile"] value:@""];
                break;
            case 12:
                cell.detailLabel.text =[Utility replaceNULL:[detail valueForKey:@"designaion"] value:@""] ;
                break;
            
            default:
                break;
        }
        return cell;
        
    }
    
    
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==4)
    {
        return 140;
    }
    else if (indexPath.row==6)
    {
        return 60;
    }
    else if (indexPath.row==8)
    {
        return 45;
    }
    return UITableViewAutomaticDimension;
}


- (IBAction)backButton_Action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getDetail{
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setValue:userId forKey:@"user_id"];
    ;
    [dictionary setValue:[loginDictionary valueForKey:@"user_type"] forKey:@"user_type"];
    [dictionary setValue:@"1" forKey:kPage_number];
    [dictionary setValue:@"" forKey:@"keyword"];
    [dictionary setValue:@"" forKey:@"from_date"];
    [dictionary setValue:@"" forKey:@"to_date"];
    [dictionary setValue:self.businessCardId forKey:@"business_card_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"scan_card_view.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    orignalDic = [[NSMutableDictionary alloc] initWithDictionary:[[payloadDictionary valueForKey:@"scan_card"] objectAtIndex:0]];
                    detail = [[payloadDictionary valueForKey:@"scan_card"] objectAtIndex:0];
                    
                    [cardImageView sd_setImageWithURL:[NSURL URLWithString:[detail valueForKey:@"card_image"]] placeholderImage:[UIImage imageNamed:@"camera"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        if (error) {
                            cardImageView.image = [UIImage imageNamed:@"camera"];
                            
                        }
                        NSLog(@"%@",error);
                    }];
                    NSString *strEvent = [detail valueForKey:@"attending_event"];
                    strEvent = [strEvent stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                    lblEventName.text = strEvent;
                    
                    if([[NSString stringWithFormat:@"%@",[detail valueForKey:@"action"]] integerValue]>0)
                    {
                        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[detail valueForKey:@"action"]]];
                        
                        NSArray *filtredArray = [actions filteredArrayUsingPredicate:predicate];
                        if(filtredArray.count>0)
                        {
                            NSString *title = [[filtredArray objectAtIndex:0] valueForKey:@"title"];
                            [detail setValue:title forKey:@"action"];
                        }
                        else{
                             [detail setValue:@"" forKey:@"action"];
                        }
                        
                    }
                    else{
                        [detail setValue:@"" forKey:@"action"];
                    }
                    if([[NSString stringWithFormat:@"%@",[detail valueForKey:@"category"]] integerValue]>0)
                    {
                        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[detail valueForKey:@"category"]]];
                        
                        NSArray *filtredArray = [category filteredArrayUsingPredicate:predicate];
                        if(filtredArray.count>0)
                        {
                            NSString *title = [[filtredArray objectAtIndex:0] valueForKey:@"title"];
                            [detail setValue:title forKey:@"category"];
                        }
                        else{
                            [detail setValue:@"" forKey:@"category"];
                        }
                        
                    }
                    else{
                        [detail setValue:@"" forKey:@"category"];
                    }
                    if([[NSString stringWithFormat:@"%@",[detail valueForKey:@"country_id"]] integerValue]>0)
                    {
                        NSPredicate *predicate1 =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[detail valueForKey:@"country_id"]]];
                        
                        NSArray *filtredArray1 = [country filteredArrayUsingPredicate:predicate1];
                        if(filtredArray1.count>0)
                        {
                            NSString *title = [[filtredArray1 objectAtIndex:0] valueForKey:@"name"];
                            [detail setValue:title forKey:@"country"];
                        }
                        else{
                            [detail setValue:@"" forKey:@"country"];
                        }
                        
                    }
                    else{
                        [detail setValue:@"" forKey:@"country"];
                    }
                    if([[NSString stringWithFormat:@"%@",[detail valueForKey:@"template"]] integerValue]>0)
                    {
                        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",[detail valueForKey:@"template"]]];
                        
                        NSArray *filtredArray = [template filteredArrayUsingPredicate:predicate];
                        if(filtredArray.count>0)
                        {
                            NSString *title = [[filtredArray objectAtIndex:0] valueForKey:@"title"];
                            [detail setValue:title forKey:@"template"];
                        }
                        else{
                            [detail setValue:@"" forKey:@"template"];
                        }
                        
                    }
                    else{
                        [detail setValue:@"" forKey:@"template"];
                    }
                    [detaialTable reloadData];
                    
                    
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

- (IBAction)backButton_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editButton_Action:(id)sender {
    [self performSegueWithIdentifier:@"EditCardSegueIdentifier" sender:detail];
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"EditCardSegueIdentifier"])
    {
        AddBusinessCardVC *controller = segue.destinationViewController;
        controller.detailDic = [[NSMutableDictionary alloc] initWithDictionary:orignalDic];
        
    }
    
}
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

