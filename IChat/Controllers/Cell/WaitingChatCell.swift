//
//  WaitingChatCell.swift
//  IChat
//
//  Created by Artyom Beldeiko on 20.05.22.
//

import UIKit


class WaitingChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    static var reuseId: String = "WaitingChatCell"
    
    let friendImage = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
        setupConstraints()
        
    }
    
    func configure<U>(with value: U) where U : Hashable {
        
        guard let chat: MChat = value as? MChat else { return }
        
        friendImage.image = UIImage(named: chat.userImageString)
        
    }
    
    private func setupConstraints() {
        
        friendImage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(friendImage)
        
        NSLayoutConstraint.activate([
            
            friendImage.topAnchor.constraint(equalTo: self.topAnchor),
            friendImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            friendImage.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: SwiftUI

import SwiftUI

struct WaitingChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: WaitingChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<WaitingChatCellProvider.ContainerView>) {
            
        }
    }
}

