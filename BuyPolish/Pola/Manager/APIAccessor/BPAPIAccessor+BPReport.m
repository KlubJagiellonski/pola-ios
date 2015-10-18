//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPAPIAccessor+BPReport.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (BPReport)

- (NSDictionary *)addReport:(NSString *)barcode description:(NSString *)description error:(NSError **)error {
    NSDictionary *body = @{@"description" : description};
    BPAPIResponse *response = [self post:[NSString stringWithFormat:@"create_report"] json:body error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forReportId:(int)reportId error:(NSError **)error {


}


@end