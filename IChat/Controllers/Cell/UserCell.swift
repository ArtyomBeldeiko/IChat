//
//  UserCell.swift
//  IChat
//
//  Created by Artyom Beldeiko on 22.05.22.
//

import UIKit

class UserCell: UICollectionViewCell, SelfConfiguringCell {
    
    let userImageView = UIImageView()
    let userName = UILabel(text: "text", font: .laoSangamMN20())
    let containerView = UIView()
    
    
    static var reuseId: String = "UserCell"
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupContraints()
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor(red: 189 / 255, green: 189 / 255, blue: 189 / 255, alpha: 1).cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.containerView.layer.cornerRadius = 4
        self.containerView.clipsToBounds = true
    }
    
    private func setupContraints() {
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
            
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            userImageView.heightAnchor.constraint(equalTo: containerView.widthAnchor)
        
        ])
        
        NSLayoutConstraint.activate([
            
            userName.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userName.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            userName.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            userName.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        
        ])
        
    }
    
    func configure<U>(with value: U) where U : Hashable {
        
        guard let user: MUSer = value as? MUSer else { return }
        
        userImageView.image = UIImage(named: user.avatarStringURL)
        userName.text = user.username
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: SwiftUI

import SwiftUI

struct UserCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let tabBarVC = MainTabBarController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<UserCellProvider.ContainerView>) -> MainTabBarController {
            return tabBarVC
        }
        
        func updateUIViewController(_ uiViewController: UserCellProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<UserCellProvider.ContainerView>) {
            
        }
    }
}

