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
	IBOutlet UILabel *labelWeekday;
	IBOutlet UILabel *labelDatum;
	IBOutlet UILabel *labelText1; 
	IBOutlet UILabel *labelStelle1; 
	IBOutlet UILabel *labelText2; 
	IBOutlet UILabel *labelStelle2; 
	IBOutlet UIScrollView *scrollView;
	IBOutlet UIImageView *imageViewHeute;
}

- (void)configureForIndex:(NSInteger)inIndex;
- (BOOL)isSameDay:(NSDate*)date1 likeDay:(NSDate*)date2;

@property (nonatomic, assign) NSInteger index;

@end
