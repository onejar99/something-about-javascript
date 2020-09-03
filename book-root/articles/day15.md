# 你不可不知的 JavaScript 二三事#Day15：this 關鍵字 (1)

> 今天驟聞武俠大師金庸查先生逝世的消息，身為一位超過二十年的金迷，實在難以表達心中的難過。在此偷渡對一代文學大師的懷念，聊表追思，紀念這個對華文世界影響至深之偉人殞落的日子：金庸武俠，永垂不朽，緬懷再三，一路好走。—— 2018.10.30


`this` 是一個特殊的關鍵字，代表著一個物件，在很多程式語言都可以看到這個設計。由於不同程式語言有各自的特性， `this` 的運作方式也不盡相同。

那在 JavaScript 裡，`this` 指什麼呢？

來看看 W3Schools 的說明：
> * In a method, this refers to the **owner object**.
> * Alone, this refers to the **global object**.
> * In a function, this refers to the **global object**.
> * In a function, in strict mode, this is **undefined**.
> * In an event, this refers to **the element that received the event**.
> * Methods like call(), and apply() can refer this to **any object**.

JavaScript 的 `this` 一下是物件本身，一下是 Global 物件，一下是 `undefined`，一下還可以是任何物件！

![](https://i.imgur.com/RqTPySJ.png)  
(Source: [網路圖片](https://pic.pimg.tw/kenmy/1380581708-2393697494_n.jpg))

`this` 是程式語言中很重要的部分，誤判 `this` 所代表的物件會直接對程式的運作造成影響。所以本篇文章就來好好弄清楚 JavaScript 的 `this`。


## `this` 的簡單範例

照例先上一個基本款的情境範例：

```js
var ironMan = {
    firstName: "Tony",
    lastName : "Stark",
    getFullName : function() {
        return this.firstName + " " + this.lastName;
    }
};

console.log(ironMan.getFullName()); // "Tony Stark"
```

這是一個典型的 `this` 應用例子，對物件進行物件導向風格的操作。上面這個例子看起來很好懂，那 JavaScript 的 `this` 到底複雜在哪？




## JavaScript 的 `this` 很複雜？

像 `Java`、`C#` 等基於類別的物件導向語言 (Class-based Object-oriented Languages)，由於語法規範極為嚴謹，大多數情境可以從語彙範圍 (Lexical Scope) —— 也就是看語法上定義在哪個地方來判斷。

但 JavaScript 的 `this` 關鍵字運作與其他語言不同。具體來說，**JavaScript 的 `this` 不是看定義的語彙位置，而是根據執行當下誰擁有這段程式碼**。

> W3Schools:
> `this` has different values depending on where it is used.
> The JavaScript `this` keyword refers to the object it belongs to.

換句話說，**不是看該屬性或函式被定義在哪個物件內，看的是執行當下被誰呼叫**。

JavaScript 的語彙定義上沒有像類別那樣完整明確的物件界線，加上語法結構設計上很寬鬆，衍生出各種複雜情境。

此外，不同情境下，`this` 運作的機制也不同，例如：
* 全域執行環境 (Global Context) 下和函數執行環境 (Function Context) 下不同。
* 在嚴謹模式 (Strict Mode) 與一般模式下也可能有所不同。

![](https://i.imgur.com/lcqSy7g.png)  
(Source: [網路圖片](https://colorfulblanche.com/wp-content/uploads/2018/01/%E6%8A%95%E5%BD%B1%E7%89%8713-1024x576.png))

理論描述太抽象，接下來會試圖用各種實際的例子來探討 `this` 的運作。






## 全域執行環境下 (Global Context)

全域環境下比較單純。

> MDN:
> In the global execution context (outside of any function), this refers to the global object whether in strict mode or not.

* **`this` 在所有函式以外的全域執行環境下，會被當作全域物件，無論是否處於嚴謹模式**。
  * HTML 中就是 `window` 物件。
  * Node.js 中就是 `global` 物件。

例如在全域執行環境下直接印出 `this` 物件：

一般模式：

```js
console.log(this); // window object
```

嚴謹模式：

```js
"use strict";

console.log(this); // window object
```





## 函數執行環境下 (Function Context)

函數環境下可能遇到的情境就複雜了。

> MDN:
> Inside a function, the value of this depends on how the function is called.

**在函數內的 `this` 值取決於該函數如何被呼叫。**

就先記著一個大原則：**看是誰呼叫的**，然後用這個原則來看各種情境下 `this` 運作的例子。




### 1. 物件函式 (As an Object Method)

> `this` 物件：呼叫者本身。

這應該是最常見、也相對好理解的情境，也就是 Object Method Binding。

在物件函式的用法，嚴謹模式或一般模式都是一樣的執行結果。

但同樣是物件函式的用法，也有很多種語法情境。



#### 1.1. 函數被定義在物件之內

下面例子中 `player` 物件有 2 個函式，其中一個直接在函數內回傳 `this`，藉此來觀察當下的 `this` 值：

```js
var player = {
  name: 'OneJar',
  getName: function() {
    return this.name;
  },
  whatsThis: function() {
    return this;
  },
};

console.log(player.getName());      // "OneJar"
console.log(player.whatsThis());    // {name: "OneJar", getName: ƒ, whatsThis: ƒ}    # `player` object
```

* 執行的函數是 `player.whatsThis` 和 `player.getName` 所指向的函數。
* 呼叫者是 `player`。
* 因此函數內的 `this` 指的是 `player`。

這個例子理解上應該沒什麼困難，很單純的呼叫物件函式用法，加上函數定義就在物件內，判斷上很簡單。

如果函數定義不在物件內呢？




#### 1.2. 借用函數 (函數被定義在物件之外)

函數不是物件本身自己定義，而是指向別人的函數，就像跟別人借用函數一樣。

那在函數裡的 `this`，會是物件本身，還是別人？

是不是開始有趣了。

來看下面的例子：

```js
var getName = function() {
    return this.name;
};
var whatsThis = function() {
    return this;
};

var player = { name: 'OneJar' };
player.f1 = getName;
player.f2 = whatsThis;

console.log(player.f1());     // "OneJar"
console.log(player.f2());     // {name: "OneJar", getName: ƒ, whatsThis: ƒ}    # `player` object
```

* `getName()` 和 `whatsThis()` 函數都不是定義在 `player` 內。
* 但執行當下，`player` 是呼叫者，被視為那段程式碼的擁有者，因此 `this` 仍是 `player`。


**函數是否為物件本身的語彙構件無所謂，誰是最直接的呼叫才是最重要的**。




#### 1.3. 物件的屬性物件的函式

物件內的屬性可以是另一個物件，另一個物件也可以有自己的函式，那這時候的 `this` 是誰？

例如以下例子：

```js
var getName = function() {
    return this.name;
};

var player = {
  name: 'OneJar',
  f: getName,
  pet: {
    name: 'Totoro',
    f: getName,
  }
};

console.log(player.f());      // "OneJar"
console.log(player.pet.f());  // "Totoro"
```

* `player` 物件擁有另一個物件 `pet`，而 `player` 和 `pet` 都借用 `getName()`。
* `player.f()` 的呼叫者是 `player`。
* `player.pet.f()` 的呼叫者是 `player.pet`。

這裡的原則沒有變，一樣看**誰是呼叫者，誰就是 `this`**。

只是不要混淆，`player.pet.f()` 的呼叫者是 `player.pet` 而不是 `player`。





## References
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](https://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
