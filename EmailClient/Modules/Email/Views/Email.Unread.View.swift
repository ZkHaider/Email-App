//
//  Email.Unread.View.swift
//  EmailClient
//
//  Created by Haider Khan on 7/8/18.
//  Copyright © 2018 com.zkhaider. All rights reserved.
//

import Foundation
import UIKit
import Cartography

public final class UnreadView: BaseView {
    
    // MARK: - Attributes
    
    var unreadEmails: [EmailModel] = [] {
        didSet {
            guard unreadEmails != oldValue else { return }
            update(withModels: unreadEmails)
        }
    }
    
    // MARK: - Views
    
    let unreadLabel: UILabel = {
        let view = UILabel(frame: .zero)
        view.text = "UNREAD EMAILS"
        view.font = Styles.Fonts.avenirNextDemibold.font(with: 14.0)
        view.textAlignment = .left
        view.textColor = Styles.Colors.primaryColor.uiColor
        return view
    }()
    
    let unreadCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Init
    
    public required init() {
        super.init()
        initialize()
    }
    
    // MARK: - Lifecycle
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        // ...
    }
    
    // MARK: - Update
    
    private func update(withModels models: [EmailModel]) {
        
        // Update our tableview
        unreadCollectionView.reloadData()
    }
    
}

extension UnreadView {
    
    fileprivate func initialize() {
        func addSubviews() {
            self.addSubview(unreadLabel)
            self.addSubview(unreadCollectionView)
        }
        func setupConstraints() {
            constrain(unreadLabel, unreadCollectionView) {
                $0.leading == $0.superview!.leading + 10.0
                $0.top == $0.superview!.top
                $0.height == 20.0
                $0.bottom == $1.top - 4.0
                $1.leading == $1.superview!.leading
                $1.trailing == $1.superview!.trailing
                $1.bottom == $1.superview!.bottom
            }
            constrain(unreadCollectionView) {
                $0.edges == $0.superview!.edges
            }
        }
        func prepareViews() {
            unreadCollectionView.register(UnreadCollectionViewCell.self, forCellWithReuseIdentifier: UnreadCollectionViewCell.name)
            unreadCollectionView.delegate = self
            unreadCollectionView.dataSource = self
        }
        addSubviews()
        setupConstraints()
        prepareViews()
    }
    
}

extension UnreadView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 10.0, height: self.bounds.height - 40.0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0.0, 6.0, 0.0, 0.0)
    }
    
}

extension UnreadView: UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unreadEmails.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let unreadCell = collectionView.dequeueReusableCell(withReuseIdentifier: UnreadCollectionViewCell.name, for: indexPath) as! UnreadCollectionViewCell
        unreadCell.model = unreadEmails[indexPath.row]
        return unreadCell
    }
    
}
