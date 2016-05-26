//
//  GamePlayScreen.m
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import "GamePlayScreen.h"
#import "MenuScreen.h"
#import "CCAnimation.h"
#import "AppDelegate.h"

#define Card_Hight_Interval 27

@implementation GamePlayScreen
+(CCScene*)scene
{
    CCScene* scene = [CCScene node];
    [scene addChild:[GamePlayScreen node]];
    return scene;
}

-(id)init
{
    if (self = [super init])
    {
        screenHeight = 480;
        if (IS_IPHONE_5)
            screenHeight = 568;
        m_dbMgr = [[DBManager alloc] init];
        m_webMgr = [[JSWebManager alloc] initWithAsyncOption:YES];

        [self setContentSizeType:CCSizeTypeNormalized];
        [self setContentSize:CGSizeMake(1, 1)];
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:NO];
        
        int tableType = [[NSUserDefaults standardUserDefaults] integerForKey:@"table"];
        CCSprite* sp_back = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"background_%d.png", tableType + 1]];
        [sp_back setAnchorPoint:ccp(0, 0)];
        [self addChild:sp_back];
        
        CCButton* btn_back = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_back.png"]];
        [btn_back setAnchorPoint:ccp(0, 1)];
        if (IS_iPAD)
            [btn_back setPosition:ccp(0, 1000)];
        else
            [btn_back setPosition:ccp(0, screenHeight - 10)];
        [btn_back setTarget:self selector:@selector(OnBack)];
        [self addChild:btn_back];
        
        CCButton* btn_hint = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_hint.png"]];
        [btn_hint setAnchorPoint:ccp(1, 1)];
        if (IS_iPAD)
            [btn_hint setPosition:ccp(612, 1000)];
        else
            [btn_hint setPosition:ccp(255, screenHeight - 10)];
        [btn_hint setTarget:self selector:@selector(OnHint)];
        [self addChild:btn_hint];
        
        CCButton* btn_new = [CCButton buttonWithTitle:Nil spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"btn_new.png"]];
        [btn_new setAnchorPoint:ccp(1, 1)];
        if (IS_iPAD)
            [btn_new setPosition:ccp(768, 1000)];
        else
            [btn_new setPosition:ccp(320, screenHeight - 10)];
        [btn_new setTarget:self selector:@selector(NewDeal)];
        [self addChild:btn_new];
        
        m_score = 0;
        m_moveoutIdx = 0;
        float fontSize;
        if (IS_iPAD)
            fontSize = 30;
        else
            fontSize = 15;
        lbl_highScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"High Score : %d", [m_dbMgr GetScoreByUserId:@"0"]] fontName:@"Helvetica Neue LT Std" fontSize:fontSize];
        [lbl_highScore setColor:[CCColor colorWithRed:0.84f green:0.93f blue:0.9f]];
        [lbl_highScore setAnchorPoint:ccp(0, 1)];
        if (IS_iPAD)
            [lbl_highScore setPosition:ccp(68, 900)];
        else
            [lbl_highScore setPosition:ccp(29, screenHeight - 54)];
        [self addChild:lbl_highScore];
        
        lbl_score = [CCLabelTTF labelWithString:@"Score : 0" fontName:@"Helvetica Neue LT Std" fontSize:fontSize];
        [lbl_score setColor:[CCColor colorWithRed:0.84f green:0.93f blue:0.9f]];
        [lbl_score setAnchorPoint:ccp(0, 1)];
        if (IS_iPAD)
            [lbl_score setPosition:ccp(68, 850)];
        else
            [lbl_score setPosition:ccp(29, screenHeight - 73)];
        [self addChild:lbl_score];
        
        if (IS_iPAD)
            fontSize = 60;
        else
            fontSize = 30;
        lbl_hintCount = [CCLabelTTF labelWithString:@"2x" fontName:@"bubble sharp" fontSize:fontSize];
        [lbl_hintCount setColor:[CCColor colorWithCcColor3b:ccc3(240,230,140)]];
        [lbl_hintCount setAnchorPoint:ccp(0, 1)];
        if (IS_iPAD)
            [lbl_hintCount setPosition:ccp(360, 1000)];
        else
            [lbl_hintCount setPosition:ccp(145, screenHeight - 5)];
        [self addChild:lbl_hintCount];
        
        CCSprite* sp_deckPosition = [CCSprite spriteWithImageNamed:@"card_position.png"];
        [sp_deckPosition setAnchorPoint:ccp(1, 1)];
        if (IS_iPAD)
            [sp_deckPosition setPosition:ccp(700, 912)];
        else
            [sp_deckPosition setPosition:ccp(297, screenHeight - 55)];
        [self addChild:sp_deckPosition];
        
        int deckType = [[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
        for (int i = 0; i < 5; i++)
        {
            CCSprite* sp_deck = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"deck_%d.png", deckType + 1]];
            if (IS_iPAD)
                [sp_deck setPosition:ccp(700 - i * 2, 912 + i * 2)];
            else
                [sp_deck setPosition:ccp(297 - i * 0.5f, (screenHeight - 55) + i * 0.5f)];
            [sp_deck setAnchorPoint:ccp(1, 1)];
            [self addChild:sp_deck];
            [sp_deck setName:[NSString stringWithFormat:@"deck_%d", i + 1]];
        }
        
        for(int i = 0; i < 4; i++)
        {
            m_cardsInBoard[i] = [[NSMutableArray alloc] init];
            CCSprite* sp_cardPosition = [CCSprite spriteWithImageNamed:@"card_position.png"];
            if (IS_iPAD)
                [sp_cardPosition setPosition:ccp(136 + i * 162, 615.0f)];
            else
                [sp_cardPosition setPosition:ccp(58 + i * 70, screenHeight - 185)];
            [self addChild:sp_cardPosition];
            m_increaseAmountForEachSlot[i] = 0;
        }
        
        m_cardsInDeck = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < 52; i++)
            [m_cardsInDeck addObject:[NSNumber numberWithInt:i]];
        m_tmp = 2;
        m_hintCount = 2;
        m_gameOver = false;
        m_spreading = true;
        [self scheduleOnce:@selector(StartSpread) delay:1.0f];
        
        [APP SetBannerViewBottomPosition];
    }
    return self;
}

