import Foundation

struct ChargerData {
    var chargerID: String?
    var chargingCurrent: Int?
    var chargingVoltage: Int?
    var notChargingReason: Int?
    var vacVoltageLimit: Int?
}

extension ChargerData {
    init(dict: [String: Any]) {
        self.chargerID = dict["ChargerID"] as? String
        self.chargingCurrent = dict["ChargingCurrent"] as? Int
        self.chargingVoltage = dict["ChargingVoltage"] as? Int
        self.vacVoltageLimit = dict["VacVoltageLimit"] as? Int
    }
}
