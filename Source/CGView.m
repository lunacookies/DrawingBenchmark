@interface CGView ()
@property(nonatomic) CTFrameRef cachedCTFrame;
@end

@implementation CGView {
	CTFrameRef _cachedCTFrame;
}

- (void)layout {
	[super layout];

	NSAttributedString *attributedString =
	        [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet"
	                                        attributes:@{
		                                        NSFontAttributeName : [NSFont systemFontOfSize:NSFont.systemFontSize],
		                                        NSForegroundColorAttributeName : NSColor.textColor,
	                                        }];

	CTFramesetterRef framesetter =
	        CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attributedString);

	CGSize frameSizeConstraints = {0};
	frameSizeConstraints.width = self.bounds.size.width - 10 - 10;
	frameSizeConstraints.height = CGFLOAT_MAX;

	CGSize frameSize =
	        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, (CFRange){0}, NULL, frameSizeConstraints, NULL);

	CGRect frameRect = {0};
	frameRect.origin.x = 10;
	frameRect.origin.y = self.bounds.size.height - 10 - frameSize.height;
	frameRect.size = frameSize;

	CGPathRef path = CGPathCreateWithRect(frameRect, NULL);
	self.cachedCTFrame = CTFramesetterCreateFrame(framesetter, (CFRange){0}, path, NULL);

	CFRelease(path);
	CFRelease(framesetter);
}

- (void)drawRect:(NSRect)dirtyRect {
	[NSColor.textBackgroundColor set];
	NSRectFill(dirtyRect);
	CTFrameDraw(self.cachedCTFrame, NSGraphicsContext.currentContext.CGContext);
}

- (CTFrameRef)cachedCTFrame {
	return _cachedCTFrame;
}

- (void)setCachedCTFrame:(CTFrameRef)ctFrame {
	if (_cachedCTFrame != NULL) {
		CFAutorelease(_cachedCTFrame);
	}
	if (ctFrame != NULL) {
		CFRetain(ctFrame);
	}
	_cachedCTFrame = ctFrame;
}

- (void)dealloc {
	if (_cachedCTFrame != NULL) {
		CFRelease(_cachedCTFrame);
	}
}

@end
