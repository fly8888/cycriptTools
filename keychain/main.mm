#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import "sqlite3.h"
#import "add.h"
#import "delet.h"
#import "query.h"
#import "savekeychain.h"
#import "common.h"
struct HelpCmd{
	BOOL hasH;
};
struct ListCmd {
    BOOL hasL;
	BOOL hasA;
	BOOL hasG;
	NSString * group;
};
struct DeleteCmd {
    BOOL hasR;
    BOOL hasG;
    BOOL hasA;
    NSString * group;
};
struct GhostCmd {
    BOOL hasGhost;
    NSString * path;
};

struct RecoverCmd {
    BOOL hasRecover;
    NSString * path;
    NSString * group;
};
/*
功能：
1.清空钥匙串信息
2.获取钥匙串所有的组信息
3.删除指定组钥匙串信息
*/
/*
 帮助 ： -h
 列出所有组： -lg
 删除某个组： -rg group
 删除所有： -ra
 备份钥匙串： -ghost
 列出所有：-l -a
 恢复某个组：-recover -p xx.plsit -g com.tencent.xin
*/

int main(int argc, char **argv, char **envp) {

	//addKeychainItemWithPath(@"/tmp/keychain.plist",@"RMSS829LQ5.top.iosre.keychain");
	//ghostKeychain();
	NSArray *arguments = [[NSProcessInfo processInfo] arguments];
	if(arguments.count<=1)
	{
		printUsage();
		return 0;
	}
	struct HelpCmd help = {NO};
	struct ListCmd list = {NO,NO,NO,nil};
	struct DeleteCmd delet = {NO,NO,NO,nil}; 
	struct GhostCmd ghost = {NO,nil};
	struct RecoverCmd recover = {NO,nil,nil};
	for(int i= 0; i<arguments.count;i++)
	{
		NSString * op = [arguments[i] lowercaseString];
		if([op isEqualToString:@"-l"])
		{
			list.hasL = YES;

		}else if([op isEqualToString:@"-r"])
		{
			delet.hasR = YES;

		}else if([op isEqualToString:@"-g"])
		{
			delet.hasG = YES;
			list.hasG = YES;
			if(i+1<arguments.count&&[(NSString*)(arguments[i+1]) length]>0)
			{
				delet.group = arguments[i+1];
				recover.group = arguments[i+1];
				list.group = arguments[i+1];
			}
			// else
			// {
			// 	help.hasH = YES;
			// }

		}else if([op isEqualToString:@"-a"])
		{
			delet.hasA = YES;
			list.hasA  = YES;

		}else if([op isEqualToString:@"-ghost"])
		{
			ghost.hasGhost = YES;

		}else if([op isEqualToString:@"-p"])
		{
			if(i+1<arguments.count&&[(NSString*)(arguments[i+1]) length]>0)
			{
				ghost.path = arguments[i+1];
				recover.path = arguments[i+1];

			}else
			{
				help.hasH = YES;
			}
		}else if([op isEqualToString:@"-recover"])
		{
			recover.hasRecover = YES;
		}

	}

	if(help.hasH)
	{
		printUsage();
		return 0;
	}

	if(list.hasL)
	{
		if(list.hasG)
		{
			getAllGroupsInKeychainObjecs();
			return 0;

		}else if(list.hasA)
		{
			prinftAllObj();
			return 0;
		}
		 
	}
	if(delet.hasR)
	{
		if(delet.hasG&&delet.group)
		{
			deleteKeychainObjectsForGroup(delet.group);
			return 0;
		}else if(delet.hasA)
		{
			deleteAllKeychainObjects();
			return 0;
		}
		
	}
	if(recover.hasRecover&&recover.path&&recover.group)
	{
		addKeychainItemWithPath(recover.path,recover.group);
		return 0;
	}
	if(ghost.hasGhost)
	{
		if(ghost.path)
		{
			ghostKeychain(ghost.path);
			return 0;
		}
	}
	
	
	printUsage();
	return 0;
}



