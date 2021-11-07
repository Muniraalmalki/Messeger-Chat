//
//  ConversationTableViewCell.swift
//  Messenger
//
//  Created by munira almallki on 30/03/1443 AH.
//

import UIKit
import SDWebImage
class ConversationTableViewCell: UITableViewCell {
    
    static  let identifier = "ConversationTableViewCell"
        private let userImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private var  userNameLabel:UILabel = {
       var label = UILabel()
        label.font = .systemFont(ofSize: 21, weight:.semibold)
        return label

    }()

    private var userMessageLabel:UILabel = {
       var label = UILabel()
        label.font = .systemFont(ofSize: 18, weight:.semibold)
        return label

    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        //x: userImageView.frame.right + 10 error
        userNameLabel.frame = CGRect(x: userImageView.frame.height + 10, y: 10, width: contentView.frame.width - 20 - userImageView.frame.width, height: (contentView.frame.height-20)/2)
        // x:userImageView.frame.right + 10, y: userNameLabel.frame.bottom, error
        userMessageLabel.frame = CGRect(x: userImageView.frame.width + 10, y: userNameLabel.frame.height + 10 , width: contentView.frame.width - 20 - userImageView.frame.width , height: (contentView.frame.height-20)/2)

    }

public func configure(with model : Conversation){
    self.userMessageLabel.text = model.latestMessage.text
    self.userNameLabel.text = model.name
    let path = "images/\(model.otherUserEmail)_profile_picture.png"
    StorageManager.shared.downloadURL(for: path, completion: {[weak self]result in
        switch result{
        case .success(let url):
            DispatchQueue.main.async {
                self?.userImageView.sd_setImage(with: url, completed: nil)
            }
           
        case .failure(let error):
            print("failed to get image url :\(error)")
        }
    })
}

}

