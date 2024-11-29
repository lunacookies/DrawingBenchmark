@interface BenchmarkViewController : NSViewController
@end

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

	// I kept adding random stuff till centering worked ...
	self.contentViewController = [[BenchmarkViewController alloc] init];
	[self.window updateConstraintsIfNeeded];
	[self.window layoutIfNeeded];
	[self.window center];

	[self.contentViewController addChildViewController:[[CGViewController alloc] init]];
	[self.contentViewController addChildViewController:[[MetalViewController alloc] init]];

	_selectedViewController = self.contentViewController.childViewControllers[0];
	[self.contentViewController.view addSubview:_selectedViewController.view];

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
}

@end

@implementation BenchmarkViewController

- (NSSize)preferredContentSize {
	return (NSSize){1000, 800};
}

@end
