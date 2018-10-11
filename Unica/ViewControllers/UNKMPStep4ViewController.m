//
//  UNKMPStep4ViewController.m
//  Unica
//
//  Created by vineet patidar on 10/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKMPStep4ViewController.h"
#import "MPStep4Cell.h"
#import "CountryCell.h"


@interface UNKMPStep4ViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableDictionary *_loginInfoDictionary;
}

@end

typedef enum _UNKMPSection {
    UNKMPBudget = 0,
    UNKMPCountry = 1,
    UNKSearchSection = 2
    
} UNKMPSection;

@implementation UNKMPStep4ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sectionTextArray = [NSMutableArray arrayWithObjects:@"Your total Budget Preference for education and living expenses",@"Select countries of your interest\n(max 6)",@"",nil];
    
    _priceArray = [[NSMutableArray alloc]init];
    
    _miniprofileTable.layer.cornerRadius = 5.0;
    [_miniprofileTable.layer setMasksToBounds:YES];
    
    _countryTable.layer.cornerRadius = 5.0;
    [_countryTable.layer setMasksToBounds:YES];
    
    _viewCountryBG.layer.cornerRadius = 5.0;
    [_viewCountryBG.layer setMasksToBounds:YES];
    
    // country array
    
    _countryArray = [[NSMutableArray alloc] init];
    _selectedCountryArray = [[NSMutableArray alloc] init];
    _selectedPriceDictionary = [[NSMutableDictionary alloc]init];
    
    _loginInfoDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    
    [self getCountryList];
    [self setSelectedCountry];
    
    if ([self.incomingViewType isEqualToString:kMyProfile]) {
        [self setEditMiniProfileData];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [_miniprofileTable reloadData];

}

-(void)setEditMiniProfileData{
    
    // country
    if (![_countryArray isKindOfClass:[NSNull class]] && [_countryArray count]>0) {
      // selected currency country
       /* if ([self.editMPDictionary valueForKey:@"selected_currency"]) {
            
            NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", [self.editMPDictionary valueForKey:@"selected_currency"]]];
            
            NSArray *lastEducationCountryFilterArray = [_countryArray filteredArrayUsingPredicate:predicate];
            
            if (lastEducationCountryFilterArray.count>0) {
                
                [self budgeList:[lastEducationCountryFilterArray objectAtIndex:0]];
            }
            
        }
        */
        
        // selected country array
        
        if ([[self.editMPDictionary valueForKey:@"interested_country"] count]>0) {
            
            NSMutableArray *interested_country = [self.editMPDictionary valueForKey:@"interested_country"];
            
            if ([interested_country count]>0) {
                
                for (NSMutableDictionary *dict in interested_country) {
                    
                    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", [dict valueForKey:Kid]]];
                    
                    NSArray *lastEducationCountryFilterArray = [_countryArray filteredArrayUsingPredicate:predicate];
                    
                    if (lastEducationCountryFilterArray.count>0) {
                        [_selectedCountryArray addObject:[lastEducationCountryFilterArray objectAtIndex:0]];
                        
                    }

                }
                [_collectionView reloadData];

            }
        }
        
      
    }
    
}


#pragma mark - APIs
-(void)getCountryList{
    
    _countryArray =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
    
   // [self setEditMiniProfileData];
   // [self setSelectedCountry];
    
  /*  NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:@"" forKey:kSearch_country];
    [dictionary setValue:@"1000" forKey:kPageNumber];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"country_search.php"];
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _countryArray = [payloadDictionary valueForKey:kCountries];
                    
                    [self setEditMiniProfileData];
                    [self setSelectedCountry];
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
        
    }];*/
}


