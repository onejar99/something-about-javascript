# 你不可不知的 JavaScript 二三事#Day18：this 關鍵字 (4)

## 函數執行環境下 (Function Context) (續)

### 7. 回呼函數 (Callback Function) 裡的 this

> `this` 物件：視乎怎麼呼叫 Callback Function。

JavaScript 裡常會需要用到 Callback Function，將某個函數物件 A 當作參數傳進另一個函數 B，由函數 B 決定執行 A 的時機。

這時候就要注意函數 B 是如何去呼叫函數 A，否則函數 A —— 也就是 Callback Function —— 裡面的 `this`，很可能不是你所預期的對象。

#### 7.1. 簡單呼叫 Callback Function (一般模式)

今天我有一個 `hero` 物件，存在一些屬性，例如 `name`，我想透過 Callback 的方式去控制 `hero` 物件，我只在 `hero` 物件裡實作一個 `act()`，負責執行 Callback Function。而 Callback Function 的內容由其他人提供。例如以下：

```js
var name = "Hi I am Global";

function sayHi(){
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act: function(cbk){
    return cbk();
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act(sayHi) );   // Hi I am Global
```

* `hero.act(sayHi)` 就是一個 callback 的用法，`sayHi` 就是 callback function。
* 在 `hero.act()` 裡，採用**簡單呼叫的方式**來執行 callback function。
* 根據昨天介紹的「 2.簡易呼叫 (Simple Call) 」，函數裡的 `this` 會是 Global 物件，所以 `hero.act(sayHi)` 回傳的結果是 Global 變數的 `name`。


#### 7.2. 簡單呼叫 Callback Function (嚴謹模式)

```js
"use strict";

var name = "Hi I am Global";

function sayHi(){
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act: function(cbk){
    return cbk();
  }
};

console.log( sayHi() );           // TypeError: Cannot read property 'name' of undefined
console.log( hero.act(sayHi) );   // TypeError: Cannot read property 'name' of undefined
```

 * 如果在嚴謹模式下，透過簡單呼叫，函數裡 `this` 會是 `undefined`，無法執行 `this.name`，會發生錯誤。

但上述的範例，我想達到的效果是 `hero.act(sayHi)` 可以回傳物件 `hero` 自己的 `name` 值，我該怎麼做？


#### 7.3. 用 apply() / call() 將物件本身傳入 Callback Function

如果想把物件本身帶入 Callback Function 裡的 `this`，就要用 `apply()` / `call()`。

```js
var name = "Hi I am Global";

function sayHi(){
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act: function(cbk){
    return cbk.apply(this); // 將物件本身傳入 Callback Function
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act(sayHi) );   // Hi I am a Hero
```


## 總結 this

### 要判斷 this 是誰，就看是誰呼叫

`this` 出現的位置有可能在：
* 全域執行環境下 (Global Context)
* 函數執行環境下 (Function Context)

但全域執行環境下 (Global Context) 遇到的機率相對低，而且十分單純，`this` 就是 Global 物件本身。

比較容易發生問題的是函數執行環境 (Function Context)，遇到的情境可能千變萬化，過程可能讓人很混淆。

記得一個大原則：**看呼叫時的物件是誰**。

**JavaScript 的 `this` 不是看定義的語彙位置，而是根據執行當下誰擁有這段程式碼，也就是看誰呼叫的**。

但要注意的是，簡單呼叫 (Simple Call) 的情形下，一般模式和嚴謹模式會有不同的行為。


### 函數執行環境下，判斷 this 的公式秘笈

所有人都知道，寫程式就像學數學一樣，不建議背誦，而是去理解背後原理 (話說回來，比樂透可能性還多的語法組合，企圖用背的也很不科學)。

但當你確定你已經理解原理之後，我不反對用一些類似口訣或公式筆記的方式來輔助記憶，幫助快速回憶。畢竟如果每次寫程式要用到時，都從頭推導，那效率是不現實的。

曾有人做過實驗，讓大學數學教授和高中生一起做同一份高中數學考券，結果高中生輕輕鬆鬆在時間內完成，數學教授卻沒有寫完。是因為數學教授的程度比高中生差嗎？

當然不是。

數學教授每一個題目都知道背後原理，給他足夠的時間推導，他每一題都能完美解答。但考試時間是有限的，對那些高中生來說，這些題目範圍是他們非常熟悉，幾乎看到題目腦海就浮現解法。這代表那些高中生不理解背後原理嗎？不，他們也是經過理解的過程學到這些題目的解法，但為了應付嚴峻的考試，他們用各種方法來加速遇到題目的解決速度，例如解題口訣、公式表。

現實中的專案開發也有同樣情境。專案開發通常有時程限制，為了減少每次回憶的時間，相信很多工程師都有自己的私藏筆記，這些筆記就是你理解的精華，用來幫助自己快速回想，或減少從頭推導的時間。


前面舉了非常多情境，整體歸納下來，大致上不出以下公式的範圍：

| 呼叫方式              | 模式    |  this 所指的物件                                    |
| -------------------- | ------ | ------------------------------------------------ |
| obj.method()         | 不限    | 該 obj 物件                                       |
| function()           | 一般模式 | Global 物件                                       |
| function()           | 嚴謹模式 | `undefined`                                        |
| 透過 apply() 或 call() | 不限    | 第一個參數的物件 (若第一個參數是 `null`，則視同「function()」) |

* 以上指的都是未經 `bind()` 綁定而來的函數物件
* 透過 `bind()` 產生的函數，不管呼叫方式為何，`this` 都指向當初 `bind()` 所綁定的物件。



### 小補充：`this` 不是變數

這一點我想大家都清楚，只是作為 `this` 介紹完整性的一個小補充。

正如最一開始所說，`this` 是一個關鍵字，不是變數，所以不能改變 this 的值，例如企圖這樣：

```js
this = { name: "OneJar" };
```


## References
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](http://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
