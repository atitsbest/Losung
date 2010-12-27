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
	pagingScrollView.backgroundColor = [UIColor blackColor];
}

- (void)viewDidLoad {
	[self setupForYear:[ApplicationContext current].currentYear];
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


- (void)startupHideAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	[splashView removeFromSuperview];
    [splashView release];
	splashView = nil;
	[pagingScrollView.window bringSubviewToFront:pagingScrollView];

}

- (void)startupShowAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	NSNumber *direction = (NSNumber*)context;
	NSInteger year = [ApplicationContext current].currentYear + [direction intValue];
	[self setupForYear:year];
	if ([direction intValue] == -1) {
		[self scrollToDayOfYear:365];
	}
	[direction release];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:pagingScrollView.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupHideAnimationDone:finished:context:)];
	splashView.alpha = 0.0;
    splashView.frame = CGRectMake(-60, -60, 440, 600);
    [UIView commitAnimations];
}

- (void)changeYear:(NSInteger)direction {
	if (splashView != nil) return;
    splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    splashView.image = [UIImage imageNamed:@"Default.png"];
	splashView.alpha = 0.0;
    [pagingScrollView.window addSubview:splashView];
    [pagingScrollView.window bringSubviewToFront:splashView];
    [UIView beginAnimations:nil context:[[NSNumber numberWithInt:direction] retain]];
    [UIView setAnimationDuration:.7];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:pagingScrollView.window cache:YES];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(startupShowAnimationDone:finished:context:)];
	splashView.alpha = 1.0;
    [UIView commitAnimations];
//	[self setupForYear:[ApplicationContext current].currentYear + direction];
}



/**
 * Nur die nötigen Losungen anzeigen.
 */
- (void)tileLosungViews {
	// Welche Seiten sollen sichtbar sein?
	CGRect visibleBounds = pagingScrollView.bounds; // Alle 356 Tage.
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
	
	// Sicher gehen dass wir auf keiner Seite über die Grenzen hinausschießen.
	firstNeededPageIndex = MAX(0, firstNeededPageIndex);
	lastNeededPageIndex = MIN([[ApplicationContext current].losungen count] + 1, lastNeededPageIndex);
	
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
			if (index == ([[ApplicationContext current].losungen count] + 1)) {
				[self changeYear:+1];
			}
			else if (index == 0) {
				[self changeYear:-1];
			}
			else {
				// LosungView erstellen.
				LosungView *page = [self dequeueRecycledPage];
				if (page == nil) {
					[[NSBundle mainBundle] loadNibNamed:@"LosungView" owner:self options:nil];
					page = self.losungView;
				}
				[page configureForIndex:index];
				[pagingScrollView addSubview:page];
				[pagingScrollView bringSubviewToFront:page];
				[visiblePages addObject:page];
			}
		}
	}
									
}

/**
 * Scrollt die Losungen zum heutigen Tag.
 */
- (void) scrollToToday {
	// Zum aktuellen Tag scrollen.
	NSCalendar *gregorian = [[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease];
	NSUInteger dayOfYear =[gregorian ordinalityOfUnit:NSDayCalendarUnit
											   inUnit:NSYearCalendarUnit 
											  forDate:[NSDate date]];
	// TODO: Entfernen!
	dayOfYear = 363;
	[self scrollToDayOfYear:dayOfYear];
}

/**
 * Scrollt die Losungen zum angegebenen Tag.
 */
- (void) scrollToDayOfYear:(NSUInteger)dayOfYear {
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
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

- (void)setupForYear:(NSInteger)year {
	[ApplicationContext current].currentYear = year;
	
	// Angezeigte Losungen von der Scrollview entfernen.
	for(LosungView *page in visiblePages) {
		[recycledPages addObject:page];
		[page removeFromSuperview];
	}
	
	// Alle Losungen von der DB laden und sortieren.
	LosungRepository *repository = [[[LosungRepository alloc] init] autorelease];
	[ApplicationContext current].losungen = [[repository getLosungenForYear:[ApplicationContext current].currentYear] sortedArrayUsingComparator:
		 ^(id a, id b) {
			 return [((Losung*)a).datum compare:((Losung*)b).datum];
		 }
	 ];
	
	// Scrollview initialisieren, so dass die Losungen eines ganzen Jahres drauf passen.
	CGRect pagingScrollViewFrame = [[UIScreen mainScreen] bounds];
	pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
	pagingScrollView.pagingEnabled = YES;
	pagingScrollView.contentSize = CGSizeMake(
											  pagingScrollViewFrame.size.width * ([[ApplicationContext current].losungen count] + 2), 
											  pagingScrollViewFrame.size.height);
	pagingScrollView.backgroundColor = [UIColor whiteColor];
	pagingScrollView.delegate = self;
	self.view = pagingScrollView;
	
	if (splashView != nil) {
		[pagingScrollView.window bringSubviewToFront:splashView];
	}
	[pagingScrollView setContentOffset:CGPointMake(CGRectGetWidth(pagingScrollViewFrame) * 1, 0) 
							  animated:NO];
}


// DTR
- (void) dealloc
{
	[losungen release];
	[visiblePages release];
	[recycledPages release];
	[losungView release];
	[super dealloc];
}


@end
