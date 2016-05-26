//
//  OptionScreen.h
//  Solitaire
//
//  Created by richboy on 2/24/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "cocos2d-ui.h"
#import "JSFBManager.h"
#import "JSWebManager.h"
#import "DBManager.h"

@interface OptionScreen : CCNode<JSFBManagerDelegate> {
    JSFBManager* m_fbMgr;
    JSWebManager* m_webMgr;
    DBManager*      m_dbMgr;
}
-(void)OnLook;
-(void)Refresh;
@end
