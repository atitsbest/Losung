//
//  UIScrollViewLosungViewController.h
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LosungRepository, LosungView;

@interface UIScrollViewLosungViewController : UIViewController <UIScrollViewDelegate> {
	LosungRepository *losungen;
	NSString *htmlTemplate;
	
	UIScrollView *pagingScrollView;
	NSMutableSet *visiblePages;
	NSMutableSet *recycledPages;
}

- (void)tileLosungViews; // Nur die nötigen Losungen anzeigen.
- (BOOL)isDisplayingLosungForIndex:(NSInteger)index; // Wird die Losung mit dem Index gerade angezeigt?
- (void) scrollToToday;
- (LosungView*)dequeueRecycledPage;

@end

