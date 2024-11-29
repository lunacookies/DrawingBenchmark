@implementation CGView

- (void)drawRect:(NSRect)dirtyRect {
	NSAttributedString *attributedString =
	        [[NSAttributedString alloc] initWithString:@"Lorem ipsum dolor sit amet"
	                                        attributes:@{
		                                        NSFontAttributeName : [NSFont systemFontOfSize:NSFont.systemFontSize],
		                                        NSForegroundColorAttributeName : NSColor.labelColor,
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
	CTFrameRef frame = CTFramesetterCreateFrame(framesetter, (CFRange){0}, path, NULL);
	CTFrameDraw(frame, NSGraphicsContext.currentContext.CGContext);

	CFRelease(path);
	CFRelease(frame);
	CFRelease(framesetter);
}

@end
