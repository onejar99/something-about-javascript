# 你不可不知的 JavaScript 二三事#Day11：Strict Mode (嚴謹模式)

JavaScript 在語法的限制上很寬容，這是它容易上手的優點，不會在學習初期就用一堆語法規則打擊你。

但方便和安全永遠是一體兩面。

就像機場安檢，如果太過嚴格，很安全，但旅客會覺得擾民；如果太寬鬆，旅客方便，恐怖份子也容易出現。

Bug 就是程式裡的恐怖份子。

![](https://i.imgur.com/IGsOxho.png)
(Source: [網路](https://cw1.tw/CW/images/article/C1465977854096.jpg))

JavaScript 語法限制寬鬆，也是它容易產生 Bug 的原罪。

例如未宣告的變數也能使用、使用寫在宣告之前也能被允許 (Day10 文章介紹的 Hoisting 效果)，這些行為其實很常是程式編寫時不小心打錯變數名稱，但 JavaScript 都會很寬容的對待，有時是用其他預設行為來處理，有時是視而不見，而不會拋錯，這對工程師 Debugging 來說並不理想。

難道 JavaScript 不想改善？

有的，就是今天文章要介紹的 **Strict Mode (嚴謹模式)**。




## 什麼是嚴謹模式 (Strict Mode)

嚴謹模式是 ECMAScript 5 新支援的功能，提供開發者語法嚴格、語法受限的模式。

你可以**透過指令 (Directive) 宣告，選擇要讓你的程式在嚴謹模式下執行**。

如果選擇嚴謹模式，很多原本被接受執行的不良語法行為，會變成拋錯。

例如使用未宣告的變數名稱，原本能正常執行：

```js
x = 123;
console.log(x);     // 123
```

如果在嚴謹模式執行，會拋出錯誤：

```js
"use strict";
x = 123;            // ReferenceError: x is not defined
console.log(x);
```



## 如何使用嚴謹模式

### 透過`"use strict"` 指令宣告

使用嚴謹模式的方法很簡單：**在程式一開始宣告 `"use strict"` 即可**。

例如：

```js
"use strict";
x = 123;            // ReferenceError: x is not defined
console.log(x);
```

要注意的是，**`"use strict"` 宣告位置必須在主程式或函數的開頭**，才會被辨識為嚴謹模式。

例如以下的 `"use strict"` 並不會生效：

```js
x = 123;
"use strict";
console.log(x);     // 123
```

### "use strict" 的作用範圍 (Scope)

作用範圍會依宣告位置分為兩種：
1. **宣告在主程式開頭**：Global Scope，所有的程式都會在嚴謹模式下執行。
2. **宣告在函數開頭**：Function Scope，只有該函數內的程式會在嚴謹模式下執行。

以下是 Global Scope 的舉例：

```js
"use strict";
myFunc();

function myFunc() {
    y = 3.14;   // ReferenceError: y is not defined
}
```

以下是 Function Scope 的舉例：


```js
x = 3.14;       // 啦啦啦~ 我不會拋錯
myFunc();

function myFunc() {
   "use strict";
    y = 3.14;   // ReferenceError: y is not defined
}
```




## 瀏覽器對嚴謹模式的支援性

嚴謹模式是 ES5 新增加的功能，除了一些比較老舊的瀏覽器，現代瀏覽器 (modern browsers) 大多可以支援。

> IE9 及以下版本不支援。

那遇到不支援的瀏覽器怎麼辦？會因為不認得 `"use strict"` 而造成整個程式掛掉？

不用擔心，即使是不支援的瀏覽器，只會忽略 `"use strict"` 用一般模式執行，而不會掛掉。

為什麼呢？

> W3Schools:
> It is not a statement, but a literal expression, ignored by earlier versions of JavaScript.

這是在設計上，為了能夠相容於舊版瀏覽器的一個小巧思。

**`"use strict"` 本質只是一個字串，而不是關鍵字或描述句**。

例如在正常的 JavaScript 程式中，本來就可以接受一個數字實字 (numeric literal) 或字串實字 (string literal) 單獨存在：

```js
console.log("JS here");     // "JS here"
3 + 4;                      // (a numeric literal)
"Hello";                    // (a string literal)
```

對 JavaScript 來說，這些值一度產生，但因為沒有被存放到任何變數內，很快就消滅，對程式不會有任何影響 (side effects)。

所以不認得 `"use strict"` 的瀏覽器也只會把 `"use strict"` 當成一個普通的字串實字，不會造成錯誤。





## 既有程式切換到嚴謹模式必須注意

值得注意的是，同樣的語法在嚴謹模式和一般模式下執行，不僅是拋不拋錯的差別，甚至有些程式行為也不一樣。

如果維護的舊程式本來是在非嚴謹模式下執行測試正常，切換到嚴謹模式後可能有些程式會因為行為不同而導致非預期的結果。

想做這樣的切換，建議配合完整的測試來確保程式運作無虞。




## 為什麼要使用嚴謹模式

使用嚴謹模式貌似給自己找麻煩，讓語法的限制變多，到底有什麼好處？

引用 W3Schools 的一句話：
> Strict mode changes previously accepted "bad syntax" into real errors.

**嚴謹模式下，「不適當的寫法」會從原本被默默接受，轉變成拋出實際錯誤。**

拋錯是 Debugging 非常重要的一環，透過拋出錯誤的訊息，可以加快開發者發現 Bug 和診斷 Bug。

但在一般模式的 JavaScript 下，很多不當或不合邏輯的寫法，JavaScript 沒有給予任何錯誤回饋 (Error Feedback)，容易造成潛在 Bug 或 Debugging 的困難。

例如在一般模式下賦值給不可寫入 (non-writable) 的物件屬性 (property)，雖然不會寫入成功，但也不會拋出錯誤提醒，對程式碼的維護也是種干擾。


## 簡單來說，嚴謹模式的好處在於
* 更容易寫出安全、不易出錯的 JavaScript 程式 ("secure" JavaScript)。
* 幫助你的程式碼更乾淨。




## References
* [W3Schools - JavaScript Use Strict](https://www.w3schools.com/js/js_strict.asp)
* [Strict mode - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
