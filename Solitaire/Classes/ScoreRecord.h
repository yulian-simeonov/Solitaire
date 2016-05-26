//
//  ScoreRecord.h
//  Solitaire
//
//  Created by richboy on 3/4/14.
//  Copyright 2014 Appdeen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ScoreRecord : CCNode {
    
}
-(id)initWithData:(NSString*)userName hightScore:(int)score userID:(NSString*)userId;
@end
