import Foundation

class BatteryDataRecord {
    
    enum BatteryDataRecordType: Int {
        case Automatic = 0      // 自动记录
        case ManualAdd = 1      // 手动记录，但是数据是API的
        case AutomaticOCR = 2   // 自动记录，是OCR导入的
        case ManualRecord = 3   // 手动记录，但是数据是自己填写的
    }
    
    // 数据库表的
    private let dbTableVersion = 1
    
    // ID
    let id: Int
    
    // 记录的日期
    let createDate: Int
    
    // 记录的类型
    let recordType: BatteryDataRecordType
    
    let cycleCount: Int
    
    var nominalChargeCapacity: Int?
    
    var designCapacity: Int?
    
    var maximumCapacity: String?
    
    init( cycleCount: Int, nominalChargeCapacity: Int, designCapacity: Int) {
        self.id = 0
        self.createDate = 0
        self.recordType = .Automatic
        
        self.cycleCount = cycleCount
        self.nominalChargeCapacity = nominalChargeCapacity
        self.designCapacity = designCapacity
    }
    
    init(createDate: Int, cycleCount: Int, nominalChargeCapacity: Int, designCapacity: Int) {
        self.id = 0
        self.recordType = .Automatic
        
        self.createDate = createDate
        
        self.cycleCount = cycleCount
        self.nominalChargeCapacity = nominalChargeCapacity
        self.designCapacity = designCapacity
    }
    
    init(id: Int, createDate: Int, recordType: BatteryDataRecordType, cycleCount: Int, nominalChargeCapacity: Int, designCapacity: Int) {
        self.id = id
        self.createDate = createDate
        self.nominalChargeCapacity = nominalChargeCapacity
        self.designCapacity = designCapacity
        self.cycleCount = cycleCount
        self.recordType = recordType
    }
    
    init(id: Int, createDate: Int, recordType: BatteryDataRecordType, cycleCount: Int, nominalChargeCapacity: Int? = nil, designCapacity: Int? = nil, maximumCapacity: String? = nil) {
        self.id = id
        self.createDate = createDate
        self.recordType = recordType
        self.cycleCount = cycleCount
        self.nominalChargeCapacity = nominalChargeCapacity
        self.designCapacity = designCapacity
        self.maximumCapacity = maximumCapacity
    }
}
