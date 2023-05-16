//
//  LibraryViewController.swift
//  YouTube
//
//  Created by Daniil Chemaev on 31.03.2023.
//

import UIKit

class LibraryViewController: UIViewController {
    var presenter: LibraryPresenter!

    var collectionView: UICollectionView! = nil

    override func viewDidAppear(_ animated: Bool) {
        Task {
            await presenter.viewDidLoad()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupViews()
    }

    private func setupViews() {
        view.backgroundColor = UIColor(named: "Background")
        setupNavigationBar()

        view.addSubview(collectionView)

        self.edgesForExtendedLayout = []
    }

    func reloadData() {
        collectionView.reloadData()
    }

    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "Background")
        collectionView.reloadData()
    }

    private func setupNavigationBar() {
        createCustomNavigationBar()

        navigationItem.leftBarButtonItem = createCustomTitle(text: "History", selector: nil)

        let accountButton = createCustomButton(imageName: "person.circle.fill", selector: #selector(showProfile))
        let searchButton = createCustomButton(imageName: "magnifyingglass", selector: #selector(showSearch))

        navigationItem.rightBarButtonItems = [accountButton, searchButton]
    }

    @objc func showSearch() {
        presenter.showSearch()
    }

    @objc func showProfile() {
        presenter.showProfile()
    }
}

extension LibraryViewController {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return self.createVideosSection()
    }

    private func createVideosSection() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(300))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - UICollectionViewDelegate

extension LibraryViewController: UICollectionViewDelegate { }

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getCollectionViewSize()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as? VideoCollectionViewCell else {
            return UICollectionViewCell()
        }
        presenter.configureCell(cell: cell, row: indexPath.row)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.showDetails(row: indexPath.row)
    }
}
