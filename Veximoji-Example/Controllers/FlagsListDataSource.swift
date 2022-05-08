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
  
  private var allCategories: [EmojiFlagCategory]
  private var visibleCategories: [EmojiFlagCategory]
  
  public var hiddenCategories = Set<EmojiFlagCategory>() {
    didSet {
      self.visibleCategories = allCategories.filter { !hiddenCategories.contains($0) }
    }
  }
  
  private var flagData: [EmojiFlagCategory: [String]] = [
    .country: EmojiCountryCodes,
    .subdivision: EmojiSubdivisionCodes,
    .international: EmojiInternationalCodes,
    .unique: EmojiFlagUniqueTerms
  ]
  
  // MARK: - Initializers
  
  convenience override init() {
    self.init(sections: EmojiFlagCategory.allCases)
  }
  
  init(sections: [EmojiFlagCategory]) {
    self.allCategories = sections
    self.visibleCategories = allCategories
    
    super.init()
  }
  
  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return visibleCategories.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return visibleCategories[section].rawValue.capitalized
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let category = visibleCategories[section]
    return flagData[category]?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagsListCell.reuseIdentifier,
                                             for: indexPath) as! FlagsListCell
    let category = visibleCategories[indexPath.section]
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