-(void)OnBack
{
    [APP PlayEffect:@"btn_click.wav"];
    [[CCDirector sharedDirector] replaceScene:[MenuScreen scene] withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.5f]];
}

-(void)NewDeal
{
    if (m_lastAnimating)
        return;
    m_tmp = 2;
    m_hintCount = 2;
    m_gameOver = false;
    m_spreading = true;
    [APP PlayEffect:@"btn_click.wav"];
    m_score = 0;
    m_moveoutIdx = 0;
    [lbl_score setString:[NSString stringWithFormat:@"Score : %d", m_score]];
    [lbl_highScore setString:[NSString stringWithFormat:@"High Score : %d", [m_dbMgr GetScoreByUserId:@"0"]]];
    
    CCNode* congView = [self getChildByName:@"cong_banner" recursively:NO];
    if (congView)
        [congView removeFromParent];
    
    [m_cardsInDeck removeAllObjects];
    for(int i = 0; i < 52; i++)
        [m_cardsInDeck addObject:[NSNumber numberWithInt:i]];
    
    for(int i = 0; i < 4; i++)
    {
        [m_cardsInBoard[i] removeAllObjects];
    }
    
    for(int i = 0; i < 13; i++)
    {
        for(int j = 0; j < 4; j++)
        {
            Card* cd = (Card*)[self getChildByName:[NSString stringWithFormat:@"card_%d_%d", i + 1, j + 1] recursively:NO];
            if (cd)
                [cd removeFromParentAndCleanup:YES];
        }
    }
    
    int deckType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"deck"];
    for (int i = 0; i < 5; i++)
    {
        CCNode* node = [self getChildByName:[NSString stringWithFormat:@"deck_%d", i + 1] recursively:NO];
        if (node)
            [node removeFromParentAndCleanup:YES];
        CCSprite* sp_deck = [CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"deck_%d.png", deckType + 1]];
        if (IS_iPAD)
            [sp_deck setPosition:ccp(700 - i * 2, 912 + i * 2)];
        else
            [sp_deck setPosition:ccp(297 - i * 0.5f, ((screenHeight - 55)) + i * 0.5f)];
        [sp_deck setAnchorPoint:ccp(1, 1)];
        [self addChild:sp_deck];
        [sp_deck setName:[NSString stringWithFormat:@"deck_%d", i + 1]];
    }
    
    [self scheduleOnce:@selector(StartSpread) delay:1.0f];
    [APP ShowAd];
}

