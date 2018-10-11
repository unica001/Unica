//
//  UNKAgentAboutViewController.m
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentAboutViewController.h"
#import "AgentAboutCell.h"

@interface UNKAgentAboutViewController (){

    NSUInteger X_axis;
}

@end

typedef enum
{   AboutName = 0,
    AboutSince = 1,
    AboutOffered = 2,
    AboutLocation = 3
    
} AboutField;

@implementation UNKAgentAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    _aboutTable.layer.cornerRadius = 5.0;
    [_aboutTable.layer setMasksToBounds:YES];

    _aboutArray = [[NSMutableArray alloc]initWithObjects:@"Name",@"Established Since",@"Services Offered",@"Location", nil];
    
    X_axis = 40;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_backButton setTarget: self.revealViewController];
            [_backButton setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
    self.revealViewController.delegate = self;
}




#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_aboutArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"aboutCell";
    
    AgentAboutCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AgentAboutCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    // set about call data
    cell.headeLabel.text = [_aboutArray objectAtIndex:indexPath.row];
    
    if (indexPath.row == AboutName) {
        NSString *_agentName = [self.agentDictionary valueForKey:kAgent_name];
        
    cell.serviceLabel.text = _agentName;
        
    cell.serviceLabelHeight.constant =[Utility getTextHeight:_agentName size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else  if (indexPath.row == AboutSince) {
        
        NSString *_experince = [self.agentDictionary valueForKey:@"establish"];
        
        cell.serviceLabel.text = _experince;
        
        cell.serviceLabelHeight.constant =[Utility getTextHeight:_experince size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else  if (indexPath.row == AboutOffered) {
        cell.serviceLabel.text = [self.agentDictionary valueForKey:kAgent_service];
        
        NSString *_srvice = [self.agentDictionary valueForKey:kAgent_service];
        
        cell.serviceLabel.text = _srvice;
        
        cell.serviceLabelHeight.constant =[Utility getTextHeight:_srvice size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else  if (indexPath.row == AboutLocation) {
        NSString *_address = [self.agentDictionary valueForKey:kAddress];
        
        cell.serviceLabel.text = _address;
        
        cell.serviceLabelHeight.constant =[Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
 
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat height = 0.0;
    NSString *_agentName = [self.agentDictionary valueForKey:kAgent_name];
    NSString *_experince = [self.agentDictionary valueForKey:kAgent_experience];
       NSString *_srvice = [self.agentDictionary valueForKey:kAgent_service];
    NSString *_address = [self.agentDictionary valueForKey:kAddress];

    
    if (indexPath.row == AboutName && [Utility getTextHeight:_agentName size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp]>20) {
        
        height =[Utility getTextHeight:_agentName size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    
    else  if (indexPath.row == AboutSince && [Utility getTextHeight:_experince size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp]>20) {
        
       height = [Utility getTextHeight:_experince size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else  if (indexPath.row == AboutOffered && [Utility getTextHeight:_srvice size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        
        height = [Utility getTextHeight:_srvice size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    else  if (indexPath.row == AboutLocation && [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        
        height = [Utility getTextHeight:_address size:CGSizeMake(kiPhoneWidth - X_axis, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    
    return 55+height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backButton_clicked:(id)sender {
}
@end
