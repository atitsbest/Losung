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


@implementation LosungView

@synthesize index;

/**
 * CTR
 */
- (id)init {
    if ((self = [super init])) {
        // Initialization code
		webView = [[UIWebView alloc] init];
		webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
		webView.backgroundColor = [UIColor whiteColor];
		[self addSubview:webView];
	}
    return self;
}

/**
 * View configurieren.
 */
- (void)configureForIndex:(NSInteger)inIndex htmlTemplate:(NSString*)htmlTemplate {
	index = inIndex;

	// Angezeigter Bereich.
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
	// Position & Ausdehnung der akutellen Losung berechnen.
	CGRect frame = CGRectMake(5+(pagingScrollViewFrame.size.width*index), 5, pagingScrollViewFrame.size.width-10, pagingScrollViewFrame.size.height);

	// Position & Ausdehnung für die View setzen.
	self.frame = frame;
	webView.frame = [self bounds];
	
	// Losung für den übergebenen index.
	Losung *losung = [[ApplicationContext current].losungen objectAtIndex:index];

	// Name des aktuellen Wochentags ermitteln und davon nur die ersten beiden Buchstaben verwenden.
	NSString *weekday = [NSDateFormatter localizedStringFromDate:losung.datum 
													   dateStyle:NSDateFormatterFullStyle 
													   timeStyle:NSDateFormatterNoStyle];
	weekday = [weekday substringToIndex:2];
	
	[webView loadHTMLString:[NSString stringWithFormat:htmlTemplate
							 , weekday
							 , [NSDateFormatter localizedStringFromDate:losung.datum 
															  dateStyle:NSDateFormatterLongStyle 
															  timeStyle:NSDateFormatterNoStyle]
							 , losung.text1
							 , losung.stelle1
							 , losung.text2
							 , losung.stelle2]
					baseURL:nil];
}


- (void)dealloc {
	[webView release];
    [super dealloc];
}


@end
