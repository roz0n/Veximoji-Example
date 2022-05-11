//
//  FlagsListFilterDataSource.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit
import Veximoji

final class FlagsListFilterDataSource: NSObject, UITableViewDataSource {
  
  // MARK: -
  
  private var categoryData: [EmojiFlagCategory]
  public var hiddenCategories: Set<EmojiFlagCategory>?
  
  // MARK: - Initializers
  
  convenience override init() {
    self.init(sections: EmojiFlagCategory.allCases)
  }
  
  init(sections categories: [EmojiFlagCategory]) {
    self.categoryData = categories
    super.init()
  }
  
  // MARK: - Helpers
  
  public func updateHiddenCategories(_ categories: Set<EmojiFlagCategory>) {
    self.hiddenCategories = categories
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categoryData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let category = categoryData[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagsListFilterViewController.reuseIdentifier,
                                             for: indexPath)
    
    cell.textLabel?.text = category.rawValue.capitalized
    
    if let hiddenCategories = hiddenCategories {
      cell.accessoryType = hiddenCategories.contains(category) ? .none : .checkmark
    } else {
      cell.accessoryType = .checkmark
    }
    
    return cell
  }
  
}
