

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "JSStoreObserver.h"
#define ProductID   @"solitare_proversion"

@protocol JSStoreManagerDelegate <NSObject>
@required
-(void)Failed:(NSString*)errMsg;
-(void)Successed;
@end

@interface JSStoreManager : NSObject<SKProductsRequestDelegate> {
    BOOL isRestored;
}
@property (nonatomic, retain) id<JSStoreManagerDelegate> delegate;
@property (nonatomic, retain) JSStoreObserver *storeObserver;
@property (strong, nonatomic) NSMutableSet * _purchasedProducts;
@property (strong, nonatomic) NSArray *products;
@property (strong, nonatomic) NSSet *_productIdentifiers;
@property (strong, nonatomic) SKProductsRequest *request;

+ (JSStoreManager*)sharedManager;
-(void)SuccessfullyPurchased:(NSString*)productIdentifier;
-(void)Restored:(NSString*)productIdentifier;
-(void)Failed:(NSString*)msg;
-(void)Restore;
-(void)Buy;
@end
