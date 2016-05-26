//
//  MenuScreen.m
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "MenuScreen.h"
#import "GamePlayScreen.h"
#import "OptionScreen.h"
#import "StatesScreen.h"
#import "AppDelegate.h"
#import "HelpScreen.h"

@implementation MenuScreen
+(CCScene*)scene
{
    CCScene* s = [CCScene node];
    [s addChild:[MenuScreen node]];
    return s;
}

-(id)init
{
    if (self = [super init])
    {
        [self setContentSizeType:CCSizeTypeNormalized];
        [self setContentSize:CGSizeMake(1, 1)];
        
        CCSprite* sp = [CCSprite spriteWithImageNamed:@"main_menu_background.png"];
        if (IS_iPAD)
            [sp setPosition:ccp(384, 512)];
        else
            [sp setPosition:ccp(160, 284)];
        [self addChild:sp];
        
        CCButton* btn_play = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_play.png"]];
        if (IS_iPAD)
            [btn_play setPosition:ccp(384, 440)];
        else
            [btn_play setPosition:ccp(160, 270)];
        [btn_play setName:@"button_0"];
        [btn_play setTarget:self selector:@selector(OnPlay)];
        [self addChild:btn_play];
        
        CCButton* btn_help = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_help.png"]];
        if (IS_iPAD)
            [btn_help setPosition:ccp(384, btn_play.position.y - 109)];
        else
            [btn_help setPosition:ccp(160, btn_play.position.y - 45)];
        [btn_help setName:@"button_1"];
        [btn_help setTarget:self selector:@selector(OnHelp)];
        [self addChild:btn_help];
        
        CCButton* btn_option = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_option.png"]];
        if (IS_iPAD)
            [btn_option setPosition:ccp(384, btn_help.position.y - 109)];
        else
            [btn_option setPosition:ccp(160, btn_help.position.y - 45)];
        [btn_option setName:@"button_2"];
        [btn_option setTarget:self selector:@selector(OnOption)];
        [self addChild:btn_option];
        
        CCButton* btn_states = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_states.png"]];
        if (IS_iPAD)
            [btn_states setPosition:ccp(384, btn_option.position.y - 109)];
        else
            [btn_states setPosition:ccp(160, btn_option.position.y - 45)];
        [btn_states setName:@"button_3"];
        [btn_states setTarget:self selector:@selector(OnStates)];
        [self addChild:btn_states];
        
        CCButton* btn_setting = [CCButton buttonWithTitle:nil spriteFrame:[CCSpriteFrame frameWithImageNamed:@"btn_setting.png"]];
        [btn_setting setTarget:self selector:@selector(OnShare)];
        if (IS_iPAD)
        {
            [btn_setting setPosition:ccp(723, 45)];
        }
        else
        {
            [btn_setting setPosition:ccp(295, 25)];
        }
        [self addChild:btn_setting];
        [APP SetBannerViewTopPosition];
    }
    return self;
}

-(void)OnShare
{
    [APP ShowActionsheet];
}

-(void)OnPlay
{
    [APP PlayEffect:@"btn_click.wav"];
    [[CCDirector sharedDirector] replaceScene:[GamePlayScreen scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.5f]];
}

-(void)OnHelp
{
    [APP PlayEffect:@"btn_click.wav"];
    [[CCDirector sharedDirector] replaceScene:[HelpScreen scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}

-(void)OnOption
{
    [APP PlayEffect:@"btn_click.wav"];
    for(int i = 0; i < 4; i++)
    {
        CCNode* nd = [self getChildByName:[NSString stringWithFormat:@"button_%d", i] recursively:NO];
        [nd setUserInteractionEnabled:NO];
    }
    OptionScreen* optScreen = [[OptionScreen alloc] init];
    if (IS_iPAD)
        [optScreen setPosition:ccp(384, 512)];
    else
        [optScreen setPosition:ccp(160, 284)];
    [self addChild:optScreen];
}

-(void)OnStates
{
    [APP PlayEffect:@"btn_click.wav"];
    for(int i = 0; i < 4; i++)
    {
        CCNode* nd = [self getChildByName:[NSString stringWithFormat:@"button_%d", i] recursively:NO];
        [nd setUserInteractionEnabled:NO];
    }
    [APP AddQAView:self];
    return;
    StatesScreen* optScreen = [[StatesScreen alloc] init];
    if (IS_iPAD)
        [optScreen setPosition:ccp(384, 512)];
    else
        [optScreen setPosition:ccp(160, 284)];
    [self addChild:optScreen];
}

-(void)EnableTouch
{
    [APP PlayEffect:@"btn_click.wav"];
    for(int i = 0; i < 4; i++)
    {
        CCNode* nd = [self getChildByName:[NSString stringWithFormat:@"button_%d", i] recursively:NO];
        [nd setUserInteractionEnabled:YES];
    }
}

@end
