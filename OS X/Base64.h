//
//  Base64.h
//  Dripwn
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Base64 : NSObject {

}

+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength;
+ (NSData*) decode:(NSString*) string;

@end
