以下是一个包含 C、Lua、Rust、Python 和 C++ 示例代码的 Markdown 文件，这些代码展示了各语言的主要特性，适合用于配色方案的预览：

```markdown
# 编程语言语法示例

以下是几种编程语言的示例代码，用于展示各语言的主要特性及语法高亮效果。

## C 语言示例

```c
#include <stdio.h>
#include <stdlib.h>

// 结构体和指针示例
typedef struct {
    int x;
    int y;
} Point;

// 函数指针
typedef int (*Operation)(int, int);

int add(int a, int b) {
    return a + b;
}

int main() {
    // 指针和内存管理
    Point *p = malloc(sizeof(Point));
    p->x = 10;
    p->y = 20;
  
    // 函数指针使用
    Operation op = add;
    int result = op(p->x, p->y);
  
    printf("Result: %d\n", result);
    free(p);
    return 0;
}
```

## Lua 示例

```lua
-- 表格和元表示例
local person = {
    name = "Alice",
    age = 30,
    greet = function(self)
        print("Hello, my name is " .. self.name)
    end
}

-- 元表实现继承
local student = {
    grade = "A"
}
setmetatable(student, { __index = person })

-- 协程示例
local co = coroutine.create(function()
    for i = 1, 3 do
        print("Coroutine", i)
        coroutine.yield()
    end
end)

-- 调用
person:greet()
student:greet()
coroutine.resume(co)
coroutine.resume(co)
```

## Rust 示例

```rust
use std::fmt;

// 特质定义
trait Greet {
    fn greet(&self);
}

// 结构体和实现
struct Person {
    name: String,
    age: u32,
}

impl Greet for Person {
    fn greet(&self) {
        println!("Hello, I'm {} and {} years old", self.name, self.age);
    }
}

// 枚举和模式匹配
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
}

fn process_message(msg: Message) {
    match msg {
        Message::Quit => println!("Quit"),
        Message::Move { x, y } => println!("Move to ({}, {})", x, y),
        Message::Write(s) => println!("Message: {}", s),
    }
}

fn main() {
    // 所有权和借用
    let person = Person {
        name: String::from("Bob"),
        age: 25,
    };
    person.greet();
  
    let msg = Message::Write(String::from("Hello Rust"));
    process_message(msg);
}
```

## Python 示例

```python
# 类和装饰器
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
  
    @property
    def description(self):
        return f"{self.name} is {self.age} years old"

# 生成器和上下文管理器
def fibonacci(n):
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# 类型提示和异步
async def fetch_data(url: str) -> dict:
    import aiohttp
    async with aiohttp.ClientSession() as session:
        async with session.get(url) as response:
            return await response.json()

# 使用示例
p = Person("Charlie", 35)
print(p.description)

print(list(fibonacci(5)))
```

## C++ 示例

```cpp
#include <iostream>
#include <vector>
#include <memory>

// 模板和智能指针
template<typename T>
class Container {
    std::vector<std::unique_ptr<T>> items;
public:
    void add(T* item) {
        items.emplace_back(item);
    }
  
    void printAll() const {
        for (const auto& item : items) {
            std::cout << *item << std::endl;
        }
    }
};

// Lambda 表达式
auto make_adder(int x) {
    return [x](int y) { return x + y; };
}

int main() {
    // 现代 C++ 特性
    Container<int> intContainer;
    intContainer.add(new int(10));
    intContainer.add(new int(20));
    intContainer.printAll();
  
    auto add5 = make_adder(5);
    std::cout << add5(3) << std::endl;  // 输出 8
  
    // 范围 for 循环
    std::vector<int> nums = {1, 2, 3};
    for (auto& n : nums) {
        std::cout << n * 2 << " ";
    }
    return 0;
}
```

## 总结

以上代码展示了各语言的主要特性：
- C: 指针、内存管理、结构体、函数指针
- Lua: 表格、元表、协程
- Rust: 所有权系统、特质、模式匹配
- Python: 装饰器、生成器、类型提示
- C++: 模板、智能指针、Lambda 表达式
```

