@interface BenchmarkWindowController () <NSToolbarDelegate>
@end

@implementation BenchmarkWindowController {
	NSViewController *_selectedViewController;
}

const NSToolbarItemIdentifier CGItemIdentifier = @"org.xoria.DrawingBenchmark.CGItemIdentifier";
const NSToolbarItemIdentifier BenchmarkItemIdentifier = @"org.xoria.DrawingBenchmark.BenchmarkItemIdentifier";

- (instancetype)init {
	return [super initWithWindowNibName:@""];
}

- (void)loadWindow {
	self.window = [[NSWindow alloc] initWithContentRect:(NSRect){0}
	                                          styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskClosable |
	                                                    NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable
	                                            backing:NSBackingStoreBuffered
	                                              defer:YES];
	self.window.title = @"Drawing Benchmark";

	self.contentViewController = [[NSViewController alloc] init];
	[self.contentViewController addChildViewController:[[CGViewController alloc] init]];
	[self.contentViewController addChildViewController:[[MetalViewController alloc] init]];

	_selectedViewController = self.contentViewController.childViewControllers[0];
	[self.contentViewController.view addSubview:_selectedViewController.view];
	NSView *view = self.contentViewController.view;
	NSView *subview = _selectedViewController.view;
	subview.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[subview.topAnchor constraintEqualToAnchor:view.topAnchor],
		[subview.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
		[subview.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
		[subview.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
	]];

	[self.window setFrame:(NSRect) { {0, 0}, {1000, 800} } display:YES];
	[self.window center];

	NSToolbar *toolbar =
	        [[NSToolbar alloc] initWithIdentifier:@"org.xoria.DrawingBenchmark.BenchmarkWindowControllerToolbar"];
	toolbar.displayMode = NSToolbarDisplayModeIconOnly;
	toolbar.delegate = self;
	self.window.toolbar = toolbar;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
            itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier
        willBeInsertedIntoToolbar:(BOOL)flag {
	if ([itemIdentifier isEqualToString:BenchmarkItemIdentifier]) {
		NSArray<NSViewController *> *viewControllers = self.contentViewController.childViewControllers;
		NSMutableArray<NSString *> *titles = [NSMutableArray arrayWithCapacity:viewControllers.count];
		for (NSViewController *viewController in viewControllers) {
			[titles addObject:viewController.title];
		}

		NSToolbarItemGroup *group = [NSToolbarItemGroup groupWithItemIdentifier:BenchmarkItemIdentifier
		                                                                 titles:titles
		                                                          selectionMode:NSToolbarItemGroupSelectionModeSelectOne
		                                                                 labels:titles
		                                                                 target:self
		                                                                 action:@selector(didSelectBenchmark:)];
		group.selectedIndex = 0;
		return group;
	}

	return nil;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
	return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
	return @[ BenchmarkItemIdentifier ];
}

- (void)didSelectBenchmark:(NSToolbarItemGroup *)group {
	NSViewController *newSelectedViewController =
	        self.contentViewController.childViewControllers[(NSUInteger)group.selectedIndex];

	[self.contentViewController transitionFromViewController:_selectedViewController
	                                        toViewController:newSelectedViewController
	                                                 options:NSViewControllerTransitionCrossfade |
	                                                         NSViewControllerTransitionAllowUserInteraction
	                                       completionHandler:nil];

	_selectedViewController = newSelectedViewController;

	NSView *view = self.contentViewController.view;
	NSView *subview = _selectedViewController.view;
	subview.translatesAutoresizingMaskIntoConstraints = NO;
	[NSLayoutConstraint activateConstraints:@[
		[subview.topAnchor constraintEqualToAnchor:view.topAnchor],
		[subview.bottomAnchor constraintEqualToAnchor:view.bottomAnchor],
		[subview.leadingAnchor constraintEqualToAnchor:view.leadingAnchor],
		[subview.trailingAnchor constraintEqualToAnchor:view.trailingAnchor],
	]];
}

@end
