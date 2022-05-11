//
//  FlagListViewController.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit
import Veximoji
import MapKit

final class FlagListViewController: UITableViewController, FlagListFilterDelegate {
  
  // MARK: -
  
  private var dataSource: FlagListDataSource
  private var filterViewController: FlagListFilterViewController
  
  // MARK: - Initializers
  
  init(with dataSource: FlagListDataSource, filterViewController: FlagListFilterViewController) {
    self.dataSource = dataSource
    self.filterViewController = filterViewController
    
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    filterViewController.delegate = self
    configureTableView()
    configureNavigation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView.reloadData()
  }
  
  // MARK: - Configuration
  
  private func configureTableView() {
    tableView.register(FlagListCell.self, forCellReuseIdentifier: FlagListCell.reuseIdentifier)
    tableView.dataSource = dataSource
    tableView.reloadData()
  }
  
  private func configureNavigation() {
    let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
    let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle.fill",
                             withConfiguration: iconConfiguration)
    let filterButton = UIBarButtonItem(image: filterIcon,
                                       style: .plain,
                                       target: self,
                                       action: #selector(presentFilterViewController))
    
    filterButton.tintColor = UIColor(named: "AccentColor")
    navigationItem.rightBarButtonItem = filterButton
    navigationItem.backButtonTitle = "Back"
  }
  
  // MARK: - Selectors
  
  @objc func presentFilterViewController() {
    filterViewController.navigationItem.title = "Categories"
    navigationController?.pushViewController(filterViewController, animated: true)
    
    if #available(iOS 10.0, *) {
      UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
  }
  
  // MARK: - FlagListFilterDelegate
  
  func didTapCategory(_ category: EmojiFlagCategory) {
    if dataSource.hiddenCategories.contains(category) {
      dataSource.hiddenCategories.remove(category)
    } else {
      dataSource.hiddenCategories.insert(category)
    }
    
    filterViewController.updateHiddenCategories(dataSource.hiddenCategories)
  }
  
}

// MARK: - UITableViewDelegate

extension FlagListViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! FlagListCell
    
    if let data = cell.flagData {
      let map = FlagDetailMapView()
      let detailViewController = FlagDetailViewController(flag: data, map: map)
      
      navigationController?.pushViewController(detailViewController, animated: true)
    } else {
      return
    }
  }
  
}
