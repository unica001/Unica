//
//  GlobalApplicationStep3ViewController.m
//  Unica
//
//  Created by Chankit on 3/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "GlobalApplicationStep3ViewController.h"
#import "UtilityPlist.h"

@interface GlobalApplicationStep3ViewController ()

@end

@implementation GlobalApplicationStep3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    // self.title = @"Global Application Personal Information";
    arrayRequiredFileds =[[NSMutableArray alloc]initWithArray:[[UtilityPlist getData:KBackgroundQuestionList] valueForKey:@"background_questions"]];
    
    selecteOptionDictionary = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *GAPStep3Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep3]];
    

    if(GAPStep3Dictionary.count<=0 )
    {
        [self setdata];
    }
   
    [self initialLayout];
    
    
}

-(void)initialLayout {
    [self textFieldLayout];
}



-(void)textFieldLayout {
    
    NSMutableDictionary *optionDictionary1 = [NSMutableDictionary dictionary];
    [optionDictionary1 setValue:[NSNumber numberWithInt:UIKeyboardTypeAlphabet] forKey:kTextFeildOptionKeyboardType];
    [optionDictionary1 setValue:[NSNumber numberWithInt:UIReturnKeyNext] forKey:kTextFeildOptionReturnType];
    [optionDictionary1 setValue:[NSNumber numberWithInt:UITextAutocorrectionTypeNo] forKey:kTextFeildOptionAutocorrectionType];
    [optionDictionary1 setValue:[NSNumber numberWithInt:UITextAutocapitalizationTypeNone] forKey:kTextFeildOptionAutocapitalizationType];
    
    self.textFieldPassport = [Control newTextFieldWithOptions:optionDictionary1 frame:CGRectMake(kiPhoneWidth-200, btnNoValidPassport.frame.origin.y + 45, kiPhoneWidth-200, 30) delgate:self];
    [self.textFieldPassport setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldPassport.textColor = [UIColor blackColor];
    self.textFieldPassport.backgroundColor = [UIColor clearColor];
    self.textFieldPassport.text = @"";
    
    self.textFieldCntry = [Control newTextFieldWithOptions:optionDictionary1 frame:CGRectMake(kiPhoneWidth-200, self.textFieldPassport.frame.origin.y + 40,kiPhoneWidth-200, 30) delgate:self];
    self.textFieldCntry.textColor = [UIColor blackColor];
    
    [self.textFieldCntry setBorderStyle:UITextBorderStyleRoundedRect];
    self.textFieldCntry.backgroundColor = [UIColor clearColor];
    
    _countrySelectionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, kiPhoneWidth, 40)];
    _countrySelectionButton.backgroundColor = [UIColor clearColor];
    [_countrySelectionButton addTarget:self action:@selector(countrySelectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *GAPStep3Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep3]];
    
    if (GAPStep3Dictionary.count>0) {
        selecteOptionDictionary = GAPStep3Dictionary;
        if ([[selecteOptionDictionary valueForKey:kStep3ValidPassport]isEqualToString:@"true"]) {
            
            self.textFieldPassport.text = [selecteOptionDictionary valueForKey:kStep3PassportNumber];
            _textFieldCntry.text = [NSString stringWithFormat:@"%@",[selecteOptionDictionary valueForKey:kStep3PassportIssueCountryName]];
            
            selectedCountryID = [selecteOptionDictionary valueForKey:kStep3PassportIssueCountry];
        }
    }
    textViewDetails = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, kiPhoneWidth-45, 80)];
    textViewDetails.font = font;
    textViewDetails.layer.borderWidth = 1.0f;
    textViewDetails.layer.cornerRadius = 10.0;
    textViewDetails.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    textViewDetails.delegate =self;
    textViewDetails.autocorrectionType = UITextAutocorrectionTypeNo;
    textViewDetails.returnKeyType = UIReturnKeyDone;
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_type = %@",@"3"];
  
    NSArray *filterArray = [arrayRequiredFileds filteredArrayUsingPredicate:predicate];
    NSInteger indexValue=-1;
    if (filterArray.count>0) {
        indexValue = [arrayRequiredFileds indexOfObject:[filterArray objectAtIndex:0]];
        if (indexValue>0) {
            indexValue = indexValue-1;
        }
    }
    
    if(filterArray.count>0)
    {
        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"question_id = %@",[[filterArray objectAtIndex:0] valueForKey:Kid]];
        NSArray *filterArray2 = [[selecteOptionDictionary valueForKey:kQuestionaier] filteredArrayUsingPredicate:predicate2];
        
        if(filterArray2.count>0 )
        {
            textViewDetails.text = [[filterArray2 objectAtIndex:0] valueForKey:kanswer];
        }
    }

}


