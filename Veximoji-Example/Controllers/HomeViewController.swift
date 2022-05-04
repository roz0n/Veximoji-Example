//
//  HomeViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/21/21.
//

import UIKit
import Veximoji

typealias EmojiFlagCategories = Veximoji.FlagCategories

final class HomeViewController: UITableViewController, UISearchResultsUpdating {
  
  let locationDataManager = LocationDataManager()
  var locationData: [LocationCoords]?
  var searchController: UISearchController?
  var sections: [String] = EmojiFlagCategories.allCases.map { $0.rawValue }.map { $0 }
  
  var selectedSections: [String: Bool]? {
    didSet {
      tableView.reloadData()
    }
  }
  
  var visibleSections: [String] {
    get {
      if let selectedSections = selectedSections {
        return sections.filter { selectedSections[$0] ?? true }
      } else {
        return [String]()
      }
    }
  }
  
  var totalFlagCount: Int {
    get {
      return sectionData.values.flatMap { $0 }.count
    }
  }
  
  var tableFooter: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    return view
  }()
  
  var sectionData: [EmojiFlagCategories: [String]] = [
    .country: Veximoji.countryCodes,
    .subdivision: Veximoji.subdivisionCodes,
    .international: Veximoji.internationalCodes,
    .unique: Veximoji.uniqueTerms
  ]
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLocationData()
    configureSelectedSections()
    configureNavigation()
    configureSearchBar()
    configureTableView()
    configureTableFooter()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureLocationData() {
    locationData = locationDataManager.decode()
  }
  
  fileprivate func configureSelectedSections() {
    var defaultSelections = [String: Bool]()
    
    sections.forEach { defaultSelections[$0] = true }
    selectedSections = defaultSelections
  }
  
  fileprivate func configureNavigation() {
    let iconConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
    let filterIcon = UIImage(systemName: "line.horizontal.3.decrease.circle.fill", withConfiguration: iconConfiguration)
    let filterButton = UIBarButtonItem(image: filterIcon, style: .plain, target: self, action: #selector(presentFilterView))
    
    filterButton.tintColor = UIColor(named: "AccentColor")
    navigationItem.rightBarButtonItem = filterButton
    navigationItem.backButtonTitle = "Back"
  }
  
  fileprivate func configureSearchBar() {
    searchController = UISearchController(searchResultsController: nil)
    searchController?.searchResultsUpdater = self
    searchController?.hidesNavigationBarDuringPresentation = false
    searchController?.obscuresBackgroundDuringPresentation = false
    searchController?.definesPresentationContext = true
    searchController?.searchBar.tintColor = UIColor(named: "AccentColor")
    searchController?.searchBar.placeholder = "Search by code or term"
    searchController?.searchBar.backgroundImage = UIImage()
    searchController?.searchBar.backgroundColor = .systemBackground
    navigationItem.hidesSearchBarWhenScrolling = false
  }
  
  fileprivate func configureTableView() {
    let backgroundView = UIView()
    
    backgroundView.backgroundColor = .systemBackground
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.register(HomeViewCell.self, forCellReuseIdentifier: HomeViewCell.reuseId)
    tableView.tableHeaderView = searchController!.searchBar
    tableView.backgroundView = backgroundView
    tableView.tableFooterView = tableFooter
  }
  
  fileprivate func configureTableFooter() {
    let textView = UITextView()
    
    textView.text = "\(totalFlagCount) Emoji Flags Supported"
    textView.font = UIFont.boldSystemFont(ofSize: 14)
    textView.textAlignment = .center
    textView.translatesAutoresizingMaskIntoConstraints = false
    tableFooter.addSubview(textView)
    
    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: tableFooter.leadingAnchor),
      textView.trailingAnchor.constraint(equalTo: tableFooter.trailingAnchor),
      textView.topAnchor.constraint(equalTo: tableFooter.topAnchor),
      textView.bottomAnchor.constraint(equalTo: tableFooter.bottomAnchor)
    ])
  }
  
  // MARK: - Presenters
  
  @objc func presentFilterView() {
    let filterViewController = FilterTableViewController()
    
    filterViewController.navigationItem.title = "Categories"
    navigationController?.pushViewController(filterViewController, animated: true)
    
    if #available(iOS 10.0, *) {
      UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
    }
  }
  
  func presentDetailView(data: EmojiFlag, cell: HomeViewCell) {
    let detailViewController = DetailViewController(flagData: data)
    
    detailViewController.navigationItem.title = cell.flagData?.name ?? cell.flagData?.code.capitalized
    detailViewController.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  // MARK: - UITableViewDataSource
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return visibleSections.count
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return visibleSections[section].capitalized
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let key = visibleSections[section]
    let keyCategory = EmojiFlagCategories(rawValue: key)
    
    guard let keyCategory = keyCategory else { return 0 }
    
    return sectionData[keyCategory]?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let key = visibleSections[indexPath.section]
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewCell.reuseId, for: indexPath) as! HomeViewCell
    
    guard let keyCategory = EmojiFlagCategories(rawValue: key) else {
      return cell
    }
    
    let code = sectionData[keyCategory]?[indexPath.row]
    
    
    if let emoji = code?.flag(), let code = code {
      cell.accessoryType = .disclosureIndicator
      cell.tintColor = UIColor(named: "AccentColor")
      cell.flagData = EmojiFlag(emoji: emoji, code: code,
                                name: Locale.current.localizedString(forRegionCode: code),
                                group: key,
                                location: nil)
      if let flagLocationData = locationData?.first(where: { $0.isoCode == code }) {
        cell.flagData?.location = flagLocationData
      }
      
      return cell
    } else {
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! HomeViewCell
    
    if let data = cell.flagData {
      searchController?.isActive = false
      presentDetailView(data: data, cell: cell)
    }
  }
  
  // MARK: - Search Helpers
  
  func resetData() {
    sectionData = [
      EmojiFlagCategories.country: Veximoji.countryCodes,
      EmojiFlagCategories.subdivision: Veximoji.subdivisionCodes,
      EmojiFlagCategories.international: Veximoji.internationalCodes,
      EmojiFlagCategories.unique: Veximoji.uniqueTerms
    ]
    
    tableView.reloadData()
  }
  
  func filterResultsData(query: String) {
    sectionData.removeAll()
    sectionData = [
      .country: Veximoji.countryCodes.filter { $0.contains(query.uppercased()) },
      .subdivision: Veximoji.subdivisionCodes.filter { $0.contains(query.uppercased()) },
      .international: Veximoji.internationalCodes.filter { $0.contains(query.uppercased()) },
      .unique: Veximoji.uniqueTerms.filter { $0.contains(query.lowercased()) }
    ]
    
    tableView.reloadData()
  }
  
  // MARK: - UISearchResultsUpdating
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else {
      return
    }
    
    guard query != "" else {
      resetData()
      return
    }
    
    filterResultsData(query: query)
  }
  
}
