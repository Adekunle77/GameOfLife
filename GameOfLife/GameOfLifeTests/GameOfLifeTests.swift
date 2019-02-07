//
//  GameOfLifeTests.swift
//  GameOfLifeTests
//
//  Created by Ade Adegoke on 06/02/2019.
//  Copyright © 2019 AKA. All rights reserved.
//

import XCTest
@testable import GameOfLife

class GameOfLifeTests: XCTestCase {
    
    var gameSceneModel = GameSceneModel()
        
    func testCreateGrid() {
            
        let cells = [[Cell]]()
        let grid = gameSceneModel.createGrid(row: 0, col: 0)
            XCTAssertEqual(cells, grid)
        }
        
    func testGetCellsAround() {
            
        let cell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
            
        let cellsAround = gameSceneModel.getCellsAround(cell: cell.position)
            
        XCTAssertEqual(cellsAround.count, 0)
            
        }
        
    func testAddCellToGrid() {
            
//        let cell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
//        cell.position =
//        let addtoGrid = gameSceneModel.addCellToGrid(row: 1, col: 1)
            
    }
}
