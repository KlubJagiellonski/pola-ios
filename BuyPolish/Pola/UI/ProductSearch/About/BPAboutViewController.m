//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPAboutViewController.h"
#import "BPWebAboutRow.h"
#import "BPAnalyticsHelper.h"
#import "BPDeviceHelper.h"

NSString *const ABOUT_APP_STORE_APP_URL = @"itms-apps://itunes.apple.com/app/id1038401148";
NSString *const ABOUT_MAIL = @"example@email.com";


@interface BPAboutViewController ()
@property(nonatomic, readonly) NSArray *rowList;
@end

@implementation BPAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Info", @"Info");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleDone target:self action:@selector(didTapCloseButton:)];

    _rowList = [self createRowList];
}

- (NSArray *)createRowList {
    NSMutableArray *rowList = [NSMutableArray array];
    [rowList addObject:
            [BPWebAboutRow rowWithTitle:NSLocalizedString(@"About Pola application", @"O aplikacji Pola") action:@selector(didTapWebRow:) url:@"http://www.onet.pl" analyticsName:@"O aplikacji Pola"]
    ];
    [rowList addObject:
            [BPWebAboutRow rowWithTitle:NSLocalizedString(@"Metodology", @"Metodologia") action:@selector(didTapWebRow:) url:@"http://www.onet.pl" analyticsName:@"Metodologia"]
    ];
    [rowList addObject:
            [BPWebAboutRow rowWithTitle:NSLocalizedString(@"About KJ", @"O Klubie Jagiellońskim") action:@selector(didTapWebRow:) url:@"http://www.wp.pl" analyticsName:@"O Klubie Jagiellońskim"]
    ];
    [rowList addObject:
            [BPWebAboutRow rowWithTitle:NSLocalizedString(@"Team", @"Zespół") action:@selector(didTapWebRow:) url:@"http://www.onet.pl" analyticsName:@"Zespół"]
    ];
    [rowList addObject:
            [BPWebAboutRow rowWithTitle:NSLocalizedString(@"Partners", @"Partnerzy") action:@selector(didTapWebRow:) url:@"http://www.wp.pl" analyticsName:@"Partnerzy"]
    ];
    if ([MFMailComposeViewController canSendMail]) {
        [rowList addObject:
                [BPAboutRow rowWithTitle:NSLocalizedString(@"Write to us", @"Napisz do nas") action:@selector(didTapWriteToUs:)]
        ];
    }
    [rowList addObject:
            [BPAboutRow rowWithTitle:NSLocalizedString(@"Rate us", @"Oceń nas") action:@selector(didTapRateUs:)]
    ];
    [rowList addObject:
            [BPAboutRow rowWithTitle:NSLocalizedString(@"Pola on Facebook", @"Pola na Feacbooku") action:@selector(didTapFacebook:)]
    ];
    [rowList addObject:
            [BPAboutRow rowWithTitle:NSLocalizedString(@"Pola on Twitter", @"Pola na Twitterze") action:@selector(didTapTwitter:)]
    ];
    return rowList;
}

- (void)didTapTwitter:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Pola na Twitterze"];

}

- (void)didTapFacebook:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Pola na Facebooku"];
}

- (void)didTapRateUs:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Oceń Polę"];
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ABOUT_APP_STORE_APP_URL]];
}

- (void)didTapWriteToUs:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Napisz do nas"];

    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
    composeViewController.delegate = self;
    [composeViewController setMailComposeDelegate:self];
    [composeViewController setToRecipients:@[ABOUT_MAIL]];
    [composeViewController setSubject:NSLocalizedString(@"mailt_title", @"Domyślny tytuł")];
    [composeViewController setMessageBody:[BPDeviceHelper deviceInfo] isHTML:NO];
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)didTapWebRow:(BPWebAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:row.analyticsName];
    [self.delegate showWebWithUrl:row.url title:row.title];
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
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    BPAboutRow *infoRow = self.rowList[(NSUInteger) indexPath.row];

    cell.textLabel.text = infoRow.title;

    return cell;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BPAboutRow *infoRow = self.rowList[(NSUInteger) indexPath.row];
    [self performSelector:infoRow.action withObject:infoRow];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma clang diagnostic pop

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end