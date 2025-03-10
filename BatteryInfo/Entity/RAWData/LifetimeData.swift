import Foundation

struct LifetimeData {
    var averageTemperature: Int?
    var cycleCountLastQmax: Int?
    var maximumChargeCurrent: Int?
    var minimumPackVoltage: Int?
    var maximumQmax: Int?
    var minimumQmax: Int?
    var totalOperatingTime: Int?
}

extension LifetimeData {
    init(dict: [String: Any]) {
        self.averageTemperature = dict["AverageTemperature"] as? Int
        self.cycleCountLastQmax = dict["CycleCountLastQmax"] as? Int
        self.maximumChargeCurrent = dict["MaximumChargeCurrent"] as? Int
        self.minimumPackVoltage = dict["MinimumPackVoltage"] as? Int
        self.maximumQmax = dict["MaximumQmax"] as? Int
        self.minimumQmax = dict["MinimumQmax"] as? Int
        self.totalOperatingTime = dict["TotalOperatingTime"] as? Int
    }
}
