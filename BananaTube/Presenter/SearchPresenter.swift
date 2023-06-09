//
//  SearchPresenter.swift
//  BananaTube
//
//  Created by Daniil Chemaev on 07.05.2023.
//

import UIKit
import SWXMLHash

class SearchPresenter {
    private weak var view: SearchViewController?
    private let coordinator: NavbarCoordinator
    private let searchBarText: String
    var completion: ((String?) -> Void)?

    let session = URLSession.shared
    let parser = XMLParser()

    var predictionsList: [String] = []

    init(coordinator: NavbarCoordinator, view: SearchViewController, searchBarText: String) {
        self.view = view
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

            print("\(searchText) :: \(predictionsList)")
        } catch {
            print(error)
            return
        }
    }

    func rowTapped(row: Int) {
        search(searchText: predictionsList[row])
    }

    func search(searchText: String) {
        completion?(searchText)
    }

    func configureCell(cell: PredictionsTableViewCell, row: Int) {
        if row < predictionsList.count {
            cell.configure(title: predictionsList[row])
        }
    }

    func getPredictionsListSize() -> Int { predictionsList.count }

    func backButtonTapped() {
        completion?(nil)
    }
}
