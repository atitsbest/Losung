//
//  LosungView.h
//  UIScrollViewLosung
//
//  Created by Stephan on 26.09.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Losung;

@interface LosungView : UIView {
	NSInteger index;
	
	UIWebView *webView;
}

- (void)configureForIndex:(NSInteger)inIndex htmlTemplate:(NSString*)htmlTemplate;

@property (nonatomic, assign) NSInteger index;

@end
