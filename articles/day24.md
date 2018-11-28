# 你不可不知的 JavaScript 二三事#Day24：函數呼叫 (Function Invocation) 與立即函數 (Self-Invoking Functions)

Day19 的文章曾介紹傳統函數定義 (Function Definition) 的 ~~100 種~~ 4 種寫法，定義了也得有人呼叫才有用，那今天來介紹函數呼叫 (Function Invocation) 吧。

根據場合，函數有 3 種被呼叫的時機，其中立即函數 (Self-Invoking Functions) 是特別有趣的一種，會花比較多篇幅介紹。


## 函數有三種被呼叫的時機

### 1. HTML 事件觸發

JavaScript 可以和 HTML 元件 (HTML Elements) 互動，例如點擊按鈕、偵測鍵盤、瀏覽器載入完畢等。

事件 (Events) 就是發生在 HTML 元件的狀況。

> W3Schools:
> HTML events are "things" that happen to HTML elements.

當事件被偵測到時，JavaScript 就能呼叫指定的函數執行對應動作。

HTML 事件有很多種類，最常見的就是 `onclick`：

```js
<button onclick="sayHello()">Click Me</button>
<script>
function sayHello(){
    alert('Hello');
}
</script>
```



### 2. 由其他 JavaScript 程式碼主動呼叫

這應該是程式中最普遍的呼叫方式：

```js
sayHello();

function sayHello(){
    console.log('Hello');
}
```


### 3. 立即函數 (Self-Invoking Functions)


#### 快速複習一下函數表達式 (Function Expressions) 的概念

Day19 介紹過函數表達式 (Function Expressions) 形式的函數定義語法：
* 匿名表達式 (Function Expressions w/o Function Name)
* 具名表達式 (Function Expressions w/ Function Name)

複習一個簡單的函數表達式範例：

```js
var sayHello = function () {
    console.log('Hello');
};

sayHello();     // "Hello"
```

語法可以分匿名和具名，但具名沒什麼意義。

```js
var sayHello = function abc() {
    console.log('Hello');
};

abc();          // ReferenceError: abc is not defined
```

因為**透過 Function Expressions 定義的函數，我們實際在使用時，無法透過函數名稱 (`abc`) 取得函數物件，而是透過變數名稱 (`sayHello`) 取得函數物件**，然後執行該函數物件。



#### 函數定義用小括號包起來，一律代表 Function Expressions

這個小地方容易有概念上的模糊。

以下是一個**宣告式 (Function Declarations)** 的函數用法：

```js
function sayHello() {
    console.log('Hello');
};

sayHello();     // "Hello"
```

`sayHello` 是函數名稱，**宣告式的函數，我們可以直接透過函數名稱來取得函數物件，並且執行**。

**但一旦使用小括號將函數宣告式包裝起來，原本的 Function Declarations 也會被視為 Function Expressions**。

例如以下：

```js
(function sayHello() {
    console.log('Hello');
});

sayHello();     // ReferenceError: sayHello is not defined
```

如前面提到，透過 Function Expressions 定義的函數，無法透過函數名稱 (`sayHello`) 取得函數物件本身。而上面例子並沒有將這個函數物件儲存於任何變數，等於沒有機會去呼叫它。

所以如果使用 Function Expressions，幾乎都會宣告一個變數去儲存，並且不為函數特別具名。


#### 對函數表達式作立即性的呼叫 (Self-Invoking Expressions)

但如果 Function Expressions 是一次性的，只會使用一次，而且是馬上使用，就可以不用將函數物件另外存放到變數裡，而是加上 `()` 符號要求立刻執行：

```js
(function () {
    console.log('Hello');
})();
```

執行結果：

```
Hello
```

這就是為什麼本篇文章將 Self-Invoking Expressions 稱為「立即函數」，精確的名稱應該要翻「自我呼叫的函數表達式」，但立即函數這個名稱我認為在概念上更有助記憶和理解。

如同前面提到，函數表達式可以具名，語法上可以被接受。但實際上具名的函數名稱無法被呼叫，毫無意義：

```js
(function abc() {
    console.log('Hello');
})();

abc();
```

執行結果：

```
Hello
Uncaught ReferenceError: abc is not defined
```

所以**立即函數不需要具名**。




#### 不能對函數宣告 (Function Declarations) 作立即呼叫

> W3Schools:
> You cannot self-invoke a function declaration.

例如以下語法是不成立的：

```js
function sayHello() {
    console.log('Hello');
}();
```

一定要先包裝成一個 Function Expression，才能進行立即呼叫。




## 總結

**函數有三種被呼叫的時機：**
1. HTML 事件觸發
2. 由其他 JavaScript 程式碼主動呼叫
3. 立即函數

**立即函數使用重點：**
* 函數定義用小括號 `(` 和 `)` 包起來，一律代表 Function Expressions (即使原本是 Function Declarations)。
* 在 Function Expressions 後面加上 `()`，就能作立即性的呼叫。
* 立即函數不需要具名。
* 不能對函數宣告 (Function Declarations) 作立即呼叫。

## References
* [W3Schools - JavaScript Functions](https://www.w3schools.com/js/js_functions.asp)
* [Javascript 開發學習心得 - 函數的多種寫法與應用限制](http://sweeteason.pixnet.net/blog/post/40371736)
