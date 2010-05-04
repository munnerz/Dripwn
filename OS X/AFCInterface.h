//
//  AFConnect.h
//  AFConnect
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MobileDevice.h"


@interface AFCInterface : NSObject {
	struct afc_connection *afc_handle;
}

-(id)initWithAFCConnection:(struct afc_connection *)handle;

-(BOOL)removePath:(NSString *)path;
-(BOOL)renamePath:(NSString *)from to:(NSString *)to;
-(BOOL)createDirectory:(NSString *)path;
-(NSArray *)listFilesInPath:(NSString *)path;
-(BOOL)isDirectoryAtPath:(NSString *)path;
-(BOOL)isFileAtPath:(NSString *)path;
-(NSDictionary *)getAttributesAtPath:(NSString *)path;
-(NSDictionary *)getDeviceAttributes;
-(unsigned long long)openFileAtPath:(NSString *)path withMode:(int)mode;
-(BOOL)closeFile:(unsigned long long)rAFC;
-(NSData *)readFromFile:(unsigned long long)rAFC size:(unsigned int *)size offset:(off_t)offset;

-(BOOL)writeToFile:(unsigned long long)rAFC data:(const char *)data size:(size_t)size offset:(off_t)offset;
-(BOOL)setSizeOfFile:(NSString *)path toSize:(off_t)size ;

-(NSDictionary *)createDictionaryForAFCDictionary:(struct afc_dictionary *)dict;

@end
