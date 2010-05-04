//
//  DripwnAppDelegate.m
//  Dripwn
//
//  Created by James Munnelly on 03/05/2010.
//  Copyright 2010 JamWare. All rights reserved.
//

#import "DripwnAppDelegate.h"
#import "AFCFactory.h"
#import "Base64.h"
#import "NSString+XML.h"
#import "MobileDevice.h"


@implementation DripwnAppDelegate

@synthesize window;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	deviceType = NSDeviceTypeNone;
	NSRect center = [[window contentView] frame];
	center.origin.y = center.size.height - 40;
	center.size.height = 35;
	NSTextField *textField = [[NSTextField alloc] initWithFrame:center];
	[textField setAlignment:NSCenterTextAlignment];
	[textField setFont:[NSFont fontWithName:@"Lucida Grande" size:25.0f]];
	[textField setStringValue:@"Dripwn"];
	[textField setEditable:NO];
	[textField setBordered:NO];
	[textField setBezelStyle:NSTextFieldRoundedBezel];
	[[window contentView] addSubview:textField];
	[textField release];
	
	center = [[window contentView] frame];
	center.size.height = 12.0f;
	center.origin.y = 5;
	center.size.height = 15;
	textField = [[NSTextField alloc] initWithFrame:center];
	[textField setFont:[NSFont fontWithName:@"Lucida Grande" size:10.0f]];
	[textField setAlignment:NSCenterTextAlignment];
	[textField setStringValue:@"No device connected"];
	[textField setTag:3];
	[textField setEditable:NO];
	[textField setBordered:NO];
	[textField setBezelStyle:NSTextFieldRoundedBezel];
	[[window contentView] addSubview:textField];
	[textField release];
	
	center = [[window contentView] frame];
	center.origin.y = 39;
	center.origin.x = (center.size.width - 100) / 2;
	center.size.width = 100;
	center.size.height = 30;
	NSButton *button = [[NSButton alloc] initWithFrame:center];
	[button setTitle:@"Dump Zephyr"];
	[button setButtonType:NSMomentaryPushInButton];
	[button setEnabled:NO];
	[button setTag:2];
	[button setTarget:self];
	[button setAction:@selector(openSavePanel:)];
	[button setBezelStyle:NSTexturedRoundedBezelStyle];
	[[window contentView] addSubview:button];
	[button release];
	
	[[AFCFactory factory] setDelegate:self];
}

- (void) openSavePanel: (id) sender {
	NSOpenPanel *savePanel = [NSOpenPanel openPanel];
	[savePanel setCanCreateDirectories:YES];	
	[savePanel setCanChooseDirectories:YES];
	[savePanel setCanChooseFiles:NO];
	[savePanel setAllowsMultipleSelection:NO];
	[savePanel beginSheetForDirectory:nil file:nil modalForWindow:[self window] modalDelegate:self didEndSelector:@selector(savePath:returnCode:contextInfo:) contextInfo:nil];
}

