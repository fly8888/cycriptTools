#import "query.h"
#import "saveKeychain.h"

NSDictionary * fixKeychainItemDic(NSDictionary * account)
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
//获取所有keychain
NSMutableDictionary * getAllKeychainItems()
{
    NSMutableDictionary * ghostDic = [[NSMutableDictionary alloc]init];
	NSDictionary * keychains = getAllKeychainObjDic();
	for(id kSecClassType in [keychains allKeys])
	{
		NSArray * secClassValues = keychains[kSecClassType];
        NSMutableArray * kindsDataArray = [[NSMutableArray alloc]init];
        for(NSDictionary * account in secClassValues)
        {
            NSDictionary * re = fixKeychainItemDic(account);
            if(re)[kindsDataArray addObject:re];
        }
        [ghostDic setValue:kindsDataArray forKey:kSecClassType];
	}
    return ghostDic;
}

//获取指定用户组的keychain
NSMutableDictionary * getKeychainItemsOfGroup(NSString * groupName)
{
    NSMutableDictionary * ghostDic = [[NSMutableDictionary alloc]init];
	NSDictionary * keychains = getAllKeychainObjDic();
	for(id kSecClassType in [keychains allKeys])
	{
        NSMutableArray * kindsDataArray = [[NSMutableArray alloc]init];
		NSArray * secClassValues = keychains[kSecClassType];
        for(NSDictionary * account in secClassValues)
        {
            NSString * agrp = account[@"agrp"];
            if(agrp&&[agrp rangeOfString:groupName].location!=NSNotFound)
            {
                NSDictionary * re = fixKeychainItemDic(account);
                if(re)[kindsDataArray addObject:re];
            }
        }
        [ghostDic setValue:kindsDataArray forKey:kSecClassType];
	}
    return ghostDic;
}

void ghostKeychain(NSString * path)
{
    NSMutableDictionary * ghostDic = getAllKeychainItems();
	if([ghostDic writeToFile:path atomically:YES])
    printf("----success--save to %s----\n",[path UTF8String]);
    else printf("----error--save to %s----\n",[path UTF8String]);
}

void ghostKeychainWithGroup(NSString * path,NSString * groupName)
{
    NSMutableDictionary * ghostDic = getKeychainItemsOfGroup(groupName);
	if([ghostDic writeToFile:path atomically:YES])
    printf("----success--save to %s----\n",[path UTF8String]);
    else printf("----error--save to %s----\n",[path UTF8String]);
}