//
//  InputBar.swift
//  CollabOn
//
//  Created by 박다혜 on 2/23/24.
//

import UIKit
import RxSwift
import RxCocoa

final class InputBar: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configHierarchy()
        setLayout()
        setUIProperties()
        bindRx()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let disposeBag = DisposeBag()

    private let inputBackgroundView = UIView()
    private let inputStackView = UIStackView()
    private let pictureStackView = UIStackView()
    private let textView = UITextView()
    private let placeholder = UILabel()
    private let sendButton = UIButton()
    private let addImageButton = UIButton()
    private var count = 0

    private var imageCount = BehaviorSubject(value: 0)

    let addImageButtonDidTap = PublishRelay<Void>()
    let sendButtonDidTap = PublishRelay<Void>()

    var text: Observable<String> {
        textView.rx.text.orEmpty
            .distinctUntilChanged()
            .asObservable()
    }

    private func bindRx() {

        imageCount
            .bind(with: self) { owner, value in
                owner.placeholder.rx.isHidden.onNext(value > 0)
                owner.addImageButton.rx.isEnabled.onNext(value < 5)
            }
            .disposed(by: disposeBag)

        textView.rx.didChange
            .bind(with: self) { owner, _ in
                let size = CGSize(width: owner.inputStackView.frame.width, height: .infinity)
                let estimatedSize = owner.textView.sizeThatFits(size)

                if estimatedSize.height > 54 {
                    owner.textView.isScrollEnabled = true
                }
                else {
                    owner.textView.isScrollEnabled = false
                }

                owner.textView.reloadInputViews()
                owner.textView.setNeedsUpdateConstraints()
            }
            .disposed(by: disposeBag)

        addImageButton.rx.tap
            .bind(to: addImageButtonDidTap)
            .disposed(by: disposeBag)

        sendButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.sendButtonDidTap.accept(())
                owner.textView.text = ""
            }
            .disposed(by: disposeBag)

        textView.rx.didBeginEditing
            .bind(with: self) { owner, _ in
                owner.placeholder.isHidden = true
            }
            .disposed(by: disposeBag)

        textView.rx.didEndEditing
            .withLatestFrom(textView.rx.text)
            .map { $0 != nil }
            .bind(with: self) { owner, value in
                owner.placeholder.rx.isHidden.onNext(value)
            }
            .disposed(by: disposeBag)

        Observable.combineLatest(textView.rx.text.orEmpty, imageCount)
            .map({ (text, count) in
                return (text.isEmpty || text.trimmingCharacters(in: [" "]) == "") && count == 0
            })
            .bind(with: self) { owner, value in
                let image: UIImage = value ? .send : .sendFill
                owner.sendButton.setImage(image, for: .normal)
            }
            .disposed(by: disposeBag)
    }

    func addPicture(_ image: UIImage) {
        let view = UIView()
        let deleteButton = UIImageView(image: .delete)
        let pictureImage = UIImageView()

        count += 1
        imageCount.onNext(count)

        pictureStackView.addArrangedSubview(view)
        view.addSubview(pictureImage)
        view.addSubview(deleteButton)

        view.snp.makeConstraints {
            $0.size.equalTo(50)
        }

        pictureImage.snp.makeConstraints {
            $0.leading.bottom.equalToSuperview()
            $0.size.equalTo(44)
        }

        deleteButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(20)
        }

        pictureImage.image = image
        pictureImage.contentMode = .scaleAspectFill
        pictureImage.layer.cornerRadius = 8
        pictureImage.clipsToBounds = true

    }

}

extension InputBar {

    private func configHierarchy() {
        addSubview(inputBackgroundView)
        inputBackgroundView.addSubview(inputStackView)
        inputStackView.addArrangedSubview(textView)
        inputStackView.addArrangedSubview(pictureStackView)
        inputBackgroundView.addSubview(placeholder)
        inputBackgroundView.addSubview(sendButton)
        inputBackgroundView.addSubview(addImageButton)
    }

    private func setLayout() {

        inputBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.greaterThanOrEqualTo(38)
        }

        addImageButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(9)
            $0.width.equalTo(22)
            $0.height.equalTo(20)
        }

        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(9)
            $0.size.equalTo(24)
        }

        placeholder.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(addImageButton.snp.trailing).offset(8)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
            $0.height.equalTo(18)
        }

        inputStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(8)
            $0.leading.equalTo(addImageButton.snp.trailing).offset(8)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }

        textView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(18)
        }

    }

    private func setUIProperties() {
        sendButton.backgroundColor = .clear
        sendButton.setImage(.send, for: .normal)
        sendButton.tintColor = .textSecondary

        addImageButton.backgroundColor = .clear
        addImageButton.setImage(.plus, for: .normal)
        addImageButton.tintColor = .textSecondary

        inputBackgroundView.layer.cornerRadius = 8
        inputBackgroundView.backgroundColor = .backgroundPrimary

        inputStackView.axis = .vertical
        inputStackView.spacing = 8
        inputStackView.alignment = .leading
        inputStackView.distribution = .fill

        pictureStackView.axis = .horizontal
        pictureStackView.spacing = 6
        pictureStackView.alignment = .fill
        pictureStackView.distribution = .fill

        placeholder.font = .body
        placeholder.textColor = .textSecondary
        placeholder.text = String(localized: "메세지를 입력하세요")

        textView.font = .body
        textView.backgroundColor = .clear
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.isScrollEnabled = false
    }

}
