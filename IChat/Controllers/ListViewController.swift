//
//  ListViewController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 19.05.22.
//

import UIKit
import SDWebImage
import FirebaseFirestore


class ListViewController: UIViewController {
    
    var activeChats = [MChat]()
    var waitingChats = [MChat]()
    
    var collectionView: UICollectionView!
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
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
    
    private let currentUser: MUSer
    
    init(currentUser: MUSer) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupSearchBar()
        createDataSource()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsObserve(chats: waitingChats, completion: { (result) in
            
            switch result {
                
            case .success(let chats):
                if self.waitingChats != [], self.waitingChats.count <= chats.count {
                    let chatRequestVC = ChatRequestViewController(chat: chats.last!)
                    chatRequestVC.delegate = self
                    self.present(chatRequestVC, animated: true, completion: nil)
                }
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.activeChatsObserve(chats: activeChats, completion: { (result) in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        })
        
    }
    
    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mainWhite()
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
        
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

// MARK: UICollectionViewDelegate

extension ListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let chat = self.dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .waitingChats:
            let chatRequestVC = ChatRequestViewController(chat: chat)
            chatRequestVC.delegate = self
            self.present(chatRequestVC, animated: true, completion: nil)
        case .activeChats:
            let chatsVC = ChatsViewController(user: currentUser, chat: chat)
            navigationController?.pushViewController(chatsVC, animated: true)
        
        }
    }
}

// MARK: WaitingChatNavigation

extension ListViewController: WaitingChatNavigation {
    
    func removeWaitingChat(chat: MChat) {
        FirestoreService.shared.deleteWaitingChat(chat: chat) { (result) in
            
            switch result {
                
            case .success:
                self.showAlert(with: "Success!", and: "Chat with \(chat.friendUsername) was deleted.")
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
    }
    
    func chatToActive(chat: MChat) {
        FirestoreService.shared.changeToActive(chat: chat) { (result) in
            
            switch result {
                
            case .success():
                self.showAlert(with: "Seucces!", and: "Start converstion with \(chat.friendUsername)")
            case .failure(let error):
                self.showAlert(with: "Error", and: error.localizedDescription)
            }
        }
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



