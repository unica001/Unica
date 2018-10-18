

#import <UIKit/UIKit.h>
#import "ParticipantInfoViewController.h"
#import "ParticipantAboutViewController.h"
#import "ChatViewController.h"

@interface ParticipantDetailViewController : UIViewController<YSLContainerViewControllerDelegate>{
    
    ParticipantInfoViewController * infoView;
    ParticipantAboutViewController  *aboutView;
    ChatViewController *chatView;
    YSLContainerViewController *containerVC;

}
@property (weak, nonatomic) IBOutlet UIView *viewBg;
@property (weak, nonatomic) IBOutlet UIView *segmentView;
@property (weak, nonatomic) IBOutlet UIButton *nameButton;
@property (weak, nonatomic) IBOutlet UILabel *universityName;
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *sendRequestbutton;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *profileImageButton;
@property (weak, nonatomic) IBOutlet UIView *viewReceived;

- (IBAction)profileImageButtonAction:(id)sender;
- (IBAction)rejectButtonAction:(id)sender;
- (IBAction)nameButtonAction:(id)sender;
- (IBAction)sendRequestButtonAction:(id)sender;
- (IBAction)accepButtonAction:(id)sender;

@property(nonatomic, weak) NSString *strParticipantId;
@property(nonatomic,retain) NSDictionary *participantDict;
@property(nonatomic,retain) QBChatDialog *dialog;


@end
