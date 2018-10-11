//
//  selectedDocCell.h
//  Unica
//
//  Created by Chankit on 8/1/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selectedDocCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *documentImage;
@property (weak, nonatomic) IBOutlet UILabel *fileLabel;
@property (nonatomic,retain) NSMutableArray *documentArray;
@property (nonatomic,retain) NSMutableArray *deletedDocumentArray;
@property (nonatomic,retain) UITableView *tableView;

//- (IBAction)crossButton_clicked:(id)sender;
-(void)setData:(NSMutableDictionary*)dict;
@property (strong, nonatomic) IBOutlet UIButton *crossButton;


@end
