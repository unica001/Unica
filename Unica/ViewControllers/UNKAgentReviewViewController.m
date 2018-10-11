//
//  UNKAgentReviewViewController.m
//  Unica
//
//  Created by vineet patidar on 24/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentReviewViewController.h"
#import "AgentReviewCell.h"
#import "UNKAddAgentReviewViewController.h"

@interface UNKAgentReviewViewController ()

@end

@implementation UNKAgentReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Review Screen"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self getAgentReview:self.agentDictionary];
    
    
    _reviewTable.layer.cornerRadius = 5.0;
    [_reviewTable.layer setMasksToBounds:YES];
    
    // sw reveal view  delegate
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {  SWRevealViewController *revealViewController = self.revealViewController;
        if ( revealViewController )
        {
            [_revealMenu setTarget: self.revealViewController];
            [_revealMenu setAction: @selector( revealToggle: )];
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
    self.revealViewController.delegate = self;

}



#pragma  mark -APIS

-(void)getAgentReview:(NSMutableDictionary *)selectedDictionary{
    
    NSMutableDictionary *dictLogin = [Utility unarchiveData:[kUserDefault valueForKey:kLoginInfo]];
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    if ([[dictLogin valueForKey:Kid] length]>0 && ![[dictLogin valueForKey:Kid] isKindOfClass:[NSNull class]]) {
        [dictionary setValue:[dictLogin valueForKey:Kid] forKey:kUser_id];
    }
    else{
        [dictionary setValue:[dictLogin valueForKey:Kuserid] forKey:kUser_id];
    }
    [dictionary setValue:[selectedDictionary valueForKey:kAgent_id] forKey:kAgent_id];
 
    NSString *url = [NSString stringWithFormat:@"%@%@",kAPIBaseURL,@"agent_review.php"];
    
    
   [[ConnectionManager sharedInstance] sendPOSTRequestForURL:url message:@"" params:(NSMutableDictionary*)dictionary  timeoutInterval:kAPIResponseTimeout showHUD:YES showSystemError:YES completion:^(NSDictionary *dictionary, NSError *error) {
        
        if (!error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([[dictionary valueForKey:kAPICode] integerValue]== 200) {
                    
                    _reviewArray = [dictionary valueForKey:kAPIPayload];
                    
                    [_reviewTable reloadData];
                    
                }else{
                    
                   /* dispatch_async(dispatch_get_main_queue(), ^{
                        [Utility showAlertViewControllerIn:self title:kErrorTitle message:[dictionary valueForKey:kAPIMessage] block:^(int index) {
                            
                        }];
                    });*/
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


#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_reviewArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0.1;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier3  =@"aboutCell";
    
    AgentReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
    
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"AgentReviewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // set about call data
    cell.nameLabel.text = [[_reviewArray objectAtIndex:indexPath.row]valueForKey:Kuser_name ];
    
    NSString *messageLabel = [[_reviewArray objectAtIndex:indexPath.row]valueForKey:kreview_message];
    cell.reviewDescription.text = messageLabel;
    
    cell.reviewDescriptionHeight.constant =[Utility getTextHeight:messageLabel size:CGSizeMake(kiPhoneWidth - 100, CGFLOAT_MAX) font:kDefaultFontForApp];
    
    // profile image
    
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width/2;
    [cell.profileImage.layer setMasksToBounds:YES];
    
    NSString *imageUrl =  [[_reviewArray objectAtIndex:indexPath.row]valueForKey:kuser_image];
    
    if (![imageUrl isKindOfClass:[NSNull class]]) {
        
        [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"userimageplaceholder"] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            NSLog(@"%@",error);
        }];
    }
    
    
    // code for rating view
    
    HCSStarRatingView *_ratingView = [[HCSStarRatingView alloc] initWithFrame:CGRectMake(80, 31,70, 20)];
    _ratingView.userInteractionEnabled = NO;
    _ratingView.allowsHalfStars = NO;
    _ratingView.tintColor = [UIColor colorWithRed:252.0f/255.0f green:180.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    _ratingView.value = [[[_reviewArray objectAtIndex:indexPath.row]valueForKey:krating] integerValue];
    _ratingView.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:_ratingView];
    
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *messageLabel = [[_reviewArray objectAtIndex:indexPath.row]valueForKey:kreview_message];
    
    CGFloat height = 0.0;
    
    if ([Utility getTextHeight:messageLabel size:CGSizeMake(kiPhoneWidth -100, CGFLOAT_MAX) font:kDefaultFontForApp] >20) {
        
        height = [Utility getTextHeight:messageLabel size:CGSizeMake(kiPhoneWidth - 100, CGFLOAT_MAX) font:kDefaultFontForApp];
    }
    return 80+height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   
    if ([segue.identifier isEqualToString:kaddAgentReviewSegueIdentifeir]) {
        UNKAddAgentReviewViewController *addAgentReviewViewController = segue.destinationViewController;
        addAgentReviewViewController.agentDictionary = sender;
    }
}


#pragma  mark - button clicked

- (IBAction)addReviewButton_clicked:(id)sender {
    
    [self performSegueWithIdentifier:kaddAgentReviewSegueIdentifeir sender:self.agentDictionary];
}
@end
