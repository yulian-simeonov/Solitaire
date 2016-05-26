//
//  ScrollScreen.m
//  Solitaire
//
//  Created by richboy on 2/24/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "ScrollScreen.h"
#import "cocos2d-ui.h"
#import "OptionScreen.h"
#import "AppDelegate.h"

@implementation ScrollScreen
-(id)init
{
    if (self = [super init])
    {
        CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"storage_background.png"];
        [self addChild:sp_back];
        [self setContentSize:sp_back.contentSize];

        for(int i = 0; i < 4; i++)
        {
            CCButton* btn = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"deck_%d.png", i + 1]]];
            if (IS_iPAD)
                [btn setPosition:ccp(57 + i * (btn.contentSize.width + 30) - sp_back.contentSize.width / 2, 18)];
            else
                [btn setPosition:ccp(28 + i * (btn.contentSize.width + 10) - sp_back.contentSize.width / 2, 8)];
            [btn setTarget:self selector:@selector(OnDeck:)];
            [btn setName:[NSString stringWithFormat:@"%d", i]];
            [btn setAnchorPoint:ccp(0, 0)];
            [self addChild:btn];
        }

        for(int i = 0; i < 4; i++)
        {
            CCButton* btn = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"background_%d.png", i + 1]]];
            if (IS_iPAD)
            {
                [btn setScaleX:0.19f];
                [btn setScaleY:0.19f];
                [btn setPosition:ccp(40 + i * (btn.boundingBox.size.width + 30) - sp_back.contentSize.width / 2, -16)];
            }
            else
            {
                [btn setScaleX:0.2f];
                [btn setScaleY:0.14f];
                [btn setPosition:ccp(14 + i * (btn.boundingBox.size.width + 10) - sp_back.contentSize.width / 2, -8)];
            }
            [btn setTarget:self selector:@selector(OnTable:)];
            [btn setName:[NSString stringWithFormat:@"%d", i]];
            [btn setAnchorPoint:ccp(0, 1)];
            [self addChild:btn];
        }
        
        int deckIdx = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
        CCSprite* sp_activeCardFrame = [CCSprite spriteWithImageNamed:@"card_position.png"];
        if (IS_iPAD)
            [sp_activeCardFrame setPosition:ccp(50 + deckIdx * 167 - sp_back.contentSize.width / 2, 8)];
        else
            [sp_activeCardFrame setPosition:ccp(25 + deckIdx * 67 - sp_back.contentSize.width / 2, 4)];
        [sp_activeCardFrame setScale:1.1f];
        [sp_activeCardFrame setName:@"deck_frame"];
        [sp_activeCardFrame setAnchorPoint:ccp(0, 0)];
        [self addChild:sp_activeCardFrame];

        int tableIdx = [[NSUserDefaults standardUserDefaults] integerForKey:@"table"];
        CCSprite* sp_tableFrame = [CCSprite spriteWithImageNamed:@"card_position.png"];
        if (IS_iPAD)
        {
            [sp_tableFrame setPosition:ccp(38 + tableIdx * 176 - sp_back.contentSize.width / 2, -8)];
            [sp_tableFrame setScaleX:1.1f];
            [sp_tableFrame setScaleY:1.1f];
        }
        else
        {
            [sp_tableFrame setPosition:ccp(9 + tableIdx * 74 - sp_back.contentSize.width / 2, -4)];
            [sp_tableFrame setScaleX:74.0f / sp_tableFrame.contentSize.width];
            [sp_tableFrame setScaleY:1.1f];
        }
        [sp_tableFrame setName:@"table_frame"];
        [sp_tableFrame setAnchorPoint:ccp(0, 1)];
        [self addChild:sp_tableFrame];
        
        CCButton* btnClose = [CCButton buttonWithTitle:nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_close.png"]];
        [btnClose setAnchorPoint:ccp(1, 1)];
        [btnClose setTarget:self selector:@selector(OnClose)];
        [btnClose setPosition:ccp(sp_back.contentSize.width / 2, sp_back.contentSize.height / 2)];
        [self addChild:btnClose];
        
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

-(void)Closed
{
    for(int i = 1; i < 4; i++)
    {
        CCNode* nd = [[self parent] getChildByName:[NSString stringWithFormat:@"control%d", i] recursively:NO];
        [nd setUserInteractionEnabled:YES];
    }
    [(OptionScreen*)[self parent] Refresh];
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

-(void)OnDeck:(CCButton*)sender
{
    [APP PlayEffect:@"btn_click.wav"];
    int idx = [sender.name intValue];
    CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"storage_background.png"];
    CCNode* deckFrame = [self getChildByName:@"deck_frame" recursively:NO];
    if (IS_iPAD)
        [deckFrame setPosition:ccp(50 + idx * 167 - sp_back.contentSize.width / 2, 8)];
    else
        [deckFrame setPosition:ccp(25 + idx * 67 - sp_back.contentSize.width / 2, 4)];
    [[NSUserDefaults standardUserDefaults] setInteger:idx forKey:@"deck"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)OnTable:(CCButton*)sender
{
    [APP PlayEffect:@"btn_click.wav"];
    int idx = [sender.name intValue];
    CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"storage_background.png"];
    CCNode* sp_tableFrame = [self getChildByName:@"table_frame" recursively:NO];
    if (IS_iPAD)
        [sp_tableFrame setPosition:ccp(38 + idx * 176 - sp_back.contentSize.width / 2, -8)];
    else
        [sp_tableFrame setPosition:ccp(9 + idx * 74 - sp_back.contentSize.width / 2, -4)];
    [[NSUserDefaults standardUserDefaults] setInteger:idx forKey:@"table"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
