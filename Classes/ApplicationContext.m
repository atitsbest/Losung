//
//  ApplicationContext.m
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ApplicationContext.h"


@implementation ApplicationContext

static ApplicationContext* current;

@synthesize databaseName, databasePath, losungen;

// Initialize the singleton instance if needed and return
+ (ApplicationContext *)current {
	if (!current) {
		current = [[ApplicationContext alloc] init];
	}
	return current;
}

+ (id)alloc {
	NSAssert(current == nil, @"Attempted to allocate a second instance of a singleton.");
	current = [super alloc];
	return current;
}

+ (id)copy {
	NSAssert(current == nil, @"Attempted to copy the singleton.");
	return current;
}

/**
 * DTR
 */
- (void) dealloc
{
	[super dealloc];
}


@end