#pragma mark - TableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (arrayRequiredFileds.count>0) {
        return arrayRequiredFileds.count-1;
    }
    return arrayRequiredFileds.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section==0 )
    {
        return 44;
    }
    else
    {
        return 0.001;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section==0 )
    {
        // header view
        UIView *viewHeader = [[UIView alloc]init];
        viewHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        viewHeader.backgroundColor = [UIColor clearColor];
        
        // header title
        UILabel *labelPersonalInformation = [[UILabel alloc]init];
        labelPersonalInformation.frame = CGRectMake(8, 5, self.view.frame.size.width, 21);
        labelPersonalInformation.text = @"Background Questions";
        
        [viewHeader addSubview:labelPersonalInformation];
        

        return viewHeader;
    }
    else
    {
        return nil;
    }
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kiPhoneWidth, 5)];
    footerView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:244.0f/255.0f blue:249.0f/255.0f alpha:1];
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifierStep3 = @"GlobalApplicationStep3";
    
    RadioButtonStep3 *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierStep3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"RadioButtonStep3" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    // check header label height
    NSString *headerTitle = [[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:@"question_title"];
    cell.labelQuestion.text = headerTitle;
    
    float height = [Utility getTextHeight:headerTitle size:CGSizeMake(kiPhoneWidth-30, 999) font:kDefaultFontForApp];
    
    if (height>25) {
        cell.headerLabelHeight.constant = height;
    }
    
    // button Action
    
    [cell.btnYES addTarget:self action:@selector(btnYESActionValid:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnNo addTarget:self action:@selector(btnNoActionValid:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnYES.tag  = indexPath.section;
    cell.btnNo.tag  = indexPath.section;
    
    [self addMoeFieldInCell:cell indexPath:indexPath];
    [self setCellData:cell indexPath:indexPath];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    int lblHeight;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_type = %@",@"3"];
    NSLog(@"%@",[arrayRequiredFileds objectAtIndex:indexPath.section]);
    NSArray *filterArray = [arrayRequiredFileds filteredArrayUsingPredicate:predicate];
    NSInteger indexValue=-1;
    if (filterArray.count>0) {
        indexValue = [arrayRequiredFileds indexOfObject:[filterArray objectAtIndex:0]];
        if (indexValue>0) {
            indexValue = indexValue-1;
        }
    }
    
    if(indexPath.section == 0 &&[[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"]){
        lblHeight = 120;
    }
    
    else if (indexPath.section==indexValue){
        lblHeight = 270;
    }
    else{
        NSString *headerTitle = [[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:@"question_title"];
        
        lblHeight = [Utility getTextHeight:headerTitle size:CGSizeMake(kiPhoneWidth-30, 999) font:kDefaultFontForApp];
    }
    return lblHeight + 92;
}




// method for add more field in table cell
-(void)addMoeFieldInCell:(RadioButtonStep3*)cell indexPath:(NSIndexPath*)indexPath{
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_type = %@",@"3"];
    NSLog(@"%@",[arrayRequiredFileds objectAtIndex:indexPath.section]);
    NSArray *filterArray = [arrayRequiredFileds filteredArrayUsingPredicate:predicate];
    NSInteger indexValue=-1;
    if (filterArray.count>0) {
        indexValue = [arrayRequiredFileds indexOfObject:[filterArray objectAtIndex:0]];
        if (indexValue>0) {
            indexValue = indexValue-1;
        }
    }

  /*  if(filterArray.count>0)
    {
        NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"question_id = %@",[[filterArray objectAtIndex:0] valueForKey:Kid]];
        NSArray *filterArray2 = [[selecteOptionDictionary valueForKey:kQuestionaier] filteredArrayUsingPredicate:predicate2];
        
        if(filterArray2.count>0 )
        {
            textViewDetails.text = [[filterArray2 objectAtIndex:0] valueForKey:kanswer];
        }
    }*/
    
    if (indexPath.section == 0 && [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"]) {
        
        // line view
        lineView = [[UIView alloc]initWithFrame:CGRectMake(10, cell.btnNo.frame.origin.y+30,kiPhoneWidth-20,1)];
        lineView.backgroundColor = [UIColor colorWithRed:237.0f/255.0f green:237.0f/255.0f blue:237.0f/255.0f alpha:1];
        
        // passport label
        UILabel *labelTextField = [[UILabel alloc]initWithFrame:CGRectMake(10, lineView.frame.origin.y +5, 170, 40)];
        labelTextField.text = @"If yes enter passport number";
        labelTextField.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        labelTextField.numberOfLines = 2;
        labelTextField.lineBreakMode = NSLineBreakByWordWrapping;
        labelTextField.backgroundColor = [UIColor clearColor];
        
        
        // isssue passport label
        UILabel *labelCountryIssued = [[UILabel alloc]initWithFrame:CGRectMake(10, labelTextField.frame.origin.y + 35, 140, 36)];
        labelCountryIssued.text = @"Country that issued this Passport";
        labelCountryIssued.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
        labelCountryIssued.backgroundColor = [UIColor clearColor];
        labelCountryIssued.numberOfLines = 0;
        
        self.textFieldCntry.leftViewMode = UITextFieldViewModeAlways;
        
        

        UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(160, lineView.frame.origin.y +44, kiPhoneWidth-180, 30)];
        //BGView.backgroundColor = [UIColor redColor];
        BGView.layer.borderWidth =1;
        BGView.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
        BGView.layer.borderColor= [UIColor lightGrayColor].CGColor;
        BGView.layer.cornerRadius = 5;
        BGView.clipsToBounds = YES;
        //[cell.contentView addSubview:BGView];
        
        
        self.textFieldPassport.frame = CGRectMake(160, lineView.frame.origin.y +10, kiPhoneWidth-180, 30);

       // self.textFieldPassport.frame = CGRectMake(160+20, lineView.frame.origin.y +10, kiPhoneWidth-200, 30);

        textFieldPassportNumber = self.textFieldPassport;
        textFieldPassportNumber.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textFieldPassportNumber];
        
        _textFieldCntry.userInteractionEnabled = NO;
        
        UIView *viewBound =  [[UIView alloc]initWithFrame:CGRectMake(160, self.textFieldPassport.frame.origin.y +40,kiPhoneWidth-180, 30)];
        viewBound.layer.borderWidth =1;
        viewBound.layer.borderColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1].CGColor;
        viewBound.layer.cornerRadius = 5;
        viewBound.clipsToBounds = YES;
        
        UIButton *btn =  [[UIButton alloc]initWithFrame:CGRectMake(160, self.textFieldPassport.frame.origin.y +40,kiPhoneWidth-180, 30)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(countrySelectionButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        self.textFieldCntry.frame = CGRectMake(viewBound.frame.origin.x+30,viewBound.frame.origin.y,kiPhoneWidth-210, 30);
        self.textFieldCntry.borderStyle = UITextBorderStyleNone;
       
        
       // UIImageView *globeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, 10, 20, 20)];
        UIImageView *globeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(165, self.textFieldPassport.frame.origin.y+45, 20, 20)];
        globeImageView.image = [UIImage imageNamed:@"StepGlobe"];
        
        [cell.contentView addSubview:_textFieldCntry];
        [cell addSubview:lineView];
        [cell addSubview:viewBound];
        [cell addSubview:btn];

        [cell addSubview:labelTextField];
        [cell addSubview:labelCountryIssued];
        [cell addSubview:globeImageView];
       
        //[cell.contentView addSubview:_countrySelectionButton];
        [cell.contentView addSubview:self.textFieldPassport];
        [cell addSubview:btn];
        
        
        
        
    }
        else if (indexPath.section==indexValue){
            
        lineView = [[UIView alloc]initWithFrame:CGRectMake(0,cell.btnNo.frame.origin.y+40,kiPhoneWidth,10)];
        lineView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:241.0f/255.0f blue:248.0f/255.0f alpha:1];
        
        UILabel *labelTextView = [[UILabel alloc]initWithFrame:CGRectMake(8, lineView.frame.origin.y + 20, cell.labelQuestion.frame.size.width, 41)];
        labelTextView.textColor = [UIColor colorWithRed:94.0/255.0 green:114.0/255.0 blue:131.0/255.0 alpha:1];
            
        labelTextView.text =[[filterArray objectAtIndex:0] valueForKey:@"question_title"];
        labelTextView.lineBreakMode = NSLineBreakByWordWrapping;
        labelTextView.numberOfLines = 0;
        labelTextView.font = font;
        
        //textViewDetails = [[UITextView alloc]initWithFrame:CGRectMake(15, labelTextView.frame.origin.y + labelTextView.frame.size.height + 10, kiPhoneWidth-45, 80)];
            CGRect frame = textViewDetails.frame;
            frame.origin.y = labelTextView.frame.origin.y + labelTextView.frame.size.height + 10;
            textViewDetails.frame=frame;
        
            
            
     /*   if ([selecteOptionDictionary valueForKey:kStep3MoreDetails]) {
            if([[selecteOptionDictionary valueForKey:kQuestionaier] count]>=indexPath.section+1)
            {
                textViewDetails.text = [[[selecteOptionDictionary valueForKey:kQuestionaier]objectAtIndex:indexPath.section+1] valueForKey:kanswer];
            }
            
        }*/
            
        /*    if(filterArray.count>0)
            {
                NSPredicate * predicate2 = [NSPredicate predicateWithFormat:@"question_id = %@",[[filterArray objectAtIndex:0] valueForKey:Kid]];
                NSLog(@"%@",[arrayRequiredFileds objectAtIndex:indexPath.section]);
                NSArray *filterArray2 = [[selecteOptionDictionary valueForKey:kQuestionaier] filteredArrayUsingPredicate:predicate2];
                if(filterArray2.count>0)
                {
                    textViewDetails.text = [[filterArray2 objectAtIndex:0] valueForKey:kanswer];
                }
            }*/
           
        
        labelProfilePicture = [[UILabel alloc]initWithFrame:CGRectMake(15, textViewDetails.frame.origin.y + textViewDetails.frame.size.height,kiPhoneWidth-40, 56)];
        labelProfilePicture.text = @"Change/Upload Profile Picture for the Application";
        labelProfilePicture.font = [UIFont systemFontOfSize:14];
        labelProfilePicture.textColor = [UIColor colorWithRed:94.0/255.0 green:114.0/255.0 blue:131.0/255.0 alpha:1];
        labelProfilePicture.numberOfLines = 2;
        labelProfilePicture.font = font;
        
        btnProfilePicture = [[UIButton alloc]initWithFrame:CGRectMake(kiPhoneWidth-130, labelProfilePicture.frame.origin.y+45, 100, 30)];
        [btnProfilePicture setTitle:@"Browse" forState:UIControlStateNormal];
        btnProfilePicture.titleLabel.font = [UIFont systemFontOfSize:14];
        
        btnProfilePicture.titleLabel.textColor = [UIColor whiteColor];
        btnProfilePicture.backgroundColor = [UIColor colorWithRed:42/255.0f green:64/255.0f blue:89/255.0f alpha:1.0];
        
        btnProfilePicture.layer.cornerRadius = 5.0f;
        [btnProfilePicture addTarget:self action:@selector(btnProfilePictureAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [btnProfilePicture addTarget:self action:@selector(btnProfilePictureAction:) forControlEvents:UIControlEventTouchUpInside];
        currentFrameOriginal = CGRectMake(labelProfilePicture.frame.size.width+10, labelProfilePicture.frame.origin.y, 160, 30);
        _profileImage = [[UIImageView alloc]init];
        _profileImage.frame = CGRectMake(10, labelProfilePicture.frame.origin.y+46, 30, 30);
        _profileImage.layer.cornerRadius =_profileImage.frame.size.height/2;
        _profileImage.clipsToBounds =YES;
          //  _profileImage.image =[UIImage imageNamed:@"RegisterUser"];
        
        [cell addSubview:lineView];
        [cell addSubview:labelTextView];
        [cell addSubview:textViewDetails];
        [cell addSubview:labelProfilePicture];
        [cell addSubview:_profileImage];
        [cell addSubview:btnProfilePicture];
        
        
    }
}

-(void)setCellData:(RadioButtonStep3*)cell indexPath:(NSIndexPath*)indexPath{
    // set selected values
    NSString *key;
    
    /*if (indexPath.section == 0) {
        key = kStep3ValidPassport;
    }
    else if (indexPath.section == 1) {
        key = kStep3RefusedVisa;
    }
    else if (indexPath.section == 2) {
        key = kStep3Immigration;
    }
    else if (indexPath.section == 3) {
        key = kStep3RemovedFromCountry;
    }
    else if (indexPath.section == 4) {
        key = kStep3TravelledOutside;
    }
    else if (indexPath.section == 5) {
        key = kStep3Overstayed;
    }
    else if (indexPath.section == 6) {
        key = kStep3CriminalOffence;
    }
    else if (indexPath.section == 7) {
        key = kStep3MedicalCondition;
        UIImage *prof =[selecteOptionDictionary valueForKey:kStep3ProfileImage];
        _profileImage.image = prof;
    }
    if ([[Utility replaceNULL:[selecteOptionDictionary valueForKey:key] value:@""] isEqualToString:@"true"]) {
        [cell.btnYES setImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
        [cell.btnNo setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
    }
    else if ([[Utility replaceNULL:[selecteOptionDictionary valueForKey:key] value:@""] isEqualToString:@"false"]){
        [cell.btnYES setImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
        [cell.btnNo setImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
    }*/
    
    
    
    NSString *Id =[[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:Kid] ;
    
    //NSMutableDictionary *dic =  [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep3]];
    if(selecteOptionDictionary.count>0)
    {
        NSMutableArray *questionarrier =[[NSMutableArray alloc] initWithArray:[selecteOptionDictionary valueForKey:kQuestionaier]] ;
        if(questionarrier.count>0)
        {
           
          NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_id = %@",Id];
            NSMutableArray *filterArray = [questionarrier filteredArrayUsingPredicate:predicate].mutableCopy;
            
            if (filterArray.count>0) {
                 BOOL answer =NO;
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[filterArray objectAtIndex:0]];
                answer = [[dict valueForKey:kanswer] boolValue];
                
                if(answer)
                {
                    [cell.btnYES setBackgroundImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
                    [cell.btnNo setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                    
                }
                else
                {
                    [cell.btnYES setBackgroundImage:[UIImage imageNamed:@"unchecked_gray"] forState:UIControlStateNormal];
                    [cell.btnNo setBackgroundImage:[UIImage imageNamed:@"StepCheckedActive"] forState:UIControlStateNormal];
                }
            }
            
        }
        
    }
   
    
    if([[[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:@"question_type"] isEqualToString:@"3"])
    {
        
        
        
        if ([[selecteOptionDictionary valueForKey:kStep3ProfileImage] isKindOfClass:[UIImage class]]) {
          
            UIImage *prof =[selecteOptionDictionary valueForKey:kStep3ProfileImage];
            _profileImage.image = prof;
        }
        else{
            NSURL *imageURL = [NSURL URLWithString:[selecteOptionDictionary valueForKey:kStep3ProfileImage]];
            NSLog(@"imge %@",imageURL);

            [_profileImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"RegisterUser"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"%@",error);
            }];}
    }
    else{
        if ([selecteOptionDictionary valueForKey:@"profileImage"]) {
            
          
            
            if ([[selecteOptionDictionary valueForKey:@"profileImage"] isKindOfClass:[UIImage class]]) {
              
                UIImage *prof = [selecteOptionDictionary valueForKey:@"profileImage"];
                _profileImage.image = prof;
            }
            else{
                NSURL *imageURL = [NSURL URLWithString:[selecteOptionDictionary valueForKey:@"profileImage"]];
                NSLog(@"imge %@",imageURL);
                
                [_profileImage sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"RegisterUser"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    NSLog(@"%@",error);
                }];

            }
           
            
            labelProfilePicture.text = @"Change/Upload Profile Picture for the Application";
        }
    }
    
   
}


#pragma mark - Validation
-(BOOL)isValid {
    
    BOOL returnvariable = true;
    
    if([[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"] && ([textFieldPassportNumber.text isEqualToString:@""])) {
        
        
        CGPoint txtFieldPosition = [textFieldPassportNumber convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep3];
        NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep3 indexPathForRowAtPoint:txtFieldPosition];
        [Utility scrolloTableView:_tableViewGlobalApplicationStep3 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        
        failedMessage = @"Enter passport number";
        [self showAlert:failedMessage];
        returnvariable = false;
    }
    else if([[Utility replaceNULL:_textFieldCntry.text value:@""] isEqualToString:@""] && [[Utility replaceNULL:[selecteOptionDictionary valueForKey:kStep3ValidPassport] value:@""] isEqualToString:@"true"]) {
        
        
        CGPoint txtFieldPosition = [_textFieldCntry convertPoint:CGPointZero toView: _tableViewGlobalApplicationStep3];
        NSIndexPath *currentTouchPosition = [_tableViewGlobalApplicationStep3 indexPathForRowAtPoint:txtFieldPosition];
        [Utility scrolloTableView:_tableViewGlobalApplicationStep3 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        failedMessage = @"Enter passport issuing country";
        [self showAlert:failedMessage];
        returnvariable = false;
    }
    else if([[selecteOptionDictionary valueForKey:kQuestionaier] count]<=0)
    {
        NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
        [Utility scrolloTableView:_tableViewGlobalApplicationStep3 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
        failedMessage = @"Please answer all background questions";
        [self showAlert:failedMessage];
        returnvariable = false;
    }
    else
    {
        for(int i=0; i<arrayRequiredFileds.count;i++)
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_id = %@",[[arrayRequiredFileds objectAtIndex:i] valueForKey:Kid]];
            NSMutableArray *filterArray = [[selecteOptionDictionary valueForKey:kQuestionaier] filteredArrayUsingPredicate:predicate].mutableCopy;
            if(![[[arrayRequiredFileds objectAtIndex:i] valueForKey:@"question_type"] isEqualToString:@"3"] && filterArray.count<=0)
            {
                failedMessage = @"Please answer all background questions";
              
                NSIndexPath *currentTouchPosition = [NSIndexPath indexPathForRow:NSNotFound inSection:i];
                [Utility scrolloTableView:_tableViewGlobalApplicationStep3 point:CGPointMake(0, 0) indexPath:currentTouchPosition];
                [self showAlert:failedMessage];
                
                
                returnvariable = false;
                break;

            }
        }
    }
    
    
    
    return returnvariable;
}

-(void)showAlert:(NSString*)message {
    
    UIAlertView *msgAlert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:message
                                                      delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    
    [msgAlert show];
    
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    GlobalApplicationStep4ViewController *_step4ViewController = segue.destinationViewController;
    _step4ViewController.globalApplicationData = self.globalApplicationData;
}
#pragma mark - Button Action

-(void)btnCountrySelectedAction:(id)selector {
    
}

-(void)btnProfilePictureAction:(id)sender {
    
    
    [_textView resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Set Profile Picture" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Upload from Gallery", @"Take Camera Picture", nil];
    [sheet showInView:self.view.window];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(buttonIndex==actionSheet.cancelButtonIndex) {
        
        return;
    }
    
    UIImagePickerControllerSourceType type;
    
    if(buttonIndex==0) {
        
        type = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else  {
        
        type = UIImagePickerControllerSourceTypeCamera;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.delegate = self;
    picker.sourceType = type;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)backButton_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark- ImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    _profileImage.image = image;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    else{
        
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        [self getImageName:image url:imageURL];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (image) {
    [selecteOptionDictionary setValue:image forKey:kStep3ProfileImage];

    }
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        if (error) {
            NSLog(@"error");
        } else {
            NSLog(@"url %@", assetURL);
            
            [self getImageName:image url:assetURL];
        }
    }];
    
  /*  if (error) {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:[error localizedDescription]
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles:nil];
        [alert show];
    }*/
    
}

-(void)getImageName:(UIImage*)image url:(NSURL*)url{
    
    NSURL *imageURL = url;
    PHAsset *phAsset = [[PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil] lastObject];
    NSString *imageName = [phAsset valueForKey:@"filename"];
    
    labelProfilePicture.text = [NSString stringWithFormat:@"Change/Upload Profile Picture for the Application %@",imageName];
}


- (IBAction)btnNextAction:(id)sender {
    
    if([self isValid] == true) {
    
        

        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_type = %@",@"3"];
            NSArray *filterArray = [arrayRequiredFileds filteredArrayUsingPredicate:predicate];
            NSString *ID;
            if (filterArray.count>0) {
                ID = [[filterArray objectAtIndex:0] valueForKey:Kid];
            }
            
            NSPredicate * predicateForQuestion = [NSPredicate predicateWithFormat:@"question_id = %@",ID];
            NSMutableArray *filterArrayForQuestion = [[selecteOptionDictionary valueForKey:kQuestionaier] filteredArrayUsingPredicate:predicateForQuestion].mutableCopy;
            
            if (filterArrayForQuestion.count>0) {
                NSInteger indexValue = [[selecteOptionDictionary valueForKey:kQuestionaier] indexOfObject:[filterArrayForQuestion objectAtIndex:0]];
               
                /*if(textViewDetails.text.length>0)
                {
                    [[[selecteOptionDictionary valueForKey:kQuestionaier] objectAtIndex:indexValue] setValue:textViewDetails.text forKey:kanswer];
                }*/
                [[[selecteOptionDictionary valueForKey:kQuestionaier] objectAtIndex:indexValue] setValue:textViewDetails.text forKey:kanswer];
                
            }
            else
            {
                NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
                [dict setValue:textViewDetails.text forKey:kanswer];
                [dict setValue:ID forKey:kquestion_id];
                [[selecteOptionDictionary valueForKey:kQuestionaier] addObject:dict];
                
                
            }
            
            [selecteOptionDictionary setValue:textFieldPassportNumber.text forKey:kStep3PassportNumber];
            
            NSString *countryName = _textFieldCntry.text;
            countryName = [countryName stringByReplacingOccurrencesOfString:@"   " withString:@""];
            [selecteOptionDictionary setValue:countryName forKey:kStep3PassportIssueCountryName];
            
            [selecteOptionDictionary setValue:selectedCountryID forKey:kStep3PassportIssueCountry];
            [selecteOptionDictionary setValue:textViewDetails.text forKey:kStep3MoreDetails];
            
            [kUserDefault setValue:[Utility archiveData:selecteOptionDictionary] forKey:kGAPStep3];
            dispatch_async( dispatch_get_main_queue(), ^{
                NSLog(@"finished");
            });
        });
        
      
        // run task in background
        
        BOOL status = [[self.globalApplicationData valueForKey:kisGlobalFormCompleted] boolValue];
        
        if(status == YES)
        {
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self SaveGlobalApplicatioData];
                
                dispatch_async( dispatch_get_main_queue(), ^{
                    NSLog(@"finished");
                });
            });
        }
        
        dispatch_async( dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:ksegueStep3to4 sender:self];
        });
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    BOOL returnvariable = YES;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceCharacterSet];
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:charSet];
    
    if([trimmedString isEqualToString:@""]) {
        
        [self showAlert] ;
    }
    else {
        
        [textField resignFirstResponder];
    }
    
    return returnvariable;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
}

-(void)showAlert {
    
    UIAlertView *msgAlert = [[UIAlertView alloc] initWithTitle:@""
                                                       message:@"Please enter details"
                                                      delegate:self cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
    [msgAlert show];
    
}

//- (void)textViewDidChange:(UITextView *)textView
//{
//    [selecteOptionDictionary setValue:textView.text forKey:kStep3MoreDetails];
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
   else if([textView.text stringByAppendingString:text].length>160)
    {
        return NO;
    }
    else
    {
        
        
        [selecteOptionDictionary setValue:[textView.text stringByAppendingString:text] forKey:kStep3MoreDetails];
        return true;
    }
    //Same conditions go on
}

-(void)btnYESActionValid:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableViewGlobalApplicationStep3];
    NSIndexPath *indexPath = [_tableViewGlobalApplicationStep3 indexPathForRowAtPoint:buttonPosition];

     NSString *Id =[[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:Kid] ;
    if([Id isEqualToString:@"1"])
    {
        [selecteOptionDictionary setValue:@"true" forKey:kStep3ValidPassport];
    }
   
    
    NSMutableArray *questionarrier =[[NSMutableArray alloc] initWithArray:[selecteOptionDictionary valueForKey:kQuestionaier]] ;
    if(questionarrier.count>0)
    {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_id = %@",Id];
        NSMutableArray *filterArray = [questionarrier filteredArrayUsingPredicate:predicate].mutableCopy;
        
        if (filterArray.count>0) {
            NSInteger indexValue = [questionarrier indexOfObject:[filterArray objectAtIndex:0]];
            [[questionarrier objectAtIndex:indexValue] setValue:@"true" forKey:kanswer];
        }
        else
        {
            NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
            [dict setValue:@"true" forKey:kanswer];
            [dict setValue:Id forKey:kquestion_id];
            [questionarrier addObject:dict];
            
            
        }
    }
    else
    {
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setValue:@"true" forKey:kanswer];
        [dict setValue:Id forKey:kquestion_id];
        [questionarrier addObject:dict];
        
        
    }

    
    [selecteOptionDictionary setObject:questionarrier forKey:kQuestionaier];
    
    //[kUserDefault setObject:[Utility archiveData:dic] forKey:kGAPStep3];
    
    [_tableViewGlobalApplicationStep3 reloadData];
    
}

