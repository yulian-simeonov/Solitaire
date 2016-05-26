//
//  StateView.h
//  Solitaire
//
//  Created by mobile master on 4/11/14.
//  Copyright (c) 2014 Appdeen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "JSWebManager.h"
#import "JSFBManager.h"
#import "DBManager.h"

@interface StateView : UIView<JSFBManagerDelegate>
{
    IBOutlet UITableView* tbl_userInfo;
    DBManager*      m_dbMgr;
    NSArray*        m_friends;
    JSFBManager* m_fbMgr;
    JSWebManager* m_webMgr;
    NSArray* m_ary;
    __weak id          m_parent;
}
-(void)InitControls:(id)parent;
@end
