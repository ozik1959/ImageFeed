import UIKit

final class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let profileImageAvatar = UIImage(named: "Profile Avatar")
        let profileAvatar = UIImageView(image: profileImageAvatar)
        profileAvatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileAvatar)
        profileAvatar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        profileAvatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        profileAvatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        profileAvatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        let profileNameLable = UILabel()
        profileNameLable.text = "Екатерина Новикова"
        profileNameLable.textColor = .init(named: "YP White")
        profileNameLable.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(profileNameLable)
        profileNameLable.leadingAnchor.constraint(equalTo: profileAvatar.leadingAnchor).isActive = true
        profileNameLable.topAnchor.constraint(equalTo: profileAvatar.bottomAnchor, constant: 8).isActive = true
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = .init(named: "YP White")
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.leadingAnchor.constraint(equalTo: profileAvatar.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: profileNameLable.bottomAnchor, constant: 8).isActive = true
        
        let button = UIButton()
        button.setImage(UIImage(named: "logout_button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -18).isActive = true
        button.centerYAnchor.constraint(equalTo: profileAvatar.centerYAnchor).isActive = true
        
    }
}
