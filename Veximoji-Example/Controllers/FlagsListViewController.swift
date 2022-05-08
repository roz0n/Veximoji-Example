//
//  FlagsListViewController.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit

class FlagsListViewController: UITableViewController {
  
  // MARK: -
  
  private var dataSource: FlagsListDataSource
  
  // MARK: - Initializers
  
  init(dataSource: FlagsListDataSource) {
    self.dataSource = dataSource
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(FlagsListCell.self, forCellReuseIdentifier: FlagsListCell.reuseIdentifier)
    tableView.dataSource = dataSource
    tableView.reloadData()
  }
  
}
