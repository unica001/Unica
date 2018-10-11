//
//  ParticipantsCell.h
//  Unica
//
//  Created by Ram Niwas on 05/10/18.
//  Copyright © 2018 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *universityName;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestbutton;
@property (weak, nonatomic) IBOutlet UIButton *checkMarkButton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmedButton;
@property (weak, nonatomic) IBOutlet UIView *viewReceived;

-(void)setParticipantsData:(NSDictionary *)dict viewType:(NSString*)viewType selectedArray:(NSArray*)selectedArray title:(NSString*)title;

@end
