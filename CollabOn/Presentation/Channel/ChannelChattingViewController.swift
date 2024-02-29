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
    private let chatTableView = UITableView()

    let viewModel: ChannelChattingViewModel

    init(viewModel: ChannelChattingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavItem()
        view.backgroundColor = .white
        tabBarController?.tabBar.isHidden = true
    }

    let disposeBag = DisposeBag()

    override func bindRx() {
        viewModel.output.chatList
            .bind(to: chatTableView.rx.items(cellIdentifier: ChannelChattingTableViewCell.className, cellType: ChannelChattingTableViewCell.self)) { (row, element, cell) in
                cell.setData(element)
            }
            .disposed(by: disposeBag)

        inputBar.addImageButtonDidTap.asSignal()
            .emit(with: self) { owner, _ in
                owner.presentPickerView()
            }
            .disposed(by: disposeBag)

        inputBar.sendButtonDidTap.asSignal()
            .emit(to: viewModel.input.sendButtonDidTap)
            .disposed(by: disposeBag)

        inputBar.text
            .bind(to: viewModel.input.chatText)
            .disposed(by: disposeBag)
    }

    override func configHierarchy() {
        view.addSubview(inputBar)
        view.addSubview(chatTableView)
    }

    override func setLayout() {
        inputBar.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        chatTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(inputBar.snp.top)
        }
    }

    override func setUIProperties() {
        chatTableView.register(ChannelChattingTableViewCell.self, forCellReuseIdentifier: ChannelChattingTableViewCell.className)
        chatTableView.separatorStyle = .none
        chatTableView.backgroundColor = .clear
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = 180
        chatTableView.allowsSelection = false
        chatTableView.showsVerticalScrollIndicator = false
        chatTableView.delegate = self
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

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .backgroundSecondary
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.title = String(localized: "?????")

        let settingButton = UIBarButtonItem(
            image: .list,
            style: .done,
            target: self,
            action: #selector(settingButtonDidTap)
        )
        settingButton.tintColor = .black
        navigationController?.navigationBar.tintColor = .white.withAlphaComponent(0.75)
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
                itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                    guard let data, let image = UIImage(data: data) else { return }
                    image.resizeImage(toTargetSizeMB: 1) { image in
                        guard let image = image, let data = image.jpegData(compressionQuality: 1) else { return }
                        DispatchQueue.main.async {
                            self?.inputBar.addPicture(image)
                            self?.viewModel.input.file.onNext(data)
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

extension ChannelChattingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
