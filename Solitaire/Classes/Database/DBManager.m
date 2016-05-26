//
//  DBManager.m
//  BrazilWorldCup
//
//  Created by     on 12/20/13.
//  Copyright (c) 2013 Hamza. All rights reserved.
//

#import "DBManager.h"


@implementation DBManager
-(id)init
{
    if (self = [super init])
    {
        m_dbConnector = [[JSDBConnector alloc] init];
    }
    return self;
}

-(void)UpdateScore:(NSString*)userId score:(int)scre
{
    NSString* query = [NSString stringWithFormat:@"SELECT score FROM tbl_score WHERE user_id = '%@'", userId];
    id scalarValue = [m_dbConnector ExecuteScalar:query];
    if (scalarValue)
        query = [NSString stringWithFormat:@"UPDATE tbl_score SET score = %d WHERE user_id = '%@'", scre, userId];
    else
        query = [NSString stringWithFormat:@"INSERT INTO tbl_score VALUES('%@', %d)", userId, scre];
    [m_dbConnector ExecuteNonQuery:query];
}

-(int)GetScoreByUserId:(NSString*)userId
{
    NSString* query = [NSString stringWithFormat:@"SELECT score FROM tbl_score WHERE user_id = '%@'", userId];
    id scalarValue = [m_dbConnector ExecuteScalar:query];
    if (scalarValue)
        return [scalarValue integerValue];
    else
        return 0;
}

-(NSArray*)GetFriendsInfo
{
    return [m_dbConnector ExecuteReader:@"SELECT * FROM tbl_score ORDER BY score DESC"];
}
@end