-(void)setSelectedCountry{
    NSPredicate *predicate;
    if (([Utility replaceNULL:[self.editMPDictionary valueForKey:@"selected_currency"] value:@""].length>0) && [self.incomingViewType isEqualToString:kMyProfile]) {
        
        predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", [self.editMPDictionary valueForKey:@"selected_currency"]]];
        
        
        
    }
    else
    {
        if (![[_loginInfoDictionary valueForKey:kcountry_id]isKindOfClass:[NSNull class]] && [[_loginInfoDictionary valueForKey:kcountry_id]length]>0 )
        {
        if ([[_loginInfoDictionary valueForKey:kcountry_id] integerValue]>0) {
            predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", [_loginInfoDictionary valueForKey:kcountry_id]]];
        }
        }
        
    }
    NSArray *currenyCountry = [_countryArray filteredArrayUsingPredicate:predicate];
    
    if (currenyCountry.count>0) {
        
        NSLog(@"%@",currenyCountry);
        _countryNameLabel.text = [[currenyCountry objectAtIndex:0] valueForKey:kName];
        
        if ([Utility getTextWidth:[[currenyCountry objectAtIndex:0] valueForKey:kName] size:CGSizeMake(999, 40) font:kDefaultFontForApp]> (kiPhoneWidth-235)) {
            countryViewWidth.constant = kiPhoneWidth-195;
        }
        else{
            countryViewWidth.constant = [Utility getTextWidth:[[currenyCountry objectAtIndex:0] valueForKey:kName] size:CGSizeMake(999, 40) font:kDefaultFontForApp]+40;
            
            
        }
        
        if (![[[currenyCountry  objectAtIndex:0] valueForKey:kcountry_image] isKindOfClass:[NSNull class]]) {
            
            [_countryImage sd_setImageWithURL:[NSURL URLWithString:[[currenyCountry objectAtIndex:0] valueForKey:kcountry_image]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"%@",error);
            }];
        }
        [self.miniProfileDictionary setValue:[[currenyCountry objectAtIndex:0] valueForKey:Kid] forKey:kselected_currency];
        [self budgeList:[currenyCountry  objectAtIndex:0]];
    }
    
    
    
}
-(void)budgeList:(NSMutableDictionary *)dict{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (![[_loginInfoDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[_loginInfoDictionary valueForKey:Kid] length]>0 ) {
        
        [dictionary setValue:[_loginInfoDictionary valueForKey:Kid] forKey:kUser_id];
    }
    else {
        [dictionary setValue:[_loginInfoDictionary valueForKey:Kuserid] forKey:kUser_id];
    }
    
    [dictionary setValue:[dict valueForKey:Kid] forKey:@"country_id"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"budget_preference.php"];
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    _priceArray = [payloadDictionary valueForKey:@"budget"];
                    //[_selectedPriceDictionary removeAllObjects];
                    [_miniprofileTable reloadData];
                    
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

-(void)saveMiniProfileData{
    
    

    [self replaceEditMPDictionary];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-mini-profile.php"];
    NSMutableDictionary *dataDict ;
    if(self.editMPDictionary)
    {
        dataDict = [[NSMutableDictionary alloc] initWithDictionary:self.editMPDictionary];
        
    }
    
    else
    {
            if (![[_loginInfoDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[_loginInfoDictionary valueForKey:Kid] length]>0 ) {
                [self.miniProfileDictionary setValue:[_loginInfoDictionary valueForKey:Kid] forKey:Kuserid];
            }
            else{
                [self.miniProfileDictionary setValue:[_loginInfoDictionary valueForKey:Kuserid] forKey:Kuserid];}
        if([Utility replaceNULL:[self.miniProfileDictionary valueForKey:Kuserid] value:@""].length<=0)
        {
            [self.miniProfileDictionary setValue:[_loginInfoDictionary valueForKey:Kuserid] forKey:Kuserid];
        }
         dataDict = [[NSMutableDictionary alloc] initWithDictionary:self.miniProfileDictionary];
    }
    
    [kUserDefault setObject:[Utility archiveData:dataDict] forKey:KminiProfileData];
    

   
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dataDict  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *_loginDictionary= [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
                    [_loginDictionary setValue:@"1" forKey:kLoginStatus];
                    [_loginDictionary setValue:@"true" forKey:kmini_profile_status];
                    
                    if (![[_loginDictionary valueForKey:Kid] isKindOfClass:[NSNull class]] && [[_loginDictionary valueForKey:Kid] length]>0) {
                        [_loginDictionary setValue:[_loginDictionary valueForKey:Kid] forKey:Kuserid];
                    }
                    
                    [kUserDefault setValue:[Utility archiveData:_loginDictionary] forKey:kLoginInfo];
                    
                    if ([self.incomingViewType isEqualToString:kMyProfile]) {
                        [Utility showAlertViewControllerIn:self title:@"" message:@"Profile updated" block:^(int index){
                            [self backToHome];
                            
                        }];
                    }
                    else{
                        
                        // remove GAp data if exist
                        [kUserDefault removeObjectForKey:kGAPStep1];
                        [kUserDefault removeObjectForKey:kGAPStep2];
                        [kUserDefault removeObjectForKey:kGAPStep3];
                        [kUserDefault removeObjectForKey:kGAPStep4];

                        [self backToHome];

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

#pragma mark - Table view delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == _countryTable) {
        return 1;
    }
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",(long)section);
    
    if (tableView == _countryTable) {
        return [_countryArray count];
    }
    else {
        if (section == UNKMPBudget ) {
            return [_priceArray count];
        }
        else if (section == UNKSearchSection ) {
            return 1;
        }
    }
    return 0;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _countryTable) {
        return nil;
    }
    
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    // heade label
    UILabel* headerLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, kiPhoneWidth-40, 59)];
    headerLbl.font =[UIFont fontWithName:@"SF UI Text" size:16];
    headerLbl.numberOfLines= 2;
    headerLbl.text = [_sectionTextArray objectAtIndex:section];
    [headerView addSubview:headerLbl];
    
    
    // add live view in botton of section
    UILabel* lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 59, kiPhoneWidth-20, 1)];
    lineLabel.backgroundColor = [UIColor lightGrayColor];
   // [headerView addSubview:lineLabel];
    
    if (section == UNKMPCountry) {
        lineLabel.hidden = YES;
    }
    else if (section == UNKSearchSection) {
        lineLabel.hidden = YES;
        headerLbl.hidden = YES;
        
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 5, kiPhoneWidth-40, 30)];
        searchBar.searchBarStyle = UISearchBarStyleMinimal;
        searchBar.placeholder = @"Country";
        searchBar.opaque = YES;
        [headerView addSubview:searchBar];
        
        UIButton *searchButton = [[UIButton alloc]initWithFrame: headerView.frame];
        searchButton.backgroundColor = [UIColor clearColor];
        [searchButton addTarget:self action:@selector(searchButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:searchButton];
        
    }
    else{
        
        lineLabel.frame = CGRectMake(10, 49, kiPhoneWidth-20, 1);
    }
    
    
    return headerView;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _countryTable) {
        return nil;
    }
    //    if (_priceArray.count == 0 && section ==UNKMPBudget) {
    //
    //        return nil;
    //
    //    }
    
    if (section == UNKMPBudget) {
        
        UIView* footerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
        UILabel *lblLine =[[UILabel alloc]initWithFrame:CGRectMake(0,0,self.view.frame.size.width , 5)];
        lblLine.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1.0];
        [footerView addSubview:lblLine];
        
        return footerView;
    }
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == _countryTable) {
        return 0;
    }
 
    if (section == UNKSearchSection) {
       return  40;
    }
    return 60;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (tableView == _countryTable) {
        return 0;
    }
  
    else if (section == UNKMPBudget) {
        return 5.0;
    }
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _miniprofileTable) {
        
        static NSString *cellIdentifier  =@"MPStep4";
        
        MPStep4Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MPStep4Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.section == UNKMPBudget) {
            
            cell.titleLabel.text = [[_priceArray objectAtIndex:indexPath.row] valueForKey:ktitle_budget];
            cell.subTitleLabel.text = [[_priceArray objectAtIndex:indexPath.row] valueForKey:kconverted_amount];
            
            // set check and unchecked selected button
            if(_selectedPriceDictionary.count<=0)
            {
                if(indexPath.row==0)
                {
                    [self setBudget];
                }
                if ([[[_priceArray objectAtIndex:indexPath.row] valueForKey:Kid] isEqual:[self.editMPDictionary valueForKey:kbudget_id]]) {
                    [cell.chechMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                    
                   // _selectedPriceDictionary = [_priceArray objectAtIndex:indexPath.row];
                }
                else{
                    [cell.chechMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                }
            }
            else
            {
                if ([[[_priceArray objectAtIndex:indexPath.row] valueForKey:Kid] isEqual:[_selectedPriceDictionary valueForKey:Kid]]) {
                    [cell.chechMarkButton setBackgroundImage:[UIImage imageNamed:@"Checked"] forState:UIControlStateNormal];
                }
                else{
                    [cell.chechMarkButton setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                }
            }
            
        }
        
        else if (indexPath.section == UNKSearchSection){
            
            
            // hide cell  contain
            cell.titleLabel.hidden = YES;
            cell.subTitleLabel.hidden = YES;
            cell.chechMarkButton.hidden = YES;
            
            
            UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
            _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, kiPhoneWidth-20,140) collectionViewLayout:layout];
            [_collectionView setDataSource:self];
            [_collectionView setDelegate:self];
            
            [_collectionView registerNib:[UINib nibWithNibName:@"MPCountrySelectionCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"countryCell"];
            [_collectionView setBackgroundColor:[UIColor clearColor]];
            
            [cell.contentView addSubview:_collectionView];
        }
        
        return  cell;
    }
    
    
    // country name table view
    static NSString *cellIdentifier = @"HistoryCell";
    
    UITableViewCell *cell = (UITableViewCell *)[_countryTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = [UIFont fontWithName:@"SF UI Text" size:13];
    
    cell.textLabel.text = [[_countryArray objectAtIndex:indexPath.row] valueForKey:kName];
    
    
    if (![[[_countryArray  objectAtIndex:indexPath.row] valueForKey:kcountry_image] isKindOfClass:[NSNull class]]) {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[[_countryArray objectAtIndex:indexPath.row] valueForKey:kcountry_image]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"%@",error);
        }];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _countryTable) {
        
        _countryTable.hidden = YES;
        _backgroundView.hidden = YES;
        
        _countryNameLabel.text = [[_countryArray objectAtIndex:indexPath.row] valueForKey:kName];
        
        if ([Utility getTextWidth:[[_countryArray objectAtIndex:indexPath.row] valueForKey:kName] size:CGSizeMake(999, 40) font:kDefaultFontForApp]> (kiPhoneWidth-235)) {
            countryViewWidth.constant = kiPhoneWidth-195;
        }
        else{
            countryViewWidth.constant = [Utility getTextWidth:[[_countryArray objectAtIndex:indexPath.row] valueForKey:kName] size:CGSizeMake(999, 40) font:kDefaultFontForApp]+40;
        }
        
        
        
        if (![[[_countryArray  objectAtIndex:indexPath.row] valueForKey:kcountry_image] isKindOfClass:[NSNull class]]) {
            
            [_countryImage sd_setImageWithURL:[NSURL URLWithString:[[_countryArray objectAtIndex:indexPath.row] valueForKey:kcountry_image]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"%@",error);
            }];
        }
        [self.miniProfileDictionary setValue:[[_countryArray objectAtIndex:indexPath.row] valueForKey:Kid] forKey:kselected_currency];
        
        [self budgeList:[_countryArray objectAtIndex:indexPath.row]];
        
    }
    else if (indexPath.section == UNKMPBudget && tableView == _miniprofileTable) {
        _selectedPriceDictionary = [_priceArray objectAtIndex:indexPath.row];
        
        [_miniprofileTable reloadData];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == UNKMPBudget && tableView == _miniprofileTable) {
        return 55;
    }
    else if (indexPath.section == UNKSearchSection && tableView == _miniprofileTable) {
        
        float height = 0.0;
        if (_selectedCountryArray.count <=2) {
            height = 50;
        }
        else if (_selectedCountryArray.count >2 && _selectedCountryArray.count <4)
        {
        height = 100;
        }
        else if (_selectedCountryArray.count >2 )
        {
            height = 140;
        }
        
        return height;
    }
    else if (tableView == _countryTable) {
        return 30;
    }
    return 40;
    
}



