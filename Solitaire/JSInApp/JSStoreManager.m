

#import "JSStoreManager.h"

@implementation JSStoreManager

static JSStoreManager* _sharedStoreManager; // self

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers{
    self = [super init];
    if(self){
        self._productIdentifiers = productIdentifiers;
        NSMutableSet *purchased = [NSMutableSet set];
        for(NSString * productId in self._productIdentifiers){
            BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:productId];
            if(flag){
                [purchased addObject:productId];
            }
        }
        self._purchasedProducts = purchased;
    }
    return self;
}

- (void)dealloc
{
	[_sharedStoreManager release];
	[_storeObserver release];
	[super dealloc];
}

+ (JSStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			NSSet *productIds = [NSSet setWithObjects:ProductID, nil];
            _sharedStoreManager = [[self alloc] initWithProductIdentifiers:productIds]; // assignment not done here
			_sharedStoreManager.storeObserver = [[JSStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}

- (void)requestProducts{
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:self._productIdentifiers];
    self.request.delegate = self;
    [self.request start];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(Failed:)])
            [_delegate Failed:@"Product request failed."];
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    self.products = response.products;
    [self.request release];
    self.request = nil;
    [self buyProduct:ProductID];
}

- (void)buyProduct:(NSString*)productId
{
    if (!self.products)
    {
        [self requestProducts];
        return;
    }
	if ([SKPaymentQueue canMakePayments])
	{
        SKProduct* product = nil;
        for(SKProduct* pt in _products)
        {
            NSLog(@"%@", pt.productIdentifier);
            if ([pt.productIdentifier isEqualToString:productId])
            {
                product = pt;
                break;
            }
        }
        if (!product)
            return;
		SKPayment *payment = [SKPayment paymentWithProduct:product];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		[[[[UIAlertView alloc] initWithTitle:nil message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"Try later" otherButtonTitles: nil] autorelease] show];
	}
}

-(void)Restore
{
    isRestored = false;
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

-(void)SuccessfullyPurchased:(NSString*)productIdentifier
{
    [self setLockKey: productIdentifier];
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(Successed)])
            [_delegate Successed];
    }
}

-(void)Restored:(NSString*)productIdentifier
{
    [self setLockKey:productIdentifier];
    if (!isRestored)
        isRestored = true;
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(Successed)])
            [_delegate Successed];
    }
}

-(void)Failed:(NSString*)msg
{
    if (_delegate)
    {
        if ([_delegate respondsToSelector:@selector(Failed:)])
            [_delegate Failed:msg];
    }
}

-(void) setLockKey: (NSString*) productIdentifier
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
	if([productIdentifier isEqualToString:ProductID])
    {
        [defaults setBool:TRUE forKey:ProductID];
        [defaults setBool:TRUE forKey:@"world_result"];
    }
	[NSUserDefaults resetStandardUserDefaults];
}

-(void)Buy
{
    [self buyProduct:ProductID];
}
@end
