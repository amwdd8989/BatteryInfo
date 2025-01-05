import Foundation

// 定义一个结构体来存储电池信息
struct BatteryInfo {
    var bootPathUpdated: Int?
    var ioReportLegend: [IOReport]?
    var postChargeWaitSeconds: Int?
    var appleRawExternalConnected: Int?
    var serial: String?
    var virtualTemperature: Int?
    var voltage: Int?
    var maxCapacity: Int?
    var updateTime: Int?
    var externalChargeCapable: Int?
    var absoluteCapacity: Int?
    var temperature: Int?
    var isCharging: Bool?
    var cycleCount: Int?
    var designCapacity: Int?
    var nominalChargeCapacity: Int?
    var amperage: Int?
    var instantAmperage: Int?
    var currentCapacity: Int?
    var avgTimeToEmpty: Int?
    var fullyCharged: Bool?
}

// 定义一个IOReport结构体来存储IOReportLegend的子项
struct IOReport {
    var channelInfo: [String: Int]?
    var channels: [[Any]]?
    var groupName: String?
}

// 将NSDictionary转换为BatteryInfo
extension BatteryInfo {
    init(dict: [String: Any]) {
        self.bootPathUpdated = dict["BootPathUpdated"] as? Int
        if let ioReportArray = dict["IOReportLegend"] as? [[String: Any]] {
            self.ioReportLegend = ioReportArray.map { IOReport(dict: $0) }
        }
        self.postChargeWaitSeconds = dict["PostChargeWaitSeconds"] as? Int
        self.appleRawExternalConnected = dict["AppleRawExternalConnected"] as? Int
        self.serial = dict["Serial"] as? String
        self.virtualTemperature = dict["VirtualTemperature"] as? Int
        self.voltage = dict["Voltage"] as? Int
        self.maxCapacity = dict["MaxCapacity"] as? Int
        self.updateTime = dict["UpdateTime"] as? Int
        self.externalChargeCapable = dict["ExternalChargeCapable"] as? Int
        self.absoluteCapacity = dict["AbsoluteCapacity"] as? Int
        self.temperature = dict["Temperature"] as? Int
        self.isCharging = (dict["IsCharging"] as? Int) == 1
        self.cycleCount = dict["CycleCount"] as? Int
        self.designCapacity = dict["DesignCapacity"] as? Int
        self.nominalChargeCapacity = dict["NominalChargeCapacity"] as? Int
        self.amperage = dict["Amperage"] as? Int
        self.instantAmperage = dict["InstantAmperage"] as? Int
        self.currentCapacity = dict["CurrentCapacity"] as? Int
        self.avgTimeToEmpty = dict["AvgTimeToEmpty"] as? Int
        self.fullyCharged = (dict["FullyCharged"] as? Int) == 1
    }
}

extension IOReport {
    init(dict: [String: Any]) {
        self.channelInfo = dict["IOReportChannelInfo"] as? [String: Int]
        self.channels = dict["IOReportChannels"] as? [[Any]]
        self.groupName = dict["IOReportGroupName"] as? String
    }
}

