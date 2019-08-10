# 你不可不知的 JavaScript 二三事#Day10：程式也懂電梯向上？ —— Hoisting

有沒有注意過 JavaScript 裡一個神奇的現象？

比如以下程式：

```js
console.log(x);
```

執行結果：

```
Uncaught ReferenceError: x is not defined
```

![](https://i.imgur.com/zhRQGS8.png)
(Source: [白爛貓貼圖](https://store.line.me/stickershop/product/1265214/?ref=Desktop))

因為使用了根本不存在的變數 `x`，執行時拋出錯誤，非常合理。

為了彌補，我們趕快增加 `x` 的變數宣告：

```js
console.log(x);
var x = "OneJar";
```

你程式老師在你後面，他非常火。

![](https://i.imgur.com/8IUOmvs.png)
(Source: [Youtube](https://www.youtube.com/watch?v=RrzNpZcoaPs))

變數宣告當然是要在使用之前，補在後面有什麼用，一樣會先執行到拋錯的那一行。

執行結果：

```
undefined
```

![](https://i.imgur.com/IAgBBAs.png)
(Source: [白爛貓貼圖](https://store.line.me/stickershop/product/4337259/?ref=Desktop))

Why？為什麼宣告在使用之後不會拋錯？而且印了個莫名的答案。

我知道了。

![](https://i.imgur.com/Lb9iqZ9.jpg)
(Source: [網路](http://farm9.static.flickr.com/8716/28345276131_48339620bf_o.jpg))

喂，冷靜。

程式不會變魔術，一定有理可循。

其實背後的原因，就是今天文章要介紹的 **Hoisting**。




## JavaScript 裡的文章置頂效果 —— Hoisting

Hoisting 這個術語在 [MDN](https://developer.mozilla.org/zh-TW/docs/Glossary/Hoisting) 裡翻譯為「提升」，但我覺得這個名詞太抽象，概念上不易理解。

我個人偏好翻成「**宣告置頂**」。

就像生活中網路論壇常見的置頂文章，當一些文章被設定為置頂文，無論你進入討論版的下一步想做什麼，這些置頂文都會優先被看到。

Hoisting 的效果非常類似這樣的概念。



## Hoisting 置頂了宣告的效果

以下是 W3Schools 裡的介紹：
> Hoisting is JavaScript's default behavior of moving all declarations to the top of the current scope.

Hoisting 是 JavaScript 的預設行為，**把所有宣告效果提到當前 Scope 的頂端**。

也就是說，在正式執行程式之前，JavaScript 會先偷跑一個動作——把程式碼中宣告的部分提前到所屬 Scope 的頂端。



## 變數宣告的 Hoisting 效果 (透過 `var` 關鍵字)

例如文章開頭舉的例子：

```js
console.log(x);
var x = "OneJar";
```

運作上等同於：

```js
var x;
console.log(x);
x = "OneJar";
```

這就是為什麼 JavaScript 變數可以在宣告之前就使用，而不會拋錯。

但我的程式碼明明是 `var x = "OneJar";`，宣告同時就給予初始值，為何印出來的結果是 `undefined` 而非 `"OneJar"`？



## 變數的 Hoisting 效果只有「宣告」的部分，不包含「初始化」(Initializations)

再引用 W3Schools 裡的原文：
> JavaScript Initializations are Not Hoisted.

也就是說，只有宣告的部分會被提升。

這個觀念不那麼直觀，因為不是以一整行的程式碼來看，而是單獨抽出了程式碼中「宣告」的部分。

以 `var x = "OneJar";` 這行程式來說，裡面包含 2 個動作：
1. `var x`：宣告一個變數名叫 `x`。
2. `x = "OneJar"`：將賦值給變數 `x` (撰寫時將宣告和賦值寫在同一行，這個動作也稱為「初始化」)。

**Hoisting 的效果只涵蓋動作 1，不涵蓋動作 2。**


所以這段程式：

```js
console.log(x);
var x = "OneJar";
```

經過 Hoisting 後等同於：

```js
var x;
console.log(x);
x = "OneJar";
```

而非：

```js
var x = "OneJar";
console.log(x);
```


## 函數也有 Hoisting 效果 (透過 `function` 關鍵字)

以下這種寫法一定不陌生：

```js
sayHi();

function sayHi(){
	console.log('Hi');
}
```

執行結果：

```
Hi
```

是否曾經覺得奇怪，為什麼函數 `sayHi()` 宣告定義在後面，卻可以提前呼叫？

這也是 Hoisting 效果。

使用 `function` 關鍵字去宣告函數，整個函數定義都會被提到 Scope 最前面。

```js
function sayHi(){
	console.log('Hi');
}

sayHi();
```


## 透過變數方式宣告的函數，Hoisting 效果比照變數

定義函數除了直接使用 `function` 做宣告和定義，也允許用「`var` 變數宣告 + `function` 函數定義」的寫法。

但需要注意的是，就像前面提到：Hoisting 效果只有「宣告」的部分，不包含「初始化」。

例如以下例子：

```js
console.log( sayHi );
console.log( sayHi() );

var sayHi = function(){
  return "Hi";
};
```

執行結果：

```
undefined
Uncaught TypeError: sayHi is not a function
```

被提升的只有「`var` 變數宣告」的部分，「`function` 函數定義」的部分仍在原本的位置。

運作上的效果就像以下程式碼：

```js
var sayHi;

console.log( sayHi );
console.log( sayHi() );

sayHi = function(){
  return "Hi";
};
```



## 使用 `let` 或 `const` 宣告的變數不具備 Hoisting 效果

W3Schools:
> Variables and constants declared with let or const are not hoisted!

Day8 文章介紹到 ES6 導入新的變數宣告關鍵字：`let` 和 `const`。

需要注意到，這兩個關鍵字所宣告的變數不會有 Hoisting 效果。

```js
console.log(x);
let x = "OneJar";
```

執行結果：

```
Uncaught ReferenceError: x is not defined
```


### 補充：真相是 `let` 和 `const` 其實也有 Hoisting

感謝邦友 [Caesar](https://ithelp.ithome.com.tw/users/20113117/profile) 提供一篇文章——[我知道你懂 hoisting，可是你了解到多深？](https://blog.techbridge.cc/2018/11/10/javascript-hoisting/?fbclid=IwAR1bZBRYodHNbq3Xo22HsnRoR-uiJEfnXFJmtdR1fKGAutaTqh8FOCQmONo)，才了解其實 `let` 和 `const` 有 hoisting，只是行為不一樣。

例如以下範例：

```js
let x = "OneJar";

function test(){
  console.log(x);
  let x;
}
test();
```

如果沒有 hoisting，理論上應該會根據 Scope Chain 找到外面的 `x`，印出 `"OneJar"`。

但實際上的執行結果：

```
Uncaught ReferenceError: x is not defined
```

原因簡單來說，節錄文章的一句話：

> let 與 const 也有 hoisting 但沒有初始化為 undefined，而且在賦值之前試圖取值會發生錯誤。

文章作者花了很多篇幅講解 hoisting 背後的運作原理，方知小小的 hoisting 觀念要深入，細節也是無窮無盡。



## 總結 Hoisting

Hoisting 效果包含:
1. 使用 `var` 的變數宣告。
2. 使用 `function` 宣告的函數與其定義。

Hoisting 效果不包含:
1. 初始化的部分 (Initializations)，例如變數初始值或使用 `var` 宣告的函數定義。
2. ~~使用 `let` 或 `const` 的變數宣告。~~ (實際上有，但行為和 `var` 不一樣)


## References
* [提升（Hoisting） - 術語表| MDN](https://developer.mozilla.org/zh-TW/docs/Glossary/Hoisting)
* [W3Schools - JavaScript Hoisting](https://www.w3schools.com/js/js_hoisting.asp)
* [我知道你懂 hoisting，可是你了解到多深？](https://blog.techbridge.cc/2018/11/10/javascript-hoisting/?fbclid=IwAR1bZBRYodHNbq3Xo22HsnRoR-uiJEfnXFJmtdR1fKGAutaTqh8FOCQmONo)
