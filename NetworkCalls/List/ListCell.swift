//
//  ListCell.swift
//  NetworkCalls
//
//  Created by Arthur Sobrosa on 26/11/24.
//

import UIKit

class ListCell: UITableViewCell {
    // MARK: - ID
    
    static let identifier = "listCell"
    
    // MARK: - Properties
    
    var character: Character? {
        didSet {
            guard let character else { return }
            
            circleImageView.image = character.image()
            nameLabel.text = character.name
            
            let statusAttrString = getAttributedString(title: "Status", description: character.status)
            statusLabel.attributedText = statusAttrString
            
            let speciesAttrString = getAttributedString(title: "Species", description: character.species)
            speciesLabel.attributedText = speciesAttrString
            
            let genderAttrString = getAttributedString(title: "Gender", description: character.gender)
            genderLabel.attributedText = genderAttrString
        }
    }
    
    // MARK: - UI Properties
    
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let speciesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genderLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleImageView.layer.cornerRadius = circleImageView.bounds.width / 2
    }
    
    // MARK: - Methods
    
    func getAttributedString(title: String, description: String) -> NSAttributedString {
        let font: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
        
        let titleAttrString = NSAttributedString(
            string: title,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.label
            ]
        )
        
        let descriptionAttrString = NSAttributedString(
            string: description,
            attributes: [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
        )
        
        let wholeAttrString = NSMutableAttributedString()
        wholeAttrString.append(titleAttrString)
        wholeAttrString.append(NSAttributedString(string: ": "))
        wholeAttrString.append(descriptionAttrString)
        
        return wholeAttrString
    }
}

extension ListCell {
    private func setupUI() {
        contentView.backgroundColor = .clear
        contentView.addSubview(circleImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(speciesLabel)
        contentView.addSubview(genderLabel)
        
        NSLayoutConstraint.activate([
            circleImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            circleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            circleImageView.widthAnchor.constraint(equalTo: circleImageView.heightAnchor),
            circleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: circleImageView.leadingAnchor, constant: -8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            speciesLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 8),
            speciesLabel.trailingAnchor.constraint(equalTo: statusLabel.trailingAnchor),
            speciesLabel.leadingAnchor.constraint(equalTo: statusLabel.leadingAnchor),
            
            genderLabel.topAnchor.constraint(equalTo: speciesLabel.bottomAnchor, constant: 8),
            genderLabel.trailingAnchor.constraint(equalTo: speciesLabel.trailingAnchor),
            genderLabel.leadingAnchor.constraint(equalTo: speciesLabel.leadingAnchor),
        ])
    }
}
