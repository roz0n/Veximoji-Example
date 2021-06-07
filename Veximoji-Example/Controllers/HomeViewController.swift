//
//  HomeViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/21/21.
//

import UIKit
import Veximoji

final class HomeViewController: UITableViewController, UISearchResultsUpdating {
  
  let locationDataManager = LocationDataManager()
  var locationData: [LocationCoords]?
  var searchController: UISearchController?
  var sections: [String] = Veximoji.FlagCategories.allCases.map { $0.rawValue }
  
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
  
  var sectionData: [Veximoji.FlagCategories.RawValue: [String]] = [
    Veximoji.FlagCategories.country.rawValue: Veximoji.countryCodes,
    Veximoji.FlagCategories.subdivision.rawValue: Veximoji.subdivisionCodes,
    Veximoji.FlagCategories.international.rawValue: Veximoji.internationalCodes,
    Veximoji.FlagCategories.cultural.rawValue: Veximoji.culturalTerms
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
    return sectionData[key]!.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewCell.reuseId, for: indexPath) as! HomeViewCell
    let key = visibleSections[indexPath.section]
    let code = sectionData[key]?[indexPath.row]
    let location = locationData?.first(where: { $0.isoCode == code })
    var emoji: String?
    
    if let code = code {
      switch key {
        case Veximoji.FlagCategories.country.rawValue:
          emoji = Veximoji.country(code: code)
        case Veximoji.FlagCategories.subdivision.rawValue:
          emoji = Veximoji.subdivision(code: code)
        case Veximoji.FlagCategories.international.rawValue:
          emoji = Veximoji.international(code: code)
        case Veximoji.FlagCategories.cultural.rawValue:
          emoji = Veximoji.cultural(term: Veximoji.CulturalTerms(rawValue: code)!)
        default:
          break
      }
      
      if let emoji = emoji {
        cell.flagData = EmojiFlag(emoji: emoji, code: code, name: Locale.current.localizedString(forRegionCode: code), group: key, location: location)
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = UIColor(named: "AccentColor")
      } else {
        return cell
      }
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! HomeViewCell
    
    if let data = cell.flagData {
      searchController?.isActive = false
      presentDetailView(data: data, cell: cell)
    } else {
      return
    }
  }
  
  // MARK: - Search Helpers
  
  func resetData() {
    sectionData = [
      Veximoji.FlagCategories.country.rawValue: Veximoji.countryCodes,
      Veximoji.FlagCategories.subdivision.rawValue: Veximoji.subdivisionCodes,
      Veximoji.FlagCategories.international.rawValue: Veximoji.internationalCodes,
      Veximoji.FlagCategories.cultural.rawValue: Veximoji.culturalTerms
    ]
    
    tableView.reloadData()
  }
  
  func filterResultsData(query: String) {
    sectionData.removeAll()
    
    let filteredData = [
      Veximoji.FlagCategories.country.rawValue: Veximoji.countryCodes.filter { $0.contains(query.uppercased()) },
      Veximoji.FlagCategories.subdivision.rawValue: Veximoji.subdivisionCodes.filter { $0.contains(query.uppercased()) },
      Veximoji.FlagCategories.international.rawValue: Veximoji.internationalCodes.filter { $0.contains(query.uppercased()) },
      Veximoji.FlagCategories.cultural.rawValue: Veximoji.culturalTerms.filter { $0.contains(query.lowercased()) }
    ]
    
    sectionData = filteredData
    tableView.reloadData()
  }
  
  // MARK: - UISearchResultsUpdating
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let query = searchController.searchBar.text else { return }
    
    guard query != "" else {
      resetData()
      return
    }
    
    filterResultsData(query: query)
  }
  
}
