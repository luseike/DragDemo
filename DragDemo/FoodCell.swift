//
//  FoodCell.swift
//  DragDemo
//
//  Created by 远路蒋 on 2024/7/16.
//

import UIKit
import SnapKit

class FoodCell: UICollectionViewCell {
    var containerView: UIView!
    var imageView: UIImageView!
    var nameLabel: UILabel!
    var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 12
        containerView.layer.masksToBounds = true
        
        imageView = UIImageView()
        imageView.layer.cornerRadius = 18
        imageView.layer.masksToBounds = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "System - System", size: 18)
        nameLabel.textColor = .black.withAlphaComponent(0.9)
        priceLabel = UILabel()
        
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(60)
            make.top.bottom.equalTo(containerView).inset(12)
            make.leading.equalTo(containerView).offset(20)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(20)
            //make.height.equalTo(30)
        }
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom)//.offset(12)
            
        }
    }
    
    func configFoodCell(food: Food) {
        self.imageView.image = UIImage(named: food.image)
        self.nameLabel.text = food.name
        self.priceLabel.text = "\(food.price)元"// String(food.price)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
