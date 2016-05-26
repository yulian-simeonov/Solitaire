//
//  StatesScreen.m
//  Solitaire
//
//  Created by richboy on 2/25/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "StatesScreen.h"
#import "cocos2d-ui.h"
#import "ScoreRecord.h"

@implementation StatesScreen
-(id)init
{
    if (self = [super init])
    {
        [self setContentSizeType:CCSizeTypeNormalized];
        [self setContentSize:CGSizeMake(1, 1)];        
        
        CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"states_background.png"];
        [self addChild:sp_back];
        
        CCButton* btnClose = [CCButton buttonWithTitle:nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_close.png"]];
        [btnClose setAnchorPoint:ccp(1, 1)];
        [btnClose setTarget:self selector:@selector(OnClose)];
        [btnClose setPosition:ccp(sp_back.contentSize.width / 2, sp_back.contentSize.height / 2)];
        [self addChild:btnClose];
        
        m_dbMgr = [[DBManager alloc] init];
        m_webMgr = [[JSWebManager alloc] initWithAsyncOption:NO];
        m_fbMgr = [[JSFBManager alloc] init];
        [m_fbMgr setDelegate:self];
        
        m_scorePanel = [CCNode node];
        [self Refresh];
        [self addChild:m_scorePanel];
        
        [self setScale:0.1f];
        float interval = 0.08f;
        [self runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.2f scale:1.0f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.2f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.1f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.03f],
                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                         nil]];
        if ([m_fbMgr CheckConnectedFB])
        {
            [m_fbMgr GetMyFriends];
            [self schedule:@selector(OnRefresh) interval:5];
        }
    }
    return self;
}

-(void)OnRefresh
{
    [m_fbMgr GetMyFriends];
}

-(void)Refresh
{
    [m_scorePanel removeAllChildren];
    
    int idx = 0;
    NSArray* states = [m_dbMgr GetFriendsInfo];
    if (states.count > 0)
    {
        BOOL addedMe = false;
        for(NSDictionary* friendInfo in states)
        {
            NSString* userName = [[NSUserDefaults standardUserDefaults] valueForKey:[friendInfo valueForKey:@"user_id"]];
            int score = [[friendInfo valueForKey:@"score"] integerValue];
            int myScore = [m_dbMgr GetScoreByUserId:@"0"];
            if (score < myScore && !addedMe)
            {
                addedMe = true;
                ScoreRecord* rec = [[ScoreRecord alloc] initWithData:@"Me" hightScore:myScore userID:@"0"];
                if (IS_iPAD)
                    [rec setPosition:ccp(-230, 180 - idx * 130)];
                else
                    [rec setPosition:ccp(-100, 80 - idx * 55)];
                [m_scorePanel addChild:rec];
                idx++;
            }
            ScoreRecord* rec = [[ScoreRecord alloc] initWithData:userName hightScore:score userID:[friendInfo valueForKey:@"user_id"]];
            if (IS_iPAD)
                [rec setPosition:ccp(-230, 180 - idx * 130)];
            else
                [rec setPosition:ccp(-100, 80 - idx * 55)];
            [m_scorePanel addChild:rec];
            idx++;
        }
        
        if (!addedMe)
        {
            int myScore = [m_dbMgr GetScoreByUserId:@"0"];
            ScoreRecord* rec = [[ScoreRecord alloc] initWithData:@"Me" hightScore:myScore userID:@"0"];
            if (IS_iPAD)
                [rec setPosition:ccp(-230, 180 - idx * 130)];
            else
                [rec setPosition:ccp(-100, 80 - idx * 55)];
            [m_scorePanel addChild:rec];
            idx++;
        }
    }
    else
    {
        int score = [m_dbMgr GetScoreByUserId:@"0"];
        ScoreRecord* rec = [[ScoreRecord alloc] initWithData:@"Me" hightScore:score userID:@"0"];
        if (IS_iPAD)
            [rec setPosition:ccp(-230, 180)];
        else
            [rec setPosition:ccp(-100, 80)];
        [m_scorePanel addChild:rec];
    }
}

-(void)Closed
{
    for(int i = 0; i < 4; i++)
    {
        CCNode* nd = [[self parent] getChildByName:[NSString stringWithFormat:@"button_%d", i] recursively:NO];
        [nd setUserInteractionEnabled:YES];
    }
    [self unscheduleAllSelectors];
    [self removeFromParentAndCleanup:YES];
}

-(void)OnClose
{
    id callback = [CCActionCallFunc actionWithTarget:self selector:@selector(Closed)];
    [self runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.2f scale:1.2f],
                     [CCActionScaleTo actionWithDuration:0.2f scale:0],
                     callback,
                     nil]];
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
@end