-(void)OnHint
{
    if (m_hintCount < 1)
        return;
    
    [APP PlayEffect:@"btn_click.wav"];
    for(int i = 0; i < 4; i++)
    {
        Card* card = [m_cardsInBoard[i] lastObject];
        if (card)
        {
            if (m_cardsInBoard[i].count > 1)
            {
                Card* beforeCard = [m_cardsInBoard[i] objectAtIndex:m_cardsInBoard[i].count - 2];
                if (card->m_number < beforeCard->m_number && card->m_type == beforeCard->m_type)
                {
                    float interval = 0.08f;
                    [card runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:interval scale:1.2f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.17f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.15f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.13f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.1f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.09f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.06f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.03f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.01f],
                                     [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                     nil]];
                    if (!m_usedHint)
                    {
                        m_hintCount--;
                        [lbl_hintCount setString:[NSString stringWithFormat:@"%dx", m_hintCount]];
                        m_usedHint = true;
                    }
                    return;
                }
            }
            
            for(int j = 0; j < 4; j++)
            {
                Card* otherCard = [m_cardsInBoard[j] lastObject];
                if (otherCard)
                {
                    if (i != j && card->m_number < otherCard->m_number && card->m_type == otherCard->m_type)
                    {
                        float interval = 0.08f;
                        [card runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:interval scale:1.2f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.17f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.15f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.13f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.1f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.09f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.06f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.03f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.01f],
                                         [CCActionScaleTo actionWithDuration:interval scale:1.0f],
                                             nil]];
                        if (!m_usedHint)
                        {
                            m_hintCount--;
                            [lbl_hintCount setString:[NSString stringWithFormat:@"%dx", m_hintCount]];
                            m_usedHint = true;
                        }
                        return;
                    }
                }
            }
        }
    }
}

