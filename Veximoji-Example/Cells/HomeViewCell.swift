//
//  HomeViewCell.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/21/21.
//

import UIKit

class HomeViewCell: UITableViewCell {
  
  static let reuseId = "vxCell"
    
  var flagData: EmojiFlag? {
    didSet {
      guard let data = flagData else { return }
      
      emojiLabel.text = data.emoji
      codeLabel.text = "\(data.code) "
      nameLabel.text = data.name ?? ""
    }
  }
  
  let stackContainter: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.distribution = .fill
    stack.spacing = 12
    stack.axis = .horizontal
    return stack
  }()
  
  let emojiLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .regular)
    label.layer.cornerRadius = 4
    label.layer.masksToBounds = true
    return label
  }()
  
  let codeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.backgroundColor = .systemGray5
    label.numberOfLines = 1
    label.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    label.textAlignment = .center
    label.layer.cornerRadius = 4
    label.layer.masksToBounds = true
    return label
  }()
  
  let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)
    label.layer.cornerRadius = 4
    label.layer.masksToBounds = true
    return label
  }()
  
  // MARK: Initializers
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    layoutStackContainer()
    layoutLabels()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Layout
  
  private func layoutStackContainer() {
    let padding: CGFloat = 16

    addSubview(stackContainter)
    
    NSLayoutConstraint.activate([
      stackContainter.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: padding),
      stackContainter.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: padding),
      stackContainter.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -padding),
      stackContainter.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -padding)
    ])
  }
  
  private func layoutLabels() {
    stackContainter.addArrangedSubview(emojiLabel)
    stackContainter.addArrangedSubview(codeLabel)
    stackContainter.addArrangedSubview(nameLabel)
    
    emojiLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    codeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
  }
  
}
