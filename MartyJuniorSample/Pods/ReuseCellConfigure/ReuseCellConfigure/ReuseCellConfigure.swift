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
    public func dequeueReusableCell<T where T: UITableViewCell>(withIdentifier identifier: String, to classType: T.Type, @noescape configure: (T) -> Void) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: identifier) as? T else { return nil }
        configure(cell)
        return cell
    }
    
    public func dequeueReusableCell<T where T: UITableViewCell>(withIdentifier identifier: String, for indexPath: IndexPath, to classType: T.Type, @noescape configure: (T) -> Void) -> UITableViewCell {
        let reusableCell = dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        guard let cell = reusableCell as? T else { return reusableCell }
        configure(cell)
        return cell
    }
}

//MARK: - UICollectionView Extension
public extension UICollectionView {
    public enum ElementKind {
        case header
        case footer
        
        init?(rawValue: String) {
            switch rawValue {
            case UICollectionElementKindSectionHeader: self = .header
            case UICollectionElementKindSectionFooter: self = .footer
            default: return nil
            }
        }
        
        var value: String {
            switch self {
            case .header: return UICollectionElementKindSectionHeader
            case .footer: return UICollectionElementKindSectionFooter
            }
        }
    }
    
    public func register(_ nib: UINib?, forSupplementaryViewOfKind kind: ElementKind, withReuseIdentifier identifier: String) {
        register(nib, forSupplementaryViewOfKind: kind.value, withReuseIdentifier: identifier)
    }
    
    public func register(_ viewClass: AnyClass?, forSupplementaryViewOfKind elementKind: ElementKind, withReuseIdentifier identifier: String) {
        register(viewClass, forSupplementaryViewOfKind: elementKind.value, withReuseIdentifier: identifier)
    }
    
    public func dequeueReusableSupplementaryView(ofKind elementKind: ElementKind, withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionReusableView {
        return dequeueReusableSupplementaryView(ofKind: elementKind.value, withReuseIdentifier: identifier, for: indexPath)
    }
    
    public func dequeueReusableSupplementaryView<T where T: UICollectionReusableView>(ofKind elementKind: ElementKind, withReuseIdentifier identifier: String, for indexPath: IndexPath, to classType: T.Type, @noescape configure: (T) -> Void) -> UICollectionReusableView {
        let reusableView = dequeueReusableSupplementaryView(ofKind: elementKind, withReuseIdentifier: identifier, for: indexPath)
        guard let view = reusableView as? T else { return reusableView }
        configure(view)
        return view
    }
    
    public func dequeueReusableCell<T where T: UICollectionViewCell>(withReuseIdentifier identifier: String, for indexPath: IndexPath, to classType: T.Type, @noescape configure: (T) -> Void) -> UICollectionViewCell {
        let reusableCell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        guard let cell = reusableCell as? T else { return reusableCell }
        configure(cell)
        return cell
    }
}
