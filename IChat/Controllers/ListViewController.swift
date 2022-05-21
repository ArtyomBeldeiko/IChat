//
//  ListViewController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 19.05.22.
//

import UIKit


class ListViewController: UIViewController {
    
    let activeChats = Bundle.main.decode([MChat].self, from: "activeChats.json")
    let waitingChats = Bundle.main.decode([MChat].self, from: "waitingChats.json")
    
    var collectionView: UICollectionView!
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats
        
        func description() -> String {
            
            switch self {
            case .waitingChats:
                return "Waiting Chats"
            case .activeChats:
                return "Active Chats"
            }
        }
    }
    
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MChat>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
        
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
    }
    
    private func reloadData() {
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, MChat>()
        snapshot.appendSections([.waitingChats, .activeChats])
        snapshot.appendItems(activeChats, toSection: .activeChats)
        snapshot.appendItems(waitingChats, toSection: .waitingChats)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
    }
    
    private func setupSearchBar() {
        
        navigationController?.navigationBar.tintColor = .mainWhite()
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
}

// MARK: Data Source

extension ListViewController {
    
    
    private func createDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, MChat>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, chat) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section")
            }
            
            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, with: chat, for: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell .self, with: chat, for: indexPath)
            }
            
        })
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, IndexPath in
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: IndexPath) as? SectionHeader else { fatalError("Not able to dequeue reusable supplementary view")}
            
            guard let section = Section(rawValue: IndexPath.section) else { fatalError("Unknown section kind")}
            
            sectionHeader.configure(text: section.description(), font: .laoSangamMN20()!, textColor: UIColor(red: 146 / 255, green: 146 / 255, blue: 146 / 255, alpha: 1))
            
            return sectionHeader
        }
        
    }
    
}

// MARK: Layout Setup

extension ListViewController {
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Unknown section")
            }
            
            switch section {
            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
            
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        
        return layout
        
    }
    
    private func createWaitingChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 20
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createActiveChats() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 8
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 20, bottom: 0, trailing: 20)
        
        let sectionHeader = createSectionHeader()
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
    
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        return sectionHeader
        
    }
}


// MARK: UISearchBarDelegate

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
}


// MARK: SwiftUI

import SwiftUI

struct ListVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: ListVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListVCProvider.ContainerView>) {
            
        }
    }
}



