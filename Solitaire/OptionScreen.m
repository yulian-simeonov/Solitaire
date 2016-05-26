//
//  OptionScreen.m
//  Solitaire
//
//  Created by richboy on 2/24/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "OptionScreen.h"
#import "LookButton.h"
#import "ScrollScreen.h"
#import "ToggleButton.h"
#import "AppDelegate.h"

@implementation OptionScreen
-(id)init
{
    if (self = [super init])
    {
        m_fbMgr = [[JSFBManager alloc] init];
        [m_fbMgr setDelegate:self];
        m_webMgr = [[JSWebManager alloc] initWithAsyncOption:YES];
        m_dbMgr = [[DBManager alloc] init];
        [self Refresh];
        
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
    }
    return self;
}

-(void)Refresh
{
    [self removeAllChildrenWithCleanup:YES];
    CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"setting_background.png"];
    
    [self addChild:sp_back];
    
    CCButton* btnClose = [CCButton buttonWithTitle:nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_close.png"]];
    [btnClose setName:@"control1"];
    [btnClose setAnchorPoint:ccp(1, 1)];
    [btnClose setTarget:self selector:@selector(OnClose)];
    [btnClose setPosition:ccp(sp_back.contentSize.width / 2, sp_back.contentSize.height / 2)];
    [self addChild:btnClose];
    
    ToggleButton* toggleBtn = [[ToggleButton alloc] initWithFlag:[[NSUserDefaults standardUserDefaults] boolForKey:@"sound"]];
    if (IS_iPAD)
        [toggleBtn setPosition:ccp(110, 156)];
    else
        [toggleBtn setPosition:ccp(50, 60)];
    [self addChild:toggleBtn];
    
    NSString* str_lbl_fb;
    if ([m_fbMgr CheckConnectedFB])
        str_lbl_fb = @"lbl_disconnect.png";
    else
        str_lbl_fb = @"lbl_connect.png";
    
    CCSprite* lbl_look = [CCSprite spriteWithImageNamed:@"lbl_look.png"];
    [lbl_look setAnchorPoint:ccp(0, 0)];
    if (IS_iPAD)
        [lbl_look setPosition:ccp(-sp_back.contentSize.width / 2 + 95, 5)];
    else
        [lbl_look setPosition:ccp(-sp_back.contentSize.width / 2 + 40, sp_back.contentSize.height / 2 - 120)];
    [self addChild:lbl_look];
    CCSprite* look_frame = [CCSprite spriteWithImageNamed:@"yellow_rect.png"];
    [look_frame setAnchorPoint:ccp(0.5f, 1)];
    if (IS_iPAD)
        [look_frame setPosition:ccp(-153, 0)];
    else
        [look_frame setPosition:ccp(-62, 7)];
    [self addChild:look_frame];
    
    LookButton* content = [[LookButton alloc] initWithParent:self];
    if (IS_iPAD)
        [content setPosition:ccp(-153, -107)];
    else
        [content setPosition:ccp(-62, -38)];
    [content setName:@"control2"];
    [self addChild:content];
    
    CCSprite* lbl_fb = [CCSprite spriteWithImageNamed:str_lbl_fb];
    [lbl_fb setAnchorPoint:ccp(0, 0)];
    if (IS_iPAD)
        [lbl_fb setPosition:ccp(58, 5)];
    else
    {
        if ([m_fbMgr CheckConnectedFB])
            [lbl_fb setPosition:ccp(15, sp_back.contentSize.height / 2 - 120)];
        else
            [lbl_fb setPosition:ccp(22, sp_back.contentSize.height / 2 - 120)];
    }
    [self addChild:lbl_fb];
    CCSprite* fb_frame = [CCSprite spriteWithImageNamed:@"yellow_rect.png"];
    [fb_frame setAnchorPoint:ccp(0.5f, 1)];
    if (IS_iPAD)
        [fb_frame setPosition:ccp(153, 0)];
    else
        [fb_frame setPosition:ccp(62, 7)];
    [self addChild:fb_frame];
    
    CCButton* btn_fb = [CCButton buttonWithTitle:nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_fb.png"]];
    [btn_fb setTarget:self selector:@selector(OnFBConnect)];
    [btn_fb setAnchorPoint:ccp(0.5f, 1)];
    if (IS_iPAD)
        [btn_fb setPosition:ccp(153, -12)];
    else
        [btn_fb setPosition:ccp(62, 2)];
    [btn_fb setName:@"control3"];
    [self addChild:btn_fb];
}

-(void)Closed
{
    for(int i = 0; i < 4; i++)
    {
        CCNode* nd = [[self parent] getChildByName:[NSString stringWithFormat:@"button_%d", i] recursively:NO];
        [nd setUserInteractionEnabled:YES];
    }
    [self removeFromParentAndCleanup:YES];
}

-(void)OnClose
{
    [APP PlayEffect:@"btn_click.wav"];
    id callback = [CCActionCallFunc actionWithTarget:self selector:@selector(Closed)];
    [self runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:0.2f scale:1.2f],
                     [CCActionScaleTo actionWithDuration:0.2f scale:0],
                     callback,
                     nil]];
}

-(void)OnFBConnect
{
    [APP PlayEffect:@"btn_click.wav"];
    if ([m_fbMgr CheckConnectedFB])
    {
        [m_fbMgr CloseSession];
        [self Refresh];
    }
    else
        [m_fbMgr GetMyInfo];
}

-(void)OnLook
{
    for(int i = 1; i < 4; i++)
    {
        CCNode* nd = [self getChildByName:[NSString stringWithFormat:@"control%d", i] recursively:NO];
        [nd setUserInteractionEnabled:NO];
    }
    ScrollScreen* lookScreen = [[ScrollScreen alloc] init];
    if (IS_iPAD)
        [lookScreen setPosition:ccp(0, -80)];
    else
        [lookScreen setPosition:ccp(0, -60)];
    [self addChild:lookScreen];
}

-(void)CompletedMyInfo:(NSDictionary*)myInfo
{
    if (myInfo)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[myInfo objectForKey:@"id"] forKey:@"fb_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self Refresh];
        [APP UpdateStates];
    }
}
@end