#pragma mark - collectionview delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_selectedCountryArray count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identifier = @"countryCell";
    
    MPCountrySelectionCell *cell =(MPCountrySelectionCell*) [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
    NSString *country = [[_selectedCountryArray objectAtIndex:indexPath.row] valueForKey:kName];
    cell.countryNameLabel.text = country;
    cell.countryLabelWidth.constant = [Utility getTextWidth:country size:CGSizeMake(999, 30) font:[UIFont fontWithName:kFontSFUITextRegular size:14]]+20;
    cell.crossButton.tag = indexPath.row;
    [cell.crossButton addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *country = [[_selectedCountryArray objectAtIndex:indexPath.row] valueForKey:kName];

     CGFloat width = [Utility getTextWidth:country size:CGSizeMake(999, 30) font:[UIFont fontWithName:kFontSFUITextRegular size:14]];
    return CGSizeMake(width+20,30);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0,0,10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:KPresictiveSeachSegueIdentifier]) {
        
        UNKPredictiveSearchViewController *predictiveSearchViewController = segue.destinationViewController;
        predictiveSearchViewController.delegate = self;
        
    }
}

#pragma mark - button clicked

/****************************
 * Function Name : - finishButton_clicked clicked Action
 * Create on : - 13 march 2017
 * Developed By : - Ramniwas
 * Description : -  This function are used get clicked event on button
 * Organisation Name :- Sirez
 * version no :- 1.0
 ****************************/

