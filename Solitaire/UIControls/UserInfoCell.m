//
//  UserInfoCell.m
//  Solitaire
//
//  Created by mobile master on 4/11/14.
//  Copyright (c) 2014 Appdeen. All rights reserved.
//

#import "UserInfoCell.h"
#import "JSONManager.h"

@implementation UserInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)SetData:(NSString*)userName hightScore:(int)score userID:(NSString*)userId
{
    if (userName.length > 7)
        userName = [NSString stringWithFormat:@"%@.", [userName substringToIndex:7]];
    NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [JSONManager GetSavePath:@"fb_thumb"], userId];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
    {
        [img_avatar setImage:[UIImage imageWithContentsOfFile:filePath]];
    }
    [lbl_username setText:userName];
    [lbl_score setText:[NSString stringWithFormat:@"%d", score]];
    [lbl_score setTextColor:[UIColor colorWithRed:0.99f green:0.886f blue:0.47f alpha:1]];
    [lbl_username setTextColor:[UIColor colorWithRed:0.99f green:0.886f blue:0.47f alpha:1]];
    float fontSize = 0;
    if (IS_iPAD)
        fontSize = 60;
    else
        fontSize = 28;
    [lbl_username setFont:[UIFont fontWithName:@"Brush455 BT" size:fontSize]];
    if (IS_iPAD)
        fontSize = 50;
    else
        fontSize = 20;
    [lbl_score setFont:[UIFont fontWithName:@"Brush455 BT" size:fontSize]];
}
@end
