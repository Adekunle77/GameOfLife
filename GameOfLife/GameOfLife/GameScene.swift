//
//  GameScene.swift
//  GameOfLife
//
//  Created by Ade Adegoke on 06/02/2019.
//  Copyright © 2019 AKA. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var cells = [[Cell]]()
    private let cellWidth: CGFloat = 50
    private var cellsPerColumn = Int()
    private var cellsPerRow = Int()

    private var cellsAtEdge = [Cell]()
    private var rightColumn = [Cell]()
    private var leftColumn = [Cell]()
    private var topColumn = [Cell]()
    private var bottomColumn = [Cell]()
 
    private let nofificationStartGame = StartNotificationName
    private let resetNofification = ResetNotificationName
    
    override func didMove(to view: SKView) {
        getViewSize()
        createObservers()
        resetGame()
    }
    

    // Creates the grid
    private func createGrid() {
        cells = [[Cell]]()
        for x in 0 ..< cellsPerRow {
            var row = [Cell]()
            cells.append(row)

            for y in 0 ..< cellsPerColumn {
                let cell = configureCellAtPosition(row: y, col: x)
                row.append(cell)
                
                // while grid is being created, the cells at the edge of the grid, gets added to arrays
                // right colum
                if x == cellsPerRow - 3 {
                    rightColumn.append(cell)
                }
                // top row
                if y == cellsPerColumn - 3 {
                    topColumn.append(cell)
                }
                // left colum
                if x == 3 {
                    leftColumn.append(cell)
                }
                // bottom colum
                if y == 3 {
                    bottomColumn.append(cell)
                }
            }
          cells.append(row)
        }
        
    }

    enum GameState{
      case running
      case stopped
    }

    var state = GameState.stopped {
      didSet{
        if state == .running{
          NotificationCenter.default.post(name: GameStartedNotificationName, object: nil)
        } else {
          NotificationCenter.default.post(name: GameStoppedNotificationName, object: nil)
        }
      }
    }
    
    
    // function works how many columns and rows is need
    private func getViewSize() {
        let width = self.frame.width
        let height = self.frame.height
        let row = width / cellWidth
        let col = height / cellWidth
        cellsPerColumn = Int(col)
        cellsPerRow = Int(row)
    }
    
    // this function adds cells to make up the grid
    private func configureCellAtPosition(row: Int, col: Int) -> Cell {
        let cell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
        cell.drawBorder(color: UIColor.darkGray)
        cell.row = row
        cell.col = col
        positionCell(cell)
        addChild(cell)
        cells[col].append(cell)
        return cell
    }
    
    // this function works out of where to put the cell
    private func positionCell(_ cell: Cell) {
        let viewX = self.frame.origin.x + (cellWidth / 2)
        let viewY = self.frame.origin.y + (cellWidth / 2)
        let x = cellWidth * CGFloat(cell.col) + viewX
        let y = cellWidth * CGFloat(cell.row) + viewY
        cell.position = CGPoint(x: x, y: y)
    }

    // function works out which cells turn to give, remove or take away life
    @objc func getCellsAlive() {
        var aliveCellOneNeighbor = Set<Cell>()
        var aliveCellThreeNeighbors = Set<Cell>()
        
        for (_, j) in cells.enumerated() {
            for (_, l) in j.enumerated()  {
                
                let neighborsCount = getNeighboursAliveCount(pos: l.position)
                
                if [0, 1, 4, 5, 6, 7, 8].contains(neighborsCount.count) {
                    l.color = .white
                    aliveCellOneNeighbor.insert(l)
                    
                } else if [3].contains(neighborsCount.count) && l.hasLife == false {
                    l.color = .blue
                    aliveCellThreeNeighbors.insert(l)
                    
                } else if l.hasLife == true && [2, 3].contains(neighborsCount.count) {
                    l.color = .blue
                    aliveCellThreeNeighbors.insert(l)
                }
                
                self.run(SKAction.wait(forDuration: 0.002)) {
                    for cell in aliveCellOneNeighbor {
                        cell.hasLife = false
                    }
                    
                    for cell in aliveCellThreeNeighbors {
                        cell.hasLife = true
                    }
                    
                    if aliveCellThreeNeighbors.count == 0 {
                        self.resetGame()
                    }
                }
            }
        }
        loadAfter(seconds: 0.003)
    }

    // reload function (getCellsAlive()
    func loadAfter(seconds: Double) {
        self.run(SKAction.wait(forDuration: seconds)) {
            self.getCellsAlive()
        }
    }
    

    
    // function adds more cells to the edge of the grid if it edge cells has life
    /* This function does not work. Due to technical difficulties */
    
    private func addCellsAtEdge() {
        
        var addedCells = [Cell]()
        let width = cellWidth
        
        for addright in rightColumn {
            let addedCell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
            addedCell.drawBorder(color: UIColor.gray)
            let position = addright.position
            addedCell.drawBorder(color: .gray)
            addedCell.position.x = position.x + width + width
            addedCell.position.y = position.y
            addedCells.append(addedCell)
            print(addedCell.position)
            self.addChild(addedCell)
        }
        
        for addleft in leftColumn {
            let addedCell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
            addedCell.drawBorder(color: UIColor.gray)
            let position = addleft.position
            addedCell.drawBorder(color: .gray)
            addedCell.position.x = position.x + width + width
            addedCell.position.y = position.y
            addedCells.append(addedCell)
            print(addedCell.position)
            self.addChild(addedCell)
        }
        
        for addTop in topColumn {
            let addedCell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
            addedCell.drawBorder(color: UIColor.gray)
            let position = addTop.position
            addedCell.drawBorder(color: .gray)
            addedCell.position.x = position.x
            addedCell.position.y = position.y + width + width
            
            addedCells.append(addedCell)
            print(addedCell.position)
            self.addChild(addedCell)
        }
        
        for addBottom in bottomColumn {
            let addedCell = Cell(size: CGSize(width: 50, height: 50), cellColour: UIColor.white)
            addedCell.drawBorder(color: UIColor.gray)
            let position = addBottom.position
            addedCell.drawBorder(color: .gray)
            addedCell.position.x = position.x
            addedCell.position.y = position.y - (width + width)
            addedCells.append(addedCell)
            print(addedCell.position)
            self.addChild(addedCell)
        }
        
        cells.append(addedCells)
    }

    
    // get cells alive count    // get cells alive count
    private func getNeighboursAliveCount(pos: CGPoint) -> [Cell?] {
        var cellsAlive = [Cell?]()
        let cellsAround = getCellsAround(cell: pos)
        for cells in cellsAround where cells?.hasLife == true {
            cellsAlive.append(cells)
        }
        return cellsAlive
    }
    
    // get all neighboring cells

    private func getCellsAround(cell pos: CGPoint) -> [Cell?] {
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
    
    
    // get node at CGPoint
    private func cell(at position: CGPoint) -> Cell? {
      let box = nodes(at: position).compactMap { $0 as? Cell }
      return box.first
    }

    private func touchDown(atPoint pos : CGPoint) {
        guard let clickedCell = cell(at: pos) else { return }
        clickedCell.hasLife = true
        clickedCell.color = .blue
    }
    
    
    // Add notification observers, for the reset and start button
    private func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(startGame), name: nofificationStartGame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetGame), name: resetNofification, object: nil)
    }

    @objc func startGame(){
      guard state == .stopped else {
        return
      }
      state = .running
      getCellsAlive()
    }
    
    @objc func resetGame() {
        state = .stopped
        self.removeAllActions()
        self.scene?.removeFromParent()
        self.scene?.removeAllChildren()
        if (self.children.count == 0) {
            createGrid()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
}

extension SKSpriteNode {
    func drawBorder(color: UIColor) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = 3.0
        addChild(shapeNode)
    }
}
