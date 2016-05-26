//
//  GamePlayScreen.h
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "Card.h"
#import "DBManager.h"
#import "JSWebManager.h"

@interface GamePlayScreen : CCNode {
    BOOL        m_capturedDeck;
    BOOL        m_gameOver;
    BOOL        m_usedHint;
    BOOL        m_lastAnimating;
    float       screenHeight;
    int         m_hintCount;
    int         m_score;
    int         m_moveoutIdx;
    int         m_spreadIdx;
    BOOL        m_spreading;
    int         m_countingScore;
    int         m_countInterval;
    int         m_animationLevel;
    int         m_animationLevelForEachSlot[4];
    int         m_increaseAmountForOutCard;
    int         m_increaseAmountForEmptySlot;
    int         m_increaseAmountForEachSlot[4];
    int         m_emptySlotIdx;
    int         m_tmp;
    NSMutableArray*     m_cardsInDeck;
    NSMutableArray*     m_cardsInBoard[4];
    DBManager*      m_dbMgr;
    JSWebManager*   m_webMgr;
    CCLabelTTF* lbl_highScore;
    CCLabelTTF* lbl_score;
    CCLabelTTF* lbl_hintCount;
}
+(CCScene*)scene;
@end
