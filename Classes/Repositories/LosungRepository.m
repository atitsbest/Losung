//
//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <sqlite3.h>
#import "../Models/Losung.h"
#import "LosungRepository.h"
#import "../ApplicationContext.h"

@implementation LosungRepository


/**
 * CTR
 */
- (id) init
{
	self = [super init];
	if (self != nil) {
		db = nil;
		// TODO: Fehlerbehandlung.
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[ApplicationContext current].databaseName];
		sqlite3_open([databasePathFromApp UTF8String], &db);
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"dd.MM.yyyy"];
	}
	return self;
}

//
// Liefert ein NSArray mit allen Losungen für das übergebene Jahr zurück.
//
- (NSArray*)getLosungenForYear:(NSInteger)year {
	NSMutableArray* result = [[[NSMutableArray alloc] init] autorelease];
	
	// SQL Query zusammenbauen.
	NSString* sql = [NSString stringWithFormat:@"SELECT * FROM losungen WHERE datum like '%%%i%%'", year];
	
	// Statement vorbereiten.
	sqlite3_stmt *statement;
	// TODO: Fehlerbehandlung.
	sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL);
	
	// Resultat auslesen.
	while(sqlite3_step(statement) != SQLITE_DONE) {
		Losung *losung = [self buildLosungFromStatement:statement];
		[result addObject:losung];
	}
	
	// Fertig mit der DB.
	sqlite3_finalize(statement);
	
	return result;
}

/**
 * Liefert die Losung für den angegebenen Tag.
 **/
- (Losung*)getLosungForDate:(NSDate *)date {
	Losung* result = nil;
	
	// Aus dem Datum einen String machen.
	NSString* dateText = [dateFormatter stringFromDate:date];
	
	// SQL Query zusammenbauen.
	NSString* sql = [NSString stringWithFormat:@"SELECT * FROM losungen	WHERE datum = '%@'", dateText];

	// Statement vorbereiten.
	sqlite3_stmt *statement;
	// TODO: Fehlerbehandlung.
	sqlite3_prepare(db, [sql UTF8String], -1, &statement, NULL);

	// Resultat auslesen.
	if (sqlite3_step(statement) != SQLITE_DONE) {
		result = [self buildLosungFromStatement:statement];
	}

	// Fertig mit der DB.
	sqlite3_finalize(statement);
	
	return result;
}


/**
 * Baut aus einem SQLite3 Statment ein Losung-Modell zusammen.
 */
- (Losung *) buildLosungFromStatement:(sqlite3_stmt*)statement {
	Losung *result= nil;
	NSString* dateString = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 0)];
	NSString* feiertag = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 2)];
	NSString* stelle1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 3)];
	NSString* text1 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 4)];
	NSString* stelle2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 5)];
	NSString* text2 = [NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 6)];

	// Aus dem Datumsstring ein NSDate ermitteln.
	NSDate *date = [dateFormatter dateFromString:dateString];
	
	// Losung Model erstellen.
	result = [[[Losung alloc] initWithDatum:date 
								   feiertag:feiertag 
									stelle1:stelle1 
									  text1:text1 
									stelle2:stelle2 
									  text2:text2] autorelease];
	return result;
}


/**
 * DTR
 */
- (void) dealloc
{
	// Datenbank wieder schließen.
	if (db != nil) {
		sqlite3_close(db);
	}
	[dateFormatter release];
	[super dealloc];
}


@end

