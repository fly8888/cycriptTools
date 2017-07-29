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
