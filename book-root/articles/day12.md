# 你不可不知的 JavaScript 二三事#Day12：看 Strict Mode 如何施展「還我漂亮拳」(1)

Day11 的文章介紹 JavaScript 中的嚴謹模式 (Strict Mode) 是什麼、如何使用、為什麼要用，並舉了簡單的例子來示範。

嚴謹模式 (Strict Mode) 就像 JavaScript 中的「還我漂亮拳」，能夠讓原本不夠嚴謹、造成混亂的語法，變得更安全、乾淨。

![](https://i.imgur.com/WqfhHab.jpg)  
(Source: [網路](https://scontent-ort2-1.cdninstagram.com/vp/9bcf3c4d8ed64dd8b5b9ea403dc62d16/5C630A48/t51.2885-15/e35/s480x480/31384596_175641703266886_1657800957565599744_n.jpg))

「不允許使用未宣告的變數」只是嚴謹模式最簡單的應用，事實上嚴謹模式發揮的地方非常多。

接下來會用各種例子來檢視嚴謹模式使用前和使用後的效果。

## 嚴謹模式下你不能做的事

### 1. 不能使用未宣告的變數

* 強化變數的控管，快速發現打錯變數名稱的 Bug。
* 避免不小心產生不必要的 Global 變數 (賦值給尚未宣告的變數，JavaScript 預設行為會產生 Global 變數)。

> 錯誤類型：`ReferenceError: x is not defined`

使用前：

```js
x = 3.14;
console.log(x);     // 3.14
```

使用後：

```js
"use strict";
x = 3.14;           // ReferenceError: x is not defined
console.log(x);
```


### 2. 不能刪除變數或函數

* 不能對變數或函數使用 `delete` 運算子 (原本對變數或函數作刪除並不會有效果，但也不會拋錯，等於無用的廢 code)
* 但還是可以對物件屬性或陣列元素使用。

> 錯誤類型：`SyntaxError: Delete of an unqualified identifier in strict mode`

使用前：

```js
// variable (沒有作用)
var x = 3.14;
console.log( delete x );                    // false
console.log(x);                             // 3.14

// function via declararion (沒有作用)
function f1(){ console.log('Hi 1'); }
console.log( delete f1 );                   // false
console.log(f1);                            // ƒ f1(){ console.log('Hi 1'); }

// function via expression (沒有作用)
var f2 = function() { console.log('Hi 2'); }
console.log( delete f2 );                   // false
console.log(f2);                            // ƒ () { console.log('Hi 2'); }

// array element
var fruits = ["Banana", "Orange", "Apple", "Mango"];
console.log( delete fruits[2] );            // true
console.log(fruits);                        // ["Banana", "Orange", empty, "Mango"]

// object property
var person = {name: 'John', age:18};
console.log( delete person.name );          // true
console.log(person);                        // {age: 18}
```

使用後：

```js
"use strict";

// variable
var x = 3.14;
console.log( delete x );                    // SyntaxError: Delete of an unqualified identifier in strict mode.

// function via declararion
function f1(){ console.log('Hi 1'); }
console.log( delete f1 );                   // SyntaxError: Delete of an unqualified identifier in strict mode.

// function via expression
var f2 = function() { console.log('Hi 2'); }
console.log( delete f2 );                   // SyntaxError: Delete of an unqualified identifier in strict mode.

// array element
var fruits = ["Banana", "Orange", "Apple", "Mango"];
console.log( delete fruits[2] );            // true
console.log(fruits);                        // ["Banana", "Orange", empty, "Mango"]

// object property
var person = {name: 'John', age:18};
console.log( delete person.name );          // true
console.log(person);                        // {age: 18}
```


### 3. 函數的參數名稱不能重複

* 一般模式下，函數的參數名稱如果不慎重複，不會有提醒。

> 錯誤類型：`SyntaxError: Duplicate parameter name not allowed in this context`

使用前：

```js
function myFunc(p1, p1){
    console.log(p1);
};

myFunc(10, 20); // 20
```

使用後：

```js
"use strict";

function myFunc(p1, p1){    // `SyntaxError: Duplicate parameter name not allowed in this context`
    console.log(p1);
};
```



### 4. 不能使用八進制的數字實字 (Octal numeric literals)

* 某些版本的 JavaScript 中，如果數字前頭帶 `0`，會被直譯為八進制。
* 例如：`var x = 010;` 等於十進制的 `8`。
* 一般 JavaScript 實作規範中就強烈建議不要對數字開頭帶 `0` (但一般模式下仍可被 JavaScript 直譯器接受)。
* 嚴謹模式會直接對這樣的語法拋錯。

> 錯誤類型：`SyntaxError: Octal literals are not allowed in strict mode`

使用前：

```js
var n = 010;
console.log(n);     // 8
```

使用後：

```js
"use strict";

var n = 010;        // SyntaxError: Octal literals are not allowed in strict mode.
console.log(n);
```




### 5. 不能使用八進制的跳脫字元 (Octal escape characters)

* 例如：`var x = "\010";`。

> 註：我個人沒用過這個用法，實際上印出來也只看得到空字串，不知道可以應用在哪。

> 錯誤類型：`SyntaxError: Delete of an unqualified identifier in strict mode.`

使用前：

```js
var n = "\010";
console.log(n);     // ""
```

使用後：

```js
"use strict";

var n = "\010";     // SyntaxError: Octal escape sequences are not allowed in strict mode.
console.log(n);
```



### 6. 不能對唯讀的物件屬性作寫入 (write to a read-only property of objects)

* 在定義物件屬性時，可以設定是否可寫入 (writable)。
* 一般模式下，如果對 `writable:false` 的屬性作賦值動作，不會寫入成功，但也不會報錯 (等於廢 code)。
* 嚴謹模式下會直接拋錯。

> 錯誤類型：`TypeError: Cannot assign to read only property 'articleTarget' of object '#<Object>'`

使用前：

```js
var player = {};
Object.defineProperty(player, "nickname", {value:"OneJar", writable:true});
Object.defineProperty(player, "articleTarget", {value:30, writable:false});
console.log(player);            // {nickname: "OneJar", articleTarget: 30}

player.articleTarget = 100;
console.log(player);            // {nickname: "OneJar", articleTarget: 30}
```

使用後：

```js
"use strict";

var player = {};
Object.defineProperty(player, "nickname", {value:"OneJar", writable:true});
Object.defineProperty(player, "articleTarget", {value:30, writable:false});
console.log(player);            // {nickname: "OneJar", articleTarget: 30}

player.articleTarget = 100;     // TypeError: Cannot assign to read only property 'articleTarget' of object '#<Object>'
console.log(player);
```



### 7. 不能對 get-only 的物件屬性作寫入

* 一般模式下，如果對只有 getter 的屬性作賦值動作，不會寫入成功，但也不會報錯 (等於廢 code)。
* 嚴謹模式下會直接拋錯。

> 錯誤類型：`TypeError: Cannot set property age of #<Object> which has only a getter`

使用前：

```js
var person = {get age() {return 18} };
console.log(person);                    // {}
console.log(person.age);                // 18
person.age = 70;
console.log(person.age);                // 18
```

使用後：

```js
"use strict";

var person = {get age() {return 18} };
console.log(person);                    // {}
console.log(person.age);                // 18
person.age = 70;                        // TypeError: Cannot set property age of #<Object> which has only a getter
console.log(person.age);
```



## References
* [W3Schools - JavaScript Use Strict](https://www.w3schools.com/js/js_strict.asp)
* [Strict mode - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
