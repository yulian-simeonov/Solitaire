//
//  StateView.m
//  Solitaire
//
//  Created by mobile master on 4/11/14.
//  Copyright (c) 2014 Appdeen. All rights reserved.
//

#import "StateView.h"
#import "UserInfoCell.h"
#import "MenuScreen.h"

@implementation StateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)InitControls:(id)parent
{
    m_parent = parent;
    m_dbMgr = [[DBManager alloc] init];
    m_webMgr = [[JSWebManager alloc] initWithAsyncOption:NO];
    m_fbMgr = [[JSFBManager alloc] init];
    [m_fbMgr setDelegate:self];
    m_ary = [m_dbMgr GetFriendsInfo];
    [tbl_userInfo reloadData];
    
    if ([m_fbMgr CheckConnectedFB])
    {
        [m_fbMgr GetMyFriends];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_ary.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_iPAD)
        return 154;
    else
        return 61;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfoCell * cell = nil;
    if (cell == nil)
    {
        NSString* strNibCell = nil;
        if (IS_iPAD)
            strNibCell = @"UserInfoCell_ipad";
        else
            strNibCell = @"UserInfoCell";
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:strNibCell owner:self options:nil];
        cell = (UserInfoCell*)[nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    NSDictionary* userInfo = [m_ary objectAtIndex:indexPath.row];
    int score = 0;
    NSString* userName = [[NSUserDefaults standardUserDefaults] valueForKey:[userInfo valueForKey:@"user_id"]];
    if (!userName)
    {
        userName = @"Me";
        score = [m_dbMgr GetScoreByUserId:@"0"];
        [cell SetData:userName hightScore:score userID:@"0"];
    }
    else
    {
        score = [m_dbMgr GetScoreByUserId:[userInfo valueForKey:@"user_id"]];
        [cell SetData:userName hightScore:score userID:[userInfo valueForKey:@"user_id"]];
    }
    
    return cell;
}

-(IBAction)OnClose:(id)sender
{
    [self removeFromSuperview];
    [(MenuScreen*)m_parent EnableTouch];
}

-(void)CompletedMyFriends:(NSArray*)friends
{
    m_friends = friends;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NSDictionary* friendInfo in m_friends)
        {
            NSString* val = [m_webMgr GetFriendScore:[friendInfo objectForKey:@"id"]];
            if (val.length > 0)
            {
                NSLog(@"%@, %@", [friendInfo objectForKey:@"id"], [friendInfo objectForKey:@"name"]);
                NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [JSONManager GetSavePath:@"fb_thumb"], [friendInfo objectForKey:@"id"]];
                if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
                {
                    [m_webMgr fileDownload:[NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", [friendInfo objectForKey:@"id"]] saveName:filePath];
                }
                [m_dbMgr UpdateScore:[friendInfo objectForKey:@"id"] score:[val intValue]];
                [[NSUserDefaults standardUserDefaults] setObject:[friendInfo objectForKey:@"name"] forKey:[friendInfo objectForKey:@"id"]];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        [self performSelectorOnMainThread:@selector(Refresh) withObject:self waitUntilDone:NO];
    });
}

-(void)Refresh
{
    m_ary = [m_dbMgr GetFriendsInfo];
    [tbl_userInfo reloadData];
}
@end
