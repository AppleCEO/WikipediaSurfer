//
//  RxSearchBarDelegateProxy.swift
//  RxCocoa
//
//  Created by Krunoslav Zaher on 7/4/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift

extension UISearchBar: HasDelegate {
    public typealias Delegate = UISearchBarDelegate
}

/// For more information take a look at `DelegateProxyType`.
open class RxSearchBarDelegateProxy
    : DelegateProxy<UISearchBar, UISearchBarDelegate>
    , DelegateProxyType 
    , UISearchBarDelegate {

    /// Typed parent object.
    public weak private(set) var searchWord: UISearchBar?

    /// - parameter searchBar: Parent object for delegate proxy.
    public init(searchWord: ParentObject) {
        self.searchWord = searchWord
        super.init(parentObject: searchWord, delegateProxy: RxSearchBarDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxSearchBarDelegateProxy(searchWord: $0) }
    }
}

#endif
