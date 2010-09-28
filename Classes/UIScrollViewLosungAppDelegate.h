//
//  UIScrollViewLosungAppDelegate.h
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
// W282770312

#import <UIKit/UIKit.h>

@class UIScrollViewLosungViewController;

@interface UIScrollViewLosungAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
    UIScrollViewLosungViewController *viewController;
    UIImageView *splashView;
}

- (void)checkAndCopyDatabase;
// TODO: @Private
- (void)showSplashView;
- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIScrollViewLosungViewController *viewController;

@end

