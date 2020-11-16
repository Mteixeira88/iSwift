import SwiftUI
import CoreData
import Combine

class ViewModel: ObservableObject {
    @Published var sliders = [SlidePageViewModel]()
    @Published var isLoading = false
    
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    private let developersCoreData = NSFetchRequest<Main>(entityName: Main.entityName)
    private var coreDataResult = [Main]()
    private var needCacheUpdate = false
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    init(dataController: DataController) {
        self.dataController = dataController
//                dataController.deleteAll()
        networkManager = NetworkManager(dataController: dataController)
        getContent()
    }
    
    private func getContent() {
        isLoading = true
        let viewContext = dataController.container.viewContext
        guard let result = try? viewContext.fetch(developersCoreData) else {
            return
        }
        
        coreDataResult = result
        if !coreDataResult.isEmpty {
            coreDataResult.forEach { menu in
                guard let menuSections = menu.sections,
                      let sections =  menuSections.allObjects as? [Section] else {
                    return
                }
                DispatchQueue.main.async {
                    self.buildSliders(with: menu, sliders: sections)
                }
            }
        }
        
        getSliders()
    }
    
    private func getSliders() {
        guard let url = URL(string: "https://iswift-d731e.firebaseio.com/.json") else {
            return
        }
        
        networkManager
            .fetch(url, defaultValue: [Main]())
            .collect()
            .sink { [weak self] menusValue in
                let allMenus = menusValue.joined()
                guard let self = self else {
                    return
                    
                }
                if self.needsCacheUpdate(for: allMenus.map({ $0 })) {
                    self.needCacheUpdate = true
                    self.getSections(with: allMenus.sorted(by: { $0.order < $1.order }).map({ $0 }))
                }
            }
            .store(in: &requests)
        
    }
    
    private func getSections(with menus: [Main]) {
        menus.forEach { menu in
            guard let detailURL = URL(string: "https://jsonblob.com/api/jsonBlob/\(menu.linkTo!)") else {
                fatalError("detail URL failed")
            }
            self.networkManager
                .fetch(detailURL, defaultValue: [Section]())
                .collect()
                .sink { [weak self] slidersValue in
                    guard let self = self else { return }
                    let allSliders = slidersValue.joined()
                    self.buildSliders(with: menu, sliders: allSliders.map { $0 })
                    if self.needCacheUpdate {
                        self.updateCache(with: menu, sliders: allSliders.map { $0 })
                    }
                }
                .store(in: &requests)
        }
    }
    
    private func getSlidersView(_ sliders: [Section], small: Bool = true) -> [UIHostingController<AnyView>] {
        if !small {
            return sliders.prefix(6).map({ slider in
                let model = SlideItemViewModel(
                    id: slider.id ?? "",
                    title: slider.dev ?? "No dev",
                    description: "",
                    imageURL: slider.background ?? ""
                )
                return UIHostingController(
                    rootView: AnyView(FullSlidePageView(model: model))
                )
            })
        }
        
        var slidersView = [UIHostingController<AnyView>]()
        var newSliders = [SlideItemViewModel]()
        sliders.prefix(12).enumerated().forEach { (index, slider) in
            let model = SlideItemViewModel(
                id: slider.id ?? "",
                title: slider.dev ?? "No dev",
                description: "",
                imageURL: slider.profilePic ?? ""
            )
            newSliders.append(model)
            if (index + 1).isMultiple(of: 2) ||  index == sliders.count - 1 {
                slidersView.append(
                    UIHostingController(
                        rootView: AnyView(ListSlidePageView(model: newSliders))
                    )
                )
                newSliders = []
            }
        }
        return slidersView
    }
    
    private func buildSliders(with menu: Main, sliders: [Section]) {
        self.sliders.append(
            SlidePageViewModel(
                id: menu.id ?? "",
                title: menu.name ?? "No menu",
                order: menu.order,
                items: getSlidersView(sliders, small: menu.order != 0)
            )
        )
        self.sliders = self.sliders.sorted(by: \SlidePageViewModel.order)
        isLoading = false
    }
    
    
    
    private func needsCacheUpdate(for menus: [Main]) -> Bool {
        if !menus.elementsEqual(coreDataResult, by: { $0.updatedAt == $1.updatedAt }) {
            sliders = []
            return true
        }
        return false
    }
    
    private func updateCache(with menu: Main, sliders: [Section]) {
        let viewContext = dataController.container.viewContext
        guard let result = try? viewContext.fetch(developersCoreData) else {
            return
        }
        
        // MARK: - TODO Removing duplicates from CoreData
        let object = result.filter({ $0.id == menu.id } )
        object.forEach { (duplicate) in
            dataController.delete(duplicate)
        }
        // MARK: - End duplicate CoreData
        
        let main = Main(context: viewContext)
        main.id = menu.id
        main.linkTo = menu.linkTo
        main.name = menu.name
        main.order = menu.order
        main.updatedAt = menu.updatedAt
        
        sliders.forEach { (slider) in
            let section = Section(context: viewContext)
            section.id = slider.id
            section.background = slider.background
            section.main = main
            section.profilePic = slider.profilePic
            section.dev = slider.dev
        }
        
        dataController.save()
    }
}


