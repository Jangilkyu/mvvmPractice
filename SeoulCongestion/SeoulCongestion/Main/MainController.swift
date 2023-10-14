//
//  MainController.swift
//  SeoulCongestion
//
//  Created by jangilkyu on 2023/01/25.
//

import UIKit
import SkeletonView
import Lottie
import DropDown
import SnapKit

class MainController: UIViewController {
    let viewModel = MainViewModel(restProcessor: RestProcessor())
    
    
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
    
    let citySearchTextField = CitySearchTextField()
    let cityTabListView = CityTabListView()
    let cityCountView = CityCountView()
    let emptyView = EmptyView()
    let dropDownView = DropDownView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        emptyView.isHidden = true
        self.citySearchTextField.textField.isEnabled = false
        viewModel.getCitiesAPIInfo()
        configureTFDelegate()
        
        // API fetch begins
        viewModel.restProcessor.reqeustDelegate = self
        
        cityTabListView.delegate = self
        dropDownView.mainController = self
        setup()
    }
    
    private func setup() {
        addViews()
        setConstraints()
        configureCollectionView()
        configureSkeletonView()
        configureSearchButton()
        dropDownView.setupTapGestureRecognizer()
    }
    
    private func configureTFDelegate() {
        self.citySearchTextField.textField.delegate = self
    }
    
    private func addViews() {
        view.addSubview(topLogoImageView)
        view.addSubview(leftLogoImageView)
        view.addSubview(citySearchTextField)
        view.addSubview(cityTabListView)
        view.addSubview(cityCountView)
        view.addSubview(collectionView)
        view.addSubview(emptyView)
        view.addSubview(dropDownView)
    }
    
    private func setConstraints() {
        topLogoImageViewConstraints()
        leftLogoImageViewConstraints()
        citySearchTextFieldConstraints()
        cityTabListViewConstraints()
        cityCountViewConstraints()
        collectionViewConstraints()
        emptyViewConstraints()
        dropDownViewConstraints()
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
    
    private func configureSearchButton() {
        citySearchTextField.searchButton.addTarget(
            self,
            action: #selector(handleSearchButton),
            for: .touchUpInside
        )
    }
    
    @objc func handleSearchButton() {
        viewModel.getCitiesSearchAPI(citySearchTextField.textField.text ?? "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func topLogoImageViewConstraints() {
        topLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(51)
            make.leading.equalTo(view.snp.leading).offset(83)
            make.trailing.equalTo(view.snp.trailing).offset(-187)
        }
    }
    
    private func leftLogoImageViewConstraints() {
        leftLogoImageView.snp.makeConstraints { make in
            make.top.equalTo(topLogoImageView.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalTo(citySearchTextField.snp.leading).offset(-5)
        }
    }
    
    private func citySearchTextFieldConstraints() {
        citySearchTextField.snp.makeConstraints { make in
            make.top.equalTo(leftLogoImageView.snp.top)
            make.bottom.equalTo(leftLogoImageView.snp.bottom)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    private func cityTabListViewConstraints() {
        cityTabListView.backgroundColor = .black
        cityTabListView.snp.makeConstraints { make in
            make.top.equalTo(citySearchTextField.snp.bottom).offset(20)
            make.bottom.equalTo(cityCountView.snp.top).offset(-25)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }
    }
    
    private func cityCountViewConstraints() {
        cityCountView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
        }
    }
    
    private func collectionViewConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(cityCountView.snp.bottom).offset(32)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    private func emptyViewConstraints() {
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        emptyView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 150).isActive =  true
        emptyView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //    emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 121).isActive = true
        //    emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -121).isActive = true
    }
    
    
    private func dropDownViewConstraints() {
        dropDownView.translatesAutoresizingMaskIntoConstraints = false
        dropDownView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dropDownView.topAnchor.constraint(equalTo: cityTabListView.bottomAnchor, constant: 25).isActive = true
        dropDownView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
    }
    
    
    
}

extension MainController: UICollectionViewDelegate {
    
}

extension MainController: SkeletonCollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if self.viewModel.seoulCities == nil {
            return 0
        }
        
        if self.viewModel.seoulCities.getNumberOfCities() == 0 {
            emptyView.isHidden = false
            collectionView.isHidden = true
            return 0
        } else {
            emptyView.isHidden = true
            collectionView.isHidden = false
            return self.viewModel.seoulCities.getNumberOfCities()
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        view.endEditing(true)
        let city = self.viewModel.seoulCities.getOneCenter(at: indexPath)
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

extension MainController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collecitonView: UICollectionView,
        layout collectionVIewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width - 80, height: 165)
    }
}

