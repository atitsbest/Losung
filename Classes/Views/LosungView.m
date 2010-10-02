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

// Fonts.
static UIFont *weekdayFont = nil;
static UIFont *stelleFont = nil;
static UIFont *textFont = nil;

/**
 * CTR
 */
- (id)init {
    if ((self = [super init])) {
        // Fonts.
		if (weekdayFont == nil) { weekdayFont = [UIFont fontWithName:@"Helvetica Neue" size:200]; }
		if (stelleFont == nil) { stelleFont = [UIFont fontWithName:@"Helvetica Neue" size:24]; }
		if (textFont == nil) { textFont = [UIFont fontWithName:@"Georgia" size:25]; }

		// Labels.
		labelWeekday = [[UILabel alloc] init];
		labelText1 = [[UILabel alloc] init]; 
		labelStelle1 = [[UILabel alloc] init]; 
		labelText2 = [[UILabel alloc] init]; 
		labelStelle2 = [[UILabel alloc] init]; 

		[self addSubview:labelWeekday];
		[self addSubview:labelText1];
		[self addSubview:labelText2];
		[self addSubview:labelStelle1];
		[self addSubview:labelStelle2];
						
		// Initialization code
		webView = [[UIWebView alloc] init];
		webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight); 
		webView.backgroundColor = [UIColor whiteColor];
		//[self addSubview:webView];
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
	
	// Losung für den übergebenen index.
	Losung *losung = [[ApplicationContext current].losungen objectAtIndex:index];

	// Name des aktuellen Wochentags ermitteln und davon nur die ersten beiden Buchstaben verwenden.
	NSString *weekday = [NSDateFormatter localizedStringFromDate:losung.datum 
													   dateStyle:NSDateFormatterFullStyle 
													   timeStyle:NSDateFormatterNoStyle];
	weekday = [[weekday substringToIndex:2] uppercaseString];
	
	NSInteger height = 0;
	NSInteger width = pagingScrollViewFrame.size.width - (2*10);
	
	// WOCHENTAG
	CGSize weekdaySize = [weekday sizeWithFont:weekdayFont];
	labelWeekday.frame = CGRectMake(-5, -90, weekdaySize.width, weekdaySize.height);
	labelWeekday.font = weekdayFont;
	labelWeekday.textColor = UIColorFromRGB(0xD8D8D8);
	labelWeekday.text = weekday;

	height = weekdaySize.height - 90;
	
	// TEXT1
	CGSize text1Size = [losung.text1 sizeWithFont:textFont 
								constrainedToSize:CGSizeMake(width, 1000)
									lineBreakMode:UILineBreakModeWordWrap];
	labelText1.frame = CGRectMake(10, height, text1Size.width, text1Size.height); 
	labelText1.lineBreakMode = UILineBreakModeWordWrap;
	labelText1.numberOfLines = 100;
	labelText1.font = textFont;
	labelText1.text = losung.text1;
	height += text1Size.height;

	// STELLE1
	CGSize stelle1Size = [losung.stelle1 sizeWithFont:stelleFont]; 
	labelStelle1.frame = CGRectMake(10, height, stelle1Size.width, stelle1Size.height); 
	labelStelle1.font = stelleFont;
	labelStelle1.textColor = UIColorFromRGB(0xD8D8D8);
	labelStelle1.text = losung.stelle1;
	height += stelle1Size.height * 2;
	
	// TEXT2
	CGSize text2Size = [losung.text2 sizeWithFont:textFont 
								constrainedToSize:CGSizeMake(width, 1000)
									lineBreakMode:UILineBreakModeWordWrap];
	labelText2.frame = CGRectMake(10, height, text2Size.width, text2Size.height); 
	labelText2.lineBreakMode = UILineBreakModeWordWrap;
	labelText2.numberOfLines = 100;
	labelText2.font = textFont;
	labelText2.text = losung.text2;
	height += text2Size.height;

	// STELLE1
	CGSize stelle2Size = [losung.stelle2 sizeWithFont:stelleFont]; 
	labelStelle2.frame = CGRectMake(10, height, stelle2Size.width, stelle2Size.height); 
	labelStelle2.font = stelleFont;
	labelStelle2.textColor = UIColorFromRGB(0xD8D8D8);
	labelStelle2.text = losung.stelle2;
	height += stelle2Size.height * 2;
	
	self.contentSize = CGSizeMake(frame.size.width, height);
	self.directionalLockEnabled = YES;
	self.bounces = YES;
}


- (void)dealloc {
	[webView release];
	[labelWeekday release];
	[labelText1 release];
	[labelText2 release];
	[labelStelle1 release];
	[labelStelle2 release];
	[super dealloc];
}


@end
