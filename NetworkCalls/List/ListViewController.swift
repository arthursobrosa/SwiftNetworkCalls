//
//  ListViewController.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

class ListViewController: UIViewController {
    // MARK: - Coordinator and View Model
    
    weak var coordinator: ListCoordinator?
    private let viewModel: ListViewModel
    
    // MARK: - Properties
    
    var characters: [Character] = []
    
    // MARK: - UI Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Initializer
    
    init(viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigationItem.title = "Characters"
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchCharacters()
    }
    
    // MARK: - Methods
    
    private func bindViewModel() {
        viewModel.onFetchCharacters = { [weak self] characters in
            guard let self else { return }
            
            self.characters = characters
            reloadTable()
        }
        
        viewModel.onFetchError = { [weak self] errorDescription in
            guard let self else { return }
            
            showNetworkErrorAlert(withMessage: errorDescription)
        }
    }
    
    private func reloadTable() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            tableView.reloadData()
        }
    }
    
    private func showNetworkErrorAlert(withMessage message: String) {
        let alert = UIAlertController(title: "Network Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
            guard let self else { return }
            
            viewModel.fetchCharacters()
        }
        
        alert.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            present(alert, animated: true)
        }
    }
}

// MARK: - UI Setup

extension ListViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.pinEdgesToSuperview()
    }
}

// MARK: - Table View Data Source and Delegate

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            fatalError("Could not dequeue cell")
        }
        
        let character = characters[indexPath.row]
        cell.character = character
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

