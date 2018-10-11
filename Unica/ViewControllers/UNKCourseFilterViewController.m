//
//  UNKCourseFilterViewController.m
//  Unica
//
//  Created by vineet patidar on 28/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKCourseFilterViewController.h"
#import "CourserFilterCell.h"

@interface UNKCourseFilterViewController ()

@end

@implementation UNKCourseFilterViewController

-(void)viewDidLoad{
    
    [super viewDidLoad];
    
    [_searchTextField addTarget:self action:@selector(searchTextFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    _searchTextField.delegate = self;
    
    _locationView.layer.borderWidth = 1.0;
    _locationView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _locationView.layer.cornerRadius = 5.0;
    [_locationView.layer setMasksToBounds:YES];
    
    _locationBackgroundView.layer.cornerRadius = 5.0;
    [_locationBackgroundView.layer setMasksToBounds:YES];


}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
     [self.view endEditing:YES];
    _searchTextField.text = @"";
    filterArray = [[NSMutableArray alloc]init];

    if ([self.title isEqualToString:kINSTITUTION] ) {
        _searchTextField.placeholder = @"Type here to search institution";
        searchImage.image = [UIImage imageNamed:@"Institution"];
        if (self.institutionFilter.count>0) {
            [filterArray addObjectsFromArray:self.institutionFilter];
            [dataTable reloadData];
            [dataTable setHidden:NO];
            [courseFilterTable setHidden:YES];

        }
       
      
    }
   
    else  if ([self.title isEqualToString:kCOUNTRY]  && [self.incomingViewType isEqualToString:KCourse]) {
        
        _searchTextField.placeholder = @"Type here to search country";
        searchImage.image = [UIImage imageNamed:@"StepGlobe"];


        if (self.countryFilter.count>0) {
          [filterArray addObjectsFromArray:self.countryFilter];
            [dataTable reloadData];
            [dataTable setHidden:NO];
            [courseFilterTable setHidden:YES];
        }
        
       /* _searchTextField.text = [[filterArray objectAtIndex:0] valueForKey:ksearch];
        
        for (NSMutableDictionary *dict in filterArray) {
            [dict removeObjectForKey:ksearch];
        }
        [self timeAction:_searchTextField.text];*/

    }
    
    else  if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY] && self.eventCountryFilterArray.count>0 && [self.incomingViewType isEqualToString:KEvent]) {

        _searchTextField.placeholder = @"Search country";

        if (self.eventCountryFilterArray.count>0) {
            [filterArray addObjectsFromArray:self.eventCountryFilterArray];
            [dataTable reloadData];
            [dataTable setHidden:NO];
            [courseFilterTable setHidden:YES];
        }
     /*   _searchTextField.text = [[filterArray objectAtIndex:0] valueForKey:ksearch];
        
        for (NSMutableDictionary *dict in filterArray) {
            [dict removeObjectForKey:ksearch];
        }
        [self timeAction:_searchTextField.text];*/
     
    }
//    else  if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY] && self.eventCountryFilterArray.count  == 0 && [self.incomingViewType isEqualToString:KEvent]) {
//        _searchTextField.placeholder = @"Search country";
//    }
    else  if ([self.title isEqualToString:kSCHOLARSHIP] && self.scholarShipFilter.count>0) {
        [filterArray addObjectsFromArray:self.scholarShipFilter];

        headerViewHeight.constant = 0;
        
        searchArray = [NSMutableArray arrayWithObjects:@"All",@"With Scholarship", nil];
        
        [courseFilterTable reloadData];
    }
    else  if ([self.title isEqualToString:kPERFECT] && self.perfectFilter.count>0) {
        [filterArray addObjectsFromArray:self.perfectFilter];

        headerViewHeight.constant = 0;
        [courseFilterTable reloadData];
        
        searchArray = [NSMutableArray arrayWithObjects:@"All",@"Perfect Match", nil];
        [courseFilterTable reloadData];
        
    }
    
    else  if ([self.title isEqualToString:KCITY]) {
        NSLog(@"%@",self.institutionFilter);
        [filterArray addObjectsFromArray:self.eventCityFilterArray];
        
        if (filterArray.count==0) {
            _searchTextField.placeholder = @"Type here to search";
        }
        else{
            _searchTextField.text = [[filterArray objectAtIndex:0] valueForKey:Kid];
        }
        
    }
    
    else{
        
        if ([self.title isEqualToString:kSCHOLARSHIP]) {
            headerViewHeight.constant = 0;
            searchArray = [NSMutableArray arrayWithObjects:@"All",@"With Scholarship", nil];
            [courseFilterTable reloadData];

        }
        else  if ([self.title isEqualToString:kPERFECT] ) {
            headerViewHeight.constant = 0;
            searchArray = [NSMutableArray arrayWithObjects:@"All",@"Perfect Match", nil];
            [courseFilterTable reloadData];

        }
        else  if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY]) {
                    _searchTextField.placeholder = @"Search country";
                }

    }
    pageNumber = 0;
    
}



