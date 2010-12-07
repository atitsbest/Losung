//
//  ApplicationContext.h
//  UIScrollViewLosung
//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Losung;

@interface ApplicationContext : NSObject {
	NSString *databaseName;
	NSString *databasePath;
	
	NSArray *losungen;		// Alle Losungen für das aktuelle Jahr.
	NSInteger currentYear;	// Das aktuelle Jahr (z.B.: 2010)
}

+ (ApplicationContext*) current;

@property(nonatomic, retain) NSString *databaseName;
@property(nonatomic, retain) NSString *databasePath;
@property(nonatomic, retain) NSArray *losungen;
@property(nonatomic, assign) NSInteger currentYear;

@end
