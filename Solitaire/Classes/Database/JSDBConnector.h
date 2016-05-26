//
//  DBConnector.h
//  Transform!
//
//  Created by  on 1/11/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface JSDBConnector : NSObject
{
    sqlite3*    m_dbConnection;
}
-(NSMutableArray*)ExecuteReader:(NSString*)strQuery;
-(BOOL)ExecuteNonQuery:(NSString*)strQuery;
-(id)ExecuteScalar:(NSString*)strQuery;
@end
