import Foundation
import UIKit

class AllBatteryDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    private var tableView = UITableView()
    
    private var batteryInfo: BatteryRAWInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        title = NSLocalizedString("AllData", comment: "")
        
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
        
        // 防止 ViewController 释放后仍然执行 UI 更新
        DispatchQueue.main.async {
            if self.isViewLoaded && self.view.window != nil {
                // 刷新列表
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
    }
    
    // MARK: - 设置总分组数量
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - 列表总长度
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    // MARK: - 设置每个分组的底部标题 可以为分组设置尾部文本，如果没有尾部可以返回 nil
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return NSLocalizedString("ManufacturerDataSourceMessage", comment: "") + "\n" + NSLocalizedString("BatteryDataSourceMessage", comment: "")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.numberOfLines = 0 // 允许换行
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                if let serialNumber = batteryInfo?.serialNumber {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("SerialNumber", comment: ""), serialNumber)
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("SerialNumber", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            } else if indexPath.row == 1 {
                if let serialNumber = batteryInfo?.serialNumber {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("BatteryManufacturer", comment: ""), BatteryDataController.getBatteryManufacturer(from: serialNumber))
                } else {
                    cell.textLabel?.text = String.localizedStringWithFormat(NSLocalizedString("BatteryManufacturer", comment: ""), NSLocalizedString("Unknown", comment: ""))
                }
            }
        }
        return cell
    }
    
    // MARK: - Cell的点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}
