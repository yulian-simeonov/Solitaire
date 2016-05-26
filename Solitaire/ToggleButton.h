//
//  ToggleButton.h
//  Solitaire
//
//  Created by richboy on 2/25/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ToggleButton : CCNode {
    CCSprite* sp_toggle;
    CCSprite* sp_label;
    BOOL        m_status;
}
-(id)initWithFlag:(BOOL)on;
@end
