//
//  FlagsListFilterViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/22/21.
//

import UIKit

final class FlagsListFilterViewController: UITableViewController {
  
  // MARK: -
  
  static let reuseIdentifier = "FlagsListFilterCell"
  private var dataSource: FlagsListFilterDataSource
  
  // MARK: - Initializers
  
  init(with dataSource: FlagsListFilterDataSource) {
    self.dataSource = dataSource
    super.init(style: .grouped)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTableView()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureTableView() {
    let table = UITableView(frame: .zero, style: .insetGrouped)
    
    tableView = table
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: FlagsListFilterViewController.reuseIdentifier)
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
}
