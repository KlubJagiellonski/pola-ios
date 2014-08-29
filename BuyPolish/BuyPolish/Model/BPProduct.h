#import <Foundation/Foundation.h>


@interface BPProduct : NSObject

@property(nonatomic, copy) NSString *barcode;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, getter=isPolish) BOOL polish;
@property(nonatomic, getter=isChecked) BOOL checked;

@end