//
//  FlagDetailViewController.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/22/21.
//

import UIKit
import MapKit
import Veximoji

class FlagDetailViewController: UIViewController, MKMapViewDelegate {
  
  // MARK: -
  
  var flagData: VXEmojiFlag? {
    didSet {
      emojiDataLabel.text = flagData?.emoji
      codeDataLabel.text = flagData?.code
      nameDataLabel.text = flagData?.name ?? codeDataLabel.text?.capitalized
      groupDataLabel.text = flagData?.group?.capitalized
      
      if let locationData = flagData?.coordinates {
        mapView.configureMap(coords: locationData)
      }
    }
  }
  
  var mapMarker: MKPointAnnotation
  var mapView: FlagDetailMapView
  
  // MARK: - Containers
  
  let scrollContainer: UIScrollView = {
    let scroll = UIScrollView()
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  
  let flagContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.1)
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  let detailsContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 16
    return stack
  }()
  
  let buttonsContainer: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 10
    return stack
  }()
  
  let mapViewContainer: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .systemPink
    view.layer.cornerRadius = 8
    view.layer.masksToBounds = true
    return view
  }()
  
  // MARK: - Header Labels
  
  let codeHeaderLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    label.textColor = UIColor(named: "AccentColor")!
    return label
  }()
  
  let nameHeaderLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Name".uppercased()
    label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
    label.textColor = .systemGray2
    return label
  }()
  
  let groupHeaderLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Category".uppercased()
    label.font = UIFont.systemFont(ofSize: 11, weight: .bold)
    label.textColor = .systemGray2
    return label
  }()
  
  // MARK: - Data Labels
  
  let emojiDataLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 120)
    return label
  }()
  
  let codeDataLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
    label.textColor = UIColor(named: "AccentColor")
    return label
  }()
  
  let nameDataLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  let groupDataLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    return label
  }()
  
  // MARK: - Buttons
  
  let copyCodeButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.1)
    button.tintColor = UIColor(named: "AccentColor")
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    button.setTitle("Copy Code", for: .normal)
    button.tag = 0
    return button
  }()
  
  let copyEmojiButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor(named: "AccentColor")!.withAlphaComponent(0.1)
    button.tintColor = UIColor(named: "AccentColor")
    button.layer.cornerRadius = 8
    button.layer.masksToBounds = true
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 10, bottom: 16, right: 10)
    button.setTitle("Copy Emoji", for: .normal)
    button.tag = 1
    return button
  }()
  
  // MARK: - Initializers
  
  init(flag: VXEmojiFlag, map: FlagDetailMapView, marker: MKPointAnnotation = MKPointAnnotation()) {
    self.flagData = flag
    self.mapView = map
    self.mapMarker = marker
    
    super.init(nibName: nil, bundle: nil)
    
    defer {
      self.flagData = flag
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureViewController()
    configureMapView()
    configureButtonGestures()
    
    layoutScrollContainer()
    layoutFlagContainer()
    layoutDetailContainer()
    layoutFieldLabels()
    
    if flagData?.coordinates != nil {
      layoutMapContainer()
    }
    
    layoutButtonsContainer()
  }
  
  // MARK: - Configurations
  
  fileprivate func configureViewController() {
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .systemBackground
  }
  
  fileprivate func configureMapView() {
    mapView.delegate = self
  }
  
  fileprivate func configureButtonGestures() {
    copyCodeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyToClipboard(sender:))))
    copyEmojiButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(copyToClipboard(sender:))))
  }
  
  // MARK: - Helpers
  
  fileprivate func wrapInBorderView(view: UILabel, width: CGFloat = CGFloat(1), color: UIColor = .systemGray5) -> UIView {
    let borderView = UIView()
    let yPadding: CGFloat = 8
    
    borderView.addBorder(borders: [.bottom],
                         color: color, width: width)
    borderView.addSubview(view)
    
    NSLayoutConstraint.activate([
      view.topAnchor.constraint(equalTo: borderView.topAnchor),
      view.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -yPadding),
      view.leadingAnchor.constraint(equalTo: borderView.leadingAnchor),
      view.trailingAnchor.constraint(equalTo: borderView.trailingAnchor),
    ])
    
    return borderView
  }
  
  fileprivate func wrapInFieldContainer(views: [UIView]) -> UIStackView {
    let fieldContainer = UIStackView()
    
    fieldContainer.translatesAutoresizingMaskIntoConstraints = false
    fieldContainer.axis = .vertical
    fieldContainer.spacing = 4
    
    for view in views {
      fieldContainer.addArrangedSubview(view)
    }
    
    return fieldContainer
  }
  
  // MARK: - Gestures
  
  @objc func copyToClipboard(sender: UITapGestureRecognizer) {
    switch sender.view?.tag {
      case 0:
        UIPasteboard.general.string = flagData?.code
        
        if #available(iOS 10.0, *) {
          UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
      case 1:
        UIPasteboard.general.string = flagData?.emoji
        
        if #available(iOS 10.0, *) {
          UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        }
      default:
        break
    }
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    let reuseId = "LocationMarker"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
    
    if annotationView == nil {
      annotationView = MKPinAnnotationView(annotation: mapMarker, reuseIdentifier: reuseId)
      annotationView?.animatesDrop = true
      annotationView?.pinTintColor = UIColor(named: "AccentColor")
    }
    
    return annotationView
  }
  
}

