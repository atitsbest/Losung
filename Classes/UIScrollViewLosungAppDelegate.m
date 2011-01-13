//
//  UIScrollViewLosungAppDelegate.m
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UIScrollViewLosungAppDelegate.h"
#import "UIScrollViewLosungViewController.h"
#import "ApplicationContext.h"
#import "Models/Losung.h"
#import "Repositories/LosungRepository.h"

@implementation UIScrollViewLosungAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[ApplicationContext current].databaseName = @"losungen.sqlite3";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	[ApplicationContext current].databasePath = [documentsDir stringByAppendingPathComponent:[ApplicationContext current].databaseName];

	NSCalendar* calendar = [NSCalendar currentCalendar];
	NSDateComponents* comp1 = [calendar components:NSYearCalendarUnit 
										  fromDate:[NSDate date]];
	[ApplicationContext current].currentYear = [comp1 year];
	
    // Add the view controller's view to the window and display.
	[window makeKeyAndVisible];
    [window addSubview:viewController.view];
	[self showSplashView];
    
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// iOS 4: Apps werden nicht mehr beendet sondern laufen im Hintergrund weiter.
	//		  Ich möchte aber, dass diese App immer die Losung vom heutigen Tag
	//		  anzeigt, wenn ich sie starte.
	[viewController scrollToToday];
}


- (void)showSplashView {
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
    [window addSubview:splashView];
    [window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -60, 440, 600);
    [UIView commitAnimations];
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [splashView removeFromSuperview];
    [splashView release];
}


/**
 * DTR
 */
- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}

@end

