//
//  ChannelChattingViewController.swift
//  CollabOn
//
//  Created by 박다혜 on 2/22/24.
//

import UIKit
import PhotosUI
import RxSwift
import RxCocoa

final class ChannelChattingViewController: BaseViewController {

    private let inputBar = InputBar()

    let viewModel = ChannelChattingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
    }

    let disposeBag = DisposeBag()

    override func bindRx() {
        inputBar.addImageButtonDidTap.asSignal()
            .emit(with: self, onNext: { owner, _ in
                owner.presentPickerView()
            })
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {
        view.addSubview(inputBar)
    }

    override func setLayout() {
        inputBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }

    override func setUIProperties() {
        
    }

}

extension ChannelChattingViewController {

    private func presentPickerView() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5

        configuration.filter = .any(of: [.images, .depthEffectPhotos, .livePhotos])

        let picker = PHPickerViewController(configuration: configuration)
        picker.modalPresentationStyle = .formSheet
        picker.delegate = self

        present(picker, animated: true)
    }

    private func setNavItem() {

        let settingButton = UIBarButtonItem(
            image: .list,
            style: .done,
            target: self,
            action: #selector(settingButtonDidTap)
        )
        settingButton.tintColor = .black
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = settingButton

    }

    @objc private func settingButtonDidTap() {

    }

}

extension ChannelChattingViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        for result in results {
            let itemProvider = result.itemProvider
            if itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { data, error in
                    guard let data, let image = UIImage(data: data) else { return }
                    image.resizeImage(toTargetSizeMB: 1) { image in
                        guard let image = image, let data = image.jpegData(compressionQuality: 1) else { return }
                        DispatchQueue.main.async {
                            self.inputBar.addPicture(image)
                        }
                    }
                }
            }
        }

        DispatchQueue.main.async {
            picker.dismiss(animated: true)
        }
    }

}