#pragma mark - APIS
/****************************
 * Function Name : - getSearchData
 * Create on : - 21 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for call APIs
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/
-(void)getSearchData:(NSMutableDictionary*)dictionary {
    
    NSString *url;
    
    // show loading indicator
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    courseFilterTable.tableHeaderView = spinner;
    
    if ([self.title isEqualToString:kINSTITUTION]) {
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"institute_search.php"];
    }
    else if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]){
        
              url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
    }
    else if ([self.title isEqualToString:KCITY]){
        url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent-location-search.php"];
    }

    
  [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                courseFilterTable.tableHeaderView = nil;

                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
//                    if (pageNumber == 0) {
                        if (searchArray) {
                            [searchArray removeAllObjects];
                        }
                        
                        if ([self.title isEqualToString:kINSTITUTION]) {
                            searchArray = [[dictionary valueForKey:kAPIPayload] valueForKey:@"institute"];
                            
                            dataTable.hidden = YES;
                            courseFilterTable.hidden = NO;
                            [courseFilterTable reloadData];
                        }

                        else if ([self.title isEqualToString:KCITY]) {
                            searchArray = [dictionary valueForKey:kAPIPayload];
                        }
//                        pageNumber = 1;
//                    }
                   /* else{
                        
                        NSMutableArray *arr;
                        if ([self.title isEqualToString:kINSTITUTION]) {

                          //  arr = [[dictionary valueForKey:kAPIPayload] valueForKey:@"institute"];
                        searchArray = [[dictionary valueForKey:kAPIPayload] valueForKey:@"institute"];
                        }
//                        else if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]) {
//                            searchArray = [[dictionary valueForKey:kAPIPayload] valueForKey:kCountries];
//                        }
                        else if ([self.title isEqualToString:KCITY]) {
                            searchArray = [dictionary valueForKey:kAPIPayload];
                        }
                        
//                        if(arr.count > 0){
//                            [searchArray addObjectsFromArray:arr];
//                        }
                        NSLog(@"%lu",(unsigned long)searchArray.count);
                        pageNumber = pageNumber+1 ;
                    }*/
                    isLoading = YES;
                    [courseFilterTable reloadData];
                    
                    // show message if no recoed found
                    if (searchArray.count > 0) {
                        if (messageLabel) {
                            messageLabel.text = @"";
                            [messageLabel removeFromSuperview];
                        }
                    }
                    
                    else{
                        messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, 40)];
                        messageLabel.text = @"No review found";
                        messageLabel.textAlignment = NSTextAlignmentCenter;
                        messageLabel.textColor = [UIColor whiteColor];
                        [self.view addSubview:messageLabel];
                        
                    }
                    
                    
                }else{
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        courseFilterTable.tableHeaderView = nil;

//                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
//                            
//                        }];
                    });
                }
                
            });
        }
        else{
            NSLog(@"%@",error);
            
//            if([error.domain isEqualToString:kUNKError]){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
//                        
//                    }];
//                });
//            }
            
        }
        
        
    }];
    
}


