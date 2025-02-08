import Foundation

class BatteryDataController {
    
    /// 设置中的电池健康数据
    struct SettingsBatteryData {
        var cycleCount: Int?
        var maximumCapacityPercent: Int?
    }
    
    // 检查Root权限的方法
    static func checkRunTimePermission() -> Bool {
        guard let batteryInfoDict = getBatteryInfo() as? [String: Any] else {
            print("Failed to fetch battery info")
            return false
        }
        let batteryInfo = BatteryRAWInfo(dict: batteryInfoDict)
        
        // 记录历史数据
        return batteryInfo.cycleCount != nil
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

    static func recordBatteryData(manualRecord: Bool, cycleCount: Int, nominalChargeCapacity: Int, designCapacity: Int) -> Bool {
        
        let databaseManager = BatteryRecordDatabaseManager.shared
        let settingsUtils = SettingsUtils.instance
        
        // 判断是否开启了记录
        if !settingsUtils.getEnableRecordBatteryData() {
            return true
        }
        
        if manualRecord { // 手动添加一条记录
            return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
        }
        
        switch settingsUtils.getRecordFrequency() {
        case .Automatic:
            if databaseManager.getRecordCount() == 0 { // 如果数据库还没数据就直接先创建一个
                return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
            }
            let lastRecord = databaseManager.getLatestRecord()
            if lastRecord != nil {
                if !isSameDay(timestamp1: Int(Date().timeIntervalSince1970), timestamp2: Int(lastRecord?.createDate ?? 0)) ||
                    lastRecord?.cycleCount != cycleCount ||
                    lastRecord?.nominalChargeCapacity != nominalChargeCapacity {
                    return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
                }
            }
            
        case .DataChanged:
            if databaseManager.getRecordCount() == 0 { // 如果数据库还没数据就直接先创建一个
                return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
            }
            let lastRecord = databaseManager.getLatestRecord()
            if lastRecord != nil {
                if lastRecord?.cycleCount != cycleCount || lastRecord?.nominalChargeCapacity != nominalChargeCapacity {
                    return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
                }
            }
        case .EveryDay:
            if databaseManager.getRecordCount() == 0 { // 如果数据库还没数据就直接先创建一个
                return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
            }
            let lastRecord = databaseManager.getLatestRecord()
            if lastRecord != nil {
                if !isSameDay(timestamp1: Int(Date().timeIntervalSince1970), timestamp2: Int(lastRecord?.createDate ?? 0)) { // 判断与当前的记录是否是同一天
                    return databaseManager.insertRecord(BatteryDataRecord(cycleCount: cycleCount, nominalChargeCapacity: nominalChargeCapacity, designCapacity: designCapacity))
                }
            }
            
        default: return false
        }
        
        
        return false
    }
    
    /// 比较是否是同一天
    static func isSameDay(timestamp1: Int, timestamp2: Int) -> Bool {
        let date1 = Date(timeIntervalSince1970: TimeInterval(timestamp1))
        let date2 = Date(timeIntervalSince1970: TimeInterval(timestamp2))

        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
    
    /// 格式化时间
    static func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp)) // 时间戳转换为 Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium  // 按用户地区自动适配年月日格式
        formatter.timeStyle = .short   // 按用户地区自动适配时分格式
        formatter.locale = Locale.autoupdatingCurrent // 自动适配用户的地区和语言
        
        return formatter.string(from: date)
    }

    
}
