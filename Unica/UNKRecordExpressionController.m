
#import "UNKRecordExpressionController.h"
#import "remarkCell.h"
#import "studentCell.h"
#import "busunesCardCell.h"

@interface UNKRecordExpressionController (){
    
    __weak IBOutlet UIImageView *cardImageView;
    NSMutableDictionary *detail;
    NSArray *actions,*category,*template;
    NSMutableArray *headerTextArray;
    NSMutableDictionary *loginDictionary,*orignalDic;
    
    NSArray * participantArray;
    NSMutableArray *selectedParticipant;
    NSString *actionString;
    NSString *categoryString;
    NSString *emailTemplateString;
    NSString *dateString;
    NSString *remarkTextView;
    
    NSString *actionID;
    NSString *categoryID;
    NSString *templeteID;
    NSString *strTemplate;
    
    AppDelegate *appdelegate;
}

@end

@implementation UNKRecordExpressionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    actionString = @"Select";
    categoryString = @"Select";
    emailTemplateString = @"Select";
    dateString = @"Select";
    
    loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    actions =[[[UtilityPlist getData:KActions] valueForKey:kAPIPayload] valueForKey:@"action_lists"];
    category =[[[UtilityPlist getData:Kcategories] valueForKey:kAPIPayload] valueForKey:@"category_lists"];
    
    selectedParticipant = [[NSMutableArray alloc]init];
    appdelegate  = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self setupInitialLayout];
    [self GetTemplateList];
    [self GetrecordedExpression];
}
-(void)viewWillAppear:(BOOL)animated{
}

-(void)setupInitialLayout{
    headerTextArray = [[NSMutableArray alloc] initWithObjects:@"Action",@"Category",@"Remarks",@"Template",@"Date", nil];
}

-(void)setPreviousData:(NSDictionary *)dict {
    orgNameLabel.text = [dict valueForKey:@"organizationName"];
    NSPredicate *predicate =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[dict valueForKey:@"action"] value:@""]];
    
    NSArray *filtredArray = [actions filteredArrayUsingPredicate:predicate];
    if(filtredArray.count>0)
    {
        actionString = [[filtredArray objectAtIndex:0] valueForKey:@"title"];
        actionID = [[filtredArray objectAtIndex:0] valueForKey:@"id"];
    }
    
    NSPredicate *predicate2 =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[dict valueForKey:@"category"] value:@""]];
    NSArray *filtredArray2 = [category filteredArrayUsingPredicate:predicate2];
    if(filtredArray2.count>0)
    {
        categoryString = [[filtredArray2 objectAtIndex:0] valueForKey:@"title"];
        categoryID = [[filtredArray2 objectAtIndex:0] valueForKey:@"id"];
    }
    
    NSPredicate *predicate3 =[NSPredicate predicateWithFormat:@"id == %@",[Utility replaceNULL:[dict valueForKey:@"template"] value:@""]];
    NSArray *filtredArray3 = [template filteredArrayUsingPredicate:predicate3];
    if(filtredArray3.count>0)
    {
        templeteID = [[filtredArray3 objectAtIndex:0] valueForKey:@"title"];
        emailTemplateString = [filtredArray3 objectAtIndex:0] ;
    }
    if([Utility replaceNULL:[dict valueForKey:@"email_date"] value:@""].length>0)
    {
        NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
        [datePickerFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *checkIn = [datePickerFormat dateFromString:[dict valueForKey:@"email_date"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
        dateString = [dateFormatter stringFromDate:checkIn];
    }
    [collectionView reloadData];
}

- (IBAction)tapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
          cell.remarktextView.delegate = self;
            return cell;
        }
   
//        static NSString *cellIdentifier3  =@"signIn";
//
//        studentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
//        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"studentCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        cell.contentHeaderLabel.text = [headerTextArray objectAtIndex:indexPath.row];
//        cell.outerView.layer.cornerRadius = 3;
//        cell.outerView.layer.borderWidth = 1;
//        cell.outerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//        cell.outerView.clipsToBounds = YES;
//
//        switch (indexPath.row) {
//            case 0:
//                cell.detailLabel.text = actionString;
//                break;
//            case 1:
//                cell.detailLabel.text = categoryString;
//                break;
//            case 3:
//                cell.detailLabel.text = emailTemplateString;
//                break;
//            case 4:
//                cell.detailLabel.text = dateString;
//                break;
//
//            default:
//                break;
//        }
    
    
    static NSString *cellIdentifier3  =@"signIn";
    
    busunesCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"busunesCardCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.contentLabel.text = [headerTextArray objectAtIndex:indexPath.row];
    cell.contenttextField.userInteractionEnabled = false;
    cell.contenttextField.placeholder = @"Select";

    if (indexPath.row == 0) {
        cell.dropImageView.constant = 25;
        cell.contenttextField.text = actionString;
    }
    else if (indexPath.row == 1) {
        cell.dropImageView.constant = 25;
        cell.contenttextField.text =categoryString;
    }
   
    else if (indexPath.row == 3) {
        cell.dropImageView.constant = 25;
        cell.contenttextField.text = emailTemplateString;
        if (![strTemplate isEqualToString:@""]) {
            cell.lblTemplate.hidden = false;
            cell.lblTemplate.text = strTemplate;
        }
    }
    else if (indexPath.row == 4) {
        cell.dropImageView.constant = 25;
        cell.dropdown.image = [UIImage imageNamed:@"Calendar"];
        cell.contenttextField.text = dateString;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, kiPhoneWidth-45, 1)];
        lbl.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:lbl];
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
        return 50;
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


