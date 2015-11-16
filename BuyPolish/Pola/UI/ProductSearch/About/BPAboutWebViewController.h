//
// Created by Paweł Janeczek on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPAboutWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, readonly) NSString *url;

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title;

@end