- (IBAction)finishButton_clicked:(id)sender {
    
    if ([self validation]) {
        
        [self.miniProfileDictionary setValue:[_selectedPriceDictionary valueForKey:Kid] forKey:kbudget_id];
        
        NSArray *array = [_selectedCountryArray valueForKey:Kid];
        
        
        // code for conver array into json string
        
        NSError * err;
        NSData * jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&err];
        NSString *stringData = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [self.miniProfileDictionary setValue:stringData forKey:kInterested_country];
        [self.miniProfileDictionary setValue:[_selectedPriceDictionary valueForKey:Kid] forKey:kbudget_id];
        
        [self saveMiniProfileData];
        
    }
    
    
}

- (IBAction)countyButton_clicked:(id)sender {
    
    _countryTable.hidden = NO;
    _backgroundView.hidden = NO;
    
    [_countryTable reloadData];
    
}

- (IBAction)infoButton_clicked:(id)sender {
    
    [Utility showAlertViewControllerIn:self title:kUNKError message:@"We use xe.com to show estimated prices in your preferred currency." block:^(int index){}];
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchButton_clicked:(UIButton *)sender{
    
    if ([_selectedCountryArray count] <= 5) {
        [self performSegueWithIdentifier:KPresictiveSeachSegueIdentifier sender:nil];
    }
    else{
        
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"You can add maximum 6 countries" block:^(int index){}];
    }
}