-(BOOL)CheckMovemont
{
    for(int i = 0; i < 4; i++)
    {
        Card* card = [m_cardsInBoard[i] lastObject];
        if (card)
        {
            if (m_cardsInBoard[i].count > 1)
            {
                Card* beforeCard = [m_cardsInBoard[i] objectAtIndex:m_cardsInBoard[i].count - 2];
                if (card->m_number < beforeCard->m_number && card->m_type == beforeCard->m_type)
                {
                    return true;
                }
            }
            
            for(int j = 0; j < 4; j++)
            {
                Card* otherCard = [m_cardsInBoard[j] lastObject];
                if (otherCard)
                {
                    if (i != j && card->m_number < otherCard->m_number && card->m_type == otherCard->m_type)
                    {
                        return true;
                    }
                }
            }
        }
    }
    
    for(int i = 0; i < 4; i++)
    {
        if (m_cardsInBoard[i].count == 0)
            return true;
    }
    return false;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (m_spreading)
        return;
    CGPoint pt = [touch locationInNode:self];
    
    /////////////Deck/////////////////
    int pile = m_cardsInDeck.count / 10;
    if (pile == 0)
        pile = 1;
    CCNode* deck = [self getChildByName:[NSString stringWithFormat:@"deck_%d", pile] recursively:NO];
    CGRect deckRect = CGRectMake(deck.position.x - deck.contentSize.width, deck.position.y - deck.contentSize.height, deck.contentSize.width, deck.contentSize.height);
    if (CGRectContainsPoint(deckRect, pt))
    {
        m_capturedDeck = true;
    }
    ///////////////////////////////////
    
    for(int i = 0; i < 4; i++)
    {
        Card* card = [m_cardsInBoard[i] lastObject];
        if (card)
        {
            CGRect cardRect = CGRectMake(card.position.x - card.contentSize.width / 2, card.position.y - card.contentSize.height / 2, card.contentSize.width, card.contentSize.height);
            if (CGRectContainsPoint(cardRect, pt))
            {
                if (m_cardsInBoard[i].count > 1)
                {
                    Card* beforeCard = [m_cardsInBoard[i] objectAtIndex:m_cardsInBoard[i].count - 2];
                    if (card->m_number < beforeCard->m_number && card->m_type == beforeCard->m_type)
                    {
                        [m_cardsInBoard[i] removeObject:card];
                        if (m_cardsInBoard[i].count == 0)
                        {
                            m_emptySlotIdx = i;
                            m_increaseAmountForEmptySlot = 100;
                        }
                        [self CalculateScore];
                        id callback = [CCActionCallFunc actionWithTarget:self selector:@selector(OnRemovedCard)];
                        [card runAction:[CCActionMoveTo actionWithDuration:0.5f position:ccp(card.position.x, -card.contentSize.height)]];
                        [card runAction:[CCActionSequence actions:[CCActionRotateBy actionWithDuration:0.5f angle:1000],
                                         callback,
                                         [CCActionCallFunc actionWithTarget:card selector:@selector(removeFromParent)],
                                         nil ]];
                        [APP PlayEffect:@"card_out.wav"];
                        return;
                    }
                }
                for(int j = 0; j < 4; j++)
                {
                    Card* otherCard = [m_cardsInBoard[j] lastObject];
                    if (otherCard)
                    {
                        if (i != j && card->m_number < otherCard->m_number && card->m_type == otherCard->m_type)
                        {                            
                            [m_cardsInBoard[i] removeObject:card];
                            if (m_cardsInBoard[i].count == 0)
                            {
                                m_emptySlotIdx = i;
                                m_increaseAmountForEmptySlot = 100;
                            }
                            [self CalculateScore];
                            id callback = [CCActionCallFunc actionWithTarget:self selector:@selector(OnRemovedCard)];
                            [card runAction:[CCActionMoveTo actionWithDuration:0.5f position:ccp(card.position.x, -card.contentSize.height)]];
                            [card runAction:[CCActionSequence actions:[CCActionRotateBy actionWithDuration:0.5f angle:1000], callback, nil ]];
                            [APP PlayEffect:@"card_out.wav"];
                            return;
                        }
                    }
                }
                [card setZOrder:100];
                card->m_captured = true;
                break;
            }
        }
    }
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint pt = [touch locationInNode:self];
    for(int i = 0; i < 4; i++)
    {
        Card* card = [m_cardsInBoard[i] lastObject];
        if (card)
        {
            if (card->m_captured)
            {
                [card setPosition:pt];
            }
        }
    }
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (m_spreading)
        return;
    CGPoint pt = [touch locationInNode:self];
    
    /////////////Deck/////////////////
    int pile = m_cardsInDeck.count / 10;
    if (pile == 0)
        pile = 1;
    CCNode* deck = [self getChildByName:[NSString stringWithFormat:@"deck_%d", pile] recursively:NO];
    CGRect deckRect = CGRectMake(deck.position.x - deck.contentSize.width, deck.position.y - deck.contentSize.height, deck.contentSize.width, deck.contentSize.height);
    if (CGRectContainsPoint(deckRect, pt) && m_capturedDeck)
    {
        [self StartSpread];
        m_capturedDeck = false;
    }
    ///////////////////////////////////
    
    for(int i = 0; i < 4; i++)
    {
        Card* card = [m_cardsInBoard[i] lastObject];
        if (card)
        {
            CGRect cardRect = CGRectMake(card.position.x - card.contentSize.width / 2, card.position.y - card.contentSize.height / 2, card.contentSize.width, card.contentSize.height);
            if (card->m_captured && CGRectContainsPoint(cardRect, pt))
            {
                card->m_captured = false;
                
                for(int j = 0; j < 4; j++)
                {
                    Card* otherCard = [m_cardsInBoard[j] lastObject];
                    if (!otherCard)
                    {
                        CGRect rt;
                        if (IS_iPAD)
                            rt = CGRectMake(68 + j * 162, 547, card.contentSize.width, card.contentSize.height);
                        else
                            rt = CGRectMake(29 + j * 70, (screenHeight - 225), card.contentSize.width, card.contentSize.height);
                        if (CGRectContainsPoint(rt, pt))
                        {
                            if (IS_iPAD)
                                [card setPosition:ccp(136 + j * 162, 615)];
                            else
                                [card setPosition:ccp(58 + j * 70, (screenHeight - 185))];
                            [m_cardsInBoard[j] addObject:card];
                            [m_cardsInBoard[i] removeObject:card];
                            [card setZOrder:0];
                            [self CheckGameOver];
                            [APP PlayEffect:@"put_empty_slot.wav"];
                            return;
                        }
                    }
                }
                [card setZOrder:m_cardsInBoard[i].count];
                if (IS_iPAD)
                    [card runAction:[CCActionMoveTo actionWithDuration:0.1f position:ccp(136 + i * 162, 615 - (m_cardsInBoard[i].count - 1) * 58)]];
                else
                    [card runAction:[CCActionMoveTo actionWithDuration:0.1f position:ccp(58 + i * 70, (screenHeight - 185) - (m_cardsInBoard[i].count - 1) * Card_Hight_Interval)]];
            }
        }
    }
}

