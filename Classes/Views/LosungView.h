//
//  LosungView.h
//  UIScrollViewLosung
//
//  Created by Stephan on 26.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Losung;

@interface LosungView : UIScrollView {
	NSInteger index;

	// Controls.
	UIWebView *webView;

	@protected
	UILabel *labelWeekday;
	UILabel *labelText1; 
	UILabel *labelStelle1; 
	UILabel *labelText2; 
	UILabel *labelStelle2; 
}

- (void)configureForIndex:(NSInteger)inIndex htmlTemplate:(NSString*)htmlTemplate;

@property (nonatomic, assign) NSInteger index;

@end
