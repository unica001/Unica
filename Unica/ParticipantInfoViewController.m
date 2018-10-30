//
//  ParticipantInfoViewController.m
//  Unica
//
//  Created by Ram Niwas on 08/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import "ParticipantInfoViewController.h"

@interface ParticipantInfoViewController (){
    NSArray *infoArray;
    
    NSString *designation;
    NSString *emailStrign;
    NSString *mobileNoString;
    NSString *phoneNumberString;
    NSString *websiteString;
    NSString *countryString;
}

@end

@implementation ParticipantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoArray = [[NSMutableArray alloc]initWithObjects:@"Designation",@"Email ID",@"Phone Number",@"Mobile Number",@"Website",@"Country",@"Certification", nil];
    
    designation = [Utility replaceNULL:self.infoDictionary[@"designation"] value:@""];
    emailStrign = [Utility replaceNULL:self.infoDictionary[@"email"] value:@""];
    phoneNumberString = [Utility replaceNULL:self.infoDictionary[@"phoneNo"] value:@""];
    mobileNoString = [Utility replaceNULL:self.infoDictionary[@"mobileNo"] value:@""];

    websiteString = [Utility replaceNULL:self.infoDictionary[@"website"] value:@""];
    countryString = [Utility replaceNULL:self.infoDictionary[@"country"] value:@""];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)tapLink:(UIButton *)sender {
    NSLog(@"Tap on link");
    if (![[Utility replaceNULL:self.infoDictionary[@"certification"] value:@""] isEqualToString:@""]) {
        
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:[NSURL URLWithString:self.infoDictionary[@"certification"]] options:@{} completionHandler:nil];
    }
}

#pragma mark - Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [infoArray count];
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
    
    if ((indexPath.row == 0 && [designation isEqualToString:@""]) || (indexPath.row == 5 && [countryString isEqualToString:@""])|| (indexPath.row == 4 && [websiteString isEqualToString:@""])|| (indexPath.row == 2 && [phoneNumberString isEqualToString:@""])|| (indexPath.row == 1 && [emailStrign isEqualToString:@""]) || (indexPath.row == 3 && [mobileNoString isEqualToString:@""])) {
        return 0;
    }
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"descriptionCell";
    CourseDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"CourseDescriptionCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.headerLabel.text = [infoArray objectAtIndex:indexPath.row];
    cell.btnLink.hidden = YES;
    
    if (indexPath.row == 0) {
        if ([designation isEqualToString:@""]) {
            cell.hidden = true; }else {
        cell._descriptionLabel.text = designation;
        }
    }
    else if (indexPath.row == 1){
        
        if ([emailStrign isEqualToString:@""]) {
            cell.hidden = true;
        }
        else {
            cell._descriptionLabel.text = emailStrign;
        }
    }
    else if (indexPath.row == 2){
        if ([phoneNumberString isEqualToString:@""]) {
            cell.hidden = true;
        }
        else {
        cell._descriptionLabel.text = phoneNumberString;
        }
    }
    else if (indexPath.row == 3){
        if ([mobileNoString isEqualToString:@""]) {
            cell.hidden = true;
        }
        else {
            cell._descriptionLabel.text = mobileNoString;
        }
    }
    else if (indexPath.row == 4){
        if ([websiteString isEqualToString:@""]) {
            cell.hidden = true;
        }
        else {
        cell._descriptionLabel.text = websiteString;
        }
    }
    else if (indexPath.row == 5){
        
        if ([countryString isEqualToString:@""]) {
            cell.hidden = true;
        }else {
        cell._descriptionLabel.text = countryString;
        }
        
    } else if (indexPath.row == 6){
        NSString *strCertificate = [Utility replaceNULL:self.infoDictionary[@"certification"] value:@""];
        cell.btnLink.hidden = NO;
        [cell.btnLink addTarget:self action:@selector(tapLink:) forControlEvents:UIControlEventTouchUpInside];
        if (![strCertificate  isEqual: @""]) {
            NSString *strDesc = [Utility replaceNULL:self.infoDictionary[@"certification_text"] value:@""];
            NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:strDesc];
            [attributeString addAttribute:NSUnderlineStyleAttributeName
                                    value:[NSNumber numberWithInt:1]
                                    range:(NSRange){0,[attributeString length]}];
            [attributeString addAttribute:NSFontAttributeName
                                    value:[UIFont fontWithName:@"SFUIText-Medium" size:15]
                                    range:(NSRange){0,[attributeString length]}];
            cell._descriptionLabel.attributedText = attributeString;
        } else {
            cell.headerLabel.text = @"";
        }
    }
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2){
        if (![[Utility replaceNULL:self.infoDictionary[@"mobileNo"] value:@""] isEqualToString:@""]) {
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",self.infoDictionary[@"mobileNo"] ]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }    }
    
    if (indexPath.row == 3){
        if (![[Utility replaceNULL:self.infoDictionary[@"phoneNo"] value:@""] isEqualToString:@""]) {
            
            NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",self.infoDictionary[@"phoneNo"] ]];
            
            if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
                [[UIApplication sharedApplication] openURL:phoneUrl];
            }
        }    }
    else if (indexPath.row == 4){
        if (![[Utility replaceNULL:self.infoDictionary[@"website"] value:@""] isEqualToString:@""]) {
            
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:self.infoDictionary[@"website"]] options:@{} completionHandler:nil];
        }
    }
}

@end
