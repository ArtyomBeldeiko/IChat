//
//  SetupProfileViewController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 18.05.22.
//

import UIKit
import Firebase

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
    
    private let currentUser: User
    
    init(currentUser: User) {
        
        self.currentUser = currentUser
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupconstraints()
        
        goToChatsButton.addTarget(self, action: #selector(goToChatsButtonTapped), for: .touchUpInside)
        
        addPhotoView.plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        
    }
    
    @objc private func plusButtonTapped() {
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
        
        
        
    }
    
    @objc private func goToChatsButtonTapped() {
        
        FirestoreService.shared.saveProfileWith(id: currentUser.uid,
                                                email: currentUser.email!,
                                                username: fullNameTextField.text,
                                                avatarImage: addPhotoView.imageView.image,
                                                description: aboutMeTextField.text,
                                                sex: sexSegmentedControl.titleForSegment(at: sexSegmentedControl.selectedSegmentIndex)) { (result) in
            switch result {
            case .success(let muser):
                self.showAlert(with: "Success!", and: "High time to start conversation!") {
                    let mainTabBar = MainTabBarController(currentUser: muser)
                    mainTabBar.modalPresentationStyle = .fullScreen
                    self.present(mainTabBar, animated: true, completion: nil)
                }
            case .failure(let error):
                self.showAlert(with: "Error!", and: error.localizedDescription)
            }
        }
        
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

// MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension SetupProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        addPhotoView.imageView.image = image
    }
    
}


// MARK: SwiftUI

import SwiftUI

struct SetupProfileVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainerView: UIViewControllerRepresentable {
        
        let SetupProfileVC = SetupProfileViewController(currentUser: Auth.auth().currentUser!)
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) -> SetupProfileViewController {
            return SetupProfileVC
        }
        
        func updateUIViewController(_ uiViewController: SetupProfileVCProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<SetupProfileVCProvider.ContainerView>) {
            
        }
    }
}