-(void)btnNoActionValid:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_tableViewGlobalApplicationStep3];
    NSIndexPath *indexPath = [_tableViewGlobalApplicationStep3 indexPathForRowAtPoint:buttonPosition];
    

//    }
    NSString *Id =[[arrayRequiredFileds objectAtIndex:indexPath.section] valueForKey:Kid] ;
    if([Id isEqualToString:@"1"])
    {
        [selecteOptionDictionary setValue:@"false" forKey:kStep3ValidPassport];
        [selecteOptionDictionary setValue:@"" forKey:kStep3PassportNumber];
        [selecteOptionDictionary setValue:@"" forKey:kStep3PassportIssueCountry];
        
    }
    NSMutableArray *questionarrier =[[NSMutableArray alloc] initWithArray:[selecteOptionDictionary valueForKey:kQuestionaier]] ;
    if(questionarrier.count>0)
    {
       NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_id = %@",Id];
        NSMutableArray *filterArray = [questionarrier filteredArrayUsingPredicate:predicate].mutableCopy;
        
        if (filterArray.count>0) {
           NSInteger indexValue = [questionarrier indexOfObject:[filterArray objectAtIndex:0]];
            [[questionarrier objectAtIndex:indexValue] setValue:@"false" forKey:kanswer];
            }
        else
        {
            NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
            [dict setValue:@"false" forKey:kanswer];
            [dict setValue:Id forKey:kquestion_id];
            [questionarrier addObject:dict];
            
            
        }
    }
    else
    {
        NSMutableDictionary *dict =[[NSMutableDictionary alloc] init];
        [dict setValue:@"false" forKey:kanswer];
        [dict setValue:Id forKey:kquestion_id];
        [questionarrier addObject:dict];
        
        
    }
    [selecteOptionDictionary setObject:questionarrier forKey:kQuestionaier];
    
    [_tableViewGlobalApplicationStep3 reloadData];
}

