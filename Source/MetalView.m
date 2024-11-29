@implementation MetalView : NSView

- (void)drawRect:(NSRect)dirtyRect {
	[NSColor.systemGreenColor set];
	NSRectFill(dirtyRect);
}

@end
