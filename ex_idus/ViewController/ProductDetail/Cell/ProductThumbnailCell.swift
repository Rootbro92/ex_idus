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

    var thumbList: [String] = []

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!

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
        flowLayout.itemSize = CGSize(width: UI.itemWidth, height: UI.itemHeight)
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
        progressView.progressTintColor = .white
    }

    func configure(thumbList: String) {
        self.thumbList = thumbList.components(separatedBy: "#")
        reload()
        setProgress()
    }

    func reload() {
        thumbnailCollectionView.reloadData()
    }
    
    func setProgress(page: Int = 0) {
        self.progressView.setProgress(1.0/Float(self.thumbList.count)*Float(page+1), animated: false)
    }
}

extension ProductThumbnailCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let page = Int(targetContentOffset.pointee.x / self.frame.width)
      //self.pageControl.currentPage = page
        //print(page)
        setProgress(page: page)
    }
}

extension ProductThumbnailCell: UICollectionViewDelegateFlowLayout {

}
