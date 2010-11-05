//
//  UIScrollViewLosungViewController.m
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Models/Losung.h"
#import "ApplicationContext.h"
#import "Repositories/LosungRepository.h"
#import "UIScrollViewLosungViewController.h"
#import "Views/LosungView.h"

@implementation UIScrollViewLosungViewController

@synthesize losungView;

// Rotierung konfigurieren.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	// Wir unterbinden alle Rotationen.
	return NO;
}

- (void)loadView {
	// Init.
	visiblePages = [[NSMutableSet alloc] init];
	recycledPages = [[NSMutableSet alloc] init];
	
	// Vorlage für die Losung laden.
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *templatePath = [NSString stringWithFormat:@"%@/losung.html", resourcePath];
    NSStringEncoding *encoding = nil;
	NSError *error = nil;
	htmlTemplate = [[NSString stringWithContentsOfFile:templatePath usedEncoding:encoding error:&error] retain];
	// TODO: Error überprüfen.
}

- (void)viewDidLoad {
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
	pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	pagingScrollView.pagingEnabled = YES;
	pagingScrollView.contentSize = CGSizeMake(
											  pagingScrollViewFrame.size.width * [[ApplicationContext current].losungen count], 
											  pagingScrollViewFrame.size.height);
	pagingScrollView.backgroundColor = [UIColor whiteColor];
	pagingScrollView.delegate = self;
	self.view = pagingScrollView;
	
	[self tileLosungViews];

}

-(void)viewWillAppear:(BOOL)animated {
	[self scrollToToday];
}

/**
 * Es wurde gescrollt.
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self tileLosungViews];
}

/**
 * Berührung hat geendet.
 */
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for(UITouch *touch in touches) {
		if (touch.tapCount >= 2) {
			[self scrollToToday];
		}
	}
}

/**
 * Nur die nötigen Losungen anzeigen.
 */
- (void)tileLosungViews {
	// Welche Seiten sollen sichtbar sein?
	// INFO: UIWebView hat ein Problem mit Scrollviews. UIWebView zeichnet seinen Inhalt erst dann neu
	//		 wenn die Scrollview fertig "gescrollt" hat. Dann ist aber schon die WebView mit dem falschen
	//		 Inhalt sichtbar. Damit das nicht passiert, erzeugen wir immer zwei WebViews, jeweils rechts
	//		 und links die (noch) nicht sichtbar sind.
	CGRect visibleBounds = pagingScrollView.bounds; // Alle 356 Tage.
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
	
	// Sicher gehen dass wir auf keiner Seite über die Grenzen hinausschießen.
	firstNeededPageIndex = MAX(0, firstNeededPageIndex);
	lastNeededPageIndex = MIN([[ApplicationContext current].losungen count], lastNeededPageIndex);
	
	// Seiten die nicht mehr sichtbar sind aus der View entfernen und recyclen.
	for(LosungView *page in visiblePages) {
		if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
			[recycledPages addObject:page];
			[page removeFromSuperview];
		}
	}
	// INFO: Weil wir in der oberen Schleife visiblePages iterieren, können wir es nicht ändern.
	//		 Darum machen wir das nach der Iteration so:
	[visiblePages minusSet:recycledPages];
	
	// Jetzt sind alle Views, die nicht mehr sichtbar sind aus der Superview entfernt und
	// sind im Recycling-Set gelandet.
	// Jetzt werden die sichtbaren View erstellt.
	for (int index=firstNeededPageIndex; index<=lastNeededPageIndex; index+=1) {
		if (![self isDisplayingLosungForIndex:index]) {
			// LosungView erstellen.
			LosungView *page = [self dequeueRecycledPage];
			if (page == nil) {
				//page = [[[LosungView alloc] init] autorelease];
				[[NSBundle mainBundle] loadNibNamed:@"LosungView" owner:self options:nil];
				page = self.losungView;
			}
			[page configureForIndex:index htmlTemplate:htmlTemplate];
			[pagingScrollView addSubview:page];
			[visiblePages addObject:page];
		}
	}
									
}

/**
 * Scrollt die Losungen zum heutigen Tag.
 */
- (void) scrollToToday {
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
	// Zum aktuellen Tag scrollen.
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSUInteger dayOfYear =[gregorian ordinalityOfUnit:NSDayCalendarUnit
											   inUnit:NSYearCalendarUnit 
											  forDate:[NSDate date]] - 1;
	[pagingScrollView setContentOffset:CGPointMake(CGRectGetWidth(pagingScrollViewFrame) * dayOfYear, 0) 
							  animated:NO];
}

/**
 * Lieft YES zurück, wenn die Losung mit dem angegeben Index gerade sichtbar ist.
 */
- (BOOL)isDisplayingLosungForIndex:(NSInteger)index {
	for(LosungView* page in visiblePages) {
		if (page.index == index) {
			return YES;
		}
	}
	
	return NO;
}

/**
 * Wenn es eine "recyclete" LosungView gibt, wird sie zurückgeliefert. Sonst nil.
 */
- (LosungView*)dequeueRecycledPage {
	LosungView *page = [recycledPages anyObject];
	if (page) {
		[[page retain] autorelease]; // WICHTIG: Denn mit dem removeObject wird auch ein release aufgerufen.
		[recycledPages removeObject:page];
	}
	
	return page;
}


// DTR
- (void) dealloc
{
	[htmlTemplate release];
	[losungen release];
	[visiblePages release];
	[recycledPages release];
	[losungView release];
	[super dealloc];
}


@end
