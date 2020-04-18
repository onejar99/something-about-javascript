# 你不可不知的 JavaScript 二三事#Day16：this 關鍵字 (2)

## 函數執行環境下 (Function Context) (續)


### 2. 簡易呼叫 (Simple Call)

> `this` 物件：
> * 一般模式下：Global 物件。
> * 嚴謹模式下：`undefined`

簡易呼叫指的是函數被單獨呼叫，前面沒有帶任何呼叫物件的情境。

例如這樣的語法：

```js
myFunc();
```

當函數被單獨呼叫，**無論呼叫地點在全域環境還是函數環境內，此時執行這段程式的預設綁定擁有者是 Global 物件**。

需要注意的是，**這是指一般模式下的行為，一定會設定一個綁定物件**，因為程式碼沒有指定呼叫物件，Global 物件就被推派出來當預設綁定者。

但基於安全性上的考量，**嚴謹模式下不會作呼叫物件的強制給予**，也就是說不會預設綁定 Global 物件當呼叫物件，程式碼沒指定就當沒有，因此 `this` 會是 `undefined`。

> 節錄 W3Schools 的原文：
> * When used alone, the owner is the Global object.
> * The Global object (the owner of the function) is the default binding.
> * Strict mode does not allow default binding.


根據函數被呼叫的地點不同，有幾種情境。



#### 2.1. 全域環境 (Global Context) 下定義函數 & 呼叫函數

一般模式下，`this` 會綁定 Global 物件，在 HTML 環境裡就是 `window` 物件：

```js
function f1(){
  return this;
}

console.log( f1() ); // `window`
```

在嚴格模式下，`this` 不會作預設綁定，會是 `undefined`：

```js
"use strict";

function f1(){
  return this;
}

console.log( f1() ); // undefined
```

但其實對簡易呼叫來說，在哪裡被定義和呼叫都不重要，再看下一個例子會更明白。



#### 2.2. 內部函數 (Inner Functions)

內部函數是指在 A 函數內定義一個 B 函數，然後在 A 函數裡呼叫 B。

例如以下例子 (一般模式)：

```js
var x = 10;
var obj = {
    x: 20,
    f: function(){
        console.log('Output 1: ', this.x);
        var foo = function(){ console.log('Output 2: ', this.x); }
        foo();
    }
};

obj.f();
```

執行結果：

```
Output 1:  20
Output 2:  10
```

這個例子是在 `obj.f()` 內再定義一個內部函數 `foo()` ，進行內部呼叫。

如前面所說，`foo()` 沒有指定呼叫物件，`this` 就是 Global 物件，因此 `foo()` 所印出的 `this.x` 值會是全域變數的 `x`，而非 `obj` 的 `x` (Output 2)。

如果這裡想讓 `foo()` 可以取到`obj.x`，可以使用一個變數去儲存執行 `obj.f()` 時的 `this` 物件。

```js
var x = 10;
var obj = {
    x: 20,
    f: function(){
        console.log('Output 1: ', this.x);
        var me = this;   // Use a variable to store the `this` object
        var foo = function(){ console.log('Output 2: ', me.x); }  // Access `obj.x` via `me.x`  
        foo();
    }
};

obj.f();
```

執行結果：

```
Output 1:  20
Output 2:  20
```




### 3. HTML 事件處理 (HTML Event Handlers)

> `this` 物件：接受該事件的 HTML 元素 (HTML Element)。

在 HTML 元件的事件 Callback 裡，`this` 就是該事件的 HTML 元素。

例如下面例子，`onclick` 裡的 `this`，指的就是 `<button>` 元素本身。

```html
<button onclick="console.log(this); this.style.display='none';">
     Click to Remove Me!
</button>
```




### 4. 顯性函數綁定之 bind() 篇 (Explicit Function Binding for bind())

> `this` 物件：新函數物件被指定的綁定物件，也就是 `Function.prototype.bind()` 的第一個參數。

