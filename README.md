# Swifty-Klotski

> A Klotski game with a powerful searching AI built in, completely implemented in Swift.

## About Klotski

Klotski (华容道 in Chinese), is a sliding block puzzle with special `layouts` of 10 different blocks and the aim of Klotski is to move a specific block, aka, `CaoCao`, to some predefined location.

We built Swifty-Klotski in which an AI can automatically search for `feasible` solutions to a layout.

## Interpreting the Puzzel in Math

> Coordinate Mapping. 

### Mapping Layouts to a Coordinate System

Klotski has a 4x5 board with 10 different blocks at different positions. We mapped the board to a simple coordinate system, making it easy to represent different layouts using xAxis and yAxis values.

<img src="https://github.com/allenx/Swifty-Klotski/blob/master/img/Coordinate.png" width="200px">

In the coordinate system above, every block's position can be represented by it's top left point's coordinate.

For example, in the layout HengDaoLiMa(横刀立马 in Chinese), the layout is as follows:

<img src="https://github.com/allenx/Swifty-Klotski/blob/master/img/HengDaoLiMa.png" width="600px">

(Above is a screenshot of our Klotski game)

In this picture, we can represent the layout as: 

```swift
ZhaoYun.coordinate = (0, 0); ZhaoYun.width = 1; ZhaoYun.height = 2
CaoCao.coordinate = (1, 0); CaoCao.width = 2; CaoCao.height = 2;
HuangZhong.coordinate = (3, 0); HuangZhong.width = 1; HuangZhong.height = 2;
MaChao.coordinate = (0, 2); MaChao.width = 1; MaChao.height = 2;
GuanYu.coordinate = (1, 2); GuanYu.width = 2; GuanYu.height = 1;
Soldier1.coordinate = (0, 4); Soldier1.width = 1; Soldier1.height = 1;
Soldier2.coordinate = (1, 3); Soldier2.width = 1; Soldier2.height = 1;
ZhangFei.coordinate = (3, 2); ZhangFei.width = 1; ZhangFei.height = 2;
Soldier3.coordinate = (2, 3); Soldier3.width = 1; Soldier3.height = 1;
Soldier4.coordinate = (3, 4); Soldier4.width = 1; Soldier4.height = 1;
```

And all we need to do is to move `CaoCao` from its original postion (1, 0) to its destination (1, 4)

## How We Made It

> Swift, Breadth First Searching Algorithm, SpriteKit

We decided to implement this game in a fun way, that is, to make it a real game with **Fabulous GUI** instead of some **Lame Console Output**. And that's why we are using **Swift** and **SpriteKit** to make this great iOS game.

Swift is an easy-to-use programming language with many Functional-Programming features and it's lightning fast like its name. iOS is a powerful system with a powerful and elegant GUI framework which is called Cocoa Touch and SpriteKit is part of Cocoa Touch which empowers developers to make games in easier ways.

The most important thing is that, how we wrote this AI. Using **Breadth First Searching Algorithm** is how we did it. No. Using **Breadth First Searching** with a lot of **Pruning** is how we did it.

1. In the **Queue** for **BFS**, we enque every layout the AI searched.
2. We deque the first layout in the **Queue** and see if it's already **visited**. If it has been already visited, we dump it immediately and go into the next loop. If not, we expand it and get its sublayouts and enqueue those sublayouts.
3. After each expanding in step 2, we check if `CaoCao` has reached its destination (1, 4). If not, repeat step 2. If it has, do the **backtrack** in step 4.
4. **Backtrack** those layouts that lead us to the destination and show them in the correct order.

Above is how we designed the game logic, to implement this logic we've taken 2 different ways, and the details are as follows.

## Algorithm Details

### First Implementation.

> Highly Object-Oriented. Naïve Thinking. Slow AI.
>
> AI.swift Person.swift Layout.swift SwiftyQueue.swift

#### Storing Positions and Layouts

Now that we represent every block's position using their top-left coordinate, how are we gonna represent a Layout? An array of block in which every block has its own coordinate stored? Yuck, it's gonna be a nightmare for the AI to compute. 

So we've come up with an encoding method. Every one's coordinate has two values which are x and y. Combining those values into a sequence of digits sounds like a feasible way. Like in `HengDaoLiMa`, the code will be 00103002120413322334. That's a lot of digits, 20 in total. And in our 64-bit system and hardware, the maximum of an Int value is no more than 20 digits so it's gonna crash the system. 

