#import "BPReportResult.h"
#import "BPReport.h"

const int REPORT_STATE_ADD = 0;
const int REPORT_STATE_IMAGE_ADD = 1;
const int REPORT_STATE_FINSIHED = 2;

@implementation BPReportResult

- (instancetype)initWithState:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex {
    self = [super init];
    if (self) {
        self.state = state;
        self.report = report;
        self.imageDownloadedIndex = imageDownloadedIndex;
    }

    return self;
}

+ (instancetype)resultWithState:(int)state report:(BPReport *)report imageDownloadedIndex:(int)imageDownloadedIndex {
    return [[self alloc] initWithState:state report:report imageDownloadedIndex:imageDownloadedIndex];
}

@end
