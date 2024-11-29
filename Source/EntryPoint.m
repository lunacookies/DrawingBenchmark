@import AppKit;

#include "AppDelegate.h"
#include "AppDelegate.m"

int main(void) {
	[NSApplication sharedApplication];
	AppDelegate *appDelegate = [[AppDelegate alloc] init];
	NSApp.delegate = appDelegate;
	[NSApp run];
}
