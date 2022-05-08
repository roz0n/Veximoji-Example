//
//  FlagsListFilterDataSource.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit

final class FlagsListFilterDataSource: NSObject, UITableViewDataSource {
  
  // MARK: -
  
  private var categories: [EmojiFlagCategories]
  
  // MARK: - Initializers
  
  init(categories: [EmojiFlagCategories]) {
    self.categories = categories
    super.init()
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagsListFilterViewController.reuseIdentifier,
                                             for: indexPath)
    let category = categories[indexPath.row]
    
    cell.textLabel?.text = category.rawValue.capitalized
    return cell
  }
  
}
