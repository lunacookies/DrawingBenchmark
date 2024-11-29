@implementation CGViewController

- (instancetype)init {
	self = [super init];
	self.title = @"Core Graphics";
	return self;
}

- (void)loadView {
	self.view = [[CGView alloc] init];
}

@end
