import Foundation

class BatteryDataRecord {
    
    enum BatteryDataRecordType: Int {
        case Automatic = 0      // 自动记录
        case ManualAdd = 1      // 手动记录，但是数据是API的
        case ManualRecord = 2   // 手动记录，但是数据是自己填写的
    }
    
    // 记录的日期
    let createDate: Int
    
    let nominalChargeCapacity: Int
    
    let designCapacity: Int
    
    let cycleCount: Int
    
    let recordType: BatteryDataRecordType
    
    init(createDate: Int, nominalChargeCapacity: Int, designCapacity: Int, cycleCount: Int, recordType: BatteryDataRecordType) {
        self.createDate = createDate
        self.nominalChargeCapacity = nominalChargeCapacity
        self.designCapacity = designCapacity
        self.cycleCount = cycleCount
        self.recordType = recordType
    }
}
