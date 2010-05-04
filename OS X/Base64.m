//
//  Base64.m
//  Dripwn
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import "Base64.h"


@implementation Base64

#define ArrayLength(x) (sizeof(x)/sizeof(*(x)))

static char decodingTable[128];

+ (NSData*) decode:(const char*) string length:(NSInteger) inputLength {
	if ((string == NULL) || (inputLength % 4 != 0)) {
		return nil;
	}
	
	while (inputLength > 0 && string[inputLength - 1] == '=') {
		inputLength--;
	}
	
	NSInteger outputLength = inputLength * 3 / 4;
	NSMutableData* data = [NSMutableData dataWithLength:outputLength];
	uint8_t* output = data.mutableBytes;
	
	NSInteger inputPoint = 0;
	NSInteger outputPoint = 0;
	while (inputPoint < inputLength) {
		char i0 = string[inputPoint++];
		char i1 = string[inputPoint++];
		char i2 = inputPoint < inputLength ? string[inputPoint++] : 'A'; /* 'A' will decode to \0 */
		char i3 = inputPoint < inputLength ? string[inputPoint++] : 'A';
		
		output[outputPoint++] = (decodingTable[i0] << 2) | (decodingTable[i1] >> 4);
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i1] & 0xf) << 4) | (decodingTable[i2] >> 2);
		}
		if (outputPoint < outputLength) {
			output[outputPoint++] = ((decodingTable[i2] & 0x3) << 6) | decodingTable[i3];
		}
	}
	
	return data;
}


+ (NSData*) decode:(NSString*) string {
	return [self decode:[string cStringUsingEncoding:NSASCIIStringEncoding] length:string.length];
}

@end
