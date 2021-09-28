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
	var isVisible: Bool { get }
	var expandedSubItemsCount: Int { get }
	var visibleSubItemsCount: Int { get }
	var indentMultiplier: UInt { get set }
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool)
}

protocol SubItemsCountable {
	var subItemsCount: Int { get }
}

protocol SectionProtocol: AnyObject, Expandible, SubItemsCountable {
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
	
	var expandedSubItems: [SectionProtocol] {
		return allSubitems
			.filter({ $0.isExpanded })
	}
	
	var expandedSubItemsCount: Int {
		return expandedSubItems.count
	}
	
	var visibleSubItems: [SectionProtocol] {
		return allSubitems
			.filter({ $0.isVisible })
	}
	
	var visibleSubItemsCount: Int {
		return visibleSubItems.count
	}
}

class ComputerSection: SectionProtocol {
	var indentMultiplier: UInt = 0
	let name: String
	let subsections: [SectionProtocol] = []
	let isExpandible: Bool = false
	var isExpanded: Bool
	{
		get {
			return true
		}
		set {}
	}
	
	private var isParentVisibleAndExpanded: Bool = true
	var isVisible: Bool {
		return isParentVisibleAndExpanded
	}
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool) {
		self.isParentVisibleAndExpanded = isVisible && isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
		}
	}
	
	init(withComputer computer: Computer) {
		self.name = computer.name
	}
}

class AgentGroupSection: SectionProtocol {
	var indentMultiplier: UInt = 0
	let name: String

	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool
	{
		didSet {
			for i in 0..<subsections.count {
				subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
				subsections[i].indentMultiplier = self.indentMultiplier + 1
			}
		}
	}
	
	private var isParentVisibleAndExpanded: Bool = true
	var isVisible: Bool {
		return isParentVisibleAndExpanded
	}
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool) {
		self.isParentVisibleAndExpanded = isVisible && isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
		}
	}
	
	init(withAgentGroup agentGroup: AgentGroup, isExpanded: Bool = false) {
		self.name = agentGroup.name
		self.subsections = agentGroup.computers.map({ computer in
			return ComputerSection(withComputer: computer)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
			subsections[i].indentMultiplier = self.indentMultiplier + 1
		}
	}
}

class SiteSection: SectionProtocol {
	var indentMultiplier: UInt = 0
	let name: String

	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool
	{
		didSet {
			for i in 0..<subsections.count {
				subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
				subsections[i].indentMultiplier = self.indentMultiplier + 1
			}
		}
	}
	
	private var isParentVisibleAndExpanded: Bool = true
	var isVisible: Bool {
		return isParentVisibleAndExpanded
	}
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool) {
		self.isParentVisibleAndExpanded = isVisible && isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
		}
	}
	
	init(withSite site: Site, isExpanded: Bool = false) {
		self.name = site.name
		self.subsections = site.agentGroups.map({ agentGroup in
			return AgentGroupSection(withAgentGroup: agentGroup)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
			subsections[i].indentMultiplier = self.indentMultiplier + 1
		}
	}
}

class OrganizationSection: SectionProtocol {
	var indentMultiplier: UInt = 0
	let name: String

	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = true
	var isExpanded: Bool
	{
		didSet {
			for i in 0..<subsections.count {
				subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
				subsections[i].indentMultiplier = self.indentMultiplier + 1
			}
		}
	}
	
	private var isParentVisibleAndExpanded: Bool = true
	var isVisible: Bool {
		return isParentVisibleAndExpanded
	}
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool) {
		self.isParentVisibleAndExpanded = isVisible && isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
		}
	}
	
	init(withOrganization organization: Organization, isExpanded: Bool = false) {
		self.name = organization.name
		self.subsections = organization.sites.map({ site in
			return SiteSection(withSite: site)
		})
		self.isExpanded = isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
			subsections[i].indentMultiplier = self.indentMultiplier + 1
		}
	}
}

class GlobalSection: SectionProtocol {
	var indentMultiplier: UInt = 0
	
	let name: String = "global"
	private(set) var subsections: [SectionProtocol]
	let isExpandible: Bool = false
	var isExpanded: Bool {
		get {
			return true
		}
		set {}
	}
	
	private var isParentVisibleAndExpanded: Bool = true
	var isVisible: Bool {
		return isParentVisibleAndExpanded
	}
	
	func setParentVisible(_ isVisible: Bool, andExpanded isExpanded: Bool) {
		self.isParentVisibleAndExpanded = isVisible && isExpanded
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: self.isExpanded)
		}
	}
	
	init(withOrganizationSections organizations: [OrganizationSection]) {
		self.subsections = organizations
		for i in 0..<subsections.count {
			subsections[i].setParentVisible(self.isVisible, andExpanded: true)
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
