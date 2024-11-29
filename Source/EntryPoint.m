@import AppKit;

#include "AppDelegate.h"
#include "CGView.h"
#include "CGViewController.h"
#include "MetalView.h"
#include "MetalViewController.h"
#include "BenchmarkWindowController.h"

#include "AppDelegate.m"
#include "CGView.m"
#include "CGViewController.m"
#include "MetalView.m"
#include "MetalViewController.m"
#include "BenchmarkWindowController.m"

int main(void) {
	[NSApplication sharedApplication];
	AppDelegate *appDelegate = [[AppDelegate alloc] init];
	NSApp.delegate = appDelegate;
	[NSApp run];
}
