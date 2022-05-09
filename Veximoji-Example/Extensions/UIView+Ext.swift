//
//  UIView+Ext.swift
//  Veximoji Example
//
//  Created by Arnaldo Rozon on 5/22/21.
//

import UIKit

enum UIViewBorder: String {
  case left = "left"
  case right = "right"
  case top = "top"
  case bottom = "bottom"
}

extension UIView {
  
  private func createBorders(borders: [UIViewBorder], color: UIColor, width: CGFloat) {
    borders.forEach { [weak self] (border) in
      if let view = self {
        let borderView = CALayer()
        
        borderView.backgroundColor = color.cgColor
        borderView.name = border.rawValue
        
        switch border {
          case .left:
            borderView.frame = CGRect(
              x: 0,
              y: 0,
              width: width,
              height: view.frame.size.height)
          case .right:
            borderView.frame = CGRect(
              x: view.frame.size.width - width,
              y: 0, width: width,
              height: view.frame.size.height)
          case .top:
            borderView.frame = CGRect(
              x: 0,
              y: 0,
              width: view.frame.size.width,
              height: width)
          case .bottom:
            borderView.frame = CGRect(
              x: 0,
              y: view.frame.size.height - width,
              width: view.frame.size.width, height: width)
        }
        
        view.layer.addSublayer(borderView)
      }
    }
  }
  
  func addBorder(borders: [UIViewBorder], color: UIColor, width: CGFloat) {
    DispatchQueue.main.async { [weak self] in
      self?.createBorders(borders: borders, color: color, width: width)
    }
  }
  
}
