//
// Created by Paweł on 21/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPCheckRow : UIView

- (void)setText:(NSString *)text;

- (void)configure:(NSNumber *)checked notes:(NSString *)notes;

@end