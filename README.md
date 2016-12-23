# Swifty-Klotski

## 问题分析

首先我们知道，华容道的格局是一个4x5的棋牌，并且每个棋盘的格局对应的大将（张飞、关羽、黄忠、马超、赵云）在棋盘中的坐标都是不一样的。例如，**横刀立马**的格局如下: 

![HengDaoLiMa](http://ogbzxx07e.bkt.clouddn.com/HengDaoLiMa.png)

- 我们定义每个人物的坐标为该人物的棋子左上角的坐标。并且我们遍历人物的坐标是从棋盘上的左上角开始，从左到右，从上到下遍历，我们在算法中运用了该方法。
- 在该图片中，我们可以看到，`张飞`的坐标为（0, 0），`曹操`的坐标在（1，0），`赵云`的坐标为（3, 0），`马超`的坐标为（0， 2），`关羽`的坐标为（1， 2），`黄忠`的坐标为（3， 2），`卒1`的坐标为（0， 4），`卒2`的坐标为（1， 3），`卒3`的坐标为（2， 3），`卒4`的坐标（3， 4 ）。我们游戏胜利的条件即为：`曹操`的坐标为（1， 3）。
- 首先我们将每个棋盘的格局中的每个人物坐标都读取出来，然后将这些人物的坐标读进我们实现的算法中，输出算法结果即`曹操`是如何走出华容道。

那么我们知道了以上的信息，我们就要开始思考如何通过一个人工智能的方法将`曹操`安全（即不违反游戏规则）的走到出口。



## 解决方案

对于该项目，我们经过讨论，为了使我们的项目更加直观和美观，我们决定采用 Swift 3 进行编写，该语言是 Apple 公司发布的专门为编写 iOS 应用的开发人员使用的一种语言。

使用该语言的优点有

- Swift 意味 “迅速、敏捷”，正如它的名字一样，它能加快应用程序的开发速度，同 Objective-C、C 更好地协作。同时，Swift 和脚本语言一样，非常富有表现力，能让人们更自然地对它进行阅读和编写。

- Swift 还拥有自动内存管理功能，苹果承诺它可以阻止一些开发者常见错误（如在变量初始化和数据溢出方面）的发生。

  以上就是我们为什么使用Swift的原因，总之它可是使我们更加容易发现编写项目过程中出现的BUG，可以提高我们项目的完成速度，并且该语言的可读性非常强。                                                                         



## 实现纲要

1. 我们运用的搜索方法为：广度优先算法。在使用广度优先算法的队列中，我们将搜索到的每个格局都放进队列中，由于我们每次用广度搜索算法的时候都是在棋盘的格局上从左到右，从上到下的进行搜索，通过测试这样出现的棋盘格局的所遭遇的重复项比较多，能是剪枝力度更大。
2. 我们每次将队头中的棋盘格局即10个人物的坐标进行扩展，即我们要遍历10个人物坐标，并且通过一定的条件来进行判断当前这个人物往哪些方向可走，人物所走的方向有：上，下，左，右。
3. 当某个人物进行移动后，将该移动后的格局放入队尾，重复步骤2和步骤3，以此类推，直到找到一个符合游戏胜利的格局。
4. 当我们找到游戏胜利的格局后，我们通过回溯算法，从该格局一直回溯到初始格局，回溯完成后，即可输出结果。



## 最初实现

> AI.swift Person.swift Layout.swift SwiftyQueue.swift

### 算法描述 & 设计思路：

​	面对华容道问题首先我们考虑的问题是如何存储格局，很自然的就想到用到坐标系。首先我们以左上角为坐标原点，然后使用 2 个相邻整数表示该人物的横、纵坐标，最后将所有人的横、纵坐标连成用一个字符串，即可获得当前的格局编码，首先想到的是用一个 `Int` 类型的数值来表示，但是因为需要记录 10 个人物的坐标信息，需要 20 位长度的 `Int` 数值，但是这样的想法在实现的过程中出现了超出 `Int` 表示范围的情况，然后就想到了使用一个`元组`的形式表示，同时格局具有一个指针 `superLayout` 指向其父格局，而对于整个格局我们作为一个类 `Layout`:

```swift
class Layout {
//its super layout
let superLayout: Layout?

//current layout represented as an Int value
let value: (lhs: Int, rhs: Int)

init(superLayout: Layout?, value: (lhs: Int, rhs: Int)) {
    self.superLayout = superLayout
    self.value = value
	}
}
```
​	第二个需要表示的方面是界面上的人物信息，我们对于每个人物需要记录的信息为其名字，长度和宽度以及其坐标，同时我们也记录其相邻人物的信息，记录相邻信息是通过一个 `Opitional` 数组来实现的，如果某个方位的数组为 `nil` 则它的该方位为边界，如果某个方位没有相邻人物，则当前方位指针数组为空数组:

```swift
class Person {
	let name: String
	let width: Int
	let height: Int

	var coordinate: (x: Int, y: Int)
	var positionVal: Int {
    	get {
       	 	return coordinate.x * 10 + coordinate.y
    	}
	}

	var left: [Person]? = []
	var right: [Person]? = []
	var top: [Person]? = []
	var bottom: [Person]? = []

	init(width: Int, height: Int, coordinate: (x: Int, y: Int), name: String) {
    	self.width = width
    	self.height = height
    	self.coordinate = coordinate
    	self.name = name
	}
}
```
人物同样具有向左，右，上，下移动的动作，以左为例，当人物左走以后完成一些操作之后会回退到原来的位置:

```swift
func goUp(and completion: () -> ()) {
    self.coordinate.y -= 1
    completion()
    self.coordinate.y += 1
}
```
然后需要新建华容道中的人物并赋上其具有的各种属性:

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

对于我们如何判断人物的周围人物信息，我们采用函数 `assignNeighbours()`来进行判断，首先设置人物的四周初始化为空数组。

(1)该人物的横坐标为 1，则代表他在格局的最左边，其左边为边界;

(2)当一个人物的横坐标加上该人物的宽度等于当前人物的横坐标，则表示该人物在当前人物的左边;

(3)当人物的横坐标加上人物的宽度大于 4 时，则代表人物在最右边;

(4)当一个人物的横坐标等于当前人物的横坐标加上其宽度，则表示该人物在当前人物的右边;

上方和下方人物情况类似;

```swift
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
                        //                        person.left = []
                        if personCursor.coordinate.x + personCursor.width == person.coordinate.x && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.left?.append(personCursor)
                        }
                    }
                    
                    //See right
                    if person.coordinate.x + person.width > 4 {
                        person.right = nil
                    } else {
                        //                        person.right = []
                        if personCursor.coordinate.x == person.coordinate.x + person.width && areIntersected(lhs: (personCursor.coordinate.y, personCursor.coordinate.y + personCursor.height), rhs: (person.coordinate.y, person.coordinate.y + person.height)) {
                            person.right?.append(personCursor)
                        }
                    }
                    
                    //See top
                    if person.coordinate.y == 1 {
                        person.top = nil
                    } else {
                        //                        person.top = []
                        if personCursor.coordinate.y + personCursor.height == person.coordinate.y && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.top?.append(personCursor)
                        }
                    }
                    
                    //See bottom
                    if person.coordinate.y + person.height > 5 {
                        person.bottom = nil
                    } else {
                        //                        person.bottom = []
                        if personCursor.coordinate.y == person.coordinate.y + person.height && areIntersected(lhs: (personCursor.coordinate.x, personCursor.coordinate.x + personCursor.width), rhs: (person.coordinate.x, person.coordinate.x + person.width)) {
                            person.bottom?.append(personCursor)
                        }
                    }
                }
            }
        }
    }
```

接下来我们需要做的就是进行最核心的广度优先搜索，即格局的扩展，保存，以及判断重复格局剪枝的过程，为了加快查询重复格局，我们采用二分查找的方式，在每次扩展当前格局时，先在格局数组中使用二分查找 + 二分插入的方式，先对格局表进行查找以确定当前格局是否已经出现过，如果出现，则将当前格局出队列并且不对该格局进行扩展。反之，则将该格局放入格局数组中，表示该格局已经生成。因为这个格局编码不是简单的整型数据，所以首先检查编码元组的左边部分，如果在编码数组中有相同的，再对编码元组的右边部分进行判断，如果相同则说明格局已经为重复格局，则将当前队头出队，如果右边部分小于编码中已经存在的格局编码的右边部分，则将其插入在当前位置，如果右边部分大于编码中已经存在的格局编码的左边部分，则将其插入在当前位置+1的位置。当然编码左边不同的情况则可直接插入，结束条件为当曹操的坐标为 (4, 2)，搜索即可结束。

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

最后在优化的时候，我们增加了随机因子，用以提高搜索效率:

```swift
func insert(value: (lhs: Int, rhs: Int)) -> Bool {
        for eachValue in AI.valueArr {
            if value == eachValue {
                return false
            }
        }
        let index = Int(Random.random(number: UInt32(AI.valueArr.count)))
        AI.valueArr.insert(value, at: index)
        //AI.valueArr.append(value)
        return true
}
```



### Class Reference:

| CLASS         | DISCRIPTION                              |
| :------------ | :--------------------------------------- |
| `AI`          | AI controls the logic of the game        |
| `Block`       | Including information and action of characters |
| `Layout`      | Layout is the code of different situation |
| `Person`      | initial the infomation of all characters with different level |
| `Random`      | Random offers algorithm with random parameters |
| `RawAI`       | second AI to implement the algorithm     |
| `SwiftyQueue` | SwiftyQueue is a queue used in the algorithm |

For the `AI` Class:

| PROPERTIES                             | DISCRIPTION                              |
| :------------------------------------- | :--------------------------------------- |
| `var people: [Person]`                 | an array to store all the characters     |
| `let queue: SwiftyQueue`               | Queue is to implement BFS alogrithm      |
| `var valueArr: [(lhs: Int, rhs: Int)]` | This array stores codes of different layout |
| `static let shared = AI()`             | shared instace of AI                     |

| INSTANCE METHODS                         | DISCRIPTION                              |
| ---------------------------------------- | ---------------------------------------- |
| `func assignNeighbours()`                | check out neighbours of each character   |
| `func calculatePostionValues() -> (Int, Int)` | calculate the code of each layout        |
| `func binaryInsert(value) -> Bool`       | implement binary Insert                  |
| `func didWin() -> Bool`                  | check if it wins or not                  |
| `func backtrack(layout: Layout)`         | find the final solution                  |
| `func setCurrentPeopleFrom(layout: Layout)` | set the current queue_front              |
| `func randomSearch()`                    |                                          |
| `func areIntersected( lhs: (min: Int, max: Int), rhs: (min: Int, max: Int) -> Bool` | check if the current character can move or not |
| `func removeDuplicates( includeElement: @escaping (_ lhs:Element, _ rhs:Element) -> Bool) -> [Element]` | remove duplicates from an array          |

For the Block Class

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

| INSTANCE METHODS                         | DISCRIPTION                       |
| ---------------------------------------- | --------------------------------- |
| `func set (coordinate: (x: Int, y: Int))` | set the coordinate of a character |
| `func goLeft ()`                         | go left and update the state      |
| `func goRight ()`                        | go right and update the state     |
| `func goUp ()`                           | go up and update the state        |
| `func goDown ()`                         | go down and update the state      |

For the `Layout` Class

| PROPERTIES                        | DISCRIPTION                    |
| --------------------------------- | ------------------------------ |
| `let superLayout: Layout`         | its superLayout                |
| `let value: (lhs: Int, rhs: Int)` | the code of the current layout |

For the `Person` Class

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
| static let MaChao: Person`         | character MaChao                  |
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









## 全新实现

> Block.swift RawAI.swift

由于之前的算法效率太低，只能很快的处理相对简单的格局。所以我们对整个算法进行了优化:用新的思想来更加高效的完成华容道自动求解:

新的思想更加接近底层、所以我们给新的 `AI` 取名为 `RawAI`，一次原始的尝试。

首先我们定义了枚举类型的人物形状:

`horizontal` 表示水平放置的 1 * 2 的人物，其值为 3

`vertical` 表示垂直放置的 2 * 1 的人物，其值为 2

`bigSquare` 表示 2 * 2 的人物(即曹操)，其值为 4

`tinySquare` 表示 1 * 1 的小兵，其值为 1

`foo` 表示 1 * 1 的空格白块，其值为 0

```swift
enum BlockType: Int {
    case horizontal = 3
    case vertical = 2
    case bigSquare = 4
    case tinySquare = 1
    case foo = 0
}
```

而新建的 `Block` 类相似于之前建的 `Person` 类，而相比之下，`Block` 更加的原始底层，不那么面向对象，这之后，`Person` 类成为 `Block` 这个 Model 和 UI 的中间连接者。

`Block` 的实例具有属性：`coordinate`，`width`，`height`，`id`，`BlockType`



以及这几个 `Bool` 的属性：`canGoLeft`、`canGoRight`、`canGoUp`、`canGoDown`，以左为例,如果人物坐标的横坐标为 0，则表示该人物应景在最左边的位置，不能够再向左移动了，返回 `false`，而如果该人物方块的左边的 `state` 数组都为 0，即左边都是空白块，可以向左移动，则返回 `true`，其他方向类似:

```swift
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

在判断了之后当然应该时进行移动，所以接下来时 `goLeft`、`goRight`、`goUp`、`goDown`，分别用于函数的左右上下移动，同样以左为例，首先用 `canGoLeft` 函数进行判断，如果是 `false` 则不能左走。反之则该人物方块可以左走，然后将其 `state` 数组格局当前格局的右侧1步范围内的方格都置为 0，而 `board` 数组格局当前格局的右侧 1 步范围内的方格都置为 -1，表示为都已变为空白块。而将其 `state` 数组格局当前格局的左侧1步范围内的方格都置为该人物方块的类型 `type`，确定是什么形状的方块占据该方格，而 `board` 数组格局当前格局的右侧 1 步范围内的方格都置为当前人物 `id`，以说明是谁当前占据这些方格位置:

```swift
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
//      print("left")
        coordinate.x -= 1;
}
```

接下来就是华容道的核心部分，首先初始生成华容道中的人物和坐标

```swift
 func initBoard() {
        blocks.append(Block(_width: 1, _height: 2, _id: 0).set(coordinate: (0, 0)))
        blocks.append(Block(_width: 2, _height: 2, _id: 1).set(coordinate: (1, 0)))
        blocks.append(Block(_width: 1, _height: 2, _id: 2).set(coordinate: (3, 0)))
        blocks.append(Block(_width: 1, _height: 2, _id: 3).set(coordinate: (0, 2)))
        blocks.append(Block(_width: 2, _height: 1, _id: 4).set(coordinate: (1, 2)))
        blocks.append(Block(_width: 1, _height: 1, _id: 5).set(coordinate: (1, 3)))
        blocks.append(Block(_width: 1, _height: 1, _id:
6).set(coordinate: (2, 3)))
        blocks.append(Block(_width: 1, _height: 2, _id: 7).set(coordinate: (3, 2)))
        blocks.append(Block(_width: 1, _height: 1, _id: 8).set(coordinate: (0, 4)))
        blocks.append(Block(_width: 1, _height: 1, _id: 9).set(coordinate: (3, 4)))
}
```

接下来就是要将当前格局进行编码，生成一个40位的字符串，因为是字符串，所以不存在之前编码长度超出int类型所能表示的范围。自左向右，自上到下，依次将state编码数组和board编码数组放在放在偶数位和奇数位上形成40位的编码。

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

当前格局位终止格局时，程序结束，而当曹操处于 `state[3][1]`，`state[3][2]`，`state[4][1]`，`state[4][2]`位置时，就到达终止结局。

```swift
func didWin() -> Bool {
        //print(state[3][1].rawValue)
        return (state[3][1].rawValue == state[3][2].rawValue && state[3][2].rawValue == state[4][1].rawValue &&
            state[4][1].rawValue == state[4][2].rawValue && state[4][1].rawValue == 4)
}
```

更新队头的函数

```swift
func updateCurrent(subLayout: String, currentLayout: String) {
        //queue.append(subLayout)
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

接下来就是进行搜索的函数，对当前的格局进行左右上下移动，如果当前人物能够左移则左移，并获取当前的编码，如果左移生成的格局编码在之前并没有出现过，即左移生成的格局不是重复格局，则更新队列数组，之后判断格局是否为终止格局，如果为终止格局则结束搜索，反之，向右移返回上一格局，进行左移判断，之后再重复上下移动。

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
                //printSolution(encoding: layout)
                print("We Won!")
                return true
            }
            //Omitted
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

随机因子，加入随机因子的目的，是为了尝试在随机情况下，能否提高正确答案（或者更接近正确答案的格局）的命中率，来降低搜索的复杂度。

事实证明，在小格局的情况下，我们达到了百分之五十的速度提升。在大格局下，速度提升不明显，有些时候会有明显的速度下降现象。

```swift
func insert(value: (lhs: Int, rhs: Int)) -> Bool {
        for eachValue in AI.valueArr {
            if value == eachValue {
                return false
            }
        }
        let index = Int(Random.random(number: UInt32(AI.valueArr.count)))
        AI.valueArr.insert(value, at: index)
        //AI.valueArr.append(value)
        return true
}
```

SwiftyQueue 

> 由于 Swift 里面没有原生的 Queue 实现，最开始我们使用数组来模拟 Queue，发现效率不佳，于是我们用 LinkedList 等结构实现了 SwiftyQueue

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


### Class Reference

For the RawAI Class

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





