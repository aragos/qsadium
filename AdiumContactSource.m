// Copyright Google Inc. 2011. All rights reserved.
// Author: aragos@gmail.com (Peter Schmitt)
//
// Provides Adium contacts to Quicksilver by querying Adium's AppleScript
// interface.

#import "AdiumContactSource.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import "AdiumApp.h"
#import <Foundation/Foundation.h>


@implementation AdiumContactSource
- (BOOL)indexIsValidFromDate:(NSDate *)indexDate forEntry:(NSDictionary *)theEntry{
    // We can't easily tell whether there has been a new contact recently so instead we rescan
    // every time we're queried.
    return NO;
}

- (NSImage *) iconForEntry:(NSDictionary *)dict{
    // Entries are already set with icons when we generate them.
    return nil;
}

/*
 * Returns source objects for all contacts present in Adium at the time this method is called.
 *
 * Returned objects use Adium-internal contact IDs for unique identification. By default the
 * name displayed on the object is Adium's contact name but if Adium also has a display name
 * for the same contact that will be added as a label. In the latter case the object is 
 * searchable by either their contact or display name.
 *
 * If an image is available in Adium, this method will set it on the returned source object. 
 * Otherwise the default Adium app image is used for the contact.
 */
- (NSArray *) objectsForEntry:(NSDictionary *)theEntry{	
	AdiumApplication *adium = [SBApplication applicationWithBundleIdentifier:@"com.adiumX.adiumX"];
	
	NSMutableArray *objects = [NSMutableArray arrayWithCapacity:1];
	QSObject *newObject;
	for (AdiumContact *contact in [adium contacts]) {
		newObject = [QSObject objectWithName:[contact name]];
		if ([contact displayName] != nil) {
			[newObject setLabel:[contact displayName]];
			[newObject setObject:[contact displayName] forType:kAdiumContactType];
		} else {
			[newObject setObject:[contact name] forType:kAdiumContactType];
		}
		[newObject setPrimaryType:kAdiumContactType];
		[newObject setIdentifier:[contact ID]];
		if ([contact image] != nil) {
			[newObject setIcon:[contact image]];
		} else {
			[newObject setIcon:[QSResourceManager imageNamed:@"com.adiumX.adiumX"]];
		}
		[objects addObject:newObject];
	}  
    return objects;    
}
@end
