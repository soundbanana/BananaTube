//
//  PredictionsTableViewCell.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 08.05.2023.
//

import Foundation

import UIKit

class PredictionsTableViewCell: UITableViewCell {
    static let identifier = "PredictionsTableViewCell"

    private let searchIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(named: "MainText")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "MainText")
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(named: "Background")
        contentView.addSubview(searchIcon)
        contentView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            contentView.backgroundColor = UIColor(named: "SecondaryBackground")
        } else {
            contentView.backgroundColor = UIColor(named: "Background")
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)

        if highlighted {
            contentView.backgroundColor = UIColor(named: "SecondaryBackground")
        } else {
            contentView.backgroundColor = UIColor(named: "Background")
        }
    }

    public func configure(title: String) {
        searchIcon.image = UIImage(systemName: "magnifyingglass")
        titleLabel.text = title
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            searchIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            searchIcon.heightAnchor.constraint(equalToConstant: 24),
            searchIcon.widthAnchor.constraint(equalToConstant: 24),
            searchIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: searchIcon.centerYAnchor)
        ])
    }
}
