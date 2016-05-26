//
//  Card.h
//  Solitaire
//
//  Created by richboy on 2/23/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define SPADE_TYPE      1
#define CLUBA_TYPE      2
#define DIA_TYPE        3
#define HEART_TYPE      4

@interface Card : CCNode {
@public
    int         m_number;
    int         m_type;
    BOOL        m_captured;
}
-(id)initWithData:(int)number type:(int)typ;
@end
