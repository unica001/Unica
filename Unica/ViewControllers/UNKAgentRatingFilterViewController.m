//
//  UNKAgentRatingFilterViewController.m
//  Unica
//
//  Created by vineet patidar on 21/03/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "UNKAgentRatingFilterViewController.h"

@interface UNKAgentRatingFilterViewController (){
    HCSStarRatingView *ratingView;
}

@end

@implementation UNKAgentRatingFilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // make rating BG view round up
    
    // google analytics
//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:@"Agent Rating Filter"];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    _ratingBackGroundView.layer.cornerRadius = 5.0;
    [_ratingBackGroundView.layer setMasksToBounds:YES];
    
    // code for rating view
    
    ratingView = [[HCSStarRatingView alloc] initWithFrame:_ratingView.frame];
    ratingView.userInteractionEnabled = YES;
    ratingView.minimumValue = 0;
    ratingView.allowsHalfStars = false;
    ratingView.tintColor = [UIColor colorWithRed:250.0f/255.0f green:164/255.0f blue:13.0f/255.0f alpha:1.0];
    ratingView.backgroundColor = [UIColor clearColor];
     [ratingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    [_ratingBackGroundView addSubview:ratingView];
    
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[kUserDefault valueForKey:kfilterRating]];
    if ([dict isKindOfClass:[NSMutableDictionary class]] && [[dict valueForKey:kfilterRating] isKindOfClass:[NSMutableDictionary class]]) {
     
        filterDictionaty = [NSMutableDictionary dictionaryWithDictionary:[dict valueForKey:kfilterRating]];
        
        ratingView.value = [[filterDictionaty valueForKey:kfilterRating] integerValue];
    }
    else{
    
    filterDictionaty = [[NSMutableDictionary alloc]init];
        
    }
    

}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    if ([[kUserDefault valueForKey:kfilterscleared] isEqualToString:kfilterscleared]) {
        
        [kUserDefault removeObjectForKey:kfilterRating];
        [kUserDefault setValue:@"" forKey:kfilterscleared];
    }
    else{
    
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        [dict setValue:[NSString stringWithFormat:@"%f",ratingView.value] forKey:kfilterRating];
        
        [filterDictionaty setValue:dict forKey:kfilterRating];
        
        [kUserDefault setValue:filterDictionaty forKey:kfilterRating];
        
    }

   
 
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

- (IBAction)applyFilterButton_clicked:(id)sender {
    
    [kUserDefault setValue:@"No" forKey:kIsRemoveAll];
    [kUserDefault synchronize];


    if ([self.agentFilter respondsToSelector:@selector(agentRatingFilter:)]) {
        [self.agentFilter agentRatingFilter:@"1"];
    }
    [self.navigationController popViewControllerAnimated:NO];


}
- (IBAction)didChangeValue:(HCSStarRatingView *)sender {
    
    if ([[kUserDefault valueForKey:kfilterscleared] isEqualToString:kfilterscleared]) {
        
        [kUserDefault removeObjectForKey:kfilterRating];
        [kUserDefault setValue:@"" forKey:kfilterscleared];
    }
    else{
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        
        [dict setValue:[NSString stringWithFormat:@"%f",ratingView.value] forKey:kfilterRating];
        
        [filterDictionaty setValue:dict forKey:kfilterRating];
        
        [kUserDefault setValue:filterDictionaty forKey:kfilterRating];
        
    }}
@end
