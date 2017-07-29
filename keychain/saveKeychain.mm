#import "query.h"
#import "saveKeychain.h"

NSDictionary * getKeychainItemDic(NSDictionary * account,CFTypeRef kSecClassType)
{

    if([account isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary * itemInfo = [NSMutableDictionary dictionary];
        //NSLog(@"---------%@",account);
        for(id item in [account allKeys])
        {
            id value = account[item];
           
            if(value&&([value isKindOfClass:[NSString class]]||
                [value isKindOfClass:[NSData class]]||[value isKindOfClass:[NSDate class]]||
                [value isKindOfClass:[NSNumber class]]))
            {
                [itemInfo setValue:value forKey:item];
            }
        }
        return itemInfo;
    }
    return nil;
}

NSArray * getKeychainItemsArray(NSArray * items ,CFTypeRef kSecClassType )
{
    NSMutableArray * kindsDataArray = [NSMutableArray array];
    for(NSDictionary * account in items)
    {
        NSDictionary * re = getKeychainItemDic(account,kSecClassType);
        if(re)[kindsDataArray addObject:re];
    }
    return kindsDataArray;
}

void ghostKeychain(NSString * path)
{
    NSMutableDictionary * ghostDic = [[NSMutableDictionary alloc]init];
	NSDictionary * keychains = getAllKeychainObjDic();
	for(id kSecClassType in [keychains allKeys])
	{
		NSArray * secClassValues = keychains[kSecClassType];
        NSArray * re = getKeychainItemsArray(secClassValues,(__bridge CFTypeRef)kSecClassType);
        [ghostDic setValue:re forKey:kSecClassType];
	}
	if([ghostDic writeToFile:path atomically:YES])
    printf("----success--save to %s----\n",[path UTF8String]);
    else printf("----error--save to %s----\n",[path UTF8String]);
}

