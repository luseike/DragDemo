//
//  UserCell.swift
//  DragDemo
//
//  Created by 远路蒋 on 2024/7/18.
//

import UIKit

class UserCell: UICollectionViewCell {
    var containerView: UIView!
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var amountLabel: UILabel!
    var itemLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "System - System", size: 18)
        nameLabel.textColor = .black.withAlphaComponent(0.9)
        amountLabel = UILabel()
        itemLabel = UILabel()
        
        nameLabel.textAlignment = .center
        amountLabel.textAlignment = .center
        itemLabel.textAlignment = .center
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(amountLabel)
        containerView.addSubview(itemLabel)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.equalTo(containerView).inset(12)
            make.leading.trailing.equalTo(containerView).inset(12)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalTo(imageView)
        }
        amountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        itemLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(nameLabel)
            make.top.equalTo(amountLabel.snp.bottom).offset(12)
        }
    }
    
    func configFoodCell(user: User) {
        self.imageView.image = UIImage(named: user.image)
        self.nameLabel.text = user.name
        amountLabel.isHidden = user.amount == 0
        amountLabel.text = "\(user.amount)元"
        itemLabel.isHidden = user.amount == 0
        itemLabel.text = "\(user.items)件"
        containerView.backgroundColor = user.isHighlighted ? .lightGray : .white
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
