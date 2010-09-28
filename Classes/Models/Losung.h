//  Created by Stephan on 18.07.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

@interface Losung : NSObject {
	NSDate *datum;
	NSString *feiertag;
	NSString *stelle1;
	NSString *text1;
	NSString *stelle2;
	NSString *text2;
}

// CTR
- (id) initWithDatum:(NSDate*)inDatum 
			feiertag:(NSString*)inFeiertag 
			 stelle1:(NSString*)inStelle1
			   text1:(NSString*)inText1
			 stelle2:(NSString*)inStelle2
			   text2:(NSString*)inText2;

@property(nonatomic, retain) NSDate *datum;
@property(nonatomic, retain) NSString *feiertag;
@property(nonatomic, retain) NSString *stelle1;
@property(nonatomic, retain) NSString *text1;
@property(nonatomic, retain) NSString *stelle2;
@property(nonatomic, retain) NSString *text2;

@end

