//
//  ViewController.swift
//  DragDemo
//
//  Created by 远路蒋 on 2024/7/16.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    var foodCollectionView: UICollectionView!
    var userCollectionView: UICollectionView!
    
    let foods: [Food] = [.init(id: 1, name: "Pizza", price: 20, image: "Pizza"),
                               .init(id: 2, name: "Pasta", price: 13, image: "Pasta"),
                               .init(id: 6, name: "Burger", price: 10, image: "burger"),
                               .init(id: 7, name: "Sizzler", price: 50, image: "Sizzler")]

    var users: [User] = [.init(id: 1, name: "John", image: "person1", amount: 0, items: 0),
                         .init(id: 2, name: "Daizy", image: "person2", amount: 0, items: 0),
                         .init(id: 3, name: "Tom", image: "person3", amount: 0, items: 0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBrown
        
        let foodLayout = UICollectionViewFlowLayout()
        
        foodLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 84)
        foodLayout.scrollDirection = .vertical
        
        foodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: foodLayout)
        foodCollectionView.translatesAutoresizingMaskIntoConstraints = false
        foodCollectionView.backgroundColor = .clear
        foodCollectionView.delegate = self
        foodCollectionView.dataSource = self
        foodCollectionView.register(FoodCell.self, forCellWithReuseIdentifier: "FoodCell")
        
        
        let userLayout = UICollectionViewFlowLayout()
        userLayout.itemSize = CGSize(width: 104, height: 200)
        userLayout.scrollDirection = .vertical
        
        userCollectionView = UICollectionView(frame: .zero, collectionViewLayout: userLayout)
        userCollectionView.translatesAutoresizingMaskIntoConstraints = false
        userCollectionView.backgroundColor = .clear
        userCollectionView.delegate = self
        userCollectionView.dataSource = self
        userCollectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        
        foodCollectionView.dragDelegate = self
        userCollectionView.dropDelegate = self
        
        view.addSubview(foodCollectionView)
        view.addSubview(userCollectionView)
        
        foodCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view)
            make.height.equalTo(460)
        }
        userCollectionView.snp.makeConstraints { make in
            make.top.equalTo(foodCollectionView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(foodCollectionView).inset(28)
            make.bottom.equalTo(self.view)
        }
        
    }


}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == foodCollectionView {
            return foods.count
        } else {
            return users.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == foodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
            cell.configFoodCell(food: foods[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
            cell.configFoodCell(user: users[indexPath.row])
            return cell
        }
        
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: any UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemPrice = String(foods[indexPath.item].price)
        let itemProvider = NSItemProvider(object: itemPrice as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = itemPrice
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        if collectionView == foodCollectionView {
            let previewParameters = UIDragPreviewParameters()
            previewParameters.visiblePath = UIBezierPath(roundedRect: CGRect(x: 20, y: 12, width: 60, height: 60), cornerRadius: 18)
            return previewParameters
        }
        return nil
    }
}

extension ViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: any UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: row - 1, section: 0)
        }

        if collectionView == userCollectionView {
            if coordinator.proposal.operation == .copy {
                copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            }
        }
    }
    
    // Get the position of the dragged data over the collection view changed
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: any UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView == userCollectionView, let indexPath = destinationIndexPath {
            users.indices.forEach{ users[$0].isHighlighted = false }
            users[indexPath.item].isHighlighted = true
            collectionView.reloadData()
        }
        return UICollectionViewDropProposal(operation: .copy)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: any UIDropSession) {
        users.indices.forEach({users[$0].isHighlighted = false})
        collectionView.reloadData()
    }
    
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.performBatchUpdates {
            for (_, item) in coordinator.items.enumerated() {
                if collectionView === userCollectionView {
                    let productPrice = item.dragItem.localObject as? String
                    if let price = productPrice, let intPrice = Int(price) {
                        users[destinationIndexPath.item].amount += intPrice
                        users[destinationIndexPath.item].items += 1
                        UIView.performWithoutAnimation {
                            collectionView.reloadSections(IndexSet(integer: 0))
                        }
                    }
                }
            }
        }
    }
}

