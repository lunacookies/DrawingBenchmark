@implementation CGView

- (void)drawRect:(NSRect)dirtyRect {
	[NSColor.systemRedColor set];
	NSRectFill(dirtyRect);
}

@end
