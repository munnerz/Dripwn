//
//  DripwnAppDelegate.h
//  Dripwn
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AFCFactory.h"
#import "AFCDevice.h"
#import "File.h"


typedef enum {
	NSDeviceTypeNone,
	NSDeviceTypeiPod11,
	NSDeviceTypeiPod12,
	NSDeviceTypeiPod21,
	NSDeviceTypeiPhone11,
	NSDeviceTypeiPhone12,
	NSDeviceTypeiPhone21,
} NSDeviceType;

#if (MAC_OS_X_VERSION_MAX_ALLOWED <= MAC_OS_X_VERSION_10_5)
@interface DripwnAppDelegate : NSObject
#else
@interface DripwnAppDelegate : NSObject <NSApplicationDelegate>
#endif
{    
	NSWindow *window;
	AFCDevice *iPhone;
	NSString *serialNumber;
	NSDeviceType deviceType;
}

- (void) openSavePanel: (id) sender;
- (void)savePath:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo;
- (NSArray *)filesAtPath:(NSString *)path;

- (void) AFCDeviceWasConnected:(AFCDeviceRef *)dev;
-(void)deviceWasDisconnected:(AFCDevice *)device;

- (void) reset;
- (NSString *) sanitisedName;

@property (assign) IBOutlet NSWindow *window;

@end
