//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPAPIAccessor+BPReport.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (BPReport)

- (NSDictionary *)addReportWithDescription:(NSString *)description error:(NSError **)error {
    NSDictionary *body = @{@"description" : description};
    BPAPIResponse *response = [self post:[NSString stringWithFormat:@"create_report"] jsonBody:body error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forReportId:(NSNumber *)reportId error:(NSError **)error {
    NSData *data = [NSData dataWithContentsOfFile:imageAtPath];
    NSDictionary *parameters = @{@"report_id" : reportId};
    BPAPIResponse *response = [self postMultipart:@"attach_file" parameters:parameters fileName:@"file" data:data error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

@end