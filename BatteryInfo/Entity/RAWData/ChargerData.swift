import Foundation

struct ChargerData {
    var chargerID: String?
    var chargingCurrent: Int?    // 充电电流
    var chargingVoltage: Int?    // 充电电压
    // 未充电的原因 0    = 正常状态
    //            1    = 电池已充满电
    //            128  = 电池未在充电
    //            256  = 电池温度过高导致停止充电
    //            272  = 电池温度过高导致停止充电
    //            8192 = (可能是正在握手)
    //            1024 = (可能是正在握手)
    var notChargingReason: Int?
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
