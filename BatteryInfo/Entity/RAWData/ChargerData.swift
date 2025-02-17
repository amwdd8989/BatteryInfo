import Foundation

struct ChargerData {
    var chargerID: String?
    var chargingCurrent: Int?    // 充电电流
    var chargingVoltage: Int?    // 充电电压
    var notChargingReason: Int?  // 未充电的原因 256 = 电池温度过高导致停止充电
    var vacVoltageLimit: Int?    // 限制电压
}

extension ChargerData {
    init(dict: [String: Any]) {
        self.chargerID = dict["ChargerID"] as? String
        self.chargingCurrent = dict["ChargingCurrent"] as? Int
        self.chargingVoltage = dict["ChargingVoltage"] as? Int
        self.notChargingReason = dict["NotChargingReason"] as? Int
        self.vacVoltageLimit = dict["VacVoltageLimit"] as? Int
    }
}
