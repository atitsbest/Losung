//
//  LosungView.m
//  UIScrollViewLosung
//
//  Created by Stephan on 26.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LosungView.h"
#import "../Models/Losung.h"
#import "../ApplicationContext.h"

// HEX-Color => UIColor
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation LosungView

@synthesize index;

/**
 * CTR
 */
- (id)init {
    if ((self = [super init])) {
	}
    return self;
}

/**
 * View configurieren.
 */
- (void)configureForIndex:(NSInteger)inIndex {
	index = inIndex;

	// Angezeigter Bereich.
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
	// Position & Ausdehnung der akutellen Losung berechnen.
	CGRect frame = CGRectMake((pagingScrollViewFrame.size.width*(index)), 20, pagingScrollViewFrame.size.width-0, pagingScrollViewFrame.size.height);

	// Position & Ausdehnung für die View setzen.
	self.frame = frame;
	
	// Losung für den übergebenen index.
	Losung *losung = [[ApplicationContext current].losungen objectAtIndex:(index-1)];

	// Name des aktuellen Wochentags ermitteln und davon nur die ersten beiden Buchstaben verwenden.
	NSString *weekday = [NSDateFormatter localizedStringFromDate:losung.datum 
													   dateStyle:NSDateFormatterFullStyle 
													   timeStyle:NSDateFormatterNoStyle];
	weekday = [[weekday substringToIndex:2] uppercaseString];
	

	// Heute?
	if ([self isSameDay:losung.datum likeDay:[NSDate date]]) {
		CGRect old = imageViewHeute.frame;
		imageViewHeute.frame = CGRectMake(old.size.width, -old.size.height, old.size.width*4, old.size.height*4);
		imageViewHeute.alpha = 0.0;
		imageViewHeute.hidden = NO;
		[UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionNone forView:imageViewHeute cache:YES];
		imageViewHeute.alpha = 1.0;
		imageViewHeute.frame = old;
		[UIView commitAnimations];
	}
	else {
		imageViewHeute.hidden = YES;
	}
	
	// WOCHENTAG
	labelWeekday.text = weekday;

	// DATUM
	NSString *datumText = [NSDateFormatter localizedStringFromDate:losung.datum 
														 dateStyle:NSDateFormatterLongStyle 
														 timeStyle:NSDateFormatterNoStyle];
	labelDatum.text = datumText;

	labelStelle1.text = losung.stelle1;
	labelText2.text = losung.text2;
	labelStelle2.text = losung.stelle2;

	NSInteger height = labelText1.frame.origin.y;
	NSInteger horizontal_margin = labelText1.frame.origin.x;
	NSInteger width = pagingScrollViewFrame.size.width - (2*horizontal_margin);
	
	// TEXT1
	CGSize text1Size = [losung.text1 sizeWithFont:[labelText1 font] 
								constrainedToSize:CGSizeMake(width, 1000)
									lineBreakMode:UILineBreakModeWordWrap];
	labelText1.frame = CGRectMake(horizontal_margin, height, text1Size.width, text1Size.height); 
	labelText1.lineBreakMode = UILineBreakModeWordWrap;
	labelText1.numberOfLines = 100;
	labelText1.text = losung.text1;
	height += text1Size.height + 4;

	// STELLE1
	CGSize stelle1Size = [losung.stelle1 sizeWithFont:[labelStelle1 font]]; 
	labelStelle1.frame = CGRectMake(horizontal_margin, height, stelle1Size.width, stelle1Size.height); 
	labelStelle1.text = losung.stelle1;
	height += stelle1Size.height * 2;

	
	// TEXT2
	CGSize text2Size = [losung.text2 sizeWithFont:[labelText2 font] 
								constrainedToSize:CGSizeMake(width, 1000)
									lineBreakMode:UILineBreakModeWordWrap];
	labelText2.frame = CGRectMake(horizontal_margin, height, text2Size.width, text2Size.height); 
	labelText2.lineBreakMode = UILineBreakModeWordWrap;
	labelText2.numberOfLines = 100;
	labelText2.text = losung.text2;
	height += text2Size.height + 4;

	// STELLE1
	CGSize stelle2Size = [losung.stelle2 sizeWithFont:[labelStelle2 font]]; 
	labelStelle2.frame = CGRectMake(horizontal_margin, height, stelle2Size.width, stelle2Size.height); 
	labelStelle2.text = losung.stelle2;
	height += stelle2Size.height * 3;
	
	scrollView.contentSize = CGSizeMake(frame.size.width, height);
	self.directionalLockEnabled = YES;
	self.bounces = YES;
    
/*    scrollView.frame = CGRectMake(
                                  -scrollView.frame.size.width, 
                                  scrollView.frame.origin.y, 
                                  scrollView.frame.size.width, 
                                  scrollView.frame.size.height);
*//*    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone 
                           forView:labelText1 
                             cache:YES];
  */  /*scrollView.frame = CGRectMake(
                                  0, 
                                  scrollView.frame.origin.y, 
                                  scrollView.frame.size.width, 
                                  scrollView.frame.size.height);
    /*[UIView commitAnimations];
*/
    
    // An den Anfang scrollen.
    [scrollView setContentOffset:CGPointMake(0, 0)];
}
	 
/**
 * Sind zwei NSDate vom gleichen Tag?
 */
- (BOOL)isSameDay:(NSDate*)date1 likeDay:(NSDate*)date2 {
	 NSCalendar* calendar = [NSCalendar currentCalendar];
	 
	 unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
	 NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
	 NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
	 
	 return [comp1 day]   == [comp2 day] &&
	 [comp1 month] == [comp2 month] &&
	 [comp1 year]  == [comp2 year];
 }


- (void)dealloc {
	[super dealloc];
}


@end
