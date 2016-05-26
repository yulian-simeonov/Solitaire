//
//  StatesScreen.h
//  Solitaire
//
//  Created by richboy on 2/25/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "DBManager.h"
#import "JSWebManager.h"
#import "JSFBManager.h"
#import "DBManager.h"
#import "cocos2d-ui.h"

@interface StatesScreen : CCNode<JSFBManagerDelegate> {
    DBManager*      m_dbMgr;
    NSArray*        m_friends;
    JSFBManager* m_fbMgr;
    JSWebManager* m_webMgr;
    CCNode*     m_scorePanel;
}

@end
