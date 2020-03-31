//
//  ProductThumbnailCell.swift
//  ex_idus
//
//  Created by 박근형 on 2020/03/29.
//  Copyright © 2020 pgh. All rights reserved.
//

import UIKit

class ProductThumbnailCell: UITableViewCell {

    struct UI {
        static let itemWidth: CGFloat = UIScreen.main.bounds.width
        static let itemHeight: CGFloat = itemWidth
        static let radius: CGFloat = 20
    }
    
    private var thumbList: [String] = []
    private var thumb: String = ""
    
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    
    var item: ModelItem? {
        didSet {
            guard let item = item as? Thumb else { return }
            self.thumbList = item.thumbList
            self.thumb = item.thumb
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupFlowLayout()
        // Initialization code
    }

    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.itemSize = CGSize(width: UI.itemWidth , height: UI.itemHeight)
        flowLayout.scrollDirection = .horizontal
        self.thumbnailCollectionView.collectionViewLayout = flowLayout
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
        layer.cornerRadius = UI.radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

extension ProductThumbnailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(thumbList.count)
        return thumbList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThumbnailCollectionViewCell.reuseIdentifier, for: indexPath) as? ThumbnailCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: thumbList[indexPath.row])
        return cell
    }
}

extension ProductThumbnailCell: UICollectionViewDelegate {
    
}

extension ProductThumbnailCell: UICollectionViewDelegateFlowLayout {
    
}
