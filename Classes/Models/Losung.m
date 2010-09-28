//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Losung.h"

@implementation Losung

@synthesize datum, feiertag, stelle1, text1, stelle2, text2;

/**
 * CTR
 */
- (id) initWithDatum:(NSDate*)inDatum 
			feiertag:(NSString*)inFeiertag 
			 stelle1:(NSString*)inStelle1
			   text1:(NSString*)inText1
			 stelle2:(NSString*)inStelle2
			   text2:(NSString*)inText2
{
	self = [super init];
	if (self != nil) {
		datum = [inDatum retain];
		feiertag = [inFeiertag retain];
		stelle1 = [inStelle1 retain];
		text1 = [inText1 retain];
		stelle2 = [inStelle2 retain];
		text2 = [inText2 retain];
	}
	return self;
}


- (void)dealloc {
	[datum release];
	[feiertag release];
	[stelle1 release];
	[text1 release];
	[stelle2 release];
	[text2 release];
    [super dealloc];
}

@end