Then can we store the code as a String value? That would be not very efficient because we need to do comparison between different layout and String comparison might be slow because we can't do Binary-Sort-Search with String values.

So we decided to seperate this code into 2 part using a Tuple. And now the code for `HengDaoLiMa` will be (00103002120413, 322334).

And our `Layout` Class is as follows:

```swift
class Layout {
	//its super layout
	let superLayout: Layout?
	//current layout represented as an (Int, Int) value
	let value: (lhs: Int, rhs: Int)
}
```

A Layout has a property `superLayout`, which is its super layout, and it has a value which is the tuple for the digit sequence.

With `superLayout`, we are able to backtrack every step that leads to success, simply by doing `layout.superLayout.superLayout…..`

Now how are we gonna represent our blocks? Here comes our classs  `Person`.

```swift
class Person {
	let name: String
	let width: Int
	let height: Int

	var coordinate: (x: Int, y: Int)

	//An empty array means it has no neighbours on the direction.
	//A nil value means it's at the the edge of the board on that direction
	var left: [Person]? = []
	var right: [Person]? = []
	var top: [Person]? = []
	var bottom: [Person]? = []
	
	//The function which makes a person go up in the board. Similar goDown, goRight, goLeft are omitted.
	func goUp(and completion: () -> ()) {
    	self.coordinate.y -= 1
    	completion()
    	self.coordinate.y += 1
	}
}
```

We treat each block as an individual, a Person. Each person has its name, width, height and coordinate. And what's also very important is that it has 4 optional arrays `left`, `right`, `top`, `bottom`. For example, if `left` is `nil`, it means the person is at the left edge of the board and cannot go further left. If `left` is an empty array `[]`, it means that the there are no other people are on its left side and it's ok to go left. Otherwise the person cannot go left.

`func goUp(and completion: () -> ())` is an interesting function. If a person goes up, its y should substract 1, and that's for sure. But why am I adding 1 back at the end of the function? That is because we can't change the person's coordinate yet because it still needs to be judged that if it can go in other directions. 

We have static members of `Person` , representing the 10 blocks in the game:

```swift
 static let CaoCao = Person(width: 2, height: 2, coordinate: (2, 1), name: "曹操")
 static let GuanYu = Person(width: 2, height: 1, coordinate: (2, 3), name: "关羽")
 static let ZhaoYun = Person(width: 1, height: 2, coordinate: (1, 1), name: "赵云")
 static let ZhangFei = Person(width: 1, height: 2, coordinate: (4, 3), name: "张飞")
 static let MaChao = Person(width: 1, height: 2, coordinate: (1, 3), name: "马超")
 static let HuangZhong = Person(width: 1, height: 2, coordinate: (4, 1), name: "黄忠")
 static let Soldier1 = Person(width: 1, height: 1, coordinate: (1, 5), name: "士兵1")
 static let Soldier2 = Person(width: 1, height: 1, coordinate: (2, 4), name: "士兵2")
 static let Soldier3 = Person(width: 1, height: 1, coordinate: (3, 4), name: "士兵3")
 static let Soldier4 = Person(width: 1, height: 1, coordinate: (4, 5), name: "士兵4")
```

#### Determining If a Person Can Go Left, Right, Up or Down

We have 4 principles about this (left for example):

1. If the person's coordinate.x is 0, it means it's at the left edge and it cannot go left. If not, go step 2.
2. If B.coordinate.x + B.width == A.coordinate.x, it means that B is at the neigbouring left column of A. Go step 3.
3. If B and A are intersected in the direction of yAxis like 2 lines overlapping, A.left.append(B), meaning B is a left neighbour of A.

This is what our `assignNeighbours()` looks like:

