import Foundation
import MessageUI

final class AboutRowsFactory {
    class func create() -> AboutRows {
        let strings = R.string.localizable.self
        var rows =
            [
                AboutRow(title: strings.aboutPolaApplication(),
                         analyticsName: .aboutPola,
                         action: .link("https://www.pola-app.pl/m/about", true)),
                AboutRow(title: strings.instructionSet(),
                         analyticsName: .instructionSet,
                         action: .link("https://www.pola-app.pl/m/method", true)),
                AboutRow(title: strings.aboutKJ(),
                         analyticsName: .aboutKJ,
                         action: .link("https://www.pola-app.pl/m/kj", true)),
                AboutRow(title: strings.team(),
                         analyticsName: .team,
                         action: .link("https://www.pola-app.pl/m/team", true)),
                AboutRow(title: strings.partners(),
                         analyticsName: .partners,
                         action: .link("https://www.pola-app.pl/m/partners", true)),
                AboutRow(title: strings.polaSFriends(),
                         analyticsName: .polasFriends,
                         action: .link("https://www.pola-app.pl/m/friends", true)),
                AboutRow(title: strings.reportErrorInData(),
                         analyticsName: .reportError,
                         action: .reportProblem),
            ]
        if MFMailComposeViewController.canSendMail() {
            rows.append(
                AboutRow(title: strings.writeToUs(),
                         analyticsName: .writeToUs,
                         action: .mail(
                             "aplikacja.pola@gmail.com",
                             strings.mail_title(),
                             UIDevice.current.deviceInfo
                         ))
            )
        }
        rows.append(
            AboutRow(title: strings.rateUs(),
                     analyticsName: .rateUs,
                     action: .link("itms-apps://itunes.apple.com/app/id1038401148", false))
        )
        let doubleRows =
            [
                (
                    AboutRow(title: strings.polaOnFacebook(),
                             analyticsName: .facebook,
                             action: .link("https://www.facebook.com/app.pola", false)),
                    AboutRow(title: strings.polaOnTwitter(),
                             analyticsName: .twitter,
                             action: .link("https://www.twitter.com/pola_app", false))
                ),
            ]

        return AboutRows(rows: rows, doubleRows: doubleRows)
    }
}
