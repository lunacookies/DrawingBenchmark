@interface CGView ()
@property(nonatomic) NSMutableArray<NSMutableString *> *lines;
@property(nonatomic) CTFrameRef cachedCTFrame;
@property(nonatomic) CGFloat cachedCTFrameHeight;
@property(nonatomic) CGFloat scrollOffset;
@property(nonatomic, readonly) NSUInteger currentLineIndex;
@end

@implementation CGView {
	CTFrameRef _cachedCTFrame;
}

- (instancetype)init {
	self = [super init];

	NSURL *url = [NSBundle.mainBundle URLForResource:@"Text" withExtension:@"txt"];
	NSString *contents = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	self.lines = [[NSMutableArray alloc] init];
	[contents enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
		(void)stop;
		[self.lines addObject:[[NSMutableString alloc] initWithString:line]];
	}];

	return self;
}

- (void)scrollWheel:(NSEvent *)event {
	self.scrollOffset -= event.scrollingDeltaY;
	self.needsDisplay = YES;
}

- (BOOL)acceptsFirstResponder {
	return YES;
}

- (void)keyDown:(NSEvent *)event {
	[self interpretKeyEvents:@[ event ]];
}

- (void)insertText:(id)stringAny {
	NSAssert([stringAny isKindOfClass:[NSString class]], @"must be NSString");
	NSString *string = (NSString *)stringAny;
	[self.lines[self.currentLineIndex] appendString:string];
	self.cachedCTFrame = NULL;
	self.needsDisplay = YES;
}

- (void)insertNewline:(id)sender {
	[self.lines insertObject:[[NSMutableString alloc] init] atIndex:self.currentLineIndex];
	self.cachedCTFrame = NULL;
	self.needsDisplay = YES;
}

- (void)layout {
	[super layout];
	self.cachedCTFrame = NULL;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSGraphicsContext *context = NSGraphicsContext.currentContext;
	[context saveGraphicsState];

	[NSColor.textBackgroundColor set];
	NSRectFill(self.bounds);

	CGContextTranslateCTM(context.CGContext, 0, self.scrollOffset);
	if (self.cachedCTFrame == NULL) {
		[self updateCachedCTFrame];
	}
	CTFrameDraw(self.cachedCTFrame, NSGraphicsContext.currentContext.CGContext);

	[context restoreGraphicsState];
}

- (void)updateCachedCTFrame {
	NSMutableString *string = [[NSMutableString alloc] init];
	for (NSMutableString *line in self.lines) {
		[string appendString:line];
		[string appendString:@"\n"];
	}

	NSAttributedString *attributedString = [[NSAttributedString alloc]
	        initWithString:string
	            attributes:@{
		            NSFontAttributeName : [NSFont monospacedSystemFontOfSize:12 weight:NSFontWeightRegular],
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
	self.cachedCTFrameHeight = frameRect.size.height;

	CFRelease(path);
	CFRelease(framesetter);
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

- (NSUInteger)currentLineIndex {
	CGFloat fractionThrough = ((self.scrollOffset + self.bounds.size.height / 2) / self.cachedCTFrameHeight);
	return (NSUInteger)(fractionThrough * (CGFloat)self.lines.count);
}

- (void)dealloc {
	if (_cachedCTFrame != NULL) {
		CFRelease(_cachedCTFrame);
	}
}

@end
