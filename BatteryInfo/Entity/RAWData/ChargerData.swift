import Foundation

struct ChargerData {
    var chargerID: String?
    var chargingCurrent: Int?
    var chargingVoltage: Int?
}

extension ChargerData {
    init(dict: [String: Any]) {
        self.chargerID = dict["ChargerID"] as? String
        self.chargingCurrent = dict["ChargingCurrent"] as? Int
        self.chargingVoltage = dict["ChargingVoltage"] as? Int
    }
}
