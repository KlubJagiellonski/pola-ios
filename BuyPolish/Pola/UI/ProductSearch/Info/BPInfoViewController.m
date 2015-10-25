//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPInfoViewController.h"
#import "BPWebInfoRow.h"


@interface BPInfoViewController ()
@property(nonatomic, readonly) NSArray *rowList;
@end

@implementation BPInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Info", @"Info");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleDone target:self action:@selector(didTapCloseButton:)];

    _rowList = [self createRowList];
}

- (NSArray *)createRowList {
    NSMutableArray *rowList = [NSMutableArray array];
    [rowList addObject:
        [BPWebInfoRow rowWithTitle:NSLocalizedString(@"About Pola application", @"O aplikacji Pola") action:@selector(didTapWebRow:) url:@""]
    ];
    [rowList addObject:
        [BPWebInfoRow rowWithTitle:NSLocalizedString(@"Metodology", @"Metodologia") action:@selector(didTapWebRow:) url:@""]
    ];
    [rowList addObject:
        [BPWebInfoRow rowWithTitle:NSLocalizedString(@"About KJ", @"O Klubie Jagiellońskim") action:@selector(didTapWebRow:) url:@""]
    ];
    [rowList addObject:
        [BPWebInfoRow rowWithTitle:NSLocalizedString(@"Team", @"Zespół") action:@selector(didTapWebRow:) url:@""]
    ];
    [rowList addObject:
        [BPWebInfoRow rowWithTitle:NSLocalizedString(@"Partners", @"Partnerzy") action:@selector(didTapWebRow:) url:@""]
    ];
    [rowList addObject:
        [BPInfoRow rowWithTitle:NSLocalizedString(@"Write to us", @"Napisz do nas") action:@selector(didTapWriteToUs:)]
    ];
    [rowList addObject:
        [BPInfoRow rowWithTitle:NSLocalizedString(@"Rate us", @"Oceń nas") action:@selector(didTapRateUs:)]
    ];
    [rowList addObject:
        [BPInfoRow rowWithTitle:NSLocalizedString(@"Pola on Facebook", @"Pola na Feacbooku") action:@selector(didTapFacebook:)]
    ];
    [rowList addObject:
        [BPInfoRow rowWithTitle:NSLocalizedString(@"Pola on Twitter", @"Pola na Twitterze") action:@selector(didTapTwitter:)]
    ];
    return rowList;
}

- (void)didTapTwitter:(BPInfoRow *)row {

}

- (void)didTapFacebook:(BPInfoRow *)row {

}

- (void)didTapRateUs:(BPInfoRow *)row {

}

- (void)didTapWriteToUs:(BPInfoRow *)row {

}

- (void)didTapWebRow:(BPWebInfoRow *)row {

}

- (void)didTapCloseButton:(UIBarButtonItem *)button {
    [self.delegate infoCancelled:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    BPInfoRow *infoRow = self.rowList[(NSUInteger) indexPath.row];

    cell.textLabel.text = infoRow.title;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BPInfoRow *infoRow = self.rowList[(NSUInteger) indexPath.row];


}

@end