extension MainController: RestProcessorRequestDelegate {
    
    func didReceiveResponseFromDataTask(
        _ result: RestProcessor.Results,
        _ usage: EndPoint
    ) {
        viewModel.resHandler = ResHandler(result: result)
        if (usage == .seoulCitiesData) {
            switch viewModel.resHandler.getResult() {
            case .ok(_, let data):
                if let data = data,
                   let citiesData = try? JSONDecoder().decode([Cities].self, from: data) {
                    self.viewModel.seoulCities = SeoulCities(citiesData)
                    guard let tot = self.viewModel.seoulCities.cities[0].cities?.count else { return }
                    
                    viewModel.categorizeCities()
                    
                    DispatchQueue.main.async {
                        self.cityCountView.cityCntLabel.text = String(tot)
                        self.collectionView.reloadData()
                        self.collectionView.hideSkeleton()
                        self.citySearchTextField.textField.isEnabled = true
                        self.cityTabListView.enableAllTabButtons()
                    }
                }
                
            default:
                break
            }
        } else if (usage == .search) {
            switch viewModel.resHandler.getResult() {
            case .ok(_, let data):
                if let data = data,
                   let citiesData = try? JSONDecoder().decode([City].self, from: data) {
                    viewModel.seoulCities.setCity(city: citiesData)
                    guard let tot = self.viewModel.seoulCities.cities[0].cities?.count else { return }
                    
                    DispatchQueue.main.async {
                        self.citySearchTextField.buttonState = .success
                        self.cityCountView.cityCntLabel.text = String(tot)
                        self.citySearchTextField.textField.isEnabled = true
                        self.collectionView.reloadData()
                    }
                }
                
            default:
                break
            }
        }
    }
    
    func didFailToPrepareRequest(
        _ result: RestProcessor.Results,
        _ usage: EndPoint
    ) {
        
    }
}

extension MainController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            self.citySearchTextField.buttonState = .loading
            self.citySearchTextField.textField.isEnabled = false
            self.viewModel.getCitiesSearchAPI(searchText)
        }

        textField.resignFirstResponder()
        return true
    }
}

extension MainController: CityTabListViewDelegate {
    func updateCollectionView(
        for cities: [City]
    ) {
        self.updateCollectionViewWithSelectedString(
            dropDownView.label.text ?? "",
            cities
        )
    }
    
    func didSelectTab(_ tab: CityTab) {
        switch tab {
        case .viewAll:
            updateCollectionView(for: self.viewModel.viewAll)
            break
        case .culturalheritage:
            updateCollectionView(for: self.viewModel.culturalheritage)
            break
        case .park:
            updateCollectionView(for: self.viewModel.park)
            break
        case .specialTouristZone:
            updateCollectionView(for: self.viewModel.tourismSpecialZone)
            break
        case .centralBusinessDistrict:
            updateCollectionView(for: self.viewModel.centralBusinessDistrict)
            break
        case .denselyPopulatedArea:
            updateCollectionView(for: self.viewModel.denselyPopulatedArea)
        }
    }
}

extension MainController {
    
    func updateCollectionViewWithSelectedString(
        _ selectedString: String,
        _ cities: [City]? = nil
    ) {
        let citiesToUse: [City] = cities ?? viewModel.seoulCities.getCity()!
        
        if selectedString == "가나다 순" {
            let alphabeticalSorted = self.viewModel.sortCitiesByAlphabet(citiesToUse)
            viewModel.seoulCities.setCity(city: alphabeticalSorted)
            DispatchQueue.main.async {
                self.cityCountView.cityCntLabel.text = String(alphabeticalSorted.count)
                self.collectionView.reloadData()
            }
        } else if selectedString == "인구 혼잡도 순" {
            let sortedByCongestion = citiesToUse.sorted { city1, city2 in
                guard let congestionLevel1 = city1.LIVE_PPLTN_STTS?.areaCongestLvl as? String,
                      let congestionLevel2 = city2.LIVE_PPLTN_STTS?.areaCongestLvl as? String else {
                    return false
                }
                let congestionOrder: [String: Int] = [
                    "여유": 0,
                    "보통": 1,
                    "약간 붐빔": 2,
                    "붐빔": 3
                ]
                return congestionOrder[congestionLevel1] ?? Int.max > congestionOrder[congestionLevel2] ?? Int.max
            }
            
            viewModel.seoulCities.setCity(city: sortedByCongestion)
            DispatchQueue.main.async {
                self.cityCountView.cityCntLabel.text = String(sortedByCongestion.count)
                self.collectionView.reloadData()
            }
        }
    }
}
