//
//  LookButton.h
//  Solitaire
//
//  Created by richboy on 2/24/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LookButton : CCNode {
    id  m_parent;
}
-(id)initWithParent:(id)parent;
-(void)Refresh;
@end
