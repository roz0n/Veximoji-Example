//
//  FlagsListDataSource.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit
import Veximoji

typealias EmojiFlagCategory = Veximoji.FlagCategories

public var EmojiCountryCodes = Veximoji.countryCodes
public var EmojiSubdivisionCodes = Veximoji.subdivisionCodes
public var EmojiInternationalCodes = Veximoji.internationalCodes
public var EmojiFlagUniqueTerms = Veximoji.uniqueTerms

final class FlagsListDataSource: NSObject, UITableViewDataSource {
  
  // MARK: -
  
  private var categories: [EmojiFlagCategory]
  private var flagData: [EmojiFlagCategory: [String]] = [
    .country: EmojiCountryCodes,
    .subdivision: EmojiSubdivisionCodes,
    .international: EmojiInternationalCodes,
    .unique: EmojiFlagUniqueTerms
  ]
  
  // MARK: - Initializers
  
  init(categories: [EmojiFlagCategory]) {
    self.categories = categories
    super.init()
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return categories.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return categories[section].rawValue.capitalized
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let category = EmojiFlagCategory.allCases[section]
    return flagData[category]?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagsListCell.reuseIdentifier,
                                             for: indexPath) as! FlagsListCell
    let category = EmojiFlagCategory.allCases[indexPath.section]
    let code = flagData[category]?[indexPath.row]
    
    if let emoji = code?.flag(), let code = code {
      let name = Locale.current.localizedString(forRegionCode: code)
      
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = UIColor(named: "AccentColor")
      cell.flagData = EmojiFlag(emoji: emoji,
                                code: code,
                                name: name,
                                group: category.rawValue,
                                location: nil)
    }
    
    return cell
  }
  
}
