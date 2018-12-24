import UIKit
import DownKit
import RxSwift
import RxCocoa

class DownloadItemDetailTableViewController: NSObject {
    var dataModel: [[DownloadItemDetailRow]]

    init(dataModel: [[DownloadItemDetailRow]] = []) {
        self.dataModel = dataModel
    }
}

extension DownloadItemDetailTableViewController {
    func prepare(_ tableView: UITableView) {
        tableView.registerCell(nibName: KeyValueTableViewCell.reuseIdentifier)

        tableView.dataSource = self
    }
}

extension Reactive where Base: DownloadItemDetailTableViewController {
    var dataModel: Binder<[[DownloadItemDetailRow]]> {
        return Binder(base) { tableController, dataModel in
            tableController.dataModel = dataModel
        }
    }
}

extension DownloadItemDetailTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataModel.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueTableViewCell.reuseIdentifier,
                                                 for: indexPath)

        guard let keyValueCell = cell as? KeyValueTableViewCell else {
            return cell
        }

        let rowData = dataModel[indexPath.section][indexPath.row]
        keyValueCell.configure(with: rowData)

        return keyValueCell
    }
}

extension DownloadItemDetailRow: KeyValueCellModel {
    var keyText: String {
        return title
    }

    var valueText: String {
        return value
    }
}
