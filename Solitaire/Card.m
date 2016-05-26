//
//  Card.m
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "Card.h"


@implementation Card
-(id)initWithData:(int)number type:(int)typ
{
    if (self = [super init])
    {
        m_number = number;
        m_type = typ;
        CCSprite* sp_back = nil;
        if (m_number > 10)
        {
            sp_back = [CCSprite spriteWithImageNamed:[self GetBackgroundName]];
        }
        else
        {
            int deckType = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
            if (deckType < 3)
                sp_back = [CCSprite spriteWithImageNamed:@"card_front.png"];
            else
            {
                if (IS_iPAD)
                    sp_back = [CCSprite spriteWithImageNamed:@"deck_position_pink.png"];
                else
                    sp_back = [CCSprite spriteWithImageNamed:@"pink_card_front.png"];
            }
            CCLabelTTF* fnt_number;
            float fontSize = 0;
            if (IS_iPAD)
                fontSize = 58;
            else
                fontSize = 25;
            if (m_number > 1)
                fnt_number = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", m_number] fontName:@"BebasNeue" fontSize:fontSize];
            else
            {
                fnt_number = [CCLabelTTF labelWithString:@"A" fontName:@"BebasNeue" fontSize:fontSize];
                m_number = 14;
            }
            if (IS_iPAD)
                [fnt_number setPosition:ccp(-29, 24)];
            else
                [fnt_number setPosition:ccp(-11, 8)];
            [fnt_number setAnchorPoint:ccp(0.5f, 0)];
            if (m_type < 3)
                [fnt_number setColor:[CCColor colorWithRed:0 green:0 blue:0]];
            else
            {
                if (deckType < 3)
                    [fnt_number setColor:[CCColor colorWithRed:0.737f green:0.121f blue:0.1f]];
                else
                    [fnt_number setColor:[CCColor colorWithRed:0.9f green:0.9f blue:0.9f]];
            }
            [self addChild:fnt_number z:1];
            
            NSString* strFlowerName = [self GetFlowerName];
            CCSprite* sp_smallFlower = [CCSprite spriteWithImageNamed:strFlowerName];
            [sp_smallFlower setScale:0.45f];
            if (IS_iPAD)
                [sp_smallFlower setPosition:ccp(22, 37)];
            else
                [sp_smallFlower setPosition:ccp(9, 14)];
            [sp_smallFlower setAnchorPoint:ccp(0.5, 0)];
            [self addChild:sp_smallFlower z:1];
            
            CCSprite* sp_mainFlower = [CCSprite spriteWithImageNamed:strFlowerName];
            if (IS_iPAD)
                [sp_mainFlower setPosition:ccp(0, -85)];
            else
                [sp_mainFlower setPosition:ccp(0, -33)];
            [sp_mainFlower setAnchorPoint:ccp(0.5f, 0)];
            [self addChild:sp_mainFlower z:1];
        }

        [self setContentSize:sp_back.contentSize];
        [self addChild:sp_back z:0];
    }
    return self;
}

-(NSString*)GetBackgroundName
{
    int deckType = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
    NSString* chr[3];
    chr[0] = @"j";
    chr[1] = @"q";
    chr[2] = @"k";
    NSString* types[4];
    types[0] = @"spade";
    types[1] = @"cluba";
    types[2] = @"dia";
    types[3] = @"heart";
    if (deckType < 3)
    {
        return [NSString stringWithFormat:@"%@_%@.png", types[m_type - 1], chr[m_number - 11]];
    }
    else
    {
        return [NSString stringWithFormat:@"pink_%@_%@.png", types[m_type - 1], chr[m_number - 11]];
    }
}

-(NSString*)GetFlowerName
{
    int deckType = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
    if (m_type == SPADE_TYPE && m_number == 14)
        return @"spade_a.png";
    switch (m_type) {
        case SPADE_TYPE:
            return @"spade.png";
        case CLUBA_TYPE:
            return @"cluba.png";
        case DIA_TYPE:
        {
            if (deckType < 3)
                return @"dia.png";
            else
                return @"pink_dia.png";
        }
        case HEART_TYPE:
        {
            if (deckType < 3)
                return @"heart.png";
            else
                return @"pink_heart.png";
        }
    }
    return nil;
}
@end
