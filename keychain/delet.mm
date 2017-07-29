#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "sqlite3.h"
#import "query.h"
#import "common.h"
#import "delet.h"
void deleteKeychainObjectsForSecClass(CFTypeRef kSecClassType) 
{
	NSMutableDictionary *genericQuery = [[NSMutableDictionary alloc]init];
	[genericQuery setObject:(__bridge id)kSecClassType forKey:(id)kSecClass];
	SecItemDelete((CFDictionaryRef)genericQuery);
	
}
BOOL deleteKeychainObjectsForSecClassWithGroup(CFTypeRef kSecClassType, NSString * group)
{
	
	NSMutableDictionary *keychainQuery = [NSMutableDictionary dictionaryWithObjectsAndKeys:
										               									(__bridge id)kSecClassType,(id)kSecClass,
																		               group,(id)kSecAttrAccessGroup,nil];

 	OSStatus statu =  SecItemDelete((CFDictionaryRef)keychainQuery);
	if(statu == errSecSuccess )return YES;
	return NO;
}

BOOL deleteKeychainObjectsForGroup(NSString * deleteGroup)
{
	BOOL success = YES;
	NSDictionary * keychainItems =	getAllGroupsInKeychainObjecsDic();
	for(id kSecClassType in [keychainItems allKeys])
	{
		for(NSString * group in keychainItems[kSecClassType])
		{
			if([group rangeOfString:deleteGroup].location!=NSNotFound)
			{
				 success = deleteKeychainObjectsForSecClassWithGroup((__bridge CFTypeRef)kSecClassType,group);
				 if(!success)
				 {
					 NSLog(@"----DELETE FAILED--:%@----\n",deleteGroup );
					 return NO;
				 }
			}
		}
	}
	if(success)NSLog(@"----DELETE SUCCESS--:%@----\n",deleteGroup );
	return YES;
}

void deleteAllKeychainObjects()
{
	NSArray * SecClasses = @[(id)kSecClassGenericPassword,(id)kSecClassInternetPassword,
							 (id)kSecClassIdentity,(id)kSecClassCertificate,(id)kSecClassKey];
	for(id kSecClassType in SecClasses )
	{
		deleteKeychainObjectsForSecClass((__bridge CFTypeRef)kSecClassType);
	}
	printf("----DELETE_ALL_KEYCHAIN_GROUPS----\n");
}
