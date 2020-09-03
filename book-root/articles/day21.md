# 你不可不知的 JavaScript 二三事#Day21：箭頭函數 (Arrow Functions) 的 this 和你想的不一樣 (1)

前面 Day15 ~ Day18 舉了很多例子來剖析傳統函數在各種情境下的 `this` 物件。

過程雖然眼花繚亂，但有一個大原則：**看呼叫時的物件是誰**。不是看定義的語彙位置，而是根據執行當下誰擁有這段程式碼，也就是看誰呼叫的。

但在 Arrow Functions 卻不是這麼回事，幾乎可以說是完全不同的另一套運作邏輯。

Day20 介紹箭頭函數 (Arrow Functions) 時示範了一個 `this` 的例子，可以發現和傳統函數的 `this` 運作原則大不相同。

這就是為什麼**最好把 Arrow Functions 當成有別於傳統函數的新種族**，在運作本質上他們有顯著的差別。

## Arrow Functions 的 `this` 判斷原則

那在 Arrow Functions 該怎麼判斷呢？

> MDN & W3Schools:
> * In arrow functions, this retains the value of the enclosing lexical context's this.
> * Arrow functions do not have their own this.
> * In global code, it will be set to the global object.

**Arrow Functions 的 `this` 和傳統函數的一個重大差異就是看的是語彙位置**。

傳統函數每次呼叫函數，都會建立一個新的函數執行環境 (Function Execution Context)，然後建立一個新的 `this` 引用物件，指向當下的呼叫者。

**而 Arrow Functions 則不會有自己的 `this` 引用物件，呼叫 `this` 時，會沿用語彙環境外圍的 `this`**。

相信這樣還是很模糊，我們一樣用具體的例子來看。

下面會將前幾天探討傳統函數 `this` 的情境範例，換成 Arrow Functions 的狀況，並和傳統函數做比對。

傳統函數的部分由於前幾天的文章已經詳細解析過，可參考 Day15 ~ Day18 的文章，下面就不再重複細節，會很快帶過，著重在 Arrow Functions 部分的解析和對照。


## 1. 物件函式

### 1.1. 函數被定義在物件之內

#### 傳統函數

傳統函數看的是誰呼叫，所以這個例子相對單純，`player.whatsThis()` 的呼叫者就是 `player`：

```js
var player = {
  whatsThis: function() {   // normal function
    return this;
  },
};

console.log( player.whatsThis() === player );    // true
```

#### Arrow Functions

`whatsThis()` 使用 Arrow Functions 定義，因此 `whatsThis()` 本身不會有自己的 `this`，而是沿用外圍環境的 `this`。

在這個例子裡，從 `whatsThis()` 再往外一層不在任何 Function Context 內，換言之就是 Global Context。在全域環境裡的 `this` 就是 Global 物件，在 HTML 裡就是 `window`：

```js
var player = {
  whatsThis: () => {    // arrow function
    return this;
  },
};

console.log( player.whatsThis() === window );    // true
```

### 1.2. 借用函數 (函數被定義在物件之外)

#### 傳統函數

傳統函數一樣單純看是誰呼叫，`player.f()` 的呼叫者就是 `player`：

```js
var whatsThis = function() {   // normal function
    return this;
};

var player = {};
player.f = whatsThis;

console.log(player.f() === player);     // true
```

#### Arrow Functions

雖然是透過 `player.f()` 呼叫，但這邊看的是語彙位置，`whatsThis()` 再往外一層的 `this` 是 Global 物件：

```js
var whatsThis = () => {    // arrow function
    return this;
};

var player = {};
player.f = whatsThis;

console.log(player.f() === window);     // true
```

### 1.3. 物件的屬性物件的函式

#### 傳統函數

根據 `obj.method()` 的公式，呼叫者同樣很好辨認：

```js
var player = {
  name: 'OneJar',
  f: function() {
    return this;
  },
  pet: {
    name: 'Totoro',
    f: function() {
      return this;
    },
  }
};

console.log(player.f() === player);             // true
console.log(player.pet.f() === player.pet );    // true
```

#### Arrow Functions

雖然呼叫者不同，函數定義的層次也不太一樣，但由於 `player.f()` 和 `player.pet.f()` 語彙位置再往外一層其實都是 Global Context，所以兩個函數回傳的 `this` 都是 Global 物件：