#pragma mark - Collection view delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return participantArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecordExpressionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"RecordExpressionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];

    
    [cell.participantImg sd_setImageWithURL:[NSURL URLWithString:[participantArray[indexPath.row] valueForKey:@"p_user_image_url"]] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    
    cell.participantImg.layer.cornerRadius = cell.participantImg.frame.size.width/2;
    cell.participantImg.layer.borderWidth = 3;
    cell.participantImg.layer.borderColor = kDefaultBlueColor.CGColor;
    cell.participantImg.layer.masksToBounds = true;
    
    if ([selectedParticipant containsObject:participantArray[indexPath.row]]) {
        cell.selectedImage.image = [UIImage imageNamed:@"CheckBoxActive"];
    }
    else {
        cell.selectedImage.image = [UIImage imageNamed:@"CheckBox"];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120,120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0.0, 30.0, 0.0, 20.0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([selectedParticipant containsObject: participantArray[indexPath.row]]) {
        [selectedParticipant removeObject:participantArray[indexPath.row]];
    }
    else {
        [selectedParticipant removeAllObjects];
        [selectedParticipant addObject:participantArray[indexPath.row]];
    }
    [collectionView reloadData];
}


// MARK Text View Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    remarkTextView = [textView.text stringByReplacingCharactersInRange:range withString:text];
    return YES;
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

- (void)showCamera {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Set Profile Picture" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Upload from Gallery" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{}];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypePhotoLibrary;
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take Camera Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // OK button tapped.
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        UIImagePickerControllerSourceType type = UIImagePickerControllerSourceTypeCamera;
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = NO;
        picker.delegate   = self;
        picker.sourceType = type;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect rect = CGRectMake(0,0,200,200);
    UIGraphicsBeginImageContext( rect.size );
    [image drawInRect:rect];
    UIGraphicsEndImageContext();
    
    businessCartImage.image =image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self presentCropViewController];
    
}
- (void)presentCropViewController
{
    UIImage *image = businessCartImage.image;
    
    TOCropViewController *cropViewController = [[TOCropViewController alloc] initWithImage:image];
    cropViewController.delegate = self;
    
    [self presentViewController:cropViewController animated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    businessCartImage.image =[Utility compressImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}


// MARK Button Action

- (IBAction)scanBusinessCartAction:(id)sender {
    [self showCamera];
}
- (IBAction)submitButtonAction:(id)sender {
    if([self Validation])
    {
        [self addCard];
    }
}

- (IBAction)cancelButtonAcrtion:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
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
                        strTemplate = [dictionary valueForKey:@"Message"];
                        [tableView reloadData];
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

-(void)GetrecordedExpression
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId =  [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    [dic setValue:userId forKey:@"user_id"];
    [dic setValue:[NSString stringWithFormat:@"%@",[loginDictionary valueForKey:@"user_type"]] forKey:@"user_type"];
     [dic setValue:appdelegate.userEventId forKey:kevent_id];
    [dic setValue:_participantId forKey:@"participantId"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-users-recorded-expression.php"];
    
    [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:dic  timeoutInterval:kAPIResponseTimeout showHUD:NO showSystemError:NO completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    NSMutableDictionary *payloadDictionary = [dictionary valueForKey:kAPIPayload];
                    participantArray = [payloadDictionary valueForKey:@"userList"];
                    [self setPreviousData:payloadDictionary];
                    [collectionView reloadData];
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

#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
-(void)addCard
{
    
    NSDictionary*loginDictionary = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSString *userId = [loginDictionary valueForKey:@"id"];
    userId = [userId stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    
    if(![Utility connectedToInternet])
    {
        [Utility hideMBHUDLoader];
        [Utility showAlertViewControllerIn:self title:@"" message:@"Internet not connected" block:^(int index){
            return;
        }];
    }
    else
    {
        dispatch_async( dispatch_get_main_queue(), ^{
            
            [Utility ShowMBHUDLoader];
        });
        NSMutableURLRequest *request = nil;
        NSLog(@"image upload");
        
        NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"org-send-expression.php"];
       
        NSMutableData *body = [NSMutableData data];
        request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
        // UserID
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[userId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // User Type
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[loginDictionary valueForKey:@"user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // Participant
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"participantId"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[_participantId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // image_id
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"p_user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[selectedParticipant[0] valueForKey:@"p_user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // image Type
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"p_user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[selectedParticipant[0] valueForKey:@"p_user_type"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
       
        // Event ID
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,kevent_id] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[appdelegate.userEventId dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
       // Action
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"action"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[actionID dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
       
        // Remark
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"remark"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[remarkTextView dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
       // Email
        
        if (templeteID.length > 0) {
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kContent,@"email_template"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[templeteID dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        
        
        NSString *date ;
        if(dateString.length>0 &&  ![dateString isEqualToString:@"Select"])
        {
            NSDateFormatter *datePickerFormat = [[NSDateFormatter alloc] init];
            [datePickerFormat setDateFormat:@"dd/MM/yyyy"];
            NSDate *checkIn = [datePickerFormat dateFromString:dateString];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            date = [dateFormatter stringFromDate:checkIn];
        }
        else {
            dateString = @"";
        }
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"mail_scheduled_date"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[date dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent,@"category"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[categoryID dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
    
        NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(businessCartImage.image)];
        if (imageData)
        {
            // image File
            [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"scan_image"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:imageData];
            [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        // }
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:body];
        
        
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
        
        defaultConfigObject.timeoutIntervalForRequest = 400;
        defaultConfigObject.timeoutIntervalForResource = 650;
        NSURLSessionDataTask *uploadTask = [defaultSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // Process the response
            dispatch_async( dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
            });
            
            
            if(error != nil) {
                
                
                if ((!data) || data== nil) {
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        
                        if(![Utility connectedToInternet])
                        {
                            [Utility showAlertViewControllerIn:self title:@"" message:kErrorMsgSlowInternet block:^(int index){
                                return;
                            }];
                        }
                        else
                        {
                            return;
                        }
                    });
    
                }
                else{
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                                options:NSJSONReadingMutableContainers
                                                                                  error:&error];
                    
                    NSLog(@"Error %@",[error userInfo]);
                    
                    [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                        
                        
                        dispatch_async( dispatch_get_main_queue(), ^{
                            [self.navigationController popViewControllerAnimated:true];
                        });
                        
                    }];
                    
                }
     
            }
            else {
                NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:&error];
                
                NSLog(@"Error %@",[error userInfo]);
                
                [Utility showAlertViewControllerIn:self title:@"" message:[json valueForKey:kAPIMessage] block:^(int index){
                    
                    dispatch_async( dispatch_get_main_queue(), ^{
                        NSLog(@"finished");
   
                    });
                    
                }];
            }
            
        }];
        
        [uploadTask resume];
    }
}


-(BOOL)Validation
{
    if(selectedParticipant.count == 0)
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select participant" block:^(int index) {
        }];
        return false;
    }
   else if(actionString.length == 0)
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select action" block:^(int index) {
        }];
        return false;
    }
    else if(categoryID.length == 0)
    {
        [Utility showAlertViewControllerIn:self title:kUNKError message:@"Please select category" block:^(int index) {
        }];
        return false;
    }
    return true;
}
@end
