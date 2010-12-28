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
	
	UIScrollView *pagingScrollView;
	UIImageView *splashView;
	NSMutableSet *visiblePages;
	NSMutableSet *recycledPages;
	IBOutlet LosungView *losungView;
	IBOutlet UIView *firstYearView;
	IBOutlet UIView *lastYearView;
}

@property(nonatomic, retain) LosungView *losungView;
@property(nonatomic, retain) UIView *firstYearView;
@property(nonatomic, retain) UIView *lastYearView;

- (void)tileLosungViews; // Nur die nötigen Losungen anzeigen.
- (BOOL)isDisplayingLosungForIndex:(NSInteger)index; // Wird die Losung mit dem Index gerade angezeigt?
- (void)scrollToToday;
- (void)scrollToLastDayOfYear:(NSUInteger)year;
- (void)scrollToDayOfYear:(NSUInteger)dayOfYear;
- (void)setupForYear:(NSInteger)year;
- (LosungView*)dequeueRecycledPage;

@end

