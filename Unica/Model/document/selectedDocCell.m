//
//  selectedDocCell.m
//  Unica
//
//  Created by Chankit on 8/1/17.
//  Copyright © 2017 Ramniwas Patidar. All rights reserved.
//

#import "selectedDocCell.h"

@implementation selectedDocCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(NSMutableDictionary*)dict{
    
//    if([Utility replaceNULL:[dict valueForKey:@"image"] value:@""]>0)
//        self.imageView.image = [dict valueForKey:@"image"];
    if([dict valueForKey:@"filename"])
    self.fileLabel.text = [dict valueForKey:@"filename"];
    else
    self.fileLabel.text = [dict valueForKey:@"name"];
}


//- (IBAction)crossButton_clicked:(id)sender {
//    UIButton *button = (UIButton*)sender;
//    
//    CGPoint point = [button convertPoint:CGPointZero toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
//    if([[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"id"])
//    {
//        [self.deletedDocumentArray addObject:[NSString stringWithFormat:@"%@",[[self.documentArray objectAtIndex:indexPath.row] valueForKey:@"id"]]];
//    }
//    
//    [self.documentArray removeObjectAtIndex:indexPath.row];
//    [self.tableView reloadData];
//    
//}
@end
