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
}

@end

@implementation ParticipantInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    infoArray = [[NSMutableArray alloc]initWithObjects:@"Designation",@"Email ID",@"Phone Number",@"Website",@"Country",@"Certification", nil];
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
        cell._descriptionLabel.text = self.infoDictionary[@"designation"];
    }
    else if (indexPath.row == 1){
        cell._descriptionLabel.text = self.infoDictionary[@"email"];
    }
    else if (indexPath.row == 2){
        cell._descriptionLabel.text = self.infoDictionary[@"mobileNo"];
    }
    else if (indexPath.row == 3){
        cell._descriptionLabel.text = self.infoDictionary[@"website"];
    }
    else if (indexPath.row == 4){
        cell._descriptionLabel.text = self.infoDictionary[@"country"];
        
    } else if (indexPath.row == 5){
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
                                    value:[UIFont fontWithName:@"SFUIText-Medium" size:17]
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
    else if (indexPath.row == 3){
        if (![[Utility replaceNULL:self.infoDictionary[@"website"] value:@""] isEqualToString:@""]) {
            
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[NSURL URLWithString:self.infoDictionary[@"website"]] options:@{} completionHandler:nil];
        }
    }
}

@end
