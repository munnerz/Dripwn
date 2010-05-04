//
//  NSString+XML.h
//  Dripwn
//
//  Created by James Munnelly on 04/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (XML)

- (NSString *) dataAsStringForKey:(NSString *)key;
- (NSString *) stringAsStringForKey:(NSString *)key;
- (NSString *) dictAsStringForKey:(NSString *) key;
- (NSString *) stringWrappedWith:(NSString*) start ending:(NSString *)end source:(NSString*) input;

@end