// country selection button clicked
-(void)countrySelectionButton_clicked:(UIButton *)sender{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    UNKPredictiveSearchViewController *searchView = [storyBoard instantiateViewControllerWithIdentifier:kPredictiveSearchStoryBoardID];
    searchView.delegate = self;
    [self.navigationController pushViewController:searchView animated:YES];
}


-(void)getSearchData:(NSMutableDictionary *)searchDictionary type:(NSString *)type{
    
    self.navigationController.navigationBarHidden = NO;
    NSString *countryNameString = [searchDictionary valueForKey:kName];
    selectedCountryID = [searchDictionary valueForKey:Kid];
    [selecteOptionDictionary setValue:countryNameString forKey:kStep3PassportIssueCountryName];
    
    _textFieldCntry.text = [NSString stringWithFormat:@"%@",countryNameString];
    
    [selecteOptionDictionary setValue:[searchDictionary valueForKey:Kid] forKey:kStep3PassportIssueCountry];
}

-(void)setdata
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *questionnaire = [self.globalApplicationData valueForKey:kQuestionaier];
    
    if([Utility replaceNULL:[self.globalApplicationData valueForKey:kProfileImage] value:@""].length>0)
    {
        NSURL *imageURL = [NSURL URLWithString:[self.globalApplicationData valueForKey:kProfileImage]];
        NSLog(@"imge %@",imageURL);
        
       /* NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        NSLog(@"imge %@",imageData);
        UIImage *image = [UIImage imageWithData:imageData];
        //  profileImgaeView.image =image;
        _profileImage.image = image;*/
        
        [dictionary setValue:[self.globalApplicationData valueForKey:kProfileImage] forKey:kStep3ProfileImage];

        [_profileImage sd_setImageWithURL:imageURL];
    }
    [dictionary setValue:[self.globalApplicationData valueForKey:kStep3PassportNumber] forKey:kStep3PassportNumber];
    if(questionnaire.count>0)
     [dictionary setObject:questionnaire forKey:kQuestionaier];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_type = %@", @"1"];
    NSArray *filterArray = [arrayRequiredFileds filteredArrayUsingPredicate:predicate];
   
    if (filterArray.count>0) {
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"question_id = %@", [[filterArray objectAtIndex:0] valueForKey:Kid]];
        NSArray *passportArray = [questionnaire filteredArrayUsingPredicate:predicate];
        
        if (passportArray.count>0) {
            if ([[[passportArray objectAtIndex:0] valueForKey:kanswer] boolValue] == true) {
                
                [dictionary setValue:[[passportArray objectAtIndex:0] valueForKey:kanswer] forKey:kStep3ValidPassport];
                [dictionary setValue:[self.globalApplicationData valueForKey:kStep3PassportNumber] forKey:kStep3PassportNumber];
                [dictionary setValue:[self getCountryName:[self.globalApplicationData valueForKey:kStep3PassportIssueCountry]] forKey:kStep3PassportIssueCountryName];
            }
        }
       
       
        
    }
    
    ;
    selecteOptionDictionary = dictionary;
    
    [kUserDefault setValue:[Utility archiveData:dictionary] forKey:kGAPStep3];
    
    
}
-(NSString*)getCountryName:(NSString *)countryId
{
    NSString *countryName;
    
    //NSMutableDictionary *GAPStep1Dictionary = [Utility unarchiveData:[kUserDefault valueForKey:kGAPStep1]];
    if (![countryId isKindOfClass:[NSNull class]]) {
        
        NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[NSString stringWithFormat:@"%@",countryId]];
        
        NSMutableArray *countryList =[[UtilityPlist getData:kCountries] valueForKey:kCountries];
        NSLog(@"%@",countryList);
        
        NSArray *lastEducationCountryFilterArray = [countryList filteredArrayUsingPredicate:predicate];
        if (lastEducationCountryFilterArray.count>0) {
            
            NSMutableDictionary *countryDict = [lastEducationCountryFilterArray objectAtIndex:0];
            countryName = [countryDict valueForKey:kName];
            
            
        }
        else{
            countryName = @"";
            
        }
        
    }
    return countryName;
}

