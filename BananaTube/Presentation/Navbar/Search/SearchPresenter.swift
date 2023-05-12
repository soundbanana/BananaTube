//
//  SearchPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit
import SWXMLHash

class SearchPresenter {
    weak var view: SearchViewController?
    var navigationController: UINavigationController?
    var coordinator: NavbarCoordinator

    let session = URLSession.shared
    let parser = XMLParser()

    var predictionsList: [String] = []
    var searchBarText: String

    init(coordinator: NavbarCoordinator, searchBarText: String) {
        self.coordinator = coordinator
        self.searchBarText = searchBarText
    }

    func viewDidLoad() {
        view?.update(searchBarText: searchBarText)
    }

    func predict(searchText: String) async {
        let encodedTexts = searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)

        guard let url = URL(string: "https://suggestqueries.google.com/complete/search?ds=yt&output=xml&q=\(encodedTexts!)") else {
            return }

        do {
            let (data, _) = try await session.data(from: url)
            let xml = XMLHash.parse(data)

            let predictons = xml["toplevel"]["CompleteSuggestion"].all.map { elem in
                elem["suggestion"].element?.attribute(by: "data")?.text
            }
            predictionsList = predictons.compactMap { $0 }
        } catch {
            print(error)
            return
        }
    }

    func rowTapped(row: Int) {
        search(searchText: predictionsList[row])
    }

    func search(searchText: String) {
        coordinator.showVideosList(searchText: searchText)
    }

    func configureCell(cell: PredictionsTableViewCell, row: Int) {
        cell.configure(title: predictionsList[row])
    }

    func getPredictionsListSize() -> Int { predictionsList.count }
}
