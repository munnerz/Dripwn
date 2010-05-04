//
//  AFConnect.m
//  AFConnect
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import "AFCInterface.h"


@implementation AFCInterface

-(id)initWithAFCConnection:(struct afc_connection *)handle {
	
	if (self = [super init]) {
		afc_handle = handle;
	}
	
	return self;
	
}

-(BOOL)removePath:(NSString *)path {
	return AFCRemovePath(afc_handle, [path UTF8String]) == 0;
}

-(BOOL)renamePath:(NSString *)from to:(NSString *)to {
	return AFCRenamePath(afc_handle, [from UTF8String], 
						 [to UTF8String]) == 0;
}

-(BOOL)createDirectory:(NSString *)path {
	return AFCDirectoryCreate(afc_handle, [path UTF8String]) == 0;
}

-(NSArray *)listFilesInPath:(NSString *)path {
	
	struct afc_directory *hAFCDir;
	
	if (AFCDirectoryOpen(afc_handle, [path UTF8String], &hAFCDir) != 0) {
		[NSException raise:@"" format:@""];
		return nil;
	} else {
		
		NSMutableArray *fileList = [[NSMutableArray alloc] init];
		char *buffer = nil;
		
		do {
			AFCDirectoryRead(afc_handle, hAFCDir, &buffer);
			if (buffer != nil) {
				[fileList addObject:[NSString stringWithCString:buffer]];
			}
		} while (buffer != nil);
		
		AFCDirectoryClose(afc_handle, hAFCDir);
		
		return [fileList autorelease];
		
	}
}

-(BOOL)isDirectoryAtPath:(NSString *)path {
	NSDictionary *dict = [self getAttributesAtPath:path];
	return dict && [[dict valueForKey:@"st_ifmt"] isEqualToString:@"S_IFDIR"];
}


-(BOOL)isFileAtPath:(NSString *)path {
	NSDictionary *dict = [self getAttributesAtPath:path];
	return dict && [[dict valueForKey:@"st_ifmt"] isEqualToString:@"S_IFREG"];
	
}


-(NSDictionary *)getAttributesAtPath:(NSString *)path {
	
	struct afc_dictionary *info;
	
	if (AFCFileInfoOpen(afc_handle, [path UTF8String], &info) != 0) {
		return nil;
	} 
	
	NSDictionary *fileProperties = [self createDictionaryForAFCDictionary:info];
	AFCKeyValueClose(info);
	
	
	return fileProperties;	
}

-(NSDictionary *)getDeviceAttributes {
	
	struct afc_dictionary *info;
	if (AFCDeviceInfoOpen(afc_handle, &info) != 0) {
		return nil;
	} 
	
	NSDictionary *deviceProperties = [self createDictionaryForAFCDictionary:info];
	AFCKeyValueClose(info);
	
	return deviceProperties;	
}


-(unsigned long long)openFileAtPath:(NSString *)path withMode:(int)mode {
	
	afc_file_ref rAFC;
	
	int ret = AFCFileRefOpen(afc_handle, [path UTF8String], mode, &rAFC);
	if (ret != 0) {
		NSLog(@"AFCFileRefOpen(%d): %d", mode, ret);
		return 0;
	}
	return rAFC;
}


-(BOOL)closeFile:(unsigned long long)rAFC {
	return AFCFileRefClose(afc_handle, rAFC) == 0;
}


-(NSData *)readFromFile:(unsigned long long)rAFC size:(unsigned int *)size offset:(off_t)offset {
	
	int ret = AFCFileRefSeek(afc_handle, rAFC, offset, 0);
	
	if (ret != 0) {
		return nil;
	}
	
    char *buffer = malloc(*size);
    unsigned int s = *size;
    
	ret = AFCFileRefRead(afc_handle, rAFC, buffer, &s);
	
	if (ret != 0) {
        //buffer = nil;
        NSLog(@"ret: %d", ret);
		return nil;
	}
    
    *size = s;
    
    NSData *data = [NSData dataWithBytes:buffer length:s];
    
    free(buffer);
    
    //buffer = buf;
	
	return data;	
}


-(BOOL)writeToFile:(unsigned long long)rAFC data:(const char *)data size:(size_t)size offset:(off_t)offset {
	
	if (size > 0) {
		
		int ret = AFCFileRefSeek(afc_handle, rAFC, offset, 0);
		
		if (ret != 0) {
			return NO;
		}
		
		ret = AFCFileRefWrite(afc_handle, rAFC, data, (unsigned long)size);
		
		if (ret != 0) {
			return NO;
		}
	}		
	
	// Writing 0 bytes can't fail, really.
	return YES;
}

-(BOOL)setSizeOfFile:(NSString *)path toSize:(off_t)size {
	
	afc_file_ref rAFC;
	int ret = AFCFileRefOpen(afc_handle, [path UTF8String], 3, &rAFC);
	
	if (ret != 0) {
		return NO;
	}
	
	ret = AFCFileRefSetFileSize(afc_handle, rAFC, size);
	AFCFileRefClose(afc_handle, rAFC);
	
	if (ret != 0) {
		return NO;
	}
	
	return YES;
	
}

-(NSDictionary *)createDictionaryForAFCDictionary:(struct afc_dictionary *)dict {
	
	NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
	char *key, *val;
	
	while ((AFCKeyValueRead(dict, &key, &val) == 0) && key && val) {
		[dictionary setValue:[NSString stringWithCString:val] forKey:[NSString stringWithCString:key]];
	}
	
	return [dictionary autorelease];
	
}

@end
