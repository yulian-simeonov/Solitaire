//
//  ScoreRecord.m
//  Solitaire
//
//  Created by richboy on 3/4/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "ScoreRecord.h"
#import "JSONManager.h"

@implementation ScoreRecord
-(id)initWithData:(NSString*)userName hightScore:(int)score userID:(NSString*)userId
{
    if (self = [super init])
    {
        [self setAnchorPoint:ccp(0, 0)];
        if (userName.length > 7)
            userName = [NSString stringWithFormat:@"%@.", [userName substringToIndex:7]];
        NSString* filePath = [NSString stringWithFormat:@"%@/%@.png", [JSONManager GetSavePath:@"fb_thumb"], userId];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:NO])
        {
            CCSprite* avatar = [CCSprite spriteWithImageNamed:filePath];
            if (IS_iPAD)
                [avatar setScale:1.8f];
            else
                [avatar setScale:0.84f];
            if (IS_iPAD)
                [avatar setPosition:ccp(12, 12)];
            else
                [avatar setPosition:ccp(6, 6)];
            [self addChild:avatar];
        }
        
        CCSprite* avatarFrame = [CCSprite spriteWithImageNamed:@"yellow_rect.png"];
        [avatarFrame setScale:0.5f];
        if (IS_iPAD)
            [avatarFrame setPosition:ccp(12, 12)];
        else
            [avatarFrame setPosition:ccp(6, 6)];
        [self addChild:avatarFrame];
        
        float fontSize = 0;
        if (IS_iPAD)
            fontSize = 60;
        else
            fontSize = 28;
        CCLabelTTF* namefnt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@", userName] fontName:@"Brush455 BT" fontSize:fontSize];
        [namefnt setColor:[CCColor colorWithRed:0.99f green:0.886f blue:0.47f]];
        [namefnt setAnchorPoint:ccp(0, 0.5f)];
        if (IS_iPAD)
            [namefnt setPosition:ccp(100, 12)];
        else
            [namefnt setPosition:ccp(40, 6)];
        [self addChild:namefnt];
        
        if (IS_iPAD)
            fontSize = 50;
        else
            fontSize = 20;
        
        CCLabelTTF* scorefnt = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", score] fontName:@"AlternateGothic2 BT" fontSize:fontSize];
        [scorefnt setColor:[CCColor colorWithRed:0.99f green:0.886f blue:0.47f]];
        [scorefnt setAnchorPoint:ccp(0, 0.5f)];
        if (IS_iPAD)
            [scorefnt setPosition:ccp(380, 12)];
        else
            [scorefnt setPosition:ccp(170, 6)];
        [self addChild:scorefnt];
    }
    return self;
}
@end