-(void)savePath:(NSOpenPanel *)sheet returnCode:(int)returnCode contextInfo:(void*)contextInfo {
	if (returnCode == NSOKButton) {
		NSString *dir = [[sheet filenames] objectAtIndex:0];
		NSString *common;
		NSString *ipod;
		NSString *iphone;
		for(File *fn in [self filesAtPath:@"/usr/share/firmware/multitouch/"]) {
			if([[fn location] hasSuffix:@"Common.mtprops"]) {
				common = [[NSString alloc] initWithData:[iPhone contentsOfFileAtPath:[fn location]] encoding:NSASCIIStringEncoding];
			} else if([[fn location] hasSuffix:@"iPod.mtprops"])
				ipod = [[NSString alloc] initWithData:[iPhone contentsOfFileAtPath:[fn location]] encoding:NSASCIIStringEncoding];
			else if([[fn location] hasSuffix:@"iPhone.mtprops"])
				iphone = [[NSString alloc] initWithData:[iPhone contentsOfFileAtPath:[fn location]] encoding:NSASCIIStringEncoding];
		}
		
		switch(deviceType) {
			case NSDeviceTypeiPhone11: {
				NSString *fwDict = [iphone dictAsStringForKey:@"Z1F50,1"];
				NSString *aSpeedFirmwareVersion = [fwDict stringAsStringForKey:@"A-Speed Firmware Version"];
				NSString *aSpeedFirmwareEnc = [fwDict dataAsStringForKey:@"A-Speed Firmware"];
				NSData *aSpeed = [Base64 decode:aSpeedFirmwareEnc];
				[aSpeed writeToFile:[NSString stringWithFormat:@"%@/zephyr_aspeed.bin", dir, aSpeedFirmwareVersion] atomically:YES];
				
				NSString *firmwareVersion = [fwDict stringAsStringForKey:@"Firmware Version"];
				NSString *firmwareEnc = [fwDict dataAsStringForKey:@"Firmware"];
				NSData *firmware = [Base64 decode:firmwareEnc];
				[firmware writeToFile:[NSString stringWithFormat:@"%@/zephyr_main.bin", dir, firmwareVersion] atomically:YES];
			} break;
			case NSDeviceTypeiPhone12: {
				NSString *fwDict = [iphone dictAsStringForKey:@"Z2F52,1"];
				NSString *constFirmwareVersion = [fwDict stringAsStringForKey:@"Constructed Firmware Version"];
				NSString *constFirmwareEnc = [fwDict dataAsStringForKey:@"Constructed Firmware"];
				NSData *constFirmware = [Base64 decode:constFirmwareEnc];
				[constFirmware writeToFile:[NSString stringWithFormat:@"%@/%@", dir, constFirmwareVersion] atomically:YES];
			} break;
			case NSDeviceTypeiPhone21: {
				NSString *fwDict = [iphone dictAsStringForKey:@"N1F54,1"];
				NSString *constFirmwareVersion = [fwDict stringAsStringForKey:@"Constructed Firmware Version"];
				NSString *constFirmwareEnc = [fwDict dataAsStringForKey:@"Constructed Firmware"];
				NSData *constFirmware = [Base64 decode:constFirmwareEnc];
				[constFirmware writeToFile:[NSString stringWithFormat:@"%@/%@", dir, constFirmwareVersion] atomically:YES];
			} break;
				
			case NSDeviceTypeiPod11: {
				NSString *fwDict = [ipod dictAsStringForKey:@"Z2F51,1"];
				NSString *constFirmwareVersion = [fwDict stringAsStringForKey:@"Constructed Firmware Version"];
				NSString *constFirmwareEnc = [fwDict dataAsStringForKey:@"Constructed Firmware"];
				NSData *constFirmware = [Base64 decode:constFirmwareEnc];
				[constFirmware writeToFile:[NSString stringWithFormat:@"%@/%@", dir, constFirmwareVersion] atomically:YES];
			} break;
			case NSDeviceTypeiPod12: {
				NSString *fwDict = [ipod dictAsStringForKey:@"Z2F53,1"];
				NSString *constFirmwareVersion = [fwDict stringAsStringForKey:@"Constructed Firmware Version"];
				NSString *constFirmwareEnc = [fwDict dataAsStringForKey:@"Constructed Firmware"];
				NSData *constFirmware = [Base64 decode:constFirmwareEnc];
				[constFirmware writeToFile:[NSString stringWithFormat:@"%@/%@", dir, constFirmwareVersion] atomically:YES];
			} break;
			case NSDeviceTypeiPod21: {
				NSString *fwDict = [ipod dictAsStringForKey:@"Z2F53,1"];
				NSString *constFirmwareVersion = [fwDict stringAsStringForKey:@"Constructed Firmware Version"];
				NSString *constFirmwareEnc = [fwDict dataAsStringForKey:@"Constructed Firmware"];
				NSData *constFirmware = [Base64 decode:constFirmwareEnc];
				[constFirmware writeToFile:[NSString stringWithFormat:@"%@/%@", dir, constFirmwareVersion] atomically:YES];
			} break;
		}
		NSAlert *alert = [NSAlert alertWithMessageText:@"Extraction complete!" defaultButton:@"Okay" alternateButton:nil otherButton:nil informativeTextWithFormat:[NSString stringWithFormat:@"Extraction of Zephyr firmware files from your %@ complete.", [self sanitisedName]]];
		[alert runModal];
	}
}

