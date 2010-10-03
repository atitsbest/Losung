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
	@protected
	UILabel *labelWeekday;
	UILabel *labelDatum;
	UILabel *labelText1; 
	UILabel *labelStelle1; 
	UILabel *labelText2; 
	UILabel *labelStelle2; 
}

- (void)configureForIndex:(NSInteger)inIndex htmlTemplate:(NSString*)htmlTemplate;
- (BOOL)isSameDay:(NSDate*)date1 likeDay:(NSDate*)date2;

@property (nonatomic, assign) NSInteger index;

@end
