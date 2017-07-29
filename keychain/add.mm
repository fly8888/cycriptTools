#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "sqlite3.h"
#import "add.h"

// 获取数据

// 保存数据
BOOL addKeychainItem(NSDictionary * item)
{
    if (item)
    {
        //SecItemDelete((CFDictionaryRef)item);
        OSStatus statu = SecItemAdd((CFDictionaryRef)item, NULL);
        if(statu == errSecSuccess )return YES;
    }
    return NO;
}

void addKeychainItemWithPath(NSString * path ,NSString * group)
{
    //tmp/keychain.plist
    NSDictionary * keychainItems =  [NSDictionary dictionaryWithContentsOfFile:path];
    BOOL statu = NO;
    if(keychainItems&&keychainItems.count>0)
    {
        
        for(NSString * classType in [keychainItems allKeys])
        {
            NSArray * itemsOfType = keychainItems[classType];
            for(NSDictionary * item in itemsOfType)
            {
                NSString * itemAgrp = item[@"agrp"];
                if(itemAgrp&&[itemAgrp rangeOfString:group].location!=NSNotFound)
                {
                    statu = addKeychainItem(item);
                }
            }
        }
    }
    if(statu)printf("-----ADD KEYCHAIN SUCCESS!---%s----\n",[group UTF8String]);
    else printf("-----ERROR---NO KEYCHAIN DATA OR KEYCHAIN ALREADY HAS THIS ITEM!-------\n");
    
}
