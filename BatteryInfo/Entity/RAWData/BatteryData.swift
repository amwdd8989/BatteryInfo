import Foundation

struct BatteryData {
    var algoChemID: Int?
    var cycleCount: Int?
    var designCapacity: Int?
    var dynamicSoc1Vcut: Int?
    var maximumFCC: Int?
    var minimumFCC: Int?
    var temperatureSamples: Int?
    var stateOfCharge: Int?
}

extension BatteryData {
    init(dict: [String: Any]) {
        self.algoChemID = dict["AlgoChemID"] as? Int
        self.cycleCount = dict["CycleCount"] as? Int
        self.designCapacity = dict["DesignCapacity"] as? Int
        self.dynamicSoc1Vcut = dict["DynamicSoc1Vcut"] as? Int
        self.maximumFCC = dict["MaximumFCC"] as? Int
        self.minimumFCC = dict["MinimumFCC"] as? Int
        self.temperatureSamples = dict["TemperatureSamples"] as? Int
        self.stateOfCharge = dict["StateOfCharge"] as? Int
    }
}