-(void)DoneSpread
{
    m_spreading = false;
    int pile = m_cardsInDeck.count / 10;
    CCNode* deck = nil;
    if (pile > 0)
    {
        deck = [self getChildByName:[NSString stringWithFormat:@"deck_%d", pile + 1] recursively:NO];
    }
    else if (m_cardsInDeck.count == 0)
        deck = [self getChildByName:@"deck_1" recursively:NO];
    if (deck)
        [deck removeFromParentAndCleanup:YES];
    [self CheckGameOver];
}

-(void)StartSpread
{
    m_tmp--;
    m_spreadIdx = 0;
    m_moveoutIdx = 0;
    m_spreading = true;
    [APP PlayEffect:@"spread_card.wav"];
    [self SpreadCards];
}

-(void)SpreadCards
{
    int pile = m_cardsInDeck.count / 10;
    if (pile == 0)
        pile = 1;
    CCNode* deck = [self getChildByName:[NSString stringWithFormat:@"deck_%d", pile] recursively:NO];
    if(m_cardsInDeck.count == 0)
        return;
    int idx = arc4random() % m_cardsInDeck.count;
    int totalNumber = [[m_cardsInDeck objectAtIndex:idx] integerValue];
    int number = totalNumber % 13 + 1;
    int type = totalNumber / 13 + 1;
    Card* cd = [[Card alloc] initWithData:number type:type];
    [cd setName:[NSString stringWithFormat:@"card_%d_%d", number, type]];
    [cd setPosition:ccp(deck.position.x - deck.contentSize.width / 2, deck.position.y - deck.contentSize.height / 2)];
    [self addChild:cd];
    id callback;
    if(m_spreadIdx == 3)
    {
        callback = [CCActionCallFunc actionWithTarget:self selector:@selector(DoneSpread)];
    }
    else
    {
        callback = [CCActionCallFunc actionWithTarget:self selector:@selector(SpreadCards)];
    }
    [cd setZOrder:m_cardsInBoard[m_spreadIdx].count];
    if (IS_iPAD)
        [cd runAction:[CCActionSequence actions:[CCActionMoveTo actionWithDuration:0.1f position:ccp(136 + m_spreadIdx * 162, 615.0f - m_cardsInBoard[m_spreadIdx].count * 56.0f)], callback, nil]];
    else
        [cd runAction:[CCActionSequence actions:[CCActionMoveTo actionWithDuration:0.1f position:ccp(58 + m_spreadIdx * 70, (screenHeight - 185) - m_cardsInBoard[m_spreadIdx].count * Card_Hight_Interval)], callback, nil]];
    [m_cardsInBoard[m_spreadIdx] addObject:cd];
    [m_cardsInDeck removeObjectAtIndex:idx];
    m_spreadIdx++;
}

-(void)OnRemovedCard
{
    [self CheckGameOver];
}

-(void)CalculateScore
{
    m_countingScore = m_score;
    m_moveoutIdx++;
    if (m_moveoutIdx < 7)
    {
        switch (m_moveoutIdx) {
            case 1:
                m_animationLevel = 1;
                m_increaseAmountForOutCard = 10;
                break;
            case 2:
                m_animationLevel = 1;
                m_increaseAmountForOutCard = 20;
                break;
            case 3:
                m_animationLevel = 1;
                m_increaseAmountForOutCard = 40;
                break;
            case 4:
                m_animationLevel = 2;
                m_increaseAmountForOutCard = 80;
                break;
            case 5:
                m_animationLevel = 3;
                m_increaseAmountForOutCard = 150;
                break;
            case 6:
                m_animationLevel = 3;
                m_increaseAmountForOutCard = 300;
                break;
            case 7:
                m_animationLevel = 4;
                m_increaseAmountForOutCard = 600;
                break;
            default:
                break;
        }
    }
    else
    {
        m_animationLevel = 5;
        m_increaseAmountForOutCard = 1000;
    }

    m_score += m_increaseAmountForOutCard;
    m_score += m_increaseAmountForEmptySlot;
    if ([m_dbMgr GetScoreByUserId:@"0"] < m_score)
    {
        [m_dbMgr UpdateScore:@"0" score:m_score];
        [lbl_highScore setString:[NSString stringWithFormat:@"High Score : %d", [m_dbMgr GetScoreByUserId:@"0"]]];
    }
    
    m_countInterval = (m_score - m_countingScore) / 15;
    if (m_score > m_countingScore && m_countInterval < 1)
        m_countInterval = 1;
    [self unscheduleAllSelectors];
    [self schedule:@selector(CountingScoreAnimationForCardOut) interval:1/30.0f];
}

