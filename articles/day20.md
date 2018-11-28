# 你不可不知的 JavaScript 二三事#Day20：ES6 的箭頭函數 (Arrow Functions)

昨天的文章我們介紹到傳統 JavaScript 對於函數定義的語法有 4 種寫法。

> 懶人包支援：
> 1. 宣告式 (Function Declarations)
> 2. 匿名表達式 (Function Expressions w/o Function Name)
> 3. 具名表達式 (Function Expressions w/ Function Name)
> 4. 建構子式 (Function Constructor)

這 4 種寫法主要差異在於語法和 Hoisting 效果的差別，其餘少數極細微的差異對於函數的使用呼叫並不影響。換言之，同樣的函數內容，用哪一種寫法並不影響函數內的運作。

相較之下，Arrow Functions 就像函數定義的新種族。

箭頭函數 (Arrow functions) 是 ES6 具代表性的新特性之一，語法上的多項簡化是它的特色，因此很多剛接觸 ES6 未深的開發者會誤以為 Arrow Functions 只是函數定義語法的簡寫版。

事實上，**Arrow Functions 所附帶的新特性對於函數內容的運作有著不同的行為**，如果沒弄清楚，單純因為趕流行，把舊函數的語法簡化成 Arrow Functions 的寫法，可能造成程式運作不正確。

本篇文章就來介紹 Arrow Functions。


## Arrow Functions 小檔案

* ECMAScript 2015 (ES6) 導入的新特性。
* 稱為 Arrow Function Expression，或稱 Fat Arrow Functions，最初在 CoffeeScript 的語法中流行。
* 在函數定義的語法上更為簡潔。
* 函數運作行為上和傳統語法所定義的函數有差異，例如 `arguments`、`this`。


## Arrow Functions 語法

### 1. 標準語法

以下是 Arrow Functions 的標準寫法：

```js
var add = (n1 ,n2) => {
  return n1 + n2;
};
console.log( add(3, 6) );   // 9
```

和傳統語法比起來：
* 少了 `function` 關鍵字。
* 使用 `=>` 符號來告知這是 Arrow Functions。

根據函數內容和參數數量，還可以進一步簡化。

### 2. 當函數內容只有單行回傳時的簡寫

很常我們的函數內容只做很簡單的動作，就像前面的 `add()` 只有一行負責簡單運算並同時做 `return`。語法上可以進一步簡化：

```js
var add = (n1 ,n2) => n1 + n2;
console.log( add(3, 6) );   // 9
```

* 省略函數外殼 `{` `}`。
* 省略 `return` 關鍵字。


### 3. 當只有單一個參數時的簡寫

例如以下範例，`intro()` 只有一個參數 `name`：

```js
var intro = (name) => {
	return `Hi, I am ${name}!`;
};
console.log( intro('OneJar') );     // "Hi, I am OneJar!"
```

`intro()` 在參數部分的語法可以進一步簡化，省略小括號，效果一樣：

```js
var intro = name => {
	return `Hi, I am ${name}!`;
};
console.log( intro('OneJar') );     // "Hi, I am OneJar!"
```

搭配前面提到的單行回傳簡寫法，整體語法就更顯簡潔：

```js
var intro = name => `Hi, I am ${name}!`;
console.log( intro('OneJar') );     // "Hi, I am OneJar!"
```

但記得這是「單一個參數」時的簡寫，若是沒有參數或多個參數，仍必須用標準寫法，例如以下是沒有參數的範例：

```js
var sayHello = () => `Hello OneJar!`;
console.log( sayHello() );          // "Hello OneJar!"
```




## Arrow Functions 使用的注意事項

### 1. 沒有 Hoisting 效果

Arrow Functions 是表達式的語法形式，就像前面介紹過的傳統函數中「具名表達式」或「匿名表達式」那樣，函數定義的部分不會被 Hoist。

換言之，**定義必須寫在使用之前**。

```js
console.log( sayHello );    //undefined
console.log( sayHello() );  // TypeError: sayHello is not a function
var sayHello = () => `Hello OneJar!`;
```

### 2. 建議使用 `const` 做名稱部分的宣告

雖然前面例子故意都用 `var`，但實際上**建議使用 `const`**。

因為函數表達式應該被視為一個常數的值，而非變數，函數定義這件事並不是一個該變動的東西。

> W3Schools:
> A function expression is always constant value.


## Arrow Functions 和傳統函數語法的差異

Arrow Functions 不是單純語法簡化而已，也會對函數的運作行為多了些限制或改變。

### 1. 不會產生新的 `arguments` 物件

> 筆者更新：這裡原本寫的是「不能使用 `arguments`」，後來發現這個理解並不精確，因為如果外圍包裝一層傳統函數，作用域內還是會有可用的 `arguments`，因此進行修訂。

