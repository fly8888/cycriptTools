#import "common.h"
#import <Security/Security.h>
#import <Security/SecItem.h>
#import "query.h"
/*
    读取指定秘钥类型的所有数据
*/
NSArray * getKeychainObjectsForSecClass(CFTypeRef kSecClassType) {
	NSMutableDictionary *genericQuery = [[NSMutableDictionary alloc] init];	
	[genericQuery setObject:(__bridge id)kSecClassType forKey:(id)kSecClass];
	[genericQuery setObject:(id)kSecMatchLimitAll forKey:(id)kSecMatchLimit];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnAttributes];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnRef];
	[genericQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
	
	CFTypeRef keychainItems = nil;
	if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)genericQuery, (CFTypeRef *)&keychainItems) != noErr)
	{
		keychainItems = nil;
	}
	return (__bridge NSArray *)keychainItems;
}

/*
    读取指定密钥类型的组
*/
NSArray * getAllGroupsInKeychainForSecClass(CFTypeRef kSecClassType)
{
	NSMutableArray * groups = [[NSMutableArray alloc]init];
	NSArray * keychainItems = getKeychainObjectsForSecClass(kSecClassType);
	for (id item in keychainItems)
	{
		NSString * agrp = item[@"agrp"];
		if(![groups containsObject:agrp])[groups addObject:agrp];
	}
	return groups;
}
/*
    读取所有密钥类型的组
*/
NSArray * getAllGroupsInKeychainObjecs()
{
	NSArray * SecClasses = @[(id)kSecClassGenericPassword,(id)kSecClassInternetPassword,
							 (id)kSecClassIdentity,(id)kSecClassCertificate,(id)kSecClassKey];
	NSMutableArray * allGroups = [NSMutableArray array];
	for(id kSecClassType in SecClasses )
	{
		NSArray * groups =	getAllGroupsInKeychainForSecClass((__bridge CFTypeRef)kSecClassType);
		[allGroups addObjectsFromArray:groups];
	}
	NSLog(@"---KEYCHAIN_GROUPS---%@\n",allGroups);
	return allGroups;
}


/*
	一下以字典类型处理
*/

/*
输出所有钥匙串内容
*/
void prinftAllObj()
{
	NSArray * SecClasses = @[(id)kSecClassGenericPassword,(id)kSecClassInternetPassword,
							 (id)kSecClassIdentity,(id)kSecClassCertificate,(id)kSecClassKey];
	NSArray *keychainItems = nil;
	for (id kSecClassType in  SecClasses) {
		keychainItems = getKeychainObjectsForSecClass((__bridge CFTypeRef)kSecClassType);
		printResultsForSecClass(keychainItems, (__bridge CFTypeRef)kSecClassType);
	}
}
/*
	获取所有秘钥类型的组，以秘钥类型分类
*/
NSMutableDictionary * getAllGroupsInKeychainObjecsDic()
{
	NSArray * SecClasses = @[(id)kSecClassGenericPassword,(id)kSecClassInternetPassword,
							 (id)kSecClassIdentity,(id)kSecClassCertificate,(id)kSecClassKey];
	NSMutableDictionary * allGroupsDic = [NSMutableDictionary dictionary];
	for(id kSecClassType in SecClasses )
	{
		NSArray * groups =	getAllGroupsInKeychainForSecClass((__bridge CFTypeRef)kSecClassType);
		[allGroupsDic setValue:groups forKey:kSecClassType];
	}

	return allGroupsDic;
}
/*
	获取所有钥匙串数据,以秘钥类型分类
*/
NSMutableDictionary * getAllKeychainObjDic()
{
	NSArray * SecClasses = @[(id)kSecClassGenericPassword,(id)kSecClassInternetPassword,
							 (id)kSecClassIdentity,(id)kSecClassCertificate,(id)kSecClassKey];
	NSMutableDictionary * allKeychainObj = [NSMutableDictionary dictionary];
	for(id kSecClassType in SecClasses )
	{
		NSArray * keychainItems = getKeychainObjectsForSecClass((__bridge CFTypeRef)kSecClassType);
		[allKeychainObj setValue:keychainItems forKey:kSecClassType];
	}

	return allKeychainObj;
}

