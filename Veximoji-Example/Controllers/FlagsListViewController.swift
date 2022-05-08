//
//  FlagsListViewController.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit

final class FlagsListViewController: UITableViewController {
  
  // MARK: -
  
  private var dataSource: FlagsListDataSource
  
  // MARK: - Initializers
  
  init(with dataSource: FlagsListDataSource) {
    self.dataSource = dataSource
    super.init(style: .plain)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureTableView()
    configureNavigation()
  }
  
  // MARK: - Configuration
  
  private func configureTableView() {
    tableView.register(FlagsListCell.self, forCellReuseIdentifier: FlagsListCell.reuseIdentifier)
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
    let dataSource = FlagsListFilterDataSource(categories: EmojiFlagCategories.allCases)
    let viewController = FlagsListFilterViewController(with: dataSource)
    
    viewController.navigationItem.title = "Categories"
    navigationController?.pushViewController(viewController, animated: true)
    
    if #available(iOS 10.0, *) {
      UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
  }
  
}
