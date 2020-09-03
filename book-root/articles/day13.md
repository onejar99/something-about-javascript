# 你不可不知的 JavaScript 二三事#Day13：看 Strict Mode 如何施展「還我漂亮拳」(2)

## 嚴謹模式下你不能做的事 (續)

### 8. 不能對不可刪除的屬性 (undeletable properties) 使用 `delete` 運算子

* 一般模式下，`delete` 會回傳 `false`，但語法本身仍可以被接受。
* 嚴謹模式下會直接拋錯。

> 錯誤類型：`TypeError: Cannot delete property 'prototype' of function Object() { [native code] }`

使用前：

```js
console.log( delete Object.prototype ); // false
```

使用後：

```js
"use strict";

console.log( delete Object.prototype ); // TypeError: Cannot delete property 'prototype' of function Object() { [native code] }
```

### 9. 不能使用 `eval` 或 `arguments` 作為變數名稱

* `eval` 和 `arguments` 是 JavaScript 的關鍵字，各自另有用途，拿來作變數名稱容易導致非預期的結果。

> 錯誤類型：`SyntaxError: Unexpected eval or arguments in strict mode`

使用前：

```js
function myFunc(){
    return arguments;
}

var arguments = 1500;
console.log(arguments);         // 1500
console.log(myFunc(1, 2, 3));   // Arguments Object [1, 2, 3]
```

使用後：

```js
"use strict";

function myFunc(){
    return arguments;
}

var arguments = 1500;           // SyntaxError: Unexpected eval or arguments in strict mode
console.log(arguments);
console.log(myFunc(1, 2, 3));
```


### 10. 不能使用未來的保留字做變數名稱 (cannot use future reserved keywords as variables)

* 有些字眼可能還不是當前 JavaScript 版本支援的關鍵字，但根據程式語言發展的經驗，有些字眼被預期很有機會在未來成為實際有作用的關鍵字。
* 例如 `interface`、`public`、`private`、`package` 等，在其他程式語言都是很重要也很普遍的關鍵字。
* 考慮到既有程式對未來 JavaScript 新版本的移植性 (portable)，這些字眼就不適合用來作為變數名稱。
* 以下是 W3Schools 列出的未來保留字，有些在 ES6 等後續版本已經成真：
    * implements
    * interface
    * let
    * package
    * private
    * protected
    * public
    * static
    * yield

> 錯誤類型：`TypeError: Cannot assign to read only property 'articleTarget' of object '#<Object>'`

使用前：

```js
var public = 1500;
console.log(public);    // 1500
```

使用後：

```js
"use strict";
var public = 1500;      // SyntaxError: Unexpected strict mode reserved word
console.log(public);
```



### 11. 用 `eval()` 宣告的變數或函數，不能在該 Scope 被語法呼叫使用

* W3Schools 的原文是：For security reasons, eval() is not allowed to create variables in the scope from which it was called.
* 但嚴格來說，並不是 `eval()` 宣告的時候拋錯，而是後續想使用的時候拋錯，而且拋出的錯誤類型是 `ReferenceError`。
* 此外，如果是在 `eval()` 內自己宣告自己使用也沒有問題，後續想用語法去呼叫使用才會拋錯。
* 所以這邊我的理解是：
    * **在嚴謹模式下，`eval()` 所執行的語法會自成一個暫時的 Scope**，在裡面宣告的變數或函數都只屬於這個 Scope。
    * 所以後續用語法呼叫時，不認得該變數或函數，因而拋出 `ReferenceError` 類型的錯誤。

> 錯誤類型：`ReferenceError: x is not defined`

使用前(用於變數)：

```js
eval("var x = 123");
console.log(x);         // 123
```

使用後(用於變數)：

```js
"use strict";

eval("var x = 123");
console.log(x);         // ReferenceError: x is not defined
```

嚴謹模式下，在 `eval()` 內自己宣告自己使用並沒有問題：

```js
"use strict";

var ret = 0;
eval("var n1 = 3, n2 = 6; ret = n1 + n2;");
console.log(ret);   // 9
console.log(n1);    // ReferenceError: n1 is not defined
```

使用前(用於函數)：

```js
eval("function myFunc(){ var x = 123; console.log(x); } myFunc();");
myFunc();
```
```
123
123
```

使用後(用於函數)：

```js
"use strict";

eval("function myFunc(){ var x = 123; console.log(x); } myFunc();");
myFunc();
```
```
123
ReferenceError: myFunc is not defined
```




### 12. 不能使用 `with` 語法

* 完全禁止 `with` 語法。

> 錯誤類型：`SyntaxError: Strict mode code may not include a with statement`

使用前：

```js
var x, y;
with (Math){
    x = cos(3 * PI) + sin(LN10);
    y = tan(14 * E);
};
console.log(x); // -0.2560196630425069
console.log(y); // 0.37279230719931067
```

使用後：

```js
"use strict";

var x, y;
with (Math){   // SyntaxError: Strict mode code may not include a with statement
    x = cos(3 * PI) + sin(LN10);
    y = tan(14 * E);
};
console.log(x);
console.log(y);
```




### 13. 全域執行環境內的函數，裡面的 `this` 代表的物件不一樣

* 一般模式下，全域執行環境內的函數裡面的 `this`，指的是 Global Object。
* 嚴謹模式下，全域執行環境內的函數裡面的 `this`，變成 `undefined`。

使用前：

```js
function myFunc(){
    console.log(this === window); // true
}
myFunc();
```

使用後：

```js
"use strict";
function myFunc(){
    console.log(this === window); // false (`this` is `undefined`)
}
myFunc();
```



## 嚴謹模式下你還是能……

![](https://i.imgur.com/21mdrMB.jpg)  
(Source: [網路](https://puui.qpic.cn/qqvideo_ori/0/l07381q86of_496_280/0))

嚴謹模式下增加了很多規範，目的是讓程式更安全。

不過也不是盡善盡美，還是有遺珠。

### 1. 還是可以重複宣告變數

* 這是一個很基本的不良語法，不過嚴謹模式並沒有加以控管。

```js
"use strict";

var x = 10;
var x = 20;
console.log(x);     // 20
```

這部分會建議使用前面文章介紹過的 `let` 或 `const` 來取代 `var`，就可以限制變數重複宣告。


## 總結

嚴謹模式的使用情境相信還有很多，無法在幾篇文章的篇幅內全數囊括。但希望透過這三篇文章的介紹，能對嚴謹模式有一定深度的了解。

當專案規模越來越大，嚴謹的開發模式和程式撰寫方式才能讓專案更容易被多人維護，使用嚴謹模式是個必然的趨勢。

事實上可以注意到，著名的 JavaScript 編譯器 Babel 在將新版 ECMAScript 轉譯成 ES5 時，在你還沒打任何程式碼之前，ES5 的那一欄已經預設好一行程式，就是 `use strict`！

![](https://i.imgur.com/3B5o5VH.png)  
(Source: [Babel REPL](https://babeljs.io/repl))


## References
* [W3Schools - JavaScript Use Strict](https://www.w3schools.com/js/js_strict.asp)
* [Strict mode - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
* [with - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/with)
* [【转载】JavaScript中with、this用法小结](https://king39461.pixnet.net/blog/post/361793370-%E3%80%90%E8%BD%AC%E8%BD%BD%E3%80%91javascript%E4%B8%ADwith%E3%80%81this%E7%94%A8%E6%B3%95%E5%B0%8F%E7%BB%93)
* [[JavaScript] with的用法](https://stannotes.blogspot.com/2014/10/javascript-with.html)
* [Try it out - Babel · The compiler for next generation JavaScript](https://babeljs.io/repl)