-(NSArray *)filesAtPath:(NSString *)path {
	NSMutableArray *files = [[NSMutableArray alloc] init];
	NSArray *origFiles = [iPhone listOfFilesAtPath:path];

    NSEnumerator *e = [origFiles objectEnumerator];
    NSString *fileName;
    
    while (fileName = [e nextObject]) {
        [files addObject: [[[File alloc] initWithLocation:[path stringByAppendingPathComponent:fileName]] autorelease]];
    }
	
	return [files autorelease];
}


#pragma mark -
#pragma mark AFC Factory Delegates


- (void) AFCDeviceWasConnected:(AFCDeviceRef *)dev {
	
	// This is where the action happens - the factory has
	// detected a new iPhone/iPod touch.	
	
	[iPhone release];
	iPhone = nil;
	
	iPhone = [[AFCDevice alloc] initWithRef:dev];
	if (iPhone == nil) {
		//[NSException raise:@"DripwnAppDelegate" format:@"Error occurred when trying to init AFC device."];
		[[[window contentView] viewWithTag:3] setTextColor:[NSColor redColor]];
		[[[window contentView] viewWithTag:3] setStringValue:[NSString stringWithFormat:@"Error connecting to device. Ensure afc2add is installed."]];
		[NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(reset) userInfo:nil repeats:NO];
	} else {
		[iPhone setDelegate:self];
		NSString *device = [[[iPhone deviceInterface] getDeviceAttributes] objectForKey:@"Model"];
		if([device isEqualToString:@"iPhone1,1"])
			deviceType = NSDeviceTypeiPhone11;
		else if([device isEqualToString:@"iPhone1,2"])
			deviceType = NSDeviceTypeiPhone12;
		else if([device isEqualToString:@"iPhone2,1"])
			deviceType = NSDeviceTypeiPhone21;
		else if([device isEqualToString:@"iPod1,1"])
			deviceType = NSDeviceTypeiPod11;
		else if([device isEqualToString:@"iPod1,2"])
			deviceType = NSDeviceTypeiPod12;
		else if([device isEqualToString:@"iPod2,1"])
			deviceType = NSDeviceTypeiPod21;
		
		[[[window contentView] viewWithTag:3] setTextColor:[NSColor greenColor]];
		[[[window contentView] viewWithTag:3] setStringValue:[NSString stringWithFormat:@"%@ connected", [self sanitisedName]]];
		[[[window contentView] viewWithTag:2] setEnabled:YES];
	}
}

- (void) reset {
	deviceType = NSDeviceTypeNone;
	[[[window contentView] viewWithTag:3] setStringValue:@"No device connected"];
	[[[window contentView] viewWithTag:3] setTextColor:[NSColor blackColor]];
	[[[window contentView] viewWithTag:2] setEnabled:NO];
}

- (NSString *) sanitisedName {
	if(deviceType == NSDeviceTypeiPhone12)
		return @"iPhone 3G";
	else if(deviceType == NSDeviceTypeiPhone21)
		return @"iPhone 3G[S]";
	else if(deviceType == NSDeviceTypeiPod11)
		return @"iPod Touch 1G";
	else if(deviceType == NSDeviceTypeiPod12)
		return @"iPod Touch 2G";
	else if(deviceType == NSDeviceTypeiPod21)
		return @"iPod Touch 3G";
	else if(deviceType == NSDeviceTypeiPhone11)
		return @"iPhone 2G";
	return @"[Unrecognised]";
}


#pragma mark -
#pragma mark AFCDevice Delegates

-(void)deviceWasDisconnected:(AFCDevice *)device {
	[self reset];
	[iPhone release];
	iPhone = nil;
}

@end
