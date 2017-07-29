#import <Foundation/Foundation.h>
#import <CoreFoundation/CoreFoundation.h>

int main(int argc, char **argv, char **envp) {

	NSArray *arguments = [[NSProcessInfo processInfo] arguments];

	if(arguments.count == 2)
	{
		NSString * item = arguments[1];
		if(item.length>0)
		{
			id result = nil;
			NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:item];
			NSArray * array = [NSArray arrayWithContentsOfFile:item];
			if(dic)
			{
				result = dic;

			}else if(array)
			{
				result = array;
			}
			NSLog(@"%@",result);
			return 0;
		}
	}
	NSLog(@"-------Error Para !----------");
	return 0;
}

// vim:ft=objc