```js
var player = {
  name: 'OneJar',
  f: () => {
    return this;
  },
  pet: {
    name: 'Totoro',
    f: () => {
      return this;
    },
  }
};

console.log(player.f() === window);         // true
console.log(player.pet.f() === window );    // true
```


## 2. 簡易呼叫 (Simple Call)

### 2.1. 全域環境 (Global Context) 下定義函數 & 呼叫函數

#### 傳統函數

前面沒有指定呼叫者的狀況，傳統函數在一般模式下是 Global 物件，嚴謹模式下是 `undefined`：

```js
var whatsThis = function() {
  return this;
}

console.log( whatsThis() ); // (normal mode) window / (strict mode) undefined
```

#### Arrow Functions

由於看的是語彙位置，往外一層是 Global Context，不管在一般模式或嚴謹模式，`this` 都是 Global 物件：

```js
var whatsThis = () => {
  return this;
}

console.log( whatsThis() ); // window
```


### 2.2. 內部函數 (Inner Functions)

#### 傳統函數

```js
var x = 10;
var obj = {
    x: 20,
    f: function(){
        console.log('Output#1: ', this.x);
        var foo = function(){ console.log('Output#2: ', this.x); }
        foo();
    }
};

obj.f();
```

執行結果：

```
Output#1:  20
Output#2:  10
```

* 「Output#1」時，呼叫方式是 `obj.f()`，因此 `this` 是呼叫者 `obj` 物件，`this.x` 是 20。
* 「Output#2」時，呼叫方式是 `foo()`，視同簡單呼叫，一般模式下 `this` 是 Global 物件，因此 `this.x` 是 10。


#### Arrow Functions I

如果只有內部函數是 Arrow Function，外部函數仍是傳統函數：

```js
var x = 10;
var obj = {
    x: 20,
    f: function(){
        console.log('Output#1: ', this.x);
        var foo = () => { console.log('Output#2: ', this.x); } // arrow function
        foo();
    }
};

obj.f();
```
執行結果：

```
Output#1:  20
Output#2:  20
```

* 「Output#1」所在的函數仍是傳統函數，因此 `this.x` 不變仍是 20。
* 「Output#2」所在的函數變成 Arrow Function，沿用外層的 `this`，其外層就是 `obj.f()`，因此 `this.x` 也是 20。


#### Arrow Functions II

如果外部函數是 Arrow Function，內部函數是傳統函數：

```js
var x = 10;
var obj = {
    x: 20,
    f: () => {  // arrow function
        console.log('Output#1: ', this.x);
        var foo = function() { console.log('Output#2: ', this.x); }
        foo();
    }
};

obj.f();
```
執行結果：

```
Output#1:  10
Output#2:  10
```

* 「Output#2」根據呼叫方式是 `foo()`，視同簡單呼叫，一般模式下 `this` 是 Global 物件，因此 `this.x` 是 10。
* 「Output#1」會沿用外層的 `this`，往外找一層是 Global Context，所以 `this` 也是 Global 物件。


#### Arrow Functions III

如果外部函數和內部函數都是 Arrow Function：

```js
var x = 10;
var obj = {
    x: 20,
    f: () => {  // arrow function
        console.log('Output#1: ', this.x);
        var foo = () => { console.log('Output#2: ', this.x); } // arrow function
        foo();
    }
};

obj.f();
```
執行結果：

```
Output#1:  10
Output#2:  10
```

* 「Output#1」會沿用外層的 `this`，往外找一層是 Global Context，所以 `this` 也是 Global 物件。
* 「Output#2」沿用外層的 `this`，其外層是 `obj.f()`；而 `obj.f()` 的 `this` 如上面所說，經過沿用後是 Global 物件。

> 可以發現上面第 2 和 第 3 個情境的結果都是 Output#1 和 Output#2 等於 10。雖然他們最後呈現的結果碰巧一樣，但要注意背後的運作原理其實有所差別。


## References
* [W3Schools - ECMAScript 6 - JavaScript 6](https://www.w3schools.com/js/js_es6.asp)
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](https://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
* [[ES6] Javascript 開發者必須知道的 10 個新功能](https://medium.com/@peterchang_82818/es6-10-features-javascript-developer-must-know-98b9782bef44)
* [ES6,ES7,ES8 · class - easonwang01 - GitBook](https://easonwang01.gitbooks.io/class/es6es7.html)
