import UIKit

class RootViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var batteryInfo: [String: Any] = [:]
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Battery Info"
        view.backgroundColor = .white

        if #available(iOS 15.0, *) {
            tableView = UITableView(frame: .zero, style: .insetGrouped)
        } else {
            tableView = UITableView()
        }
        // 初始化 TableView
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)

        // 获取电池信息
        if let info = fetchBatteryInfo() {
            batteryInfo = info
        }

        setupCopyButton()
        
        // 刷新 TableView
        tableView.reloadData()
    }

    // 获取电池信息
    func fetchBatteryInfo() -> [String: Any]? {
        
        return getBatteryInfo() as? [String: Any]
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batteryInfo.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // 获取属性名和值
        let key = Array(batteryInfo.keys)[indexPath.row]
        let value = batteryInfo[key]

        // 配置 Cell
        cell.textLabel?.text = "\(key): \(value ?? "N/A")"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

        return cell
    }
    
    func setupCopyButton() {
            let copyButton = UIButton(type: .system)
            copyButton.setTitle("复制全部数据", for: .normal)
            copyButton.addTarget(self, action: #selector(copyBatteryInfo), for: .touchUpInside)

            // 按钮位置设置
            copyButton.frame = CGRect(x: 20, y: view.bounds.height - 60, width: view.bounds.width - 40, height: 40)
            copyButton.backgroundColor = .systemBlue
            copyButton.setTitleColor(.white, for: .normal)
            copyButton.layer.cornerRadius = 8
            copyButton.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]

            view.addSubview(copyButton)
        }
    
    @objc func copyBatteryInfo() {
            // 将电池信息格式化为字符串
            let formattedInfo = batteryInfo.map { "\($0.key): \($0.value)" }.joined(separator: "\n")

            // 复制到剪贴板
            UIPasteboard.general.string = formattedInfo

            // 显示提示
            let alert = UIAlertController(title: "复制成功", message: "电池信息已复制到剪贴板", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }

}