// MARK: - Layout

fileprivate extension FlagDetailViewController {
  
  func layoutScrollContainer() {
    view.addSubview(scrollContainer)
    
    NSLayoutConstraint.activate([
      scrollContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      scrollContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      scrollContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  func layoutFlagContainer() {
    let yPadding: CGFloat = 24
    let xPadding: CGFloat = 20
    let oneThird: CGFloat = 0.33
    
    scrollContainer.addSubview(flagContainer)
    flagContainer.addSubview(emojiDataLabel)
    
    NSLayoutConstraint.activate([
      flagContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: yPadding),
      flagContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: xPadding),
      flagContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -xPadding),
      flagContainer.heightAnchor.constraint(equalTo: scrollContainer.heightAnchor, multiplier: oneThird, constant: 0),
      flagContainer.centerXAnchor.constraint(equalTo: scrollContainer.centerXAnchor),
      
      emojiDataLabel.centerXAnchor.constraint(equalTo: flagContainer.centerXAnchor),
      emojiDataLabel.centerYAnchor.constraint(equalTo: flagContainer.centerYAnchor)
    ])
  }
  
  func layoutDetailContainer() {
    let yPadding: CGFloat = 24
    let xPadding: CGFloat = 20
    
    scrollContainer.addSubview(detailsContainer)
    
    NSLayoutConstraint.activate([
      detailsContainer.topAnchor.constraint(equalTo: flagContainer.bottomAnchor, constant: yPadding),
      detailsContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: xPadding),
      detailsContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor)
    ])
  }
  
  func layoutFieldLabels() {
    let codeField = wrapInFieldContainer(views: [codeHeaderLabel, wrapInBorderView(view: codeDataLabel, width: 2.5, color: UIColor(named: "AccentColor")!)])
    let nameField = wrapInFieldContainer(views: [nameHeaderLabel, wrapInBorderView(view: nameDataLabel)])
    let groupField = wrapInFieldContainer(views: [groupHeaderLabel, wrapInBorderView(view: groupDataLabel)])
    
    detailsContainer.addArrangedSubview(codeField)
    detailsContainer.addArrangedSubview(nameField)
    detailsContainer.addArrangedSubview(groupField)
  }
  
  func layoutMapContainer() {
    let yPadding: CGFloat = 24
    let xPadding: CGFloat = 20
    let mapHeight: CGFloat = 300
    
    scrollContainer.addSubview(mapViewContainer)
    mapViewContainer.addSubview(mapView)
    
    NSLayoutConstraint.activate([
      mapViewContainer.heightAnchor.constraint(equalToConstant: mapHeight),
      mapViewContainer.topAnchor.constraint(equalTo: detailsContainer.bottomAnchor, constant: yPadding),
      mapViewContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: xPadding),
      mapViewContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -xPadding),
      
      mapView.topAnchor.constraint(equalTo: mapViewContainer.topAnchor),
      mapView.leadingAnchor.constraint(equalTo: mapViewContainer.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: mapViewContainer.trailingAnchor),
      mapView.bottomAnchor.constraint(equalTo: mapViewContainer.bottomAnchor)
    ])
  }
  
  func layoutButtonsContainer() {
    let yPadding: CGFloat = 24
    let xPadding: CGFloat = 20
    
    let previousArrangedSubview: UIView = {
      return flagData?.coordinates != nil ? mapViewContainer : detailsContainer
    }()
    
    buttonsContainer.addArrangedSubview(copyCodeButton)
    buttonsContainer.addArrangedSubview(copyEmojiButton)
    scrollContainer.addSubview(buttonsContainer)
    
    NSLayoutConstraint.activate([
      buttonsContainer.topAnchor.constraint(equalTo: previousArrangedSubview.bottomAnchor, constant: yPadding),
      buttonsContainer.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: xPadding),
      buttonsContainer.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor, constant: -xPadding),
      buttonsContainer.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -yPadding)
    ])
  }
  
  
}
