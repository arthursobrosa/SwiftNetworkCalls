//
//  ViewCode.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

extension UIView {
    func pinEdgesToSuperview() {
        guard let superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            leadingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