#pragma  mark - Table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == courseFilterTable) {
        return [searchArray count];
     }
    return filterArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseFilterTable) {
        static NSString *cellIdentifier3  =@"courseFilterCell";
        
        CourserFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourserFilterCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.checkMarkLeftImageHeight.constant = 20;
        cell.checmarkRightImage.hidden = YES;
        headerViewY_Axis.constant = 16;
        
        if ([self.title isEqualToString:kINSTITUTION]) { // institution
            
            
//            if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
//                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"Checked"];
//            }
//            else{
//                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"unchecked_gray"];
//            }
            
            cell.checkMarkLeftImageHeight.constant = 0;
            cell.checkMarkLeftImage.hidden = YES;
            
            if ([searchArray count]>0) {
                cell.nameLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
            }
        }
        else if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]){ // country
            
            
            cell.checkMarkLeftImageHeight.constant = 0;
            cell.checkMarkLeftImage.hidden = YES;
            if ([searchArray count]>0) {
                cell.nameLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
            }
        }
        else if ([self.title isEqualToString:kSCHOLARSHIP]){ // country
            
            headerViewY_Axis.constant = 0;
            if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"Checked"];
            }
            else{
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"unchecked_gray"];
            }
            if ([searchArray count]>0) {
                cell.nameLabel.text = [searchArray objectAtIndex:indexPath.row];
            }
        }
        else if ([self.title isEqualToString:kPERFECT]){ // country
            headerViewY_Axis.constant = 0;
            
            if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"Checked"];
            }
            else{
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"unchecked_gray"];
            }
            if ([searchArray count]>0) {
                cell.nameLabel.text = [searchArray objectAtIndex:indexPath.row];
            }
        }
        else if ([self.title isEqualToString:KCITY]){ // country
            
            if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"Checked"];
            }
            else{
                cell.checkMarkLeftImage.image = [UIImage imageNamed:@"unchecked_gray"];
            }
            if ([searchArray count]>0) {
                cell.nameLabel.text = [[searchArray objectAtIndex:indexPath.row] valueForKey:kName];
            }
        }
        
        return cell;
    }
    
    static NSString *cellIdentifier  =@"cell";
    
    countryDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"countryDataCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]){ // country
         
        if ([filterArray count]>0) {
            cell.countryNameLabel.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:kName];
        }
     }
    
     else  if ([self.title isEqualToString:kINSTITUTION]) { // institution
     
         if ([filterArray count]>0) {
             cell.countryNameLabel.text = [[filterArray objectAtIndex:indexPath.row] valueForKey:kName];
         }
     }
    
    [cell.crossButton addTarget:self action:@selector(removeSelectedData:) forControlEvents:UIControlEventTouchUpInside];
    cell.crossButton.tag = indexPath.row;
        return  cell;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == courseFilterTable) {
        if ([self.title isEqualToString:kINSTITUTION]) { //institution filter

//            if (filterArray.count >= 10) {
//                [Utility showAlertViewControllerIn:self title:@"" message:@"You can select max 10 countries." block:^(int index){}];
//            }
//            else{
            if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                
                
                if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                    [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
                    [self.institutionFilter removeAllObjects];
                    [self.institutionFilter addObjectsFromArray:filterArray];
                    
                    dataTable.hidden = NO;
                    courseFilterTable.hidden = YES;
                    [dataTable reloadData];
                }
                
                
              
            }
         //   }
         
            
        }
        else if ([self.title isEqualToString:kCOUNTRY] && [self.incomingViewType isEqualToString:KCourse] ) { //institution filter
            
            if (filterArray.count >= 10) {
                [Utility showAlertViewControllerIn:self title:@"" message:@"You can select max 10 countries." block:^(int index){}];
            }
            else{
            
                if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                    [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
                    [self.countryFilter removeAllObjects];
                    [self.countryFilter addObjectsFromArray:filterArray];
                }
                
            }
            
            dataTable.hidden = NO;
            courseFilterTable.hidden = YES;
            [dataTable reloadData];
        }
        else if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY] && [self.incomingViewType isEqualToString:KEvent] ) { // Event filter
            
          /*  if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                [filterArray removeObject:[searchArray objectAtIndex:indexPath.row]];
            }
            else{
                
                [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
            }*/
            if (filterArray.count >= 10) {
                [Utility showAlertViewControllerIn:self title:@"" message:@"You can select max 10 countries." block:^(int index){}];
            }
            else{
                
                if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
                    [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
                }
                [self.eventCountryFilterArray removeAllObjects];
                [self.eventCountryFilterArray addObjectsFromArray:filterArray];
                
            }

            
            
//            if (![filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
//              [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
//            }
//            [self.eventCountryFilterArray removeAllObjects];
//            [self.eventCountryFilterArray addObjectsFromArray:filterArray];
            
            dataTable.hidden = NO;
            courseFilterTable.hidden = YES;
            [dataTable reloadData];
            
        }
        else if ([self.title isEqualToString:kSCHOLARSHIP]) {
            
            [filterArray removeAllObjects];
            [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
            
            [self.scholarShipFilter removeAllObjects];
            [self.scholarShipFilter addObjectsFromArray:filterArray];
        }
        else if ([self.title isEqualToString:kPERFECT]) { //perfect filter
            
            [filterArray removeAllObjects];
            [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
            
            [self.perfectFilter removeAllObjects];
            [self.perfectFilter addObjectsFromArray:filterArray];
        }
        else if ([self.title isEqualToString:KCITY]) { //City filter
            
            //        if ([filterArray containsObject:[searchArray objectAtIndex:indexPath.row]]) {
            //            [filterArray removeObject:[searchArray objectAtIndex:indexPath.row]];
            //        }
            //        else{
            //            [filterArray addObject:[searchArray objectAtIndex:indexPath.row]];
            //        }
            //
            //        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            //        [dict setValue:_searchTextField.text forKey:Kid];
            //        NSMutableArray *array = [NSMutableArray arrayWithObject:dict];
            //        [self.eventCityFilterArray addObjectsFromArray:array];
        }
        
        _searchTextField.text = @"";
        [_searchTextField resignFirstResponder];
        NSLog(@"%@",self.institutionFilter);
        [dataTable reloadData];
        [courseFilterTable reloadData];
    }
    
   

}

