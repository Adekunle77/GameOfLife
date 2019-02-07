//
//  GameSceneModel.swift
//  GameOfLife
//
//  Created by Ade Adegoke on 07/02/2019.
//  Copyright © 2019 AKA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameSceneModel: SKScene {
    
    
    func createGrid(row: Int, col: Int) -> [[Cell]] {
        var cells = [[Cell]]()
        for x in 0 ..< row {
            var cols = [Cell]()
            for y in 0 ..< col {
                let cell = addCellToGrid(row: y, col: x)
                cols.append(cell)
            }
            cells.append(cols)
        }
        return cells
    }
    
    
    func addCellToGrid(row: Int, col: Int) -> Cell {
        let cell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
        cell.drawBorder(color: UIColor.gray)
        cell.row = row
        cell.col = col
        
        cell.position = addCell(at: cell)
        addChild(cell)
        return cell
    }
    
    private func addCell(at cell: Cell) -> CGPoint {
        let cellWidth = cell.size.width
        let viewX = self.frame.origin.x + (cellWidth / 2)
        let viewY = self.frame.origin.y + (cellWidth / 2)
        let x = cellWidth * CGFloat(cell.col) + viewX
        let y = cellWidth * CGFloat(cell.row) + viewY
        
        return CGPoint(x: x, y: y)
    }
    
    func getCellsAround(cell pos: CGPoint) -> [Cell?] {
        var allNeighbors = [Cell?]()
        let width: CGFloat = 60
        let height: CGFloat = 60
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x, y: pos.y + height))) //top
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x, y: pos.y - height))) //bottom
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x - width, y: pos.y ))) //left
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x + width, y: pos.y ))) //right
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x + width, y: pos.y + height))) //top right
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x - width, y: pos.y + height))) // top left
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x + width, y: pos.y - height))) // bottom right
        allNeighbors.append(self.cell(at: CGPoint(x: pos.x - width, y: pos.y - height))) // bottom left
        return allNeighbors
    }
    
    private func cell(at position: CGPoint) -> Cell? {
        let box = nodes(at: position).compactMap { $0 as? Cell }
        return box.first
    }
    
    
}
