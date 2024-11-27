//
//  ListCoordinator.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

class ListCoordinator: Coordinator {
    var childCoordinator: [any Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = ListViewModel(serviceType: .alamofire)
        let viewController = ListViewController(viewModel: viewModel)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
