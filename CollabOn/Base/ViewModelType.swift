//
//  ViewModelType.swift
//  CollabOn
//
//  Created by 박다혜 on 1/4/24.
//

import Foundation
import RxSwift

protocol ViewModelType {

    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get }

    var input: Input { get }
    var output: Output { get }

}