Arrow Functions 不會在自己的函數作用域內產生新的 `arguments` 物件，讓函數使用上更嚴謹。

例如以下是傳統函數寫法，雖然在函數定義的上只定義了 `n1` 和 `n2` 兩個參數，但實際上呼叫函數時我可以丟任意個參數進去，而在函數內也可以靠 `arguments` 取得所有參數：

```js
const add = function (n1, n2) {
	console.log(arguments);         // Arguments(3) [100, 200, 300]
	return n1 + n2;
};
console.log( add(100, 200, 300) );  //300
```

甚至極端一點，我可以完全不管參數定義什麼：

```js
const add = function (n1, n2) {
	return arguments[0] + arguments[1];
};
console.log( add(100, 200, 300) );  //300
```

這讓函數的參數定義非常沒有約束力。看起來好像很自由，但這種寫法很容易導致「包裝與內容物不符合」，會讓程式難以維護。

而 Arrow Functions 改善這一點。在 Arrow Functions 內不會為這個作用域建立一個新的 `Arguments` 物件，因此 `arguments` 不再被認得：

```js
const add = (n1, n2) => {
	console.log(arguments); // ReferenceError: arguments is not defined
	return n1 + n2;
};
console.log( add(100, 200, 300) ); // 300
```

無法使用 `arguments`，代表只能取用被定義的參數。雖然依舊無法阻止呼叫端任意亂丟參數進來，但至少會讓函數內容更可控。

但要注意，**Arrow Functions 只是不會產生新的 `arguments`，不代表 `arguments` 變數一定不存在**。

例如以下例子，使用一個傳統函數包裝一個 Arrow Function：

```js
function getObj(){
	console.log(arguments);  // Arguments(3) [1, 2, 3]
    return {
        f: () => {
           console.log(arguments);  // Arguments(3) [1, 2, 3]
	    }
	};
}

getObj(1, 2, 3).f(4, 5);
```

* 傳統函數 `getObj()` 還是會產生新的 `arguments`。
* 對作用域來說，`f()` 可以使用 `getObj()` 內存在的變數。
* 因此如果在 `f()` 內去使用 `arguments`，會取到的是 `getObj()` 的 `arguments`，要特別注意。

如果使用 Arrow Function 去包裝另一個 Arrow Function：

```js
var getObj = () => {
	console.log(arguments);  // ReferenceError: arguments is not defined
    return {
        f: () => {
           console.log(arguments);  // ReferenceError: arguments is not defined
	    }
	};
}

getObj(1, 2, 3).f(4, 5);
```

* `getObj()` 和 `f()` 都不會產生新的 `arguments`。
* 因此在 `getObj()` 和 `f()` 內企圖使用 `arguments`，都會得到 `arguments is not defined` 的錯誤。


### 2. `this` 運作行為的不同

前面介紹 `this` 時，提到判斷 `this` 代表什麼物件的大原則：**看呼叫時的物件是誰**。

例如借用函數的例子 (函數被定義在物件之外)，雖然 `whatsThis` 語彙上定義的地方是在 Global Context，但被執行時的呼叫者是 `player`，因此回傳的 `this` 物件是 `player`：

```js
var whatsThis = function() {
    return this;
};

var player = {};
player.f = whatsThis;

console.log(player.f() === player);     // true
```

但如果是 Arrow Functions 就不一樣了：

```js
var whatsThis = () => {
    return this;
};

var player = {};
player.f = whatsThis;

console.log(player.f() === player);     // false
console.log(player.f() === window);     // true
```

可以發現，同樣的呼叫方式，`this` 不再回傳呼叫者物件，在這個例子變成回傳 Global 物件，是不同的運作行為。

Arrow Functions 的 `this` 究竟怎麼回事，我們會在明天的文章進行介紹。



## 小結

Arrow Functions 重點小結：
* 是 ES6 導入的新特性。
* 在語法上更為簡潔。
* 不是單純語法簡化而已，也會對函數的運作行為多了些限制或改變：
    * 函數執行時不會產生新的 `arguments` 物件。
    * `this` 的運作方式與傳統函數不同。
* 定義的語法必須在使用之前 (不具 Hoisting 效果)。
* 建議使用 `const` 宣告名稱。


## References
* [W3Schools - ECMAScript 6 - JavaScript 6](https://www.w3schools.com/js/js_es6.asp)
* [[ES6] Javascript 開發者必須知道的 10 個新功能](https://medium.com/@peterchang_82818/es6-10-features-javascript-developer-must-know-98b9782bef44)
* [ES6,ES7,ES8 · class - easonwang01 - GitBook](https://easonwang01.gitbooks.io/class/es6es7.html)
