import UIKit

class RawDataViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var batteryInfo: [(key: String, value: Any)] = []
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("RawData", comment: "")
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
        
        // 添加下拉刷新
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadBatteryInfo), for: .valueChanged)
        tableView.refreshControl = refreshControl

        // 添加右上角刷新按钮
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(reloadBatteryInfo)
        )

        setupCopyButton()
        
        reloadBatteryInfo()
    }
    
    @objc func reloadBatteryInfo() {
        // 获取电池信息
        if let info = fetchBatteryInfo() {
            batteryInfo = info.sorted { $0.key < $1.key } // key按照A->Z进行排序，不然每次进入的数据都是乱的
        }
        
        // 刷新 TableView
        tableView.reloadData()
        
        // 结束下拉刷新动画
        self.tableView.refreshControl?.endRefreshing()
    }

    // 获取电池信息
    func fetchBatteryInfo() -> [String: Any]? {
        
        return getBatteryInfo() as? [String: Any]
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batteryInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 直接从有序数组中取值，获取属性名和值
        let item = batteryInfo[indexPath.row]
        let key = item.key
        let value = item.value

        // 配置 Cell
        cell.textLabel?.text = "\"\(key)\": \"\(value)\","
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)

        return cell
    }
    
    func setupCopyButton() {
        let copyButton = UIButton(type: .system)
        copyButton.setTitle(NSLocalizedString("CopyAllData", comment: ""), for: .normal)
        copyButton.addTarget(self, action: #selector(copyBatteryInfo), for: .touchUpInside)

        // 按钮位置设置
        copyButton.frame = CGRect(x: 20, y: view.frame.height - 80, width: view.bounds.width - 40, height: 40)
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
        let alert = UIAlertController(title: NSLocalizedString("CopySuccessful", comment: ""), message: NSLocalizedString("RawDataCopySuccessfulMessage", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