```swift
//Instance Methods of class AI
func assignNeighbours() {
	for person in AI.people {
    	person.left = []
        person.right = []
        person.top = []
        person.bottom = []
        for i in 0..<10 {
        let personCursor = AI.people[i]
        if personCursor.positionVal != person.positionVal {
        	//See left
            if person.coordinate.x == 1 {
    	        person.left = nil
            } else {
            	if personCursor.coordinate.x + personCursor.width == person.coordinate.x && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                	person.left?.append(personCursor)
                }
            }       
           	//See right
            if person.coordinate.x + person.width > 4 {
            	person.right = nil
            } else {
            	if personCursor.coordinate.x == person.coordinate.x + person.width && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                	person.right?.append(personCursor)
                }
            }     
            //See top
            if person.coordinate.y == 1 {
            	person.top = nil
            } else {
            	if personCursor.coordinate.y + personCursor.height == person.coordinate.y && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
					person.top?.append(personCursor)
				}
			}
			//See bottom
			if person.coordinate.y + person.height > 5 {
				person.bottom = nil
			} else {
				if personCursor.coordinate.y == person.coordinate.y + person.height && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
					person.bottom?.append(personCursor)
				}
			}
		}
	}
}

func areIntersected(lhs: (min: Int, max: Int), rhs: (min: Int, max: Int)) -> Bool {
	if lhs.max - lhs.min > rhs.max - rhs.min {
		if (rhs.max < lhs.max && rhs.max > lhs.min) || (rhs.min > lhs.min && rhs.min < lhs.max) {
			return true
		}
	} else if lhs.max - lhs.min == rhs.max - rhs.min {
		if (lhs.max == rhs.max && lhs.min == rhs.min) || (rhs.max < lhs.max && rhs.max > lhs.min) || (rhs.min > lhs.min && rhs.min < lhs.max) || (lhs.max < rhs.max && lhs.max > rhs.min) || (lhs.min < rhs.max && lhs.min > rhs.min) {
			return true
		}
	} else {
		if (lhs.max < rhs.max && lhs.max > rhs.min) || (lhs.min < rhs.max && lhs.min > rhs.min) {
			return true
		}
	}
	return false
}
```



#### Storing Visited Layouts

We store visted layouts in an array in our first implementation. And we do `Binary Insert` and `Binary Search` every time we insert a new layout and search for repeated layout.

Here's our `binaryInsert(value: (lhs: Int, rhs: Int)) -> Bool`

```swift
func binaryInsert(value: (lhs: Int, rhs: Int)) -> Bool {
	var lowerIndex = 0
    var upperIndex = AI.valueArr.count - 1
    var currentIndex: Int = 0
    
	if AI.valueArr.count == 0 {
		AI.valueArr.insert(value, at: currentIndex)
		return true
	}  
	while lowerIndex <= upperIndex {
		//print("Searching")
		currentIndex = (upperIndex - lowerIndex) / 2 + lowerIndex
		if AI.valueArr[currentIndex].lhs == value.lhs {
			if AI.valueArr[currentIndex].rhs == value.rhs {
				print("Pruned")
				return false
			}
			if AI.valueArr[currentIndex].rhs < value.rhs {
				AI.valueArr.insert(value, at: currentIndex + 1)
                return true
			} else {
				AI.valueArr.insert(value, at: currentIndex)
                return true
            }
		} else {
			if AI.valueArr[currentIndex].lhs > value.lhs {
				upperIndex = currentIndex - 1
            } else {
				lowerIndex = currentIndex + 1
			}
		}
	}
	AI.valueArr.insert(value, at: currentIndex)
	return true
}
```

Alongside with `binaryInsert`, we have this normal `insert` function with some **random flavor** added into in.

```swift
func insert(value: (lhs: Int, rhs: Int)) -> Bool {
	for eachValue in AI.valueArr {
		if value == eachValue {
			return false
		}
	}
	let index = Int(Random.random(number: UInt32(AI.valueArr.count)))
	AI.valueArr.insert(value, at: index)
	return true
}
```

This `insert` function does not append new values into the array, it inserts new values at a random index. And guess what, this **Random Factor** helped us make the searching speed **2x faster** because it gives AI **a better chance** on hitting the targeted layout.



#### References

| CLASS         | DISCRIPTION                              |
| :------------ | :--------------------------------------- |
| `AI`          | AI controls the logic of the game        |
| `Block`       | Including information and action of characters |
| `Layout`      | Layout is the code of different situation |
| `Person`      | initial the infomation of all characters with different level |
| `Random`      | Random offers algorithm with random parameters |
| `RawAI`       | second AI to implement the algorithm     |
| `SwiftyQueue` | SwiftyQueue is a queue used in the algorithm |

For the class `AI`:

