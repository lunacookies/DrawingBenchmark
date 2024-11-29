@implementation MetalViewController

- (instancetype)init {
	self = [super init];
	self.title = @"Metal";
	return self;
}

- (void)loadView {
	self.view = [[MetalView alloc] init];
}

@end