ES5 導入了 `Function.prototype.bind`，可以為一個函數建立一個繼承該函數 prototype 的新函數物件，但綁定一個固定的擁有者。

換句話說，**無論新的函數物件怎麼被呼叫，函數內的 `this` 都會是當初綁定的那個擁有者物件**。

此外，透過 `Function.prototype.bind` 的綁定，一般模式或嚴謹模式是一樣的結果。

#### 4.1. 一般模式下的範例

例如下面的例子：

```js
var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var firstName = "One", lastName = "Jar";
var introIronMan = getFullName.bind( { firstName: "Tony", lastName : "Stark" } );
var introCaptainAmerica = getFullName.bind( { firstName: "Steven", lastName : "Rogers" } );

console.log(getFullName());           // "One Jar"
console.log(introIronMan());          // "Tony Stark"
console.log(introCaptainAmerica());   // "Steven Rogers"
```

上面例子在全域環境 (Global Context) 定義了函數 `getFullName()`：
* 透過簡單呼叫去執行 `getFullName()`，也是上面 2.1 節所舉的情境。
	* 在一般模式下會預設綁定 Global 物件作為 `this` 值。
	* 因此函數內會找到全域變數 `firstName` 和 `lastName`，因而印出 `"One Jar"`。
* 使用 `getFullName().bind()`，分別產生了兩個新的函數物件，繼承了 `getFullName()` 的 prototype，但各自綁定了固定的擁有者物件。
	* `introIronMan` 函數物件綁定了擁有者物件 `{ firstName: "Tony", lastName : "Stark" }` 。
	* `introCaptainAmerica` 函數物件綁定了擁有者物件 `{ firstName: "Steven", lastName : "Rogers" }` 。
* 一樣透過簡單呼叫的形式去呼叫 `introIronMan()` 和 `introCaptainAmerica()`，函數內的 `this` 值會是各自當初綁定的物件 (而非 Global 物件)。


#### 4.2. 嚴謹模式下有同樣的行為

```js
"use strict";

var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var firstName = "One", lastName = "Jar";
var introIronMan = getFullName.bind( { firstName: "Tony", lastName : "Stark" } );
var introCaptainAmerica = getFullName.bind( { firstName: "Steven", lastName : "Rogers" } );

console.log(getFullName());          // TypeError: Cannot read property 'firstName' of undefined
console.log(introIronMan());         // "Tony Stark"
console.log(introCaptainAmerica());  // "Steven Rogers"
```

* 上面執行 `getFullName()` 時，因為是嚴謹模式，`this` 不再預設綁定 Global 物件，因此是 `undefined` (2.1 節情境)。
*  `introIronMan()` 和 `introCaptainAmerica()` 不受影響。


#### 4.3. Binding 就像山盟海誓，只有第一次有效

![](https://i.imgur.com/v6ScbGj.png)  
(Source: [網路圖片](https://www.liidda.com.tw/humanity-feelings-images/pic01.jpg))

需要注意的是，**對一個函數物件來說，只有第一次的 Binding 動作有效**。

透過 `Function.prototype.bind` 所建立的新函數物件 A，如果企圖用 `Function.prototype.bind` 再去建立一個新函數物件 B 並綁定新擁有者，因為函數物件 B 繼承了 A 的 prototype，包含當初的綁定者，因此無論是否給予新的綁定對象都沒有用。

但**第二次綁定的當下並不會拋錯，只是沒有效果**，即使在嚴謹模式下也不會 (感覺這也是嚴謹模式的遺珠)。

```js
"use strict";

var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var introIronMan = getFullName.bind( { firstName: "Tony", lastName : "Stark" } );
var introClone = introIronMan.bind();
var introSpiderMan = introIronMan.bind( { firstName: "Peter", lastName : "Parker"} );

console.log(introClone());        // "Tony Stark"
console.log(introSpiderMan());    // "Tony Stark"
```

## References
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](http://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