-(void)CountingScoreAnimationForCardOut
{
    m_countingScore += m_countInterval;
    if (m_countingScore >= m_score)
    {
        m_countingScore = m_score;
        [self unscheduleAllSelectors];
        float animationScale = 0;
        float fontScale = 0;
        if (m_increaseAmountForOutCard > 0)
        {
            switch (m_animationLevel) {
                case 1:
                    animationScale = 1.3f;
                    fontScale = 30;
                    break;
                case 2:
                    fontScale = 40;
                    animationScale = 1.5f;
                    break;
                case 3:
                    fontScale = 50;
                    animationScale = 1.8f;
                    break;
                case 4:
                    fontScale = 60;
                    animationScale = 1.8f;
                    break;
                case 5:
                    fontScale = 60;
                    animationScale = 2;
                    break;
                default:
                    break;
            }
            if (IS_iPAD)
            {
                fontScale = fontScale * 2;
            }
            CCLabelTTF* fnt_animation = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d", m_increaseAmountForOutCard] fontName:@"bubble sharp" fontSize:fontScale];
            [fnt_animation setColor:[CCColor colorWithCcColor3b:ccc3(240,230,140)]];
            if (IS_iPAD)
                [fnt_animation setPosition:ccp(384, 800)];
            else
                [fnt_animation setPosition:ccp(160, (screenHeight - 88))];
            [self addChild:fnt_animation];
            [fnt_animation runAction:[CCActionSequence actions:
                                      [CCActionScaleTo actionWithDuration:1 scale:animationScale],
                                      nil]];
            [fnt_animation runAction:[CCActionSequence actions:
                                      [CCActionFadeOut actionWithDuration:1],
                                      [CCActionCallFunc actionWithTarget:fnt_animation selector:@selector(removeFromParent)],
                                      nil]];
        }
        if (m_increaseAmountForEmptySlot > 0)
        {
            float animationScale = 1.5f;
            float fontScale = 40;
            
            if (IS_iPAD)
            {
                fontScale = fontScale * 2;
            }
            CCLabelTTF* fnt_animation = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d", m_increaseAmountForEmptySlot] fontName:@"bubble sharp" fontSize:fontScale];
            [fnt_animation setColor:[CCColor colorWithCcColor3b:ccc3(240,230,140)]];
            
            if (IS_iPAD)
                [fnt_animation setPosition:ccp(136 + m_emptySlotIdx * 162, 615.0f)];
            else
                [fnt_animation setPosition:ccp(58 + m_emptySlotIdx * 70, screenHeight - 185)];
            [self addChild:fnt_animation];
            [fnt_animation runAction:[CCActionSequence actions:
                                      [CCActionScaleTo actionWithDuration:1 scale:animationScale],
                                      nil]];
            [fnt_animation runAction:[CCActionSequence actions:
                                      [CCActionFadeOut actionWithDuration:1],
                                      [CCActionCallFunc actionWithTarget:fnt_animation selector:@selector(removeFromParent)],
                                      nil]];
            m_increaseAmountForEmptySlot = 0;
        }
        
    }
    [lbl_score setString:[NSString stringWithFormat:@"Score : %d", m_countingScore]];
}

