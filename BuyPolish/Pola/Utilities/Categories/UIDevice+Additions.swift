import UIKit

extension UIDevice {
    var deviceId: String {
        identifierForVendor?.uuidString ?? ""
    }

    var deviceInfo: String {
        var deviceInfo = "\n\n-------App & Device info--------\n"
        deviceInfo.append("- system: \(systemName), \(systemVersion)\n")
        let bundle = Bundle.main
        deviceInfo.append("- app: \(bundle.version ?? ""), \(bundle.shortVersion ?? "")\n")
        deviceInfo.append("-------End-------")
        return deviceInfo
    }

    var deviceName: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
                      encoding: .utf8)!.trimmingCharacters(in: .controlCharacters)
    }
}
