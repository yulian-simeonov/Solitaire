//
//  UserInfoCell.h
//  Solitaire
//
//  Created by mobile master on 4/11/14.
//  Copyright (c) 2014 Appdeen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoCell : UITableViewCell
{
    IBOutlet UIImageView* img_avatar;
    IBOutlet UILabel* lbl_username;
    IBOutlet UILabel* lbl_score;
}
-(void)SetData:(NSString*)userName hightScore:(int)score userID:(NSString*)userId;
@end
