#import "BPAboutViewController.h"
#import "BPAboutFooterView.h"
#import "BPAboutViewControllerDoubleCell.h"
#import "BPAboutViewControllerSingleCell.h"
#import "BPDoubleAboutRow.h"
#import "BPWebAboutRow.h"
#import <Pola-Swift.h>

@import Objection;

NSString *const ABOUT_APP_STORE_APP_URL = @"itms-apps://itunes.apple.com/app/id1038401148";
NSString *const ABOUT_FACEBOOK_URL = @"https://www.facebook.com/app.pola";
NSString *const ABOUT_TWITTER_URL = @"https://twitter.com/pola_app";
NSString *const ABOUT_MAIL = @"aplikacja.pola@gmail.com";

CGFloat const TABLE_HEADER_HEIGHT = 16.0f;
CGFloat const CELL_HEIGHT = 49;

@interface BPAboutViewController ()
@property (copy, nonatomic, readonly) NSArray *rowList;
@end

@implementation BPAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Info", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CloseIcon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(didTapCloseButton:)];
    self.navigationItem.rightBarButtonItem.accessibilityLabel = NSLocalizedString(@"Accessibility.Close", nil);

    _rowList = [self createRowList];

    [self configureTableViewUI];
}

#pragma - Private

- (NSArray *)createRowList {
    NSMutableArray *rowList = [NSMutableArray array];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"About Pola application", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/about"
                                     analyticsName:@"O aplikacji Pola"]];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"InstructionSet", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/method"
                                     analyticsName:@"Metodologia"]];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"About KJ", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/kj"
                                     analyticsName:@"O Klubie Jagiellońskim"]];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"Team", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/team"
                                     analyticsName:@"Zespół"]];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"Partners", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/partners"
                                     analyticsName:@"Partnerzy"]];
    [rowList addObject:[BPWebAboutRow rowWithTitle:NSLocalizedString(@"Pola's friends", nil)
                                            action:@selector(didTapWebRow:)
                                               url:@"https://www.pola-app.pl/m/friends"
                                     analyticsName:@"Przyjaciele Poli"]];
    [rowList addObject:[BPAboutRow rowWithTitle:NSLocalizedString(@"Report error in data", nil)
                                         action:@selector(didTapReportError:)]];
    if ([MFMailComposeViewController canSendMail]) {
        [rowList addObject:[BPAboutRow rowWithTitle:NSLocalizedString(@"Write to us", nil)
                                             action:@selector(didTapWriteToUs:)]];
    }
    [rowList addObject:[BPAboutRow rowWithTitle:NSLocalizedString(@"Rate us", nil) action:@selector(didTapRateUs:)]];
    [rowList addObject:[BPDoubleAboutRow rowWithTitle:NSLocalizedString(@"Pola on Facebook", nil)
                                               action:@selector(didTapFacebook:)
                                          secondTitle:NSLocalizedString(@"Pola on Twitter", nil)
                                         secondAction:@selector(didTapTwitter:)
                                               target:self]];
    return rowList;
}

- (void)configureTableViewUI {
    // Creation of UIView with 15px height.
    // It's added to table view as header.
    UIView *tableViewHeader = [UIView new];
    tableViewHeader.frame = CGRectMake(0, 0, self.tableView.frame.size.width, TABLE_HEADER_HEIGHT / 2);
    tableViewHeader.backgroundColor = [BPTheme mediumBackgroundColor];
    self.tableView.tableHeaderView = tableViewHeader;

    // Remove separators
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Set background color
    self.tableView.backgroundColor = [BPTheme mediumBackgroundColor];

    self.tableView.tableFooterView =
        [[BPAboutFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
}

#pragma mark - table view actions

- (void)didTapReportError:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Zgłoś błąd w danych"];

    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPReportProblemViewController *reportProblemViewController =
        [injector getObject:[BPReportProblemViewController class]];
    reportProblemViewController.delegate = self;
    [self presentViewController:reportProblemViewController animated:YES completion:nil];
}

- (void)didTapTwitter:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Pola na Twitterze"];
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ABOUT_TWITTER_URL]];
}

- (void)didTapFacebook:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Pola na Facebooku"];
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ABOUT_FACEBOOK_URL]];
}

- (void)didTapRateUs:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Oceń Polę"];
    [[UIApplication sharedApplication] openURL:[[NSURL alloc] initWithString:ABOUT_APP_STORE_APP_URL]];
}

- (void)didTapWriteToUs:(BPAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:@"Napisz do nas"];

    MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil
                                                                                                       bundle:nil];
    composeViewController.delegate = self;
    [composeViewController setMailComposeDelegate:self];
    [composeViewController setToRecipients:@[ABOUT_MAIL]];
    [composeViewController setSubject:NSLocalizedString(@"mail_title", nil)];
    [composeViewController setMessageBody:UIDevice.currentDevice.deviceInfo isHTML:NO];
    [self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)didTapWebRow:(BPWebAboutRow *)row {
    [BPAnalyticsHelper aboutOpened:row.analyticsName];
    [self.delegate showWebWithUrl:row.url title:row.title];
}

- (void)didTapCloseButton:(UIBarButtonItem *)button {
    [self.delegate infoCancelled:self];
}

#pragma mark - table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rowList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BPAboutRow *rowInfo = self.rowList[indexPath.row];
    // Cell class depends on rowInfo style
    Class cellClass = rowInfo.style == BPAboutRowStyleDouble ? [BPAboutViewControllerDoubleCell class]
                                                             : [BPAboutViewControllerSingleCell class];

    NSString *const identifier = NSStringFromClass(cellClass);
    BPAboutViewControllerBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[cellClass alloc] initWithReuseIdentifier:identifier];
    }

    cell.aboutRowInfo = rowInfo;

    return cell;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BPAboutRow *infoRow = self.rowList[(NSUInteger)indexPath.row];
    if (infoRow.style == BPAboutRowStyleSingle) {
        [self performSelector:infoRow.action withObject:infoRow];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
#pragma clang diagnostic pop

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BPReportProblemViewControllerDelegate

- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
