//
//  ContactUsViewController.m
//  Unica
//
//  Created by vineet patidar on 09/04/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "ContactUsViewController.h"
#import "ContactUsCell.h"
#import <MessageUI/MessageUI.h>
@interface ContactUsViewController ()<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contactUsArray = [[NSMutableArray alloc]initWithObjects:@"Mobile",@"Phone",@"Email",@"Address", nil];
   contactUsDictionary = [[NSMutableDictionary alloc]init];
    
    [self getContactUsData];
}


#pragma  mark - APIS

-(void)getContactUsData{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"contactus.php"];
    
    [Utility ShowMBHUDLoader];
    
    [[ConnectionManager sharedInstance] sendGETRequestForURL:url params:nil timeoutInterval:kAPIResponseTimeout showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [Utility hideMBHUDLoader];
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    contactUsDictionary = [NSMutableDictionary dictionaryWithDictionary:[dictionary valueForKey:kAPIPayload]];
                   
                    
                    if ([[contactUsDictionary valueForKey:kphone] length]>0  && ![[contactUsDictionary valueForKey:kphone] isKindOfClass:[NSNull class]]) {
                        _phoneArray = [[contactUsDictionary valueForKey:kphone] componentsSeparatedByString:@"/"];
                        
                        if (_phoneArray.count>0) {
                            [contactUsDictionary setValue:[_phoneArray objectAtIndex:1] forKey:kphone];
                        }
                    }
                    
                    
                    if ([[contactUsDictionary valueForKey:ksecond_phone] length]>0  && ![[contactUsDictionary valueForKey:ksecond_phone] isKindOfClass:[NSNull class]]) {
                        
                        _phoneArray = [[contactUsDictionary valueForKey:ksecond_phone] componentsSeparatedByString:@"/"];
                        
                        if (_phoneArray.count>0) {
                            [contactUsDictionary setValue:[_phoneArray objectAtIndex:1] forKey:ksecond_phone];
                        }
                    }
                   
                  
                    [_contactUsTable reloadData];
   
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility hideMBHUDLoader];

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
                    [Utility hideMBHUDLoader];

                    [Utility showAlertViewControllerIn:self title:kErrorTitle message:error.localizedDescription block:^(int index) {
                        
                    }];
                });
            }
        }
    }];
}

#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_contactUsArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    double height = 0.0;
    
    // address
    
    if (indexPath.row == 3)  {
        NSString *address = [contactUsDictionary valueForKey:@"adress"];

    if ( [Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth-30, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        
        height = [Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth-30, CGFLOAT_MAX) font:kDefaultFontForApp]+130;
    }
    else {
        height = 50;
    }
        return height;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier  =@"ContactUsCell";
    
    ContactUsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"ContactUsCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // address
   
    if (indexPath.row == 0)  {
        cell.numberLabel.text = [contactUsDictionary valueForKey:kmobile];

    }
  else  if (indexPath.row == 1)  {
      cell.numberLabel.text = [contactUsDictionary valueForKey:kphone];
      cell.messageButtonWidth.constant = 0;

    }
   else if (indexPath.row == 2)  {
       
       NSString *email = [contactUsDictionary valueForKey:kEmail];
       cell.numberLabel.text = email;
        cell.callButton.hidden = YES;
      cell.phoneNumberButtonWidth.constant = 0;
        [cell._messageButton setImage:[UIImage imageNamed:@"MailContactUs"] forState:UIControlStateNormal];
        
    }
    
   else if (indexPath.row == 3)  {
       
       NSString *address = [contactUsDictionary valueForKey:@"adress"];

    if (![address isKindOfClass:[NSNull class]]) {
        cell.numberLabelHeight.constant =[Utility getTextHeight:address size:CGSizeMake(kiPhoneWidth - 120, CGFLOAT_MAX) font:kDefaultFontForApp];
        cell.numberLabel.text = address;

    }
       cell.messageButtonWidth.constant = 0;
       cell.phoneNumberButtonWidth.constant = 0;
    }

    cell.headerLabel.text = [_contactUsArray objectAtIndex:indexPath.row];
    cell._messageButton.tag = indexPath.row;
    cell.callButton.tag = indexPath.row;
    
    // add target
    [cell.callButton addTarget:self action:@selector(callButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
      [cell._messageButton addTarget:self action:@selector(_messageButton_clicked:) forControlEvents:UIControlEventTouchUpInside];
    cell._messageButton.tag = indexPath.row;
    
    return  cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

#pragma  mark - button clicked

-(void)callButton_clicked:(UIButton *)sender{
    
        NSString *phonenumberString;
    
        if (sender.tag ==0) {
        phonenumberString = [contactUsDictionary valueForKey:kmobile];
        }
        else if (sender.tag ==1) {
            phonenumberString = [contactUsDictionary valueForKey:kphone];
        }
       
        
        if ([phonenumberString isEqual:[NSNull class]]) {
            return;
        }
        
        NSString *phoneNumber = [@"tel://" stringByAppendingString:phonenumberString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
   
}
-(void)_messageButton_clicked:(UIButton *)sender{
    
    if (sender.tag == 0) {
        [self sendMessage:[contactUsDictionary valueForKey:kmobile]];
    }
    else if (sender.tag == 2) {
        [self sendEmail:[contactUsDictionary valueForKey:kEmail]];
    }
    
}


-(void)sendEmail:(NSString *)email{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
        [composeViewController setMailComposeDelegate:self];
        [composeViewController setToRecipients:@[[contactUsDictionary valueForKey:kEmail]]];
        [composeViewController setSubject:@"Contact us"];
        [self presentViewController:composeViewController animated:YES completion:nil];
    }
    else{
        
        NSLog(@"Can't send email");
    }

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}


#pragma mark - selegate for send message

-(void)sendMessage:(NSString *)number{
        
        if(![MFMessageComposeViewController canSendText]) {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            return;
        }
        
        NSArray *recipents = @[number];
    
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        [messageController setRecipients:recipents];
//        [messageController setBody:message];
    
        // Present message view controller on screen
        [self presentViewController:messageController animated:YES completion:nil];
    }


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)backButton_clicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
