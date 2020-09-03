# 你不可不知的 JavaScript 二三事#Day19：函數定義 (Function Definition) 的 100 種寫法

標題只是嚇嚇你而已 (毆)。

![](https://thumbs.gfycat.com/ScrawnyDisloyalHeifer-size_restricted.gif)  
(Source: [網路圖片](https://thumbs.gfycat.com/ScrawnyDisloyalHeifer-size_restricted.gif))

函數 (Function) 是程式編寫非常重要的一環。

大多數常見程式語言的函數定義都是一套語法格式，頂多加一些修飾子的變化 (例如 `public`、`private`、`static`)，整體語法還是同一套的格式。

但 JavaScript 裡定義函數的語法花樣可多了，不同寫法所定義出來的函數物件 (Function Object) 也各有些微差異，叫人眼花撩亂。

如果沒有特別需求，太多不同寫法只會造成開發團隊 Coding Convention 一致性的困擾，甚至造成不必要的 Bug 風險。

本篇文章試著去統整已知的 JavaScript 函數寫法，比較彼此差異。


## 宣告函數在語法上有 4 種方式

1. 宣告式 (Function Declarations)
2. 匿名表達式 (Function Expressions w/o Function Name)
3. 具名表達式 (Function Expressions w/ Function Name)
4. 建構子式 (Function Constructor)

> ES6 多了第 5 種 —— Arrow Function。


## 宣告式 (Function Declarations)

特點：
* 最普遍標準的寫法。
* 使用 `function` 關鍵字作函數的宣告和定義。
* 具有 Hoisting 效果，會提升到 Scope 頂端。


```js
console.log(myFunc);
console.log(myFunc(3, 6));

function myFunc(a, b) {
    return a + b;
}
```

執行結果：

```
ƒ myFunc(a, b) {
    return a + b;
}
9
```

> 關於 Hoisting 可參考 Day10 文章。




## 匿名表達式 (Function Expressions w/o Function Name)

特點：
* 先宣告一個變數，再定義一個函數內容放到該變數裡。
* 此方式定義的函數實際上是匿名函數 (a function without a name)，只是將函數定義的主體存在某個變數裡。
* 變數名稱不等於函數名稱。
* 不具 Hoisting 效果。

```js
console.log(myFunc);
// console.log(myFunc(3, 6)); // TypeError: myFunc is not a function

var myFunc = function (a, b) {
    return a + b;
};

console.log(myFunc);
console.log(myFunc(3, 6));
```

執行結果：

```
undefined
ƒ (a, b) {
    return a + b;
}
9
```


## 具名表達式 (Function Expressions w/ Function Name)

特點：
* 和「匿名表達式」十分相似，只差在定義函數內容時，有給予一個函數名稱。
* 定義的函數印出來會有函數名稱(不等於變數名稱)。
* 但**無法直接透過該函數名稱呼叫**，所以該函數名稱基本上沒用。
* 不具 Hoisting 效果。
* **沒有使用的必要**。

> **為何無法直接透過函數名稱呼叫？**
>
> 目前理解：
> 因為該函數不算正式宣告於此 Scope，對此 Scope 來說不存在該名稱，所以無法直接透過函數名稱呼叫。

```js
console.log(myFunc);
// console.log(myFunc(3, 6)); // TypeError: myFunc is not a function

var myFunc = function aaa(a, b) {
    return a + b;
};

console.log(myFunc);
console.log(myFunc(3, 6));
// console.log(aaa); // ReferenceError: aaa is not defined
```

執行結果：

```
undefined
ƒ aaa(a, b) {
    return a + b;
}
9
```


## 建構子式 (Function Constructor)

W3Schools:
> With a built-in JavaScript function constructor called `Function()`。

特點：
* 先宣告一個變數，再用 JavaScript 內建的函數建構子 `Function()` 去定義函數內容，放到該變數裡。
* 用 `Function()` 定義的函數自動被給予函數名稱 `anonymous`，但和「具名表達式」一樣，都**無法直接透過該函數名稱呼叫**。
* 不具 Hoisting 效果。
* **沒有使用的必要**。

```js
console.log(myFunc);
// console.log(myFunc(3, 6)); // TypeError: myFunc is not a function

var myFunc = new Function("a", "b", "return a + b");
console.log(myFunc);
console.log(myFunc(3, 6));
```

執行結果：

```
undefined
ƒ anonymous(a,b
) {
return a + b
}
9
```




## 總結

函數的宣告和定義在語法上有 4 種寫法：

| # | 寫法          | Hoisting | 備註         |
|---| ------------- | -------- | ------------ |
| 1 | 宣告式        |    Y     |              |
| 2 | 匿名表達式    |    N     |              |
| 3 | 具名表達式    |    N     | 沒有必要使用 |
| 4 | 建構子式      |    N     | 沒有必要使用 |

這 4 種寫法定義時的寫法不太一樣，但在使用上除了些許細節 (例如 Hoisting)，大致上其實差不多。

其中 1 和 2 是最普遍的寫法；3 和 4 如果沒有特殊需求，沒必要使用。

ES6 多了第 5 種函數寫法：**Arrow Function**。

由於 **Arrow Function** 不只是語法有所不同，還增加了不少使用上的特性，明天的文章將另外專門對 Arrow Function 作介紹。


## References
* [W3Schools - JavaScript Functions](https://www.w3schools.com/js/js_functions.asp)
* [Javascript 開發學習心得 - 函數的多種寫法與應用限制](https://sweeteason.pixnet.net/blog/post/40371736)
