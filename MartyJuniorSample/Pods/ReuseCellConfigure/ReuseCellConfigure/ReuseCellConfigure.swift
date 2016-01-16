//
//  ReuseCellConfigure.swift
//  ReuseCellConfigure
//
//  Created by Taiki Suzuki on 2016/01/02.
//  Copyright © 2016年 szk-atmosphere. All rights reserved.
//

import UIKit

//MARK: - UITableView Extension
public extension UITableView {
    public func dequeueReusableCellWithIdentifier<T where T: UITableViewCell>(identifier: String, classForCell: T.Type, configure: T -> Void) -> T? {
        guard let cell = dequeueReusableCellWithIdentifier(identifier) as? T else { return nil }
        configure(cell)
        return cell
    }
    
    public func dequeueReusableCellWithIdentifier<T where T: UITableViewCell>(identifier: String, forIndexPath indexPath: NSIndexPath, classForCell: T.Type, configure: T -> Void) -> UITableViewCell {
        let reusableCell = dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
        guard let cell = reusableCell as? T else { return reusableCell }
        configure(cell)
        return cell
    }
}

//MARK: - UICollectionView Extension
public extension UICollectionView {
    public func dequeueReusableCellWithReuseIdentifier<T where T: UICollectionViewCell>(identifier: String, forIndexPath indexPath: NSIndexPath, classForCell: T.Type, configure: T -> Void) -> UICollectionViewCell {
        let reusableCell = dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath)
        guard let cell = reusableCell as? T else { return reusableCell }
        configure(cell)
        return cell
    }
}