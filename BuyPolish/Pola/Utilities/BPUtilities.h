#define weakify() __weak typeof(self) weakSelf = self;
#define strongify() __strong typeof(weakSelf) strongSelf = weakSelf;
