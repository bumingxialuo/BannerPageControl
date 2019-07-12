//
//  Configuration.h
//  Pods
//
//  
//
//

#ifndef Configuration_h
#define Configuration_h

#define kDevice_Is_iPhoneX [RDRootViewController is_iPhoneX]

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define NavAndStatusHight (self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height)

#define AppSkin [RdAppSkinColor sharedInstance]

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define WIDTHRADIUS (kScreenWidth/375.0)

#endif /* Configuration_h */
