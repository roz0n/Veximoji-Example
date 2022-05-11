//
//  FlagListDataSource.swift
//  Veximoji-Example
//
//  Created by Arnaldo Rozon on 5/7/22.
//

import UIKit
import Veximoji

final class FlagListDataSource: NSObject, UITableViewDataSource, VXGeoLocationManagerDelegate {
  
  // MARK: -
  
  private var allCategories: [EmojiFlagCategory]
  private var visibleCategories: [EmojiFlagCategory]
  private var geoLocationManager: VXGeoLocationManager
  private var isoCodeCoords: [VXGeoLocationData]?
  
  public var hiddenCategories = Set<EmojiFlagCategory>() {
    didSet {
      self.visibleCategories = allCategories.filter { !hiddenCategories.contains($0) }
    }
  }
  
  private var flagData: [EmojiFlagCategory: [String]] = [
    .country: EmojiFlagCountryCodes,
    .subdivision: EmojiFlagSubdivisionCodes,
    .international: EmojiFlagInternationalCodes,
    .unique: EmojiFlagUniqueTerms
  ]
  
  // MARK: - Initializers
  
  convenience override init() {
    self.init(sections: EmojiFlagCategory.allCases, locationManager: VXGeoLocationManager())
  }
  
  init(sections: [EmojiFlagCategory], locationManager: VXGeoLocationManager) {
    self.allCategories = sections
    self.visibleCategories = allCategories
    self.geoLocationManager = locationManager
    
    super.init()
    configureGeoLocationManager()
  }
  
  // MARK: - Configuration
  
  private func configureGeoLocationManager() {
    geoLocationManager.delegate = self
    geoLocationManager.decodeIsoCodeLocations()
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
    let cell = tableView.dequeueReusableCell(withIdentifier: FlagListCell.reuseIdentifier, for: indexPath) as! FlagListCell
    let category = visibleCategories[indexPath.section]
    let code = flagData[category]?[indexPath.row]
    
    if let emoji = code?.flag(), let code = code {
      let name = Locale.current.localizedString(forRegionCode: code)
      let coords = isoCodeCoords?.first(where: { $0.isoCode == code })
      
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = UIColor(named: "AccentColor")
      cell.flagData = VXEmojiFlag(emoji: emoji,
                                code: code,
                                name: name,
                                group: category.rawValue,
                                coordinates: coords)
    }
    
    return cell
  }
  
}

// MARK: - VXGeoLocationManagerDelegate

extension FlagListDataSource {
  
  func decodeSuccess(coords: [VXGeoLocationData]) {
    isoCodeCoords = coords
  }
  
  func decodeError(error: Error?, message: String?) {
    fatalError(message ?? error?.localizedDescription ?? "Unable to decode ISO code coordinates")
  }
  
}
