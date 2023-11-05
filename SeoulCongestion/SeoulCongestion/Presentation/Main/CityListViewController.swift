//
//  CityListViewController.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/01/25.
//

import UIKit
import SkeletonView
import Lottie
import SnapKit
import DropDown
import RxSwift
import RxCocoa

class CityListViewController: UIViewController {
    
    let citiesUseCase: CitiesUseCase
    let viewModel: CitiesViewModel
    let disposeBag = DisposeBag()

    init(citiesUseCase: CitiesUseCase, viewModel: CitiesViewModel) {
        self.citiesUseCase = citiesUseCase
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  let topLogoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "topLogo"))
        imageView.contentMode = .scaleAspectFit
    return imageView
  }()
    
  let leftLogoImageView: UIImageView = {
    let imageView = UIImageView(image: UIImage(named: "leftLogo"))
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

    
    let collectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      let cv = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout)
      cv.showsVerticalScrollIndicator = false
      return cv
    }()
    
    let citySearchTextField = CitySearchTextField()
    let cityTabListView = CityTabListView()
    let cityCountView = CityCountView()
    let emptyView = EmptyView()
    let dropDownView = DropDownView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesUseCase.requestCities()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .white
        configureCollectionView()
        configureSkeletonView()
        setUI()
        InPutBind()
        OutPutBind()
    }
    

    private func setUI() {
        view.addSubview(topLogoImageView)
        view.addSubview(leftLogoImageView)
        view.addSubview(citySearchTextField)
        view.addSubview(cityTabListView)
        view.addSubview(cityCountView)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(dropDownView)
        
        
        topLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(51)
            make.leading.equalTo(view.snp.leading).offset(83)
            make.trailing.equalTo(view.snp.trailing).offset(-187)
        }
        
        leftLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(topLogoImageView.snp.bottom).offset(5)
            make.leading.equalTo(view.snp.leading).offset(40)
            make.trailing.equalTo(citySearchTextField.snp.leading).offset(-5)
        }
        
        citySearchTextField.snp.makeConstraints { make in
            make.top.equalTo(leftLogoImageView.snp.top)
            make.bottom.equalTo(leftLogoImageView.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
        }
        
        cityTabListView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(citySearchTextField.snp.bottom).offset(20)
            make.bottom.equalTo(cityCountView.snp.top).offset(-25)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        cityCountView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cityCountView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        emptyView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).offset(150)
        }
        
        dropDownView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(150)
            make.top.equalTo(cityTabListView.snp.bottom).offset(25)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    private func InPutBind() {
        
        citySearchTextField.textField.rx.text.orEmpty.throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { searchText in
                self.viewModel.automaticSearch.accept(searchText)
            })
            .disposed(by: disposeBag)
        
        citySearchTextField.searchButton.rx.tap.subscribe { a in
            guard let text = self.citySearchTextField.textField.text else { return }
            self.viewModel.bb.accept(text)
        }
        .disposed(by: disposeBag)

        citySearchTextField.textField.rx.text.orEmpty.subscribe { text in
            self.viewModel.citySearchTextFieldObserver.accept(text)
        }
        .disposed(by: disposeBag)
        
        cityTabListView.didSelectTabObserver.subscribe { tab in
            self.viewModel.didSelectTabObserver.accept(tab)
        }
        .disposed(by: disposeBag)
    }
    
    private func OutPutBind() {
        
        viewModel.citySearchTextFieldOutPutObserver.subscribe { text in
            print(text)
        }
        .disposed(by: disposeBag)
                
        dropDownView.isDropDownMenuVisible.subscribe { text in
            self.viewModel.dropDownObserver.accept(text)
        }
        .disposed(by: disposeBag)
        
        viewModel.sortCitiesByAlphabetOutputObserver.subscribe { alphabeticalSorted in
            DispatchQueue.main.async {
                self.viewModel.seoulCities?.setCity(city: alphabeticalSorted)
                self.cityCountView.cityCntLabel.text = String(alphabeticalSorted.count)
                self.collectionView.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.didSelectTabOutPutObserver.subscribe { city in
            DispatchQueue.main.async {
                self.cityCountView.cityCntLabel.text = String(city.count)
                self.viewModel.seoulCities?.setCity(city: city)
                self.collectionView.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
        viewModel.aa.subscribe { city in
            DispatchQueue.main.async {
                self.cityCountView.cityCntLabel.text = String(city.count)
                self.viewModel.seoulCities?.setCity(city: city)
                self.collectionView.reloadData()
            }
        }
        .disposed(by: disposeBag)
        
        self.viewModel.cc.subscribe { filteredCities in
            self.viewModel.seoulCities?.setCity(city: filteredCities)
            guard let tot = self.viewModel.seoulCities?.cities[0].cities?.count else { return }

          DispatchQueue.main.async {
            self.citySearchTextField.buttonState = .success
            self.cityCountView.cityCntLabel.text = String(tot)
            self.citySearchTextField.textField.isEnabled = true
            self.collectionView.reloadData()
          }
        }
        .disposed(by: disposeBag)
        
        self.citiesUseCase.citiesList.subscribe { citiesData in
            self.viewModel.seoulCities = SeoulCities(citiesData)
            guard let tot = self.viewModel.seoulCities?.cities[0].cities?.count else { return }
            self.viewModel.categorizeCities()
                      DispatchQueue.main.async {
                        self.cityCountView.cityCntLabel.text = String(tot)
                        self.collectionView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.citySearchTextField.textField.isEnabled = true
                        self.cityTabListView.enableAllTabButtons()
                      }

        }
        .disposed(by: disposeBag)
    }
    
  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.register(MainCell.self, forCellWithReuseIdentifier: MainCell.identifier)
  }
  
  private func configureSkeletonView() {
    collectionView.isSkeletonable = true
    let skeletonAnimation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    self.collectionView.showAnimatedGradientSkeleton(usingGradient: .init(colors: [.lightGray, .gray]), animation: skeletonAnimation, transition: .none)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}

extension CityListViewController: UICollectionViewDelegate {
  
}

extension CityListViewController: SkeletonCollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
      guard let cityCount =  self.viewModel.seoulCities?.getNumberOfCities() else { return 0 }
      if cityCount == 0 {
          emptyView.isHidden = false
          collectionView.isHidden = true
          return 0
      } else {
          emptyView.isHidden = true
          collectionView.isHidden = false
          return cityCount
      }
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath
  ) {
    view.endEditing(true)
      let city = self.viewModel.seoulCities?.getOneCenter(at: indexPath)
    let cityDetailController = CityDetailController(city)
    navigationController?.pushViewController(cityDetailController, animated: true)
  }
  
  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    cellIdentifierForItemAt indexPath: IndexPath
  ) -> SkeletonView.ReusableCellIdentifier {
    return MainCell.identifier
  }
  
  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return UICollectionView.automaticNumberOfSkeletonItems
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: MainCell.identifier,
      for: indexPath) as? MainCell else { return UICollectionViewCell() }
      guard let cities = self.viewModel.seoulCities else { return UICollectionViewCell() }
      let city = cities.getCity()
    
    cell.city = city?[indexPath.item]
    
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.width, height: cell.frame.height))
    let image = UIImage(named: city?[indexPath.item].areaNM ?? "")
    imageView.image = image
    
    let gradientViewFrame = imageView.frame;
    imageView.addGradient(frame: gradientViewFrame)
    cell.backgroundView = UIView()
    cell.backgroundView!.addSubview(imageView)
    return cell
  }
  
  func collectionSkeletonView(
    _ skeletonView: UICollectionView,
    skeletonCellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell? {
    skeletonView.dequeueReusableCell(withReuseIdentifier: MainCell.identifier, for: indexPath)
  }
}

extension CityListViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collecitonView: UICollectionView,
    layout collectionVIewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: view.frame.width - 80, height: 165)
  }
}

extension CityListViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      viewModel.getCitiesSearchAPI()
      textField.resignFirstResponder()
      return true
  }
}

extension CityListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            collectionView.snp.remakeConstraints { make in
                make.top.equalTo(topLogoImageView.snp.top)
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }

            UIView.animate(withDuration: 0.3) {
                self.topLogoImageView.alpha = 0
                self.leftLogoImageView.alpha = 0
                self.citySearchTextField.alpha = 0
                self.cityCountView.alpha = 0
                self.dropDownView.alpha = 0
                self.view.layoutIfNeeded()
            }
        } else {
            collectionView.snp.remakeConstraints { make in
                make.top.equalTo(dropDownView.snp.bottom).offset(10)
                make.leading.equalTo(view.snp.leading)
                make.trailing.equalTo(view.snp.trailing)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.topLogoImageView.alpha = 1
                self.leftLogoImageView.alpha = 1
                self.citySearchTextField.alpha = 1
                self.cityCountView.alpha = 1
                self.dropDownView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
}