-(void)CheckGameOver
{
    m_usedHint = false;
    if (m_gameOver)
        return;
    
    if ([self CheckMovemont])
        return;
    else
        [APP ShowAd];
    
    if (m_cardsInDeck.count > 0)
        return;
    
    m_lastAnimating = true;
    m_gameOver = true;
    m_countingScore = m_score;
    for(int i = 0; i < 4; i++)
    {
        switch (m_cardsInBoard[i].count) {
            case 1:
                m_animationLevelForEachSlot[i] = 5;
                m_increaseAmountForEachSlot[i] = 2000;
                break;
            case 2:
                m_animationLevelForEachSlot[i] = 4;
                m_increaseAmountForEachSlot[i] = 900;
                break;
            case 3:
                m_animationLevelForEachSlot[i] = 4;
                m_increaseAmountForEachSlot[i] = 800;
                break;
            case 4:
                m_animationLevelForEachSlot[i] = 3;
                m_increaseAmountForEachSlot[i] = 750;
                break;
            case 5:
                m_animationLevelForEachSlot[i] = 3;
                m_increaseAmountForEachSlot[i] = 700;
                break;
            case 6:
                m_animationLevelForEachSlot[i] = 3;
                m_increaseAmountForEachSlot[i] = 600;
                break;
            case 7:
                m_animationLevelForEachSlot[i] = 3;
                m_increaseAmountForEachSlot[i] = 500;
                break;
            case 8:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 450;
                break;
            case 9:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 400;
                break;
            case 10:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 300;
                break;
            case 11:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 200;
                break;
            case 12:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 150;
                break;
            case 13:
                m_animationLevelForEachSlot[i] = 2;
                m_increaseAmountForEachSlot[i] = 75;
                break;
            default:
                m_increaseAmountForEachSlot[i] = 0;
                break;
        }
        m_score += m_increaseAmountForEachSlot[i];
    }
    
    m_countInterval = (m_score - m_countingScore) / 15;
    if (m_score > m_countingScore && m_countInterval < 1)
        m_countInterval = 1;
    if(m_score > m_countingScore)
    {
        [self unscheduleAllSelectors];
        [self schedule:@selector(CountingScoreAnimationForGameOver) interval:1/30.0f];
        int animationSequence = 0;
        for(int i = 0; i < 4; i++)
        {
            if (m_increaseAmountForEachSlot[i] > 0)
            {
                float animationScale = 0;
                float fontScale = 0;
                switch (m_animationLevelForEachSlot[i]) {
                    case 1:
                        animationScale = 1.3f;
                        fontScale = 20;
                        break;
                    case 2:
                        fontScale = 30;
                        animationScale = 1.5f;
                        break;
                    case 3:
                        fontScale = 35;
                        animationScale = 1.8f;
                        break;
                    case 4:
                        fontScale = 45;
                        animationScale = 1.8f;
                        break;
                    case 5:
                        fontScale = 45;
                        animationScale = 2;
                        break;
                    default:
                        break;
                }
                if (IS_iPAD)
                {
                    fontScale = fontScale * 2;
                }
                CCLabelTTF* fnt_animation = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d", m_increaseAmountForEachSlot[i]] fontName:@"bubble sharp" fontSize:fontScale];
                [fnt_animation setColor:[CCColor colorWithCcColor3b:ccc3(240,230,140)]];
                [self addChild:fnt_animation];
                if (IS_iPAD)
                    [fnt_animation setPosition:ccp(136 + i * 162, 750.0f )];
                else
                    [fnt_animation setPosition:ccp(58 + i * 70, screenHeight - 125)];
                [fnt_animation setScale:0];
                
                [fnt_animation runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:animationSequence scale:0],
                                          [CCActionScaleTo actionWithDuration:1 scale:animationScale],
                                          nil]];
                [fnt_animation runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:animationSequence scale:0],
                                          [CCActionFadeOut actionWithDuration:1],
                                          [CCActionCallFunc actionWithTarget:fnt_animation selector:@selector(removeFromParent)],
                                          nil]];
                animationSequence++;
            }
        }
        int oneCardSlots = 0;
        for(int i = 0; i < 4; i++)
        {
            if (m_cardsInBoard[i].count == 1)
                oneCardSlots++;
        }
        if (oneCardSlots > 0)
            m_score = m_score * pow(2, oneCardSlots);
        m_countInterval = (m_score - m_countingScore) / 15;
        if (m_score > m_countingScore && m_countInterval < 1)
            m_countInterval = 1;
        if (oneCardSlots)
        {
            float animationScale = 0, fontScale = 0;
            switch (oneCardSlots + 1) {
                case 1:
                    animationScale = 1.3f;
                    fontScale = 30;
                    break;
                case 2:
                    fontScale = 40;
                    animationScale = 1.5f;
                    break;
                case 3:
                    fontScale = 50;
                    animationScale = 1.8f;
                    break;
                case 4:
                    fontScale = 60;
                    animationScale = 1.8f;
                    break;
                case 5:
                    fontScale = 60;
                    animationScale = 2;
                    break;
                default:
                    break;
            }
            if (IS_iPAD)
            {
                fontScale = fontScale * 2;
            }
            CCLabelTTF* fnt_animation = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"X%d", (int)pow(2, oneCardSlots)] fontName:@"bubble sharp" fontSize:fontScale];
            [fnt_animation setColor:[CCColor colorWithCcColor3b:ccc3(240,230,140)]];
            if (IS_iPAD)
                [fnt_animation setPosition:ccp(384, 800)];
            else
                [fnt_animation setPosition:ccp(160, (screenHeight - 88))];
            [self addChild:fnt_animation];
            [fnt_animation setScale:0];
            
            [fnt_animation runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:animationSequence scale:0],
                                      [CCActionScaleTo actionWithDuration:1 scale:animationScale],
                                      nil]];
            [fnt_animation runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:animationSequence scale:0],
                                      [CCActionFadeOut actionWithDuration:1],
                                      [CCActionCallFunc actionWithTarget:fnt_animation selector:@selector(removeFromParent)],
                                      nil]];
            animationSequence++;
        }
        [self scheduleOnce:@selector(GiveCongParticle) delay:animationSequence];
    }
    if ([m_dbMgr GetScoreByUserId:@"0"] < m_score)
    {
        [m_dbMgr UpdateScore:@"0" score:m_score];
        [lbl_highScore setString:[NSString stringWithFormat:@"High Score : %d", [m_dbMgr GetScoreByUserId:@"0"]]];
    }
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"])
    {
        [m_webMgr PublishMyScore:[[NSUserDefaults standardUserDefaults] valueForKey:@"fb_id"] score:[m_dbMgr GetScoreByUserId:@"0"]];
    }
    if ([self GetLeftCardCount] == 4)
    {
        [APP PlayEffect:@"congratulation.wav"];
    }
}

