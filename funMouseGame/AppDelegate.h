//
//  AppDelegate.h
//  funMouseGame
//
//  Created by Alex Gievsky on 10.11.11.
//  Copyright alex.gievsky@gmail.com 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
