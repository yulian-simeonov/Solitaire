//
//  DBManager.h
//  BrazilWorldCup
//
//  Created by     on 12/20/13.
//  Copyright (c) 2013 Hamza. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSDBConnector.h"

@interface DBManager : NSObject
{
    JSDBConnector*    m_dbConnector;
}
-(void)UpdateScore:(NSString*)userId score:(int)scre;
-(int)GetScoreByUserId:(NSString*)userId;
-(NSArray*)GetFriendsInfo;
@end
