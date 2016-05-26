//
//  LookButton.m
//  Solitaire
//
//  Created by richboy on 2/24/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "LookButton.h"
#import "OptionScreen.h"
#import "AppDelegate.h"

@implementation LookButton
-(id)initWithParent:(id)parent
{
    if (self = [super init])
    {
        m_parent = parent;
        [self setAnchorPoint:ccp(0.5f, 0.5f)];
        if (IS_iPAD)
            [self setContentSize:CGSizeMake(190, 190)];
        else
            [self setContentSize:CGSizeMake(79, 79)];
        [self setUserInteractionEnabled:YES];
        [self Refresh];        
    }
    return self;
}

-(void)Refresh
{
    [self removeAllChildrenWithCleanup:YES];
    int backType = [[NSUserDefaults standardUserDefaults] integerForKey:@"table"];
    CCSprite* sp_background = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"background_%d.png", backType + 1]];
    float XscaleRatio = self.contentSize.width / sp_background.contentSize.width;
    float YscaleRatio = self.contentSize.width / sp_background.contentSize.height;
    [sp_background setScaleX:XscaleRatio];
    [sp_background setScaleY:YscaleRatio];
    [sp_background setAnchorPoint:ccp(0, 0)];
    [self addChild:sp_background];
    
    int deckType = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
    CCSprite* sp_deck = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"deck_%d.png", deckType + 1]];
    float scaleRatio = self.contentSize.width / sp_deck.contentSize.height;
    [sp_deck setScale:scaleRatio];
    [sp_deck setAnchorPoint:ccp(0, 0)];
    [self addChild:sp_deck];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCNodeColor* overLay = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0 green:0 blue:0 alpha:0.3f]];
    [overLay setContentSize:self.contentSize];
    [overLay setName:@"overlay"];
    [self addChild:overLay];
}


-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pt = [touch locationInNode:self];
    if (!CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), pt))
    {
        CCNode* nd = [self getChildByName:@"overlay" recursively:NO];
        [nd removeFromParentAndCleanup:YES];
        [APP PlayEffect:@"btn_click.wav"];
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pt = [touch locationInNode:self];
    if (CGRectContainsPoint(CGRectMake(0, 0, self.contentSize.width, self.contentSize.height), pt))
    {
        [(OptionScreen*)m_parent OnLook];
    }
    CCNode* nd = [self getChildByName:@"overlay" recursively:NO];
    [nd removeFromParentAndCleanup:YES];
    [APP PlayEffect:@"btn_click.wav"];
}

-(void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCNode* nd = [self getChildByName:@"overlay" recursively:NO];
    [nd removeFromParentAndCleanup:YES];
    [APP PlayEffect:@"btn_click.wav"];
}

@end
