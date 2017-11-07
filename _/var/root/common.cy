//获取所有window

function windows() {
	return [UIApplication sharedApplication].windows;
}

function topViewControllerFrom(vc) {
	if ([vc isKindOfClass:[UINavigationController class]])
	{
    	return topViewControllerFrom([vc topViewController]);
	}
	else if ([vc isKindOfClass:[UITabBarController class]])
	{
	 return topViewControllerFrom([vc selectedViewController]);
	} 
	else
	{
		var preVC = vc.presentedViewController;
		if (preVC) 
		{
			return topViewControllerFrom(preVC);
		} 
		else 
		{
			return vc;
		}
	}
}

function vc() {
	var rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
	if(rootViewController!=nil)
	{
	  var currentVC = topViewControllerFrom(rootViewController);
	  return currentVC;
	}
	return rootViewController;
}

function keywindow() {
	return [UIApplication sharedApplication].keyWindow;
}

function loadFramework(fw) {
  var h="/System/Library/",t="Frameworks/"+fw+".framework";
  [[NSBundle bundleWithPath:h+t]||[NSBundle bundleWithPath:h+"Private"+t] load];
}

function delegate()
{
	return [UIApplication sharedApplication ].delegate;
}
function mgr()
{
	return [UIApplication sharedApplication ].delegate.m_appViewControllerMgr;
}

function views()
{
	var x =[[UIApplication sharedApplication ].keyWindow recursiveDescription];
	return x;
}

function ivars(a)
{   var x={};
	for(i in *a)
	{
		try{
			x[i] = (*a)[i]; 
		} 
		catch(e){} 
	} 
	return x;
}

function CGPointMake(x, y) { return {0:x, 1:y}; }
function CGSizeMake(w, h) { return {0:w, 1:h}; }
function CGRectMake(x, y, w, h) { return {0:CGPointMake(x,y), 1:CGSizeMake(w, h)}; }





var intFunc = @encode(void(int));
var objFunc = @encode(void(id));
var classFunc = @encode(void(Class));
var selFunc = @encode(void(SEL));
var voidFunc = @encode(void(void));
var objSelFunc = @encode(void(id, SEL));
var classSelFunc = @encode(void(Class, SEL));

var handle = dlopen("/usr/lib/libinspectivec.dylib", RTLD_NOW);

var setMaximumRelativeLoggingDepth = intFunc(dlsym(handle, "InspectiveC_setMaximumRelativeLoggingDepth"));

var watchObject = objFunc(dlsym(handle, "InspectiveC_watchObject"));
var unwatchObject = objFunc(dlsym(handle, "InspectiveC_unwatchObject"));
var watchSelectorOnObject = objSelFunc(dlsym(handle, "InspectiveC_watchSelectorOnObject"));
var unwatchSelectorOnObject = objSelFunc(dlsym(handle, "InspectiveC_unwatchSelectorOnObject"));

var watchClass = classFunc(dlsym(handle, "InspectiveC_watchInstancesOfClass"));
var unwatchClass = classFunc(dlsym(handle, "InspectiveC_unwatchInstancesOfClass"));
var watchSelectorOnClass = classSelFunc(dlsym(handle, "InspectiveC_watchSelectorOnInstancesOfClass"));
var unwatchSelectorOnClass = classSelFunc(dlsym(handle, "InspectiveC_unwatchSelectorOnInstancesOfClass"));

var watchSelector = selFunc(dlsym(handle, "InspectiveC_watchSelector"));
var unwatchSelector = selFunc(dlsym(handle, "InspectiveC_unwatchSelector"));

var enableLogging = voidFunc(dlsym(handle, "InspectiveC_enableLogging"));
var disableLogging = voidFunc(dlsym(handle, "InspectiveC_disableLogging"));

var enableCompleteLogging = voidFunc(dlsym(handle, "InspectiveC_enableCompleteLogging"));
var disableCompleteLogging = voidFunc(dlsym(handle, "InspectiveC_disableCompleteLogging"));
