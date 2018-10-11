//
//  notificationCell.m
//  Unica
//
//  Created by Chankit on 7/20/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "notificationCell.h"

@implementation notificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSMutableDictionary *)dicationary {
    messageLabel.text = [Utility replaceNULL:[dicationary valueForKey:kmessage] value:@""];
    messageLabelHeightConstraint.constant = [Utility getTextHeight:[dicationary valueForKey:kmessage] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp]+10;
    
    
    universityNameLabel.text = [Utility replaceNULL:[dicationary valueForKey:ktitle] value:@""];
     uneversitylabelHeightConstraint.constant = [Utility getTextHeight:[dicationary valueForKey:ktitle] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp];
   
    
    addressLabel.text = [Utility replaceNULL:[dicationary valueForKey:kAddress] value:@""];
    addressLabelHeightConstraint.constant = [Utility getTextHeight:[dicationary valueForKey:kAddress] size:CGSizeMake(kiPhoneWidth-96, CGFLOAT_MAX) font:kDefaultFontForApp];
    
    
    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[dicationary valueForKey:kimage_url]] placeholderImage:[UIImage imageNamed:@""] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"%@",error);
    }];
   
    
    if([[Utility replaceNULL:[dicationary valueForKey:KNeed_action] value:@""] integerValue]>0)
    {
        self.acceptButton.hidden = NO;

        
        if([[Utility replaceNULL:[dicationary valueForKey:KActionStatus] value:@""] isEqualToString:@"accept"])
        {
            [self.acceptButton setTitle:@"Accepted" forState:UIControlStateNormal];
            self.acceptButton.userInteractionEnabled = NO;
            self.acceptButton.backgroundColor = [UIColor grayColor];

            
            self.acceptButton.layer.cornerRadius= 4;
            [self.acceptButton.layer setMasksToBounds:YES];

        }
        else  if([[Utility replaceNULL:[dicationary valueForKey:KActionStatus] value:@""] isEqualToString:@"reject"])
        {
        
            [self.acceptButton setTitle:@"Rejected" forState:UIControlStateNormal];
            self.acceptButton.userInteractionEnabled = NO;
            self.acceptButton.backgroundColor = [UIColor grayColor];

            self.acceptButton.layer.cornerRadius= 5;
            [self.acceptButton.layer setMasksToBounds:YES];

        }
        else{
        
            self.rejectButton.hidden = NO;
            self.acceptButton.hidden = NO;
            self.acceptButton.userInteractionEnabled = YES;
 
        }
      
    }
    
    
    
    // read / unread notification
    
    if ([[dicationary valueForKey:@"isUnread"] boolValue] == true) {
        innerView.backgroundColor = [UIColor colorWithRed:235.0/255.0 green:239.0/255.0 blue:246.0/255.0 alpha:1];
    }
    else{
          innerView.backgroundColor = [UIColor whiteColor];
    }
    
    
}

-(void)initLayout
{
    innerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    innerView.layer.shadowOffset = CGSizeMake(2.5f, 2.5f);
    innerView.layer.shadowRadius = 1.0f;
    innerView.layer.shadowOpacity = 0.5f;
    innerView.layer.masksToBounds = NO;
    innerView.clipsToBounds = false;
    innerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    innerView.layer.borderWidth = 0.5f;
    innerView.layer.cornerRadius= 5;
    
    universityNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    universityNameLabel.numberOfLines = 0;
    [universityNameLabel sizeToFit];

    
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.numberOfLines = 0;
    [messageLabel sizeToFit];
    
    addressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    addressLabel.numberOfLines = 0;
    [addressLabel sizeToFit];

    
    logoImageView.layer.cornerRadius= logoImageView.frame.size.height/2;
    logoImageView.clipsToBounds = true;
    self.acceptButton.layer.cornerRadius= self.acceptButton.frame.size.height/2;
    
    self.rejectButton.layer.cornerRadius= self.rejectButton.frame.size.height/2;
    
}
@end
