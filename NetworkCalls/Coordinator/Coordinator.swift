//
//  Coordinator.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinator: [any Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
