import SwiftUI
import CoreData
import Combine

class HomeViewModel: ObservableObject {
    @Published var sliders = [SlidePageViewModel]()
    @Published var isLoading = false
    
    private var networkManager: NetworkManager
    private var dataController: DataController
    private var requests = Set<AnyCancellable>()
    private let mainCoreData = NSFetchRequest<Main>(entityName: Main.entityName)
    private var coreDataResult = [Main]()
    static let imageCache = NSCache<AnyObject, AnyObject>()
    
    init(dataController: DataController) {
        self.dataController = dataController
        networkManager = NetworkManager(dataController: dataController)
        getContent()
    }
    
    // MARK: - Private func
    private func getContent() {
        isLoading = true
        let viewContext = dataController.container.viewContext
        guard let result = try? viewContext.fetch(mainCoreData) else {
            return
        }
        
        coreDataResult = result
        if !result.isEmpty {
            coreDataResult = result.filter({
                guard let sections = $0.sections else {
                    return false
                }
                if sections.allObjects.isEmpty {
                    dataController.delete($0)
                }
                return !sections.allObjects.isEmpty
            })
            
            coreDataResult.forEach { menu in
                guard let menuSections = menu.sections,
                      let sections =  menuSections.allObjects as? [Section] else {
                    return
                }
                self.buildSliders(with: menu, sliders: sections)                
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
                let allMenus = menusValue.joined().sorted(by: { $0.order < $1.order }).map({ $0 })
                guard let self = self else {
                    return
                    
                }
                if !allMenus.isEmpty,
                   self.needsCacheUpdate(for: allMenus) {
                    print("using server sections")
                    self.getSections(with: allMenus)
                } else {
                    self.isLoading = false
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
                    let allSliders = slidersValue.joined().map { $0 }
                    self.buildSliders(with: menu, sliders: allSliders)
                    self.updateCache(with: menu, sliders: allSliders)
                }
                .store(in: &requests)
        }
    }
    
    private func getSlidersView(_ sliders: [Section], small: Bool = true) -> [UIHostingController<AnyView>] {
        if !small {
            return sliders.prefix(6).map({ slider in
                let model = SlideItemViewModel(
                    id: slider.id ?? "",
                    title: slider.name ?? "No dev",
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
                title: slider.name ?? "No dev",
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
        DispatchQueue.main.async {
            self.sliders = self.sliders.sorted(by: \SlidePageViewModel.order)
            self.isLoading = false
        }
    }
    
    private func needsCacheUpdate(for menus: [Main]) -> Bool {
        let mainCompare = coreDataResult.map({ topic in
            topic.updatedAt
        })
        let mainServer = menus.map { topic in
            topic.updatedAt
        }
        print(mainServer)
        print(mainCompare)
        if !mainServer.sorted(by: { $0!.compare($1!) == .orderedDescending })
            .elementsEqual(
                mainCompare.sorted(by: { $0!.compare($1!) == .orderedDescending }), by: { $0 == $1 }
            ) {
            dataController.deleteEntity(Main.entityName)
            dataController.deleteEntity(Section.entityName)
            sliders = []
            isLoading = true
            return true
        }
        return false
    }
    
    private func updateCache(with menu: Main, sliders: [Section]) {
        let viewContext = dataController.container.viewContext
        mainCoreData.predicate = NSPredicate(format: "id = %@", menu.id!)
        
        guard let result = try? viewContext.fetch(mainCoreData) else {
            return
        }
        
        let managedObject = !result.isEmpty ? result[0] : menu
        print("caching main")
        
        sliders.forEach { (slider) in
            let section = Section(context: viewContext)
            section.id = slider.id
            section.background = slider.background
            section.main = managedObject
            section.profilePic = slider.profilePic
            section.name = slider.name
            section.topicId = slider.topicId
            section.detail = slider.detail
            section.updatedAt = slider.updatedAt
        }
        
        dataController.save()
    }
}