| PROPERTIES                               | DISCRIPTION                              |
| :--------------------------------------- | :--------------------------------------- |
| `var people: [Person]`                   | an array to store all the characters     |
| `let queue: SwiftyQueue`                 | Queue is to implement BFS alogrithm      |
| `static var valueArr: [(lhs: Int, rhs: Int)]` | This array stores codes of different layout |
| `static let shared = AI()`               | shared instace of AI                     |

| INSTANCE METHODS                         | DISCRIPTION                              |
| ---------------------------------------- | ---------------------------------------- |
| `func assignNeighbours()`                | check out neighbours of each character   |
| `func calculatePostionValues() -> (Int, Int)` | calculate the code of each layout        |
| `func binaryInsert(value) -> Bool`       | implement binary Insert                  |
| `func didWin() -> Bool`                  | check if it wins or not                  |
| `func backtrack(layout: Layout)`         | find the final solution                  |
| `func setCurrentPeopleFrom(layout: Layout)` | set the current queue_front              |
| `func randomSearch()`                    | search with random factor                |
| `func areIntersected( lhs: (min: Int, max: Int), rhs: (min: Int, max: Int) -> Bool` | check if the current character can move or not |

For class `Layout`:

| PROPERTIES                       | DISCRIPTION                    |
| -------------------------------- | ------------------------------ |
| `let superLayout: Layout`        | its superLayout                |
| `let value: (lhs: Int, rhs: Int) | the code of the current layout |

For class `Person`:

| PROPERTIES                         | DISCRIPTION                       |
| ---------------------------------- | --------------------------------- |
| `let name: String`                 | name of the character             |
| `let width: Int`                   | width of the character            |
| `let height: Int`                  | height of the character           |
| `var coordinate: (x:Int,  y: Int)` | coordinate of the character       |
| `var positionVal: Int { get }`     | get value of each position        |
| `var left: [Person]`               | array of characters on its left   |
| `var right: [Person]`              | array of characters on its right  |
| `var top: [Person]`                | array of characters on its top    |
| `var bottom: [Person]`             | array of characters on its bottom |
| `static let CaoCao: Person`        | character CaoCao                  |
| `static let GuanYu: Person`        | character GuanYu                  |
| `static let ZhaoYun: Person`       | character ZhaoYun                 |
| `static let ZhangFei: Person`      | character ZhangFei                |
| `static let MaChao: Person`        | character MaChao                  |
| `static let HuangZhong: Person`    | character HuangZhong              |
| `static let Soldier1: Person`      | character Soldier1                |
| `static let Soldier2: Person`      | character Soldier2                |
| `static let Soldier3: Person`      | character Soldier3                |
| `static let Soldier4: Person`      | character Soldier4                |

| INSTANCE METHODS                         | DISCRIPTION                              |
| ---------------------------------------- | ---------------------------------------- |
| `func goUp (and completion: () -> ())`   | go up and update coordinate and go back  |
| `func goDown (and completion: () -> ())` | go down and update coordinate and go back |
| `func goLeft (and completion: () -> ())` | go left and update coordinate and go back |
| `func goRight (and completion: () -> ())` | go right and update coordinate and go back |



### Second Implementation. A Whole New Take.

> Raw and Fast. Low-level thinking.
>
> Block.swift RawAI.swift

We tested some layouts with our first implementation and it turned out **way too slow**. The first implementation can only solve simple puzzles and when it comes to the hard ones, it gets stuck and the AI searches forever, nonstop.

We are re-thinking at a lower level and that's why we named our new AI as `RawAI`.

#### Storing Positions and Layouts

We have Enum type representing each block's type.

```swift
enum BlockType: Int {
    case horizontal = 3 // Horizontally placed block, width = 2, height = 1
    case vertical = 2 // Vertically placed block, width = 1, height = 2
    case bigSquare = 4 // CaoCao
    case tinySquare = 1 // Soldiers
    case foo = 0 // The two blank blocks on the board
}
```

Our new class `Block` is similar to the previous `Person` in many ways. It has `coordinate`, `width`, `height`, `id` and `BlockType`

And most importantly it has 4 `Bool` properties: `canGoLeft`, `canGoRight`, `canGoUp` and `canGoDown`

```swift
//Inside class Block
var canGoLeft: Bool {
    get {
		if coordinate.x == 0 {
			return false
		}
		if RawAI.shared.state[coordinate.y][coordinate.x-1] == .foo && RawAI.shared.state[coordinate.y+_height-1][coordinate.x-1] == .foo {
			return true
		}
		return false
	}
}
```

Determining the 4 `Bool` properties is easy. We have a 2D array called `state` which stores which position is occupied by which kind of block.

Once a block can go further in a direction, we make it go.

```swift
//Inside class Block
//state and board are two crucial arrays of RawAI
func goLeft() {
	if !canGoLeft {
		return
	}
	RawAI.shared.state[coordinate.y][coordinate.x+_width-1] = .foo
    RawAI.shared.state[coordinate.y+_height-1][coordinate.x+_width-1] = .foo  
	RawAI.shared.board[coordinate.y][coordinate.x+_width-1] = -1
	RawAI.shared.board[coordinate.y+_height - 1][coordinate.x+_width-1] = -1
	RawAI.shared.state[coordinate.y][coordinate.x-1] = type
	RawAI.shared.state[coordinate.y+_height-1][coordinate.x-1] = type
	RawAI.shared.board[coordinate.y][coordinate.x-1] = id
	RawAI.shared.board[coordinate.y+_height-1][coordinate.x-1] = id
	coordinate.x -= 1;
}
```

We store block types in the array `state`, and block ids in the array `board`.

For example. if `state[0][0] == .horizontal`, it means that a horizontally placed block is occupying (0, 0) and (1, 0)

if `board[0][0] == 0`, it means that `ZhangFei` is who that occupies (0, 0) and (1, 0)

**And Finally we are done storing visted layouts in an array coz that sucks.**

We use a `Dictionary` value to store if a layout has been visited. `Dictionary` is like `HashTable` in Java or `map` in C++. It's a `Key: Value` pair. For example if `hasBeenVisited[someLayout] == true`, it means that this `someLayout` has been visited. 

This whole `Dictionary` storing pulled us out of those **array sorting things** and is super fast.

And then we're storing our layout values as `String` which has 40 characters.

```swift
func encode() {
	code = ""
    for i in 0..<5 {
		for j in 0..<4 {
			code.append("\(state[i][j].rawValue)")
			code.append(board[i][j] < 0 ? "0" : "\(board[i][j])")
		}
	}
}
```

And determining if `CaoCao` has reached its destination is easy. When `state[3][1]==state[3][2]==state[4][1]==state[4][2]==.bigSquare`, that's `CaoCao` reaching its destination.

```swift
func didWin() -> Bool {
	return (state[3][1].rawValue == state[3][2].rawValue && state[3][2].rawValue == state[4][1].rawValue &&
            state[4][1].rawValue == state[4][2].rawValue && state[4][1].rawValue == 4)
}
```

Now that we don't have a `superLayout` property in class  `Block`, we need an exceptional array to store relationship between layouts. That is an array called `parents`. And we keep track of each layout by giving them indexes. That is 3 `Dictionary` values `ts`, `st` and `fullCodeAt`.

This is how we update our queue.

```swift
func updateCurrent(subLayout: String, currentLayout: String) {
	swiftyQueue.enqueue(subLayout)
	layoutWasVisited[subLayout] = true
	depthFor[subLayout] = depthFor[currentLayout]! + 1
	ts[numberOfLayoutsVisited] = subLayout
	fullCodeAt[numberOfLayoutsVisited] = code
	st[subLayout] = numberOfLayoutsVisited
	numberOfLayoutsVisited += 1
	parents[st[subLayout]!] = st[currentLayout]!
}
```

#### Breadth First Searching

```swift
func move(block: Block, currentLayout: String, direction: Int) -> Bool {
	switch direction {
	case 0:
		if block.canGoLeft {
			block.goLeft()
		} else {
	        return false
		}
	case 1:
		if block.canGoRight {
			block.goRight()
		} else {
			return false
		}
	case 2:
		if block.canGoUp {
			block.goUp()
		} else {
			return false
		}
	case 3:
		if block.canGoDown {
			block.goDown()
		} else {
			return false
		}
	default:
		return false
	}
        
	encode()
	let layout = currentStateCodeFrom(encoding: code)
	if layoutWasVisited[layout] == nil {
		updateCurrent(subLayout: layout, currentLayout: currentLayout)
		if didWin() {
			print("We Won!")
			return true
		}
	}
	
	switch direction {
	case 0:
		block.goRight()
	case 1:
		block.goLeft()
	case 2:
		block.goDown()
	case 3:
		block.goUp()
	default:
		break
	}
	return false
}
```

#### SwiftyQueue

> There's no native queue impletation in Swift and we used Array to simulate a queue and that's causing speed loss. So we then used LinkedList to implement a queue.

```swift
public struct SwiftyQueue<T> {
    fileprivate var list = LinkedList<T>()
    public var isEmpty: Bool {
        return list.isEmpty
    }
   
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        list.remove(element) 
        return element.value
    }
    
    public func peek() -> T? {
        return list.first?.value
    }
}
```



#### References

| CLASS         | DISCRIPTION                              |
| :------------ | :--------------------------------------- |
| `Block`       | Including information and action of characters |
| `RawAI`       | second AI to implement the algorithm     |
| `SwiftyQueue` | SwiftyQueue is a queue used in the algorithm |

For class `Block` :

| PROPERTIES                         | DISCRIPTION                           |
| ---------------------------------- | ------------------------------------- |
| `var coordinate: (x: Int, y: Int)` | coordinate of the character(private)  |
| `fileprivate let _width: Int`      | the width of the character(private)   |
| `fileprivate let _height: Int`     | the height of the character(private)  |
| `fileprivate let _id: Int`         | the id of the character(private)      |
| `var width: Int { get }`           | returns the width                     |
| `var height: Int { get }`          | returns the height                    |
| `var id: Int { get }`              | returns the id                        |
| `var type: BlockType { get }`      | type of the character                 |
| `var canGoLeft: Bool { get }`      | indicates if it can move left or not  |
| `var canGoRight { get }`           | indicates if it can move right or not |
| `var canGoUp { get }`              | indicates if it can move up or not    |
| `var canGoDown { get }`            | indicates  if it can move down or not |

| INSTANCE METHODS                         | DISCRIPTION                              |
| ---------------------------------------- | ---------------------------------------- |
| `func set (coordinate: (x: Int, y: Int)) -> Block` | set the coordinate of a character returns self |
| `func goLeft ()`                         | go left and update the state             |
| `func goRight ()`                        | go right and update the state            |
| `func goUp ()`                           | go up and update the state               |
| `func goDown ()`                         | go down and update the state             |

For class `RawAI`:

| PROPERTIES                             | DISCRIPTION                              |
| -------------------------------------- | ---------------------------------------- |
| `var state: [[BlockType]]`             | current state of every block on the board |
| `var board: [[Int]]`                   | current infocode of every block of the board |
| `var layoutWasVisited: [String: Bool]` | a dictionary which stores if a layout was visited |
| `var depthFor: [String: Int]`          | depth for the layout                     |
| `var st: [String: Int]`                | map from String to Int                   |
| `var ts: [Int: String]`                | st.inversed()                            |
| `var fullCodeAt: [Int: String]`        | code at a given index                    |
| `var parents: [Int]`                   | stores parent and child relationship     |
| `var swiftyQueue: SwiftyQueue`         | queue                                    |
| `var numberOfLayoutsVisited: Int`      | number of layouts visited                |
| `var code: [String]`                   | code of a layout                         |
| `var blocks: [Block]`                  | blocks array                             |

| INSTANCE METHODS                         | DISCRIPTION                              |
| ---------------------------------------- | ---------------------------------------- |
| `func initBoard ()`                      | inital the board                         |
| `func encode ()`                         | get the code of each layout              |
| `func currentStateCodeFrom(encoding: code)` | get the code of current state            |
| `func setCurrentBoardFrom ( encoding: String)` | set the state of current board           |
| `func didWin() -> Bool`                  | check if it wins or not                  |
| `func updateCurrent ()`                  | update the current layout                |
| `func  move(block: Block, currentLayout: String, direction: Int, and completion: (String) -> ()) -> Bool` | find out different ways of moving and store |



## GUI

> Sketch. SpriteKit.

UI and UX are important for an app. We used Sketch to draw the prototype for our game and then used SpriteKit to implement our UI and motions in iOS.

And we created this easy-to-use UI:

![GameOn_iPad](https://github.com/allenx/Swifty-Klotski/blob/master/img/GameOnIpad.png)
<img src="https://github.com/allenx/Swifty-Klotski/blob/master/img/GameOnIpad.png" width="650px">


## About Us

Bao Yixin (鲍一心) 3014216002

Kang Qinlong (康钦珑) 3615000030

Wang Bulei (王布雷) 3014216020

Wei Wenguo (韦文国) 3014216023