-(void)CountingScoreAnimationForGameOver
{
    m_countingScore += m_countInterval;
    if (m_countingScore >= m_score)
    {
        m_countingScore = m_score;
    }
    [lbl_score setString:[NSString stringWithFormat:@"Score : %d", m_countingScore]];
}

-(void)GiveCongParticle
{
    [self unscheduleAllSelectors];
    CCSprite* sp_particle = [CCSprite spriteWithImageNamed:@"particle0.png"];
    if (IS_iPAD)
        [sp_particle setPosition:ccp(250, 780)];
    else
        [sp_particle setPosition:ccp(105, screenHeight - 108)];
    [self addChild:sp_particle];
    CCAnimation* ani = [CCAnimation animation];
    for (int i = 0; i <= 23; i++)
    {
        NSString* resName = [NSString stringWithFormat:@"particle%d.png", i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:resName];
        [ani addSpriteFrame:frame];
    }
    [ani setDelayPerUnit:1 / 24.0f];
    [sp_particle runAction:[CCActionSequence actions:[CCActionAnimate actionWithAnimation:ani],
                            [CCActionCallFunc actionWithTarget:sp_particle selector:@selector(removeFromParent)],
                            nil]];
    
    CCSprite* sp_glow = [CCSprite spriteWithImageNamed:@"number_glow.png"];
    [self addChild:sp_glow];
    if (IS_iPAD)
        [sp_glow setPosition:ccp(250, 840)];
    else
        [sp_glow setPosition:ccp(105, screenHeight - 78)];
    [sp_glow setScale:0.1f];

    [sp_glow runAction:[CCActionSequence actions:[CCActionFadeTo actionWithDuration:0.5f opacity:1],
                        [CCActionFadeTo actionWithDuration:0.5f opacity:0],
                        nil]];
    [sp_glow runAction:[CCActionSequence actions:[CCActionScaleTo actionWithDuration:1.0f scale:1.0f],
                        [CCActionCallFunc actionWithTarget:sp_glow selector:@selector(removeFromParent)],
                        nil]];
    
    NSString* strBannerName;
    if ([self GetLeftCardCount] == 4)
        strBannerName = @"cong_banner.png";
    else if ([self GetLeftCardCount] < 8 && [self GetLeftCardCount] > 4)
        strBannerName = @"close_banner.png";
    else
        strBannerName = @"hard_luck_banner.png";
    
    CCSprite* congView = [CCSprite spriteWithImageNamed:strBannerName];
    [self addChild:congView z:100 name:@"cong_banner"];
    if (IS_iPAD)
        [congView setPosition:ccp(384, 512)];
    else
        [congView setPosition:ccp(160, screenHeight / 2)];
    [congView setOpacity:0];
    [congView runAction:[CCActionSequence actions:[CCActionFadeIn actionWithDuration:1],
                         [CCActionCallFunc actionWithTarget:self selector:@selector(DoneAllAnimation)],
                         nil]];
}

-(void)DoneAllAnimation
{
    m_lastAnimating = false;
}

-(int)GetLeftCardCount
{
    int leftCard = 0;
    for(int i = 0; i < 4; i++)
    {
        leftCard += m_cardsInBoard[i].count;
    }
    return leftCard;
}
@end