#pragma  mark - Search bar delegate


-(void)timeAction:(NSString*)text{
    
    [_timer invalidate];
    _timer = nil;
    
    if (_searchTextField.text.length < 3) {
        return;
    }
    
    NSLog(@"%@",_searchTextField.text);
    
    if([_searchTextField.text isEqualToString:@""])
    {
        pageNumber = 0;
        [searchArray removeAllObjects];
        [courseFilterTable reloadData];
    }
    else{
        
        NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
        
        
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        
        [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
        
        
        if ([self.title isEqualToString:kINSTITUTION]) {

            [dictionary setValue:_searchTextField.text forKey:ksearch_institute];
        }
        
        else  if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]) {
            
            [dictionary setValue:_searchTextField.text forKey:kSearch_country];
        }
        
        else if ([self.title isEqualToString:KCITY]) {
             
        [dictionary setValue:_searchTextField.text forKey:ksearchinput];
            
//        if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
//                [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
//            }
//            else{
//                [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
//            }
//            [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
         
        }
        else{
            
            [dictionary setValue:_searchTextField.text forKey:ksearchinput];
            if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
                [dictionary setValue:[dictLogin valueForKey:Kid] forKey:Kuserid];
            }
            else{
                [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
            }
            [dictionary setValue:_searchTextField.text forKey:ksearchinput];
        }
        
        
         if (![self.title isEqualToString:KCITY]) {
            [self getSearchData:dictionary];

        }
    }
}


#pragma mark - Button clicked Action

/****************************
 * Function Name : - button clicked Action
 * Create on : - 14 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used for get button clicked Action
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/



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

#pragma mark - Scrol view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate{
   /* if(!isLoading)
    {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        
        float reload_distance = 50;
        if(y > h + reload_distance) {
            NSLog(@"End Scroll %f",y);
            if (pageNumber != totalRecord) {
                NSLog(@"Call API for pagging from %d for total pages %d",pageNumber,totalRecord);
                isLoading = YES;
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [spinner startAnimating];
                spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
                courseFilterTable.tableFooterView = spinner;
                
                NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                
                NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
                
                [dictionary setValue:[NSString stringWithFormat:@"%d",pageNumber] forKey:kPageNumber];
                
                if ([self.title isEqualToString:kINSTITUTION]) {

                    [dictionary setValue:_searchTextField.text forKey:ksearch_institute];
                }
                else{
                    
                    [dictionary setValue:_searchTextField.text forKey:ksearchinput];
                    [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:Kuserid];
                    [dictionary setValue:_searchTextField.text forKey:ksearchinput];
                }
                
                [self getSearchData:dictionary];
            }
            
        }
    }
    
    else{
        
        courseFilterTable.tableFooterView = nil;
    }*/
}

