//
//  HelpScreen.m
//  Solitaire
//
//  Created by richboy on 3/11/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "HelpScreen.h"
#import "MenuScreen.h"
#import "AppDelegate.h"

@implementation HelpScreen
+(CCScene*)scene
{
    CCScene* s = [CCScene node];
    [s addChild:[HelpScreen node]];
    return s;
}

-(id)init
{
    if (self = [super init])
    {
        [self setContentSizeType:CCSizeTypeNormalized];
        [self setContentSize:CGSizeMake(1, 1)];
        
        CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"help_screen.png"];
        [sp_back setAnchorPoint:ccp(0, 1)];
        float screenHeight = 0;
        if (IS_iPAD)
            screenHeight = 1024;
        else
        {
            if (IS_IPHONE_5)
                screenHeight = 568;
            else
                screenHeight = 480;
        }
        [sp_back setPosition:ccp(0, screenHeight)];
        [self addChild:sp_back];
        
        CCButton* btnClose = [CCButton buttonWithTitle:nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_close.png"]];
        [btnClose setAnchorPoint:ccp(1, 1)];
        [btnClose setTarget:self selector:@selector(OnClose)];
        [btnClose setPosition:ccp(sp_back.contentSize.width, screenHeight)];
        [self addChild:btnClose];
        
        CCNode* board = [CCNode node];
        if (IS_iPAD)
        {
            [board setContentSize:CGSizeMake(633, 4075)];
            CCSprite* sp_text1 = [CCSprite spriteWithImageNamed:@"instruction_1.png"];
            [sp_text1 setAnchorPoint:ccp(0, 1)];
            [sp_text1 setPosition:ccp(0, 4075)];
            [board addChild:sp_text1];
            
            CCSprite* sp_text2 = [CCSprite spriteWithImageNamed:@"instruction_2.png"];
            [sp_text2 setAnchorPoint:ccp(0, 0)];
            [sp_text2 setPosition:ccp(0, 300)];
            [board addChild:sp_text2];
        }
        else
        {
            [board setContentSize:CGSizeMake(320, 1700)];
            CCSprite* sp_text1 = [CCSprite spriteWithImageNamed:@"instruction_1.png"];
            [sp_text1 setAnchorPoint:ccp(0, 1)];
            [sp_text1 setPosition:ccp(0, 1700)];
            [board addChild:sp_text1];
            
            CCSprite* sp_text2 = [CCSprite spriteWithImageNamed:@"instruction_2.png"];
            [sp_text2 setAnchorPoint:ccp(0, 0)];
            [sp_text2 setPosition:ccp(0, 100)];
            [board addChild:sp_text2];
            
        }
        [board setAnchorPoint:ccp(0, 0)];
        [board setName:@"board"];
        
        CCScrollView* scrollView = [[CCScrollView alloc] initWithContentNode:board];
        [scrollView setHorizontalScrollEnabled:NO];
        [scrollView setName:@"scrollview"];
        [scrollView setAnchorPoint:ccp(0, 1)];
        
        if (IS_iPAD)
        {
            [scrollView setPosition:ccp(68, 824)];
        }
        else
        {
            if (IS_IPHONE_5)
                [scrollView setPosition:ccp(0, 490)];
            else
                [scrollView setPosition:ccp(0, 402)];
        }
        [self addChild:scrollView];
        
        CCSprite* sp_header = [CCSprite spriteWithImageNamed:@"help_screen_header.png"];

        [sp_header setPosition:ccp(0, screenHeight)];
        [sp_header setAnchorPoint:ccp(0, 1)];
        [self addChild:sp_header];
        
        CCSprite* sp_footer = [CCSprite spriteWithImageNamed:@"help_screen_footer.png"];
        [sp_footer setPosition:ccp(0, 0)];
        [sp_footer setAnchorPoint:ccp(0, 0)];
        [self addChild:sp_footer];
        
        [APP SetBannerViewBottomPosition];
    }
    return self;
}

-(void)OnClose
{
    [[CCDirector sharedDirector] replaceScene:[MenuScreen scene] withTransition:[CCTransition transitionFadeWithDuration:0.5f]];
}
@end