-(BOOL)validation{
    
    if ([_selectedPriceDictionary count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your budget" block:^(int index){
            
        }];
        return false;
    }
    
    else if ([_selectedCountryArray count] == 0) {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Select your interested Country" block:^(int index){
            
        }];
        return false;
    }
    return true;
}

-(void)crossButtonClicked:(UIButton *)sender{
    
    if ([_selectedCountryArray count] >0) {
        
        [_selectedCountryArray removeObjectAtIndex:sender.tag];
        
        [_collectionView reloadData];
    }
}

// get search country data

-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    NSLog(@"%@",searchDictionary);
    
    self.navigationController.navigationBarHidden = NO;
    
    if ([_selectedCountryArray count]>0) {
        
        if (![_selectedCountryArray containsObject:searchDictionary]) {
            
            [_selectedCountryArray addObject:searchDictionary];
            [_collectionView reloadData];
        }
        else{
            
            [Utility showAlertViewControllerIn:self title:kUNKError message:@"Already Added" block:^(int index){}];
        }
    }
    else{
        
        [_selectedCountryArray addObject:searchDictionary];
        [_collectionView reloadData];
        
   
    }
    CGPoint offset = CGPointMake(0, _miniprofileTable.contentSize.height -     _miniprofileTable.frame.size.height);
    [_miniprofileTable setContentOffset:offset animated:YES];}

-(void)replaceEditMPDictionary
{
    [self.editMPDictionary addEntriesFromDictionary: self.miniProfileDictionary];
    
}

-(void)backToHome{
    UIStoryboard *storyBoard =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UNKHomeViewController * homeViewController =[storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
    
    UNKRevealMenuViewController *rearViewController = [storyBoard instantiateViewControllerWithIdentifier:@"revealMenuView"];
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *revealController = [[SWRevealViewController alloc] initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    revealController.delegate = self;
    
    self.revealViewController = revealController;
    
    self.window = (UIWindow *)[[UIApplication sharedApplication].windows firstObject];
    self.window.backgroundColor = [UIColor redColor];
    
    self.window.rootViewController =self.revealViewController;
    [self.window makeKeyAndVisible];
}



-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _countryTable.hidden = YES;
    _backgroundView.hidden = YES;
    
}
-(void)setBudget{
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@", [self.editMPDictionary valueForKey:kbudget_id]]];
    
    NSArray *priceFilterArray = [_priceArray filteredArrayUsingPredicate:predicate];
    
    if (priceFilterArray.count>0) {
        
        _selectedPriceDictionary = [priceFilterArray objectAtIndex:0];
    }
}
@end
