//
//  HomeViewController.swift
//  ios-imgur-gallery
//
//  Created by Gustavo Ziger on 01/10/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    private var pageNumber = 0
    private var imageList = [Image]()
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadImages()
    }

    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Imgur Gallery"
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.tintColor = .black
        activityIndicator.color = .darkGray
        activityIndicator.style = .large
        
        
        
    }
    
    private func loadImages() {
        isLoading = true
        activityIndicator.startAnimating()
        
        NetworkManager.shared.fetchImageList(pageNumber) { result in
            DispatchQueue.main.async {
                let filteredImages = result.filter({ image in
                    return image.type == "image/jpeg" || image.type == "image/png"
                })
                
                if self.imageList.count > 0 {
                    for image in filteredImages {
                        if self.imageList.contains(where: {$0.id == image.id}){
                            return
                        }
                        self.imageList.append(image)
                        self.collectionView.performBatchUpdates({
                            self.collectionView.insertItems(at: [IndexPath(item: self.imageList.count - 1, section: 0)])
                        })
                    }
                } else {
                    self.imageList.append(contentsOf: filteredImages)
                }
                
                self.pageNumber += 1
                self.collectionView.reloadData()
                
                if self.imageList.count < 30 {
                    self.loadImages()
                }
                
                self.isLoading = false
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
        cell.loadFrom(imageList[indexPath.row].link)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.size.width/4) - 5, height: (view.frame.size.width/4) - 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let bottomEdge = collectionView.contentOffset.y + collectionView.frame.size.height + 5;
        
        if (bottomEdge >= collectionView.contentSize.height) {
            if !isLoading {
                loadImages()
            }
        }
    }
}
