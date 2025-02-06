import Foundation
import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView = UITableView()
    
    private var settingsUtils = SettingsUtils.instance
    
    private var batteryInfo: BatteryRAWInfo?
    private var settingsBatteryInfo: BatteryDataController.SettingsBatteryData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        title = NSLocalizedString("CFBundleDisplayName", comment: "")
        
        // iOS 15 之后的版本使用新的UITableView样式
        if #available(iOS 15.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView(frame: .zero, style: .grouped)
        }

        // 设置表格视图的代理和数据源
        tableView.delegate = self
        tableView.dataSource = self
        
        // 注册表格单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // 将表格视图添加到主视图
        view.addSubview(tableView)

        // 设置表格视图的布局
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBatteryData()
    }
    
    private func loadBatteryData() {
        guard let batteryInfoDict = getBatteryInfo() as? [String: Any] else {
            print("Failed to fetch battery info")
            return
        }
        batteryInfo = BatteryRAWInfo(dict: batteryInfoDict)
        settingsBatteryInfo = BatteryDataController.getSettingsBatteryInfoData()
        
        // 防止 ViewController 释放后仍然执行 UI 更新
        DispatchQueue.main.async {
            if self.isViewLoaded && self.view.window != nil {
                // 刷新列表
//                self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    // MARK: - 列表总长度
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else if section == 1 {
            return 5
        } else if section == 2 {
            if settingsUtils.getShowSettingsBatteryInfo() {
                return 2
            }
            return 0
        }
        return 2
    }
    
    // MARK: - 设置每个分组的顶部标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("CFBundleDisplayName", comment: "")
        } else if section == 2 {
            if settingsUtils.getShowSettingsBatteryInfo() {
                return NSLocalizedString("SettingsBatteryInfo", comment: "")
            }
        }
        return nil
    }
    
    // MARK: - 创建cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.numberOfLines = 0 // 允许换行
        
        if indexPath.section == 0 {
            if indexPath.row == 0 { // 系统版本号
                if !isRunningOniPadOS() {
                    cell.textLabel?.text = getDeviceName() + " (" + String.localizedStringWithFormat(NSLocalizedString("iOSVersion", comment: ""), UIDevice.current.systemVersion) + ")"
                } else {
                    cell.textLabel?.text = getDeviceName() + " (" + String.localizedStringWithFormat(NSLocalizedString("iPadOSVersion", comment: ""), UIDevice.current.systemVersion) + ")"
                }
            } else if indexPath.row == 1 { // 设备启动时间
//                cell.textLabel?.text = getDeviceUptime()
                cell.textLabel?.text = getDeviceUptimeUsingSysctl()
            } else {
                let dc = DeviceController()
                dc.copyBatteryHealthData(toDirectory: FileManager.default.temporaryDirectory.absoluteString)
                cell.textLabel?.text = dc.getBatteryHealthData()
            }
            
        } else if indexPath.section == 1 { // 电池信息
            if indexPath.row == 0 { // 电池健康度
                if let maximumCapacity = batteryInfo?.maximumCapacity {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("MaximumCapacity", comment: ""), String(maximumCapacity))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("MaximumCapacity", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 1 { // 电池循环次数
                if let cycleCount = batteryInfo?.cycleCount {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CycleCount", comment: ""), String(cycleCount))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CycleCount", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 2 { // 电池设计容量
                if let designCapacity = batteryInfo?.designCapacity {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("DesignCapacity", comment: ""), String(designCapacity))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("DesignCapacity", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 3 { // 电池剩余容量
                if let nominalChargeCapacity = batteryInfo?.nominalChargeCapacity {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("RemainingCapacity", comment: ""), String(nominalChargeCapacity))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("RemainingCapacity", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 4 { // 电池当前温度
                if let temperature = batteryInfo?.temperature {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CurrentTemperature", comment: ""), String(format: "%.2f", Double(temperature) / 100.0))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CurrentTemperature", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            }
        } else if indexPath.section == 2 { // 设置中的电池数据
            if indexPath.row == 0 { // 电池健康度
                if let maximumCapacity = settingsBatteryInfo?.maximumCapacityPercent {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("MaximumCapacity", comment: ""), String(maximumCapacity))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("MaximumCapacity", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 1 { // 电池循环次数
                if let cycleCount = settingsBatteryInfo?.cycleCount {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CycleCount", comment: ""), String(cycleCount))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("CycleCount", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            }
        } else if indexPath.section == 3 { // 显示原始数据
            
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell.textLabel?.text = NSLocalizedString("AllData", comment: "")
            } else if indexPath.row == 1 {
                cell.textLabel?.text = NSLocalizedString("RawData", comment: "")
            }
        }
        return cell
    }
    
    // MARK: - Cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
//        self.navigationController!.pushViewController(RawDataViewController(), animated: true)
//        self.present(RawDataViewController(), animated: true, completion: nil)
        if indexPath.section == 3 {
            if indexPath.row == 0 { // 显示全部数据
                let allBatteryDataViewController = AllBatteryDataViewController()
                allBatteryDataViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(allBatteryDataViewController, animated: true)
            } else { // 显示原始数据
                let rawDataViewController = RawDataViewController()
                rawDataViewController.hidesBottomBarWhenPushed = true // 隐藏底部导航栏
                self.navigationController?.pushViewController(rawDataViewController, animated: true)
            }
            
        }
    }
    
    

}
