import Foundation

class BatteryDataController {
    
    // 当前电池电量
    var currentCapacity: Int?
    // IO接口提供的电池循环次数
    var IOCycleCount: Int?
    // IO接口提供的电池健康度
    var IONominalChargeCapacity: Int?
    // Cache的电池循环次数
    var CacheCycleCount: Int?
    // Cache的电池电池剩余容量
    
    /// 设置中的电池健康数据
    struct SettingsBatteryData {
        var cycleCount: Int?
        var maximumCapacityPercent: Int?
    }

    static func getSettingsBatteryInfoData() -> SettingsBatteryData? {
        guard let plistData = NSDictionary(contentsOfFile: "/var/MobileSoftwareUpdate/Hardware/Battery/Library/Preferences/com.apple.batteryhealthdata.plist") as? [String: Any] else {
            return nil
        }
        
        let cycleCount = plistData["CycleCount"] as? Int
        let maxCapacity = plistData["Maximum Capacity Percent"] as? Int
        
        return SettingsBatteryData(cycleCount: cycleCount, maximumCapacityPercent: maxCapacity)
    }
    
    /// 解析电池序列号，返回供应商名称
    /// - Parameter serialNumber: 电池的序列号
    /// - Returns: 供应商名称, 如果未知则返回 "Unknown"
    static func getBatteryManufacturer(from serialNumber: String) -> String {
        // 定义序列号前缀与供应商的映射表
        let manufacturerMapping: [String: String] = [
            "F8Y": NSLocalizedString("Sunwoda", tableName: "BatteryManufacturer", comment: "欣旺达"),
            "SWD": NSLocalizedString("Sunwoda", tableName: "BatteryManufacturer", comment: "欣旺达"),
            "F5D":  NSLocalizedString("Desay", tableName: "BatteryManufacturer", comment: "德赛"),
            "DTP": NSLocalizedString("Desay", tableName: "BatteryManufacturer", comment: "德赛"),
            "DSY": NSLocalizedString("Desay", tableName: "BatteryManufacturer", comment: "德赛"),
            "FG9": NSLocalizedString("Simplo", tableName: "BatteryManufacturer", comment: "新普"),
            "SMP": NSLocalizedString("Simplo", tableName: "BatteryManufacturer", comment: "新普"),
            "ATL": NSLocalizedString("ATL", tableName: "BatteryManufacturer", comment: "ATL"),
            "LGC": NSLocalizedString("LG", tableName: "BatteryManufacturer", comment: "LG"),
            "SON": NSLocalizedString("Sony", tableName: "BatteryManufacturer", comment: "索尼"),
        ]

        // 获取序列号前三个字符作为前缀
        let prefix = String(serialNumber.prefix(3))
        
        // 返回供应商名称, 如果找不到匹配项，则返回未知
        return manufacturerMapping[prefix] ?? "Unknown"
    }
    
    static func getFormatMaximumCapacity(nominalChargeCapacity: Int, designCapacity: Int) -> String {
        let rawValue = Double(nominalChargeCapacity) / Double(designCapacity) * 100.0
        
        switch SettingsUtils.instance.getMaximumCapacityAccuracy() {
        case .Keep:
            return String(Double(String(format: "%.2f", rawValue)) ?? rawValue)  // 保留两位小数
        case .Ceiling:
            return String(Int(ceil(rawValue)))  // 直接进1，解决用户强迫症问题 [Doge]
        case .Round:
            return String(Int(round(rawValue))) // 四舍五入
        case .Floor:
            return String(Int(floor(rawValue))) // 直接去掉小数
        }
    }

    
}
