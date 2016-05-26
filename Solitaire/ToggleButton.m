//
//  ToggleButton.m
//  Solitaire
//
//  Created by richboy on 2/25/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "ToggleButton.h"
#import "AppDelegate.h"

@implementation ToggleButton
-(id)initWithFlag:(BOOL)on
{
    if (self = [super init])
    {
        m_status = on;
        CCSprite* sp_back = [CCSprite spriteWithImageNamed:@"toggle_back.png"];
        [sp_back setAnchorPoint:ccp(0, 0)];
        [self addChild:sp_back];
        [self setContentSize:sp_back.contentSize];
        [self setUserInteractionEnabled:YES];
        
        sp_toggle = [CCSprite spriteWithImageNamed:@"toggle.png"];
        [self addChild:sp_toggle];
        if (m_status)
            [self SetOn];
        else
            [self SetOff];
    }
    return self;
}

-(void)SetOn
{
    if (sp_label)
        [sp_label removeFromParentAndCleanup:YES];
    sp_label = [CCSprite spriteWithImageNamed:@"lbl_on.png"];
    [sp_label setAnchorPoint:ccp(0, 0.5f)];
    [sp_label setPosition:ccp(15, self.contentSize.height / 2 - 2)];
    [self addChild:sp_label];
    
    [sp_toggle setAnchorPoint:ccp(1, 0.5f)];
    [sp_toggle setPosition:ccp(self.contentSize.width, self.contentSize.height / 2)];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[OALSimpleAudio sharedInstance] setEffectsMuted:NO];
}

-(void)SetOff
{
    if (sp_label)
        [sp_label removeFromParentAndCleanup:YES];
    sp_label = [CCSprite spriteWithImageNamed:@"lbl_off.png"];
    [sp_label setAnchorPoint:ccp(1, 0.5f)];
    [sp_label setPosition:ccp(self.contentSize.width - 15, self.contentSize.height / 2 - 2)];
    [self addChild:sp_label];
    
    [sp_toggle setAnchorPoint:ccp(0, 0.5f)];
    [sp_toggle setPosition:ccp(0, self.contentSize.height / 2)];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"sound"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[OALSimpleAudio sharedInstance] setEffectsMuted:YES];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [APP PlayEffect:@"btn_click.wav"];
    m_status = !m_status;
    if (m_status)
        [self SetOn];
    else
        [self SetOff];
}
@end
