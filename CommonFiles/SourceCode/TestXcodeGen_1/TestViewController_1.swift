import UIKit
import MyFramework


class ComputersSectionGenerator {
	static var sections: [OrganizationSection] {
		let comp1 = Computer.init(name: "Comp1", operationSystem: "Windows 10", state: .online)
		let comp2 = Computer.init(name: "Comp2", operationSystem: "Windows 10", state: .offline)
		let comp3 = Computer.init(name: "Comp3", operationSystem: "Windows 10", state: .offline)
		
		let comp4 = Computer.init(name: "Comp4", operationSystem: "Windows 10", state: .online)
		let comp5 = Computer.init(name: "Comp5", operationSystem: "Linux", state: .online)
		let comp6 = Computer.init(name: "Comp6", operationSystem: "Windows 10", state: .offline)
		
		let comp7 = Computer.init(name: "Comp7", operationSystem: "Windows 10", state: .online)
		let comp8 = Computer.init(name: "Comp8", operationSystem: "Windows 10", state: .online)
		let comp9 = Computer.init(name: "Comp9", operationSystem: "Windows 10", state: .offline)
		
		let comp10 = Computer.init(name: "Comp10", operationSystem: "Linux", state: .online)
		let comp11 = Computer.init(name: "Comp11", operationSystem: "Linux", state: .online)
		let comp12 = Computer.init(name: "Comp12", operationSystem: "FreeBSD", state: .offline)
		
		let comp13 = Computer.init(name: "Comp13", operationSystem: "Windows 10", state: .online)
		let comp14 = Computer.init(name: "Comp14", operationSystem: "Windows 10", state: .unknown)
		let comp15 = Computer.init(name: "Comp15", operationSystem: "Windows 10", state: .offline)
		
		let comp16 = Computer.init(name: "Comp16", operationSystem: "Linux", state: .online)
		let comp17 = Computer.init(name: "Comp17", operationSystem: "Linux", state: .online)
		let comp18 = Computer.init(name: "Comp18", operationSystem: "Windows 10", state: .unknown)
		
		let agentGroup1 = AgentGroup.init(name: "AG_1", computers: [comp1, comp2, comp3])
		let agentGroup2 = AgentGroup.init(name: "AG_2", computers: [comp4, comp5, comp6])
		
		let agentGroup3 = AgentGroup.init(name: "AG_3", computers: [comp7, comp8, comp9])
		let agentGroup4 = AgentGroup.init(name: "AG_4", computers: [comp10, comp11, comp12])
		
		let agentGroup5 = AgentGroup.init(name: "AG_5", computers: [comp13, comp14, comp15])
		let agentGroup6 = AgentGroup.init(name: "AG_6", computers: [comp16, comp17, comp18])
		
		let site1 = Site.init(name: "MySite_1", agentGroups: [agentGroup1, agentGroup2])
		let site2 = Site.init(name: "MySite_2", agentGroups: [agentGroup3, agentGroup4])
		let site3 = Site.init(name: "MySite_3", agentGroups: [agentGroup5, agentGroup6])
		
		return [
			OrganizationSection.init(withOrganization: Organization.init(name: "SOFT LTD", sites: [site1, site2]),
									 isExpanded: true),
			OrganizationSection.init(withOrganization: Organization.init(name: "TestOrg sp z.o.o", sites: [site3]),
									 isExpanded: true)
		]
	}
}

protocol ComputersViewModelProtocol {
	var globalSectionModel: GlobalSection { get }
}

class ComputersViewModel: ComputersViewModelProtocol {
	lazy var globalSectionModel: GlobalSection = {
		return GlobalSection.init(withOrganizationSections: ComputersSectionGenerator.sections)
	}()
}

class TestViewController_1: UIViewController,
							 UITableViewDelegate,
							 UITableViewDataSource {
	
	private let model: ComputersViewModelProtocol = ComputersViewModel()

	@IBOutlet private weak var tableView: UITableView!
	
	override func viewDidLoad() {
		
		tableView.delegate = self
		tableView.dataSource = self
		
		self.tableView.estimatedRowHeight = 48
		print("Expanded items = \(model.globalSectionModel.expandedSubItemsCount)")
		print("Visible items = \(model.globalSectionModel.visibleSubItemsCount)")
		print("All subitems = \(model.globalSectionModel.subItemsCount)")
		
//		print(model.globalSectionModel)
		
//		print(model.globalSectionModel.allSubitems)
		
//		print(model.sections[0].expandedSubItemsCount)
//		print(model.sections[0].subItemsCount)
//		print(model.sections[1].subItemsCount)
		FrameworkPrinter.printMain("TestViewConttroller_1 did load")
    }
	
	// MARK: - UITableViewDelegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}
	
	// MARK: - UITableViewDataSource
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return UITableViewCell.init()
	}
}
