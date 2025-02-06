import Foundation

struct KioskMode {
    var fullChargeVoltage: Int?
    var highSocDays: Int?
    var lastHighSocHours: Int?
    var mode: Int?
}

extension KioskMode {
    init(dict: [String: Any]) {
        self.fullChargeVoltage = dict["KioskModeFullChargeVoltage"] as? Int
        self.highSocDays = dict["KioskModeHighSocDays"] as? Int
        self.lastHighSocHours = dict["KioskModeLastHighSocHours"] as? Int
        self.mode = dict["KioskModeMode"] as? Int
    }
}
