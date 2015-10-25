//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPWebInfoRow.h"


@implementation BPWebInfoRow {

}
- (instancetype)initWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url {
    self = [super init];
    if (self) {
        self.title = title;
        self.action = action;
        self.url = url;
    }
    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url {
    return [[self alloc] initWithTitle:title action:action url:url];
}

@end