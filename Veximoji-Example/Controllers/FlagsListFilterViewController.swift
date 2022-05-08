//
//  FlagsListFilterViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/22/21.
//

import UIKit

protocol FlagsListFilterDelegate {
  func didTapCategory(_ category: EmojiFlagCategory)
}

final class FlagsListFilterViewController: UITableViewController {
  
  // MARK: -
  
  static let reuseIdentifier = "FlagsListFilterCell"
  
  private var dataSource: FlagsListFilterDataSource
  public var delegate: FlagsListFilterDelegate?
  
  // MARK: - Initializers
  
  init(dataSource: FlagsListFilterDataSource) {
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
    let customTable = UITableView(frame: .zero, style: .insetGrouped)
    
    tableView = customTable
    tableView.dataSource = dataSource
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: FlagsListFilterViewController.reuseIdentifier)
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  // MARK: - Helpers
  
  public func updateHiddenCategories(_ categories: Set<EmojiFlagCategory>) {
    dataSource.hiddenCategories = categories
    tableView.reloadData()
  }
  
}

extension FlagsListFilterViewController {
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let category = EmojiFlagCategory.allCases[indexPath.row]
    self.delegate?.didTapCategory(category)
    
    tableView.reloadData()
  }
  
}
