//
//  ExpandibleSectionsModel.swift
//  TestXcodeGen_1
//
//  Created by astafeev on 27.09.21.
//

import Foundation
import UIKit

// MARK: - View Model

protocol Expandible {
	var isExpandible: Bool { get }
	var isExpanded: Bool { get set }
	var isVisible: Bool { get set }
	var expandedSubItemsCount: Int { get }
	var visibleSubItemsCount: Int { get }
}

protocol SubItemsCountable {
	var subItemsCount: Int { get }
}

protocol SectionProtocol: Expandible, SubItemsCountable {
	var name: String { get }
	var subsections: [SectionProtocol] { get }
}

extension SectionProtocol {
	var allSubitems: [SectionProtocol] {
		let result = subsections.flatMap { section in
			[section] + section.allSubitems
		}
		return result
	}
	
	var subItemsCount: Int {
		return allSubitems.count
	}
	
	var expandedSubItemsCount: Int {
		return allSubitems
			.filter({ $0.isExpanded && $0.isVisible })
			.count
	}
	
	var visibleSubItemsCount: Int {
		return allSubitems
			.filter({ $0.isVisible })
			.count
	}
}

struct ComputerSection: SectionProtocol {
	let name: String
	var isVisible: Bool
	let subsections: [SectionProtocol] = []
	let isExpandible: Bool = false
	var isExpanded: Bool {
		get {
			return true
		}
		set {}
	}
	
	init(withComputer computer: Computer, isVisible: Bool = false) {
		self.name = computer.name
		self.isVisible = isVisible
	}
}

struct AgentGroupSection: SectionProtocol {
	let name: String
	var isVisible: Bool = false
//	{
//		didSet {
//			for i in 0..<subsections.count {
//				subsections[i].isVisible = isVisible
//			}
//		}
//	}
	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool {
		didSet {
			for i in 0..<subsections.count {
				subsections[i].isVisible = isExpanded
			}
		}
	}
	
	init(withAgentGroup agentGroup: AgentGroup, isExpanded: Bool = false) {
		self.name = agentGroup.name
		self.subsections = agentGroup.computers.map({ computer in
			return ComputerSection(withComputer: computer)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].isVisible = isExpanded
		}
	}
}

struct SiteSection: SectionProtocol {
	let name: String
	var isVisible: Bool = false
//	{
//		didSet {
//			for i in 0..<subsections.count {
//				subsections[i].isVisible = isVisible
//			}
//		}
//	}
	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool {
		didSet {
			for i in 0..<subsections.count {
				subsections[i].isVisible = isExpanded
			}
		}
	}
	
	init(withSite site: Site, isExpanded: Bool = false) {
		self.name = site.name
		self.subsections = site.agentGroups.map({ agentGroup in
			return AgentGroupSection(withAgentGroup: agentGroup)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].isVisible = isExpanded
		}
	}
}

struct OrganizationSection: SectionProtocol {
	let name: String
	var isVisible: Bool = true
//	{
//		didSet {
//			for i in 0..<subsections.count {
//				subsections[i].isVisible = isVisible
//			}
//		}
//	}
	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool {
		didSet {
			for i in 0..<subsections.count {
				subsections[i].isVisible = isExpanded
			}
		}
	}
	
	init(withOrganization organization: Organization, isExpanded: Bool = false) {
		self.name = organization.name
		self.subsections = organization.sites.map({ site in
			return SiteSection(withSite: site)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].isVisible = isExpanded
		}
	}
}

struct GlobalSection: SectionProtocol {
	let name: String = "global"
	var isVisible: Bool {
		get {
			return true
		}
		set {}
	}
	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = false
	var isExpanded: Bool {
		get {
			return true
		}
		set {}
	}
	
	init(withOrganizationSections organizations: [OrganizationSection]) {
		self.subsections = organizations
		for i in 0..<subsections.count {
			subsections[i].isVisible = isExpanded
		}
	}
}

// MARK: - Model stubs

struct Computer {
	enum State {
		case online, offline, unknown
	}
	
	let name: String
	let operationSystem: String
	var state: State = .unknown
}

struct AgentGroup {
	let name: String
	let computers: [Computer]
}

struct Site {
	let name: String
	let agentGroups: [AgentGroup]
}

struct Organization {
	let name: String
	let sites: [Site]
}
