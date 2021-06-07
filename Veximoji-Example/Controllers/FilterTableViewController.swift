//
//  FilterTableViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/22/21.
//

import UIKit
import Veximoji

final class FilterTableViewController: UITableViewController {
  
  static let reuseId = "filterCell"
  
  let categories = Veximoji.FlagCategories.allCases.map { $0.rawValue }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureTable()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureTable() {
    let table = UITableView(frame: .zero, style: .insetGrouped)
    
    tableView = table
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: FilterTableViewController.reuseId)
    tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
  }
  
  // MARK: - Helpers
  
  fileprivate func getPreviousViewController() -> UIViewController? {
    return navigationController?.viewControllers[(navigationController?.viewControllers.count)! - 2]
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Veximoji.FlagCategories.allCases.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FilterTableViewController.reuseId, for: indexPath)
    let category = categories[indexPath.row]
    
    cell.textLabel?.text = category.capitalized
    cell.tintColor = UIColor(named: "AccentColor")
    
    guard let presenter = getPreviousViewController() as? HomeViewController else { return cell }
    guard let selections = presenter.selectedSections else { return cell }
    
    cell.accessoryType = selections[category]! ? .checkmark : .none
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let presenter = getPreviousViewController() as? HomeViewController else { return }
    guard let selections = presenter.selectedSections else { return }
    
    let category = categories[indexPath.row]
    var newSelectedSections = selections
    
    newSelectedSections[category]?.toggle()
    presenter.selectedSections = newSelectedSections
    tableView.reloadData()
  }
  
}