#pragma  mark - button clicked

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_searchTextField resignFirstResponder];
   return  YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   self.applyBtnFloatConstant.constant=340+5;
     return  YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
     [_searchTextField resignFirstResponder];
    self.applyBtnFloatConstant.constant=97;
    
    if ([self.title isEqualToString:KCITY]) { //City filter
        
        [self.eventCityFilterArray removeAllObjects];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:_searchTextField.text forKey:Kid];
        NSMutableArray *array = [NSMutableArray arrayWithObject:dict];
        [self.eventCityFilterArray addObjectsFromArray:array];
    }
    return  YES;
}

-(void)searchTextFieldValueChanged:(UITextField *)textField{
    
      if ([self.title isEqualToString:kCOUNTRY]||[self.title isEqualToString:KPARTICIPATINGCOUNTRY]) {
          
//          if (_searchTextField.text.length>2) {
          
              searchArray =[[NSMutableArray alloc]initWithArray:[[UtilityPlist getData:KCountryList] valueForKey:@"countries"]];
              NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@ ",_searchTextField.text];
              searchArray = (NSMutableArray*)[searchArray filteredArrayUsingPredicate:predicate];
              
              dataTable.hidden = YES;
              courseFilterTable.hidden = NO;
              [courseFilterTable reloadData];
        //  }
        
    }
      else{
          
    if (_timer) {
        if ([_timer isValid]){ [
        _timer invalidate];
        }
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeAction:) userInfo:nil repeats:NO];
      }
}


-(void)removeSelectedData:(UIButton*)sender{
// remove array data
    
      if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY] ) {
        
        if (self.eventCountryFilterArray.count>0) {
            [filterArray removeObjectAtIndex:sender.tag];
            [self.eventCountryFilterArray removeObjectAtIndex:sender.tag];
            [dataTable reloadData];
        }
      }
    else  if ([self.title isEqualToString:kCOUNTRY]) {
    if (filterArray.count>0) {
        [filterArray removeObjectAtIndex:sender.tag];
        [self.countryFilter removeObjectAtIndex:sender.tag];
        [dataTable reloadData];
    }
    }
    else  if ([self.title isEqualToString:kINSTITUTION]) {
        if (filterArray.count>0) {
            [filterArray removeObjectAtIndex:sender.tag];
            [self.institutionFilter removeObjectAtIndex:sender.tag];
            [dataTable reloadData];
        }
    }
    
    
}
- (IBAction)applyButton_clicked:(id)sender {
    
 /*   if ([self.title isEqualToString:kINSTITUTION]) {
        
        [self.institutionFilter removeAllObjects];
        [self.institutionFilter addObjectsFromArray:filterArray];
    }
    else if ([self.title isEqualToString:kCOUNTRY] && [self.incomingViewType isEqualToString:KCourse]){
        [self.countryFilter removeAllObjects];
        [self.countryFilter addObjectsFromArray:filterArray];
    }
    else if ([self.title isEqualToString:KPARTICIPATINGCOUNTRY] && [self.incomingViewType isEqualToString:KEvent]){
        
        [self.eventCountryFilterArray removeAllObjects];
        [self.eventCountryFilterArray addObjectsFromArray:filterArray];
    }
    else if ([self.title isEqualToString:kSCHOLARSHIP]){
        [self.scholarShipFilter removeAllObjects];
        [self.scholarShipFilter addObjectsFromArray:filterArray];
    }
    else if ([self.title isEqualToString:kPERFECT]){
        [self.perfectFilter removeAllObjects];
        [self.perfectFilter addObjectsFromArray:filterArray];
    }
    else if ([self.title isEqualToString:KCITY]){
        [self.eventCityFilterArray removeAllObjects];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:_searchTextField.text forKey:Kid];
        NSMutableArray *array = [NSMutableArray arrayWithObject:dict];
        [self.eventCityFilterArray addObjectsFromArray:array];
    }*/
    
    if ([self.applyButtonDelegate respondsToSelector:@selector(checkApplyButtonAction:)]) {
        [self.applyButtonDelegate checkApplyButtonAction:1];
    }
    
    [_searchTextField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:NO];
    
}

@end