#pragma  Questionnaire

-(void)updatePaymentOnServer{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictPaymentInfo = [kUserDefault valueForKey:kPaymentResponceDict];
    
    NSMutableDictionary *institutionDict = [kUserDefault valueForKey:kPaymentInfoDict];
    
    NSString *userID;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:Kuserid];
    }
    
    
    [dictionary setValue:[dictPaymentInfo valueForKey:@"Amount"] forKey:kamount];
    [dictionary setValue:[dictPaymentInfo valueForKey:@"PaymentId"] forKey:kpayment_id];
    [dictionary setValue:@"" forKey:kpayment_response];
    [dictionary setValue:[institutionDict valueForKey:Kid] forKey:kcourse_id];
    [dictionary setValue:userID forKey:@"intake_id"];
    [dictionary setValue:@"true" forKey:@"unica_payment"];
    [dictionary setValue:userID forKey:Kuserid];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-apply-course.php"];

    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self updateQuestionnaire];
                                      
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

-(void)updateQuestionnaire{
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:selecteOptionDictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        jsonString=@"";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *institutionDict = [kUserDefault valueForKey:kPaymentInfoDict];
    
    NSString *userID;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        
        userID = [dictLogin valueForKey:Kid];
    }
    else{
        userID = [dictLogin valueForKey:Kuserid];
    }
    
    [dictionary setValue:[institutionDict valueForKey:Kid] forKey:kcourse_id];
    [dictionary setValue:userID forKey:Kuserid];

    [dictionary setValue:jsonString forKey:@"questionnaire"];
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"save-course-applied-answer.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
                
                UNKHomeViewController *homeViewController = [storyBoard instantiateViewControllerWithIdentifier:@"homeViewController"];
                
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    [self.navigationController pushViewController:homeViewController animated:YES];
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
-(void)SaveGlobalApplicatioData
{
    BOOL showHud =NO;
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc] initWithDictionary:[Utility unarchiveData:[kUserDefault valueForKey:KglobalApplicationData]]];
    
   if(dictionary.count>0)
   {
       NSMutableDictionary *step3Detail= selecteOptionDictionary;
      
       NSString * questionairStr = [Utility convertArrayToJson:[step3Detail valueForKey:kQuestionaier]];
       [dictionary setValue:questionairStr forKey:@"questionnaire"];
       [dictionary setValue:[step3Detail valueForKey:kStep3ValidPassport] forKey:kStep3ValidPassport];
       [dictionary setValue:[step3Detail valueForKey:kStep3PassportNumber] forKey:kStep3PassportNumber];
       [dictionary setValue:[step3Detail valueForKey:kStep3PassportIssueCountryName] forKey:kStep3PassportIssueCountryName];
       [dictionary setValue:[step3Detail valueForKey:kStep3PassportIssueCountry] forKey:kStep3PassportIssueCountry];
   
       
       [dictionary setValue:[step3Detail valueForKey:kStep3MoreDetails] forKey:@"global_question_description"];
       [dictionary setValue:[step3Detail valueForKey:kProfileImage] forKey:kProfileImage];
       
        [kUserDefault setObject:[Utility archiveData:dictionary] forKey:KglobalApplicationData];
       
       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
          
      
       NSMutableURLRequest *request = nil;
       NSLog(@"image upload");
       
       NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"student-global-profile.php"];
       
       
       
       NSMutableData *body = [NSMutableData data];
       request = [[NSMutableURLRequest alloc] init];
       [request setURL:[NSURL URLWithString:url]];
       [request setHTTPMethod:@"POST"];
       
       NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
       [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
       
       //** step 1 **//
       // first Name
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1FirstName] dataUsingEncoding:NSUTF8StringEncoding]];
       
       [body appendData:[[dictionary valueForKey:kStep1FirstName]dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // missle name
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1MiddleName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1MiddleName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // last name
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1LastName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1LastName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // Citizen Country
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1CitizenCountry] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1CitizenCountry] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // DOB
       
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1DOB] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1DOB] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // Mobile Number
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1MobileNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1MobileNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // SkypeID
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1SkypeID] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1SkypeID] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       //Native Language
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1NativeLanguage] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1NativeLanguage] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // Martial Status
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep1MartialStatus] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep1MartialStatus] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // userId
       NSString *userID = [dictionary valueForKey:Kuserid];
       if (![[Utility replaceNULL:userID value:@""] isEqualToString:@""] && [userID isKindOfClass:[NSString class]]) {
           userID = [userID stringByReplacingOccurrencesOfString:@"%2B" withString:@"+"];
       }
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,Kuserid] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[userID dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // Address
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kAddress] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kAddress] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // EmergencyContactFirstName
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyContactFirstName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep2EmergencyContactFirstName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // EmergencyContactLastName
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyContactLastName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep2EmergencyContactLastName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // EmergencyRelationship
       
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyRelationship] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep2EmergencyRelationship] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // EmergencyPhoneNumber
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyPhoneNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep2EmergencyPhoneNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // EmergencyEmail
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep2EmergencyEmail] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep2EmergencyEmail] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       //ValidPassport
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep3ValidPassport] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep3ValidPassport] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // PassportNumber
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep3PassportNumber] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
       // PassportIssueCountryName
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportIssueCountryName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep3PassportIssueCountryName] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       //PassportIssueCountry
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep3PassportIssueCountry] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep3PassportIssueCountry] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
       // FinancialSupport
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,@"financial_support"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep4FinancialSupport] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // moneyAccess
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kStep4AmountAccess] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kStep4AmountAccess] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
       // education
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,keducation] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:keducation] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // Valid_scores
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kValid_scores] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kValid_scores] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       if([[dictionary valueForKey:kValid_scores] isEqualToString:@"true"])
       {
           // qualified_exams
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[dictionary valueForKey:@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
           
           // exam_scores
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[dictionary valueForKey:@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
           
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       }
       else
       {
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"qualified_exams"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
           
           // exam_scores
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"exam_scores"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[@"" dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
           
           // exam_scores
           [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kContent,@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[dictionary valueForKey:@"english_exam_level"] dataUsingEncoding:NSUTF8StringEncoding]];
           [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
           
       }
       
       
       // questionnaire
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kQuestionaier] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // WorkExperience
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,kWorkExperience] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:kWorkExperience] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       //global_question_description
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,@"global_question_description"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:@"global_question_description"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
       //deleted Document
       [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kContent,@"deleted_documents"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[dictionary valueForKey:@"deleted_documents"] dataUsingEncoding:NSUTF8StringEncoding]];
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
   
       //profileImage
           
           if ([[dictionary valueForKey:kProfileImage] isKindOfClass:[UIImage class]]) {
               UIImage *image = [dictionary valueForKey:kProfileImage];
               
               NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
               if (imageData)
               {
                   // image File
                   [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
                   [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"profileImage"] dataUsingEncoding:NSUTF8StringEncoding]];
                   [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                   [body appendData:imageData];
                   [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
               }

           }
           
       
           
       
       [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
       // close form
       [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
       
       
       NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
       [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
       [request setHTTPBody:body];
       
       NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
       NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
       
       NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           // Process the response
           
           if(error != nil) {
               
               NSLog(@"Error %@",[error userInfo]);
               if(showHud)
               [Utility hideMBHUDLoader];
               
               
           } else {
               
               NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:&error];
               NSLog(@"%@",json);
               
               
               
               if(showHud)
               [Utility hideMBHUDLoader];
              
               if ([[json valueForKey:@"Status"] integerValue] == 1) {
                   [kUserDefault setBool:YES forKey:KisGlobalApplicationDataUpdated];
               }
               
               else{
                   [kUserDefault setBool:NO forKey:KisGlobalApplicationDataUpdated];
               }
               
           }
         //  [self performSegueWithIdentifier:ksegueStep3to4 sender:self];
       }];
       
       [uploadTask resume];
            });

   }
   
    
    
}
@end
