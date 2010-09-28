//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <sqlite3.h>

@class Losung;

@interface LosungRepository : NSObject {
@private
	// Zugriff auf die SQLite3 Datenbank.
	sqlite3* db;
}

- (NSArray*) getLosungen;
- (Losung*) getLosungForDate:(NSDate*)date;

// TODO: private
- (Losung*)buildLosungFromStatement:(sqlite3_stmt *)statement;

@end