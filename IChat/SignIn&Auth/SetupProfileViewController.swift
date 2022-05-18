//
//  SetupProfileViewController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 18.05.22.
//

import UIKit

class SetupProfileViewController: UIViewController {
    
    let addPhotoView = PhotoView()
    
    //    MARK: Labels
    
    let welcomeLabel = UILabel(text: "Sign up your profile!", font: .avenir26())
    let fullNameLabel = UILabel(text: "Name and Surname")
    let aboutMeLabel = UILabel(text: "About me")
    let sexLabel = UILabel(text: "Sex")
    
    //    MARK: TextField
    
    let fullNameTextField = SeparatorTextField(font: .avenir20())
    let aboutMeTextField = SeparatorTextField(font: .avenir20())
    
    //    MARK: SegmentedControl
    
    let sexSegmentedControl = UISegmentedControl(first: "Male", second: "Female")
    
    //    MARK: Buttons
    
    let goToChatsButton = UIButton(title: "Go to chats", titleColor: .white, backgroundColor: .mainBlack(), font: .avenir20(), isShadow: false, cornerRadius: 4)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupconstraints()
        
    }
    
}

extension SetupProfileViewController {
    
    private func setupconstraints() {
        
        let fullNameStackView = UIStackView(arrangedSubviews: [fullNameLabel, fullNameTextField], axis: .vertical, spacing: 0)
        let aboutMeStackView = UIStackView(arrangedSubviews: [aboutMeLabel, aboutMeTextField], axis: .vertical, spacing: 0)
        let sexStackView = UIStackView(arrangedSubviews: [sexLabel, sexSegmentedControl], axis: .vertical, spacing: 12)
        
        goToChatsButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let combinedStackView = UIStackView(arrangedSubviews: [fullNameStackView, aboutMeStackView, sexStackView, goToChatsButton], axis: .vertical, spacing: 40)
        
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        addPhotoView.translatesAutoresizingMaskIntoConstraints = false
        combinedStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(welcomeLabel)
        view.addSubview(addPhotoView)
        view.addSubview(combinedStackView)
        
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoView.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 40),
            addPhotoView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            combinedStackView.topAnchor.constraint(equalTo: addPhotoView.bottomAnchor, constant: 40),
            combinedStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            combinedStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        
        
        
        
    }
    
}


// MARK: SwiftUI

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let SetupProfileVC = SetupProfileViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return SetupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            
        }
    }
}
