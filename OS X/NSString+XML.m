//
//  NSString+XML.m
//  Dripwn
//
//  Created by James Munnelly on 04/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import "NSString+XML.h"


@implementation NSString (XML)

- (NSString *) dataAsStringForKey:(NSString *)key {
	NSString *this = [NSString stringWithString:self];
	NSRange rangeEnd = [this rangeOfString:[NSString stringWithFormat:@"<key>%@</key>", key]];
	this = [this substringFromIndex:rangeEnd.location+rangeEnd.length];
	return [self stringWrappedWith:@"<data>" ending:@"</data>" source:this];

}

- (NSString *) stringAsStringForKey:(NSString *)key {
	NSString *this = [NSString stringWithString:self];
	NSRange rangeEnd = [this rangeOfString:[NSString stringWithFormat:@"<key>%@</key>", key]];
	this = [this substringFromIndex:rangeEnd.location+rangeEnd.length];
	return [self stringWrappedWith:@"<string>" ending:@"</string>" source:this];
}

- (NSString *) dictAsStringForKey:(NSString *) key {
	NSString *this = [NSString stringWithString:self];
	NSRange rangeEnd = [this rangeOfString:[NSString stringWithFormat:@"<key>%@</key>", key]];
	this = [this substringFromIndex:rangeEnd.location+rangeEnd.length];
	return [self stringWrappedWith:@"<dict>" ending:@"</dict>" source:this];
}

- (NSString *) stringWrappedWith:(NSString*) start ending:(NSString *)end source:(NSString*) input {
	NSRange rangeStart = [input rangeOfString:start];
	input = [input substringFromIndex:rangeStart.location];
	NSRange ending = [input rangeOfString:end];
	return [input substringWithRange:NSMakeRange(rangeStart.length, ending.location-rangeStart.length)];
}

@end
