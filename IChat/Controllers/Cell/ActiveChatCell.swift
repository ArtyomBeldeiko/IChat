//
//  ActiveChatCell.swift
//  IChat
//
//  Created by Artyom Beldeiko on 20.05.22.
//

import Foundation
import UIKit
import SDWebImage


class ActiveChatCell: UICollectionViewCell, SelfConfiguringCell {
    
    
    
    static var reuseId: String = "ActiveChatCell"
    
    let friendImageView = UIImageView()
    let friendName = UILabel(text: "User name", font: .laoSangamMN20())
    let lastMessage = UILabel(text: "How are you", font: .laoSangamMN18())
    let gradientView = GradientView(from: .topTrailing, to: .bottomLeading, startColor: UIColor(red: 201 / 255, green: 161 / 255, blue: 240 / 255, alpha: 1), endColor: UIColor(red: 122 / 255, green: 178 / 255, blue: 235 / 255, alpha: 1))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupContraints()
        
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        
    }
    
    func configure<U>(with value: U) where U : Hashable {
        
        guard let chat: MChat = value as? MChat else { return }
       
        friendName.text = chat.friendUsername
        lastMessage.text = chat.lastMessageContent
        friendImageView.sd_setImage(with: URL(string: chat.friendAvatarStringURL), completed: nil)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Constraints Setup

extension ActiveChatCell {
    
    private func setupContraints() {
        
        friendImageView.translatesAutoresizingMaskIntoConstraints = false
        friendName.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        friendImageView.backgroundColor = .orange
        gradientView.backgroundColor = .black
        
        
        addSubview(friendImageView)
        addSubview(friendName)
        addSubview(lastMessage)
        addSubview(gradientView)
        
        
        NSLayoutConstraint.activate([
        
            friendImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            friendImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            friendImageView.heightAnchor.constraint(equalToConstant: 78),
            friendImageView.widthAnchor.constraint(equalToConstant: 78)
        
        ])
        
        NSLayoutConstraint.activate([
        
            friendName.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            friendName.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            friendName.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
        
            lastMessage.topAnchor.constraint(equalTo: friendName.bottomAnchor, constant: 2),
            lastMessage.leadingAnchor.constraint(equalTo: friendImageView.trailingAnchor, constant: 16),
            lastMessage.trailingAnchor.constraint(equalTo: gradientView.leadingAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
        
            gradientView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 78),
            gradientView.widthAnchor.constraint(equalToConstant: 8)
        
        ])
        
    }
    
}

// MARK: SwiftUI

import SwiftUI

struct ActiveChatCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ActiveChatCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: ActiveChatCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ActiveChatCellProvider.ContainerView>) {
            
        }
    }
}

