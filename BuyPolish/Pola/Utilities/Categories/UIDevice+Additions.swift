import UIKit

extension UIDevice {
    
    @objc
    var deviceId: String {
        identifierForVendor?.uuidString ?? ""
    }
    
    @objc
    var deviceInfo: String {
        var deviceInfo = "\n\n-------App & Device info--------\n"
        deviceInfo.append("- system: \(systemName), \(systemVersion)\n")
        let bundleDictionary = Bundle.main.infoDictionary
        let bundleVersion = bundleDictionary?["CFBundleVersion"] as? String ?? "?"
        let bundleShortVersion = bundleDictionary?["CFBundleShortVersionString"] as? String ?? "?"
        deviceInfo.append("- app: \(bundleVersion), \(bundleShortVersion)\n")
        deviceInfo.append("-------End-------")
        return deviceInfo
    }
    
    @objc
    var deviceName: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)),
                      encoding: .utf8)!.trimmingCharacters(in: .controlCharacters)
    }
}
