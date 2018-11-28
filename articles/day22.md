# 你不可不知的 JavaScript 二三事#Day22：箭頭函數 (Arrow Functions) 的 this 和你想的不一樣 (2)

## 3. 顯性函數綁定 (Explicit Function Binding)

### 3.1. Function.prototype.bind() 篇

#### 傳統函數

`Function.prototype.bind()` 可以為一個函數建立新函數物件，新函數物件會繼承原函數的 prototype，同時任意綁定一個固定的擁有者。

因此以下例子中的 `introIronMan()` 和 `introCaptainAmerica()` 雖然呼叫形式上是簡單呼叫，`this` 會指向自己的綁定物件，而非指到 Global 物件。

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

#### Arrow Functions

就像前面一再強調，**Arrow Functions 的 `this` 判斷看的是語彙位置**，因此 `Function.prototype.bind()` 的 Binding 不會發生作用，同樣只會沿用外層的 `this` 物件。

這個例子裡，`getFullName()` 往外一層是 Global Context，不管在一般模式或嚴謹模式，`this` 都是 Global 物件：

```js
var getFullName = () => {
    return this.firstName + " " + this.lastName;
}

var firstName = "One", lastName = "Jar";
var introIronMan = getFullName.bind( { firstName: "Tony", lastName : "Stark" } );
var introCaptainAmerica = getFullName.bind( { firstName: "Steven", lastName : "Rogers" } );

console.log(getFullName());           // "One Jar"
console.log(introIronMan());          // "One Jar"
console.log(introCaptainAmerica());   // "One Jar"
```


### 3.2. Function.prototype.apply() / Function.prototype.call() 篇

#### 傳統函數

透過 `apply()` / `call()` 執行某個函數物件，同時指定一個物件作為 `this`，然後回傳函數的執行結果：

```js
var whatsThis = function() {
    return this;
};
var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var ironMan = { firstName: "Tony", lastName : "Stark" };
var captainAmerica = { firstName: "Steven", lastName : "Rogers" };

console.log(whatsThis.apply(ironMan) === ironMan);                // true
console.log(getFullName.apply(ironMan));               // "Tony Stark"
console.log(whatsThis.apply(captainAmerica) === captainAmerica);  // true
console.log(getFullName.apply(captainAmerica));        // "Steven Rogers"
```

#### Arrow Functions

就像 `Function.prototype.bind()` 的 Binding 不會發生作用，`apply()` 和 `call()` 也同樣無效。只會依照語彙位置來判定 `this` 物件。

這個例子裡的 `getFullName()` 和 `whatsThis()` 往外一層都是 Global Context，因此不管在一般模式或嚴謹模式，`this` 都是 Global 物件，而 Global 物件裡並沒有 `firstName` 和 `lastName` 變數，所以印出 `"undefined undefined"`：

```js
var whatsThis = () => {
    return this;
};
var getFullName = () => {
    return this.firstName + " " + this.lastName;
}

var ironMan = { firstName: "Tony", lastName : "Stark" };
var captainAmerica = { firstName: "Steven", lastName : "Rogers" };

console.log(whatsThis.apply(ironMan) === window);        // true
console.log(getFullName.apply(ironMan));          // "undefined undefined"
console.log(whatsThis.apply(captainAmerica) === window); // true
console.log(getFullName.apply(captainAmerica));   // "undefined undefined"
```


## 4. 函數作為建構子

#### 傳統函數

將函數當作建構子，透過 new 關鍵字來產生一個物件，該物件會形成自己的環境 (Context)，原本函數內的 `this.xxx` 變成新物件的屬性。例如以下範例：


```js
var Hero = function(n){
    this.exp = n;
};

var h = new Hero(100);
console.log(h);         // Hero {exp: 100}
console.log(h.exp);     // 100
```

#### Arrow Functions

Arrow Function 所宣告的函數不能拿來當建構子，也不存在 `this` 的問題。

```js
var Hero = (n) => {
    this.exp = n;
};

var h = new Hero(100); // TypeError: Hero is not a constructor
```



## 5. 回呼函數 (Callback Function) 裡的 this

### 5.1. 簡單呼叫 Callback Function

#### 傳統函數

我們會把某函數 A 當作參數傳入函數 B，函數 A 就是 Callback Function。

而傳統函數裡，Callback Function 裡的 `this` 是誰，視乎在函數 B 裡是怎麼呼叫函數 A。如果是最常見的「簡單呼叫」的形式，此時 `this` 在一般模式下就是 Global 物件，嚴謹模式則是 `undefined`：


```js
var name = "Hi I am Global";

var sayHi = function(){
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

#### Arrow Functions I

當函數 A (Callback Function) 是傳統函數，不管函數 B 是傳統函數 (`hero.act1()`) 還是箭頭函數 (`hero.act2()`)，因為 Callback Function 本身是傳統函數，裡面的 `this` 比照傳統函數的判斷方式，也就是看呼叫方式。

由於都是透過簡單呼叫，所以 `this` 在一般模式下是 Global 物件，嚴謹模式是 `undefined`：


```js
var name = "Hi I am Global";

var sayHi = function(){
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act1: function(cbk){
    return cbk();
  },
  act2: (cbk) => {	// arrow function
    return cbk();
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act1(sayHi) );  // Hi I am Global
console.log( hero.act2(sayHi) );  // Hi I am Global
```

#### Arrow Functions II

當函數 A (Callback Function) 是箭頭函數，不管函數 B 是哪一種函數，都是看 Callback Function 本身的語彙位置。

由於 `sayHi()` 沿用外層的 `this`，不管是一般模式或嚴謹模式，`this` 都是 Global 物件：

```js
var name = "Hi I am Global";

var sayHi = () => {	// arrow function
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act1: function(cbk){
    return cbk();
  },
  act2: (cbk) => {	// arrow function
    return cbk();
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act1(sayHi) );  // Hi I am Global
console.log( hero.act2(sayHi) );  // Hi I am Global
```


### 5.2. 用 apply() / call() 將物件本身傳入 Callback Function

#### 傳統函數

透過 `apply()` / `call()` 可以明確地控制函數裡的 `this` 物件是誰：

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


#### Arrow Functions I

當函數 A (Callback Function) `sayHi()` 是傳統函數時，受 `apply()` 效果影響：
* 當函數 B 也是傳統函數 (`hero.act1()`) ：`hero.act1()` 自己的 `this` 看呼叫者是誰，也就是 `hero`，所以 `apply()` 將 `hero` 綁定為 Callback Function 的 `this`，因此印出 `"Hi I am a Hero"`。
* 當函數 B 是 Arrow Function (`hero.act2()`) ：`hero.act2()` 自己的 `this` 沿用外層，也就是 Global 物件 (無論一般模式或嚴謹模式)；再透過 `apply()` 將 Global 物件綁定於 `sayHi()` 的 `this`，因此印出 `"Hi I am Global"`。


```js
var name = "Hi I am Global";

var sayHi = function(){
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act1: function(cbk){
    return cbk.apply(this); // 將物件本身傳入 Callback Function
  },
  act2: (cbk) => {	// arrow function
    return cbk.apply(this); // 將物件本身傳入 Callback Function
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act1(sayHi) );  // Hi I am a Hero
console.log( hero.act2(sayHi) );  // Hi I am Global
```

#### Arrow Functions II

由於 `apply()` / `call()` 的綁定效果對 Arrow Function 無效，如果函數 A (Callback Function) `sayHi()` 是 Arrow Function，無論函數 B 是傳統函數 (`hero.act1()`) 或者 Arrow Function (`hero.act2()`)，`sayHi()` 裡的 `this` 都是沿用外層，也就是 Global 物件 (無論一般模式或嚴謹模式)：

```js
var name = "Hi I am Global";

var sayHi = () => {	// arrow function
  return this.name;
}

var hero = {
  name: "Hi I am a Hero",
  act1: function(cbk){
    return cbk.apply(this); // 將物件本身傳入 Callback Function
  },
  act2: (cbk) => {	// arrow function
    return cbk.apply(this); // 將物件本身傳入 Callback Function
  }
};

console.log( sayHi() );           // Hi I am Global
console.log( hero.act1(sayHi) );  // Hi I am Global
console.log( hero.act2(sayHi) );  // Hi I am Global
```

> 可以注意到，同樣遇到 Callback Functions 的情境，傳統函數和箭頭函數的判斷原理可說是完全相反：
> * 傳統函數：看的是函數 B，也就是呼叫方怎麼呼叫函數 A。
> * 箭頭函數：看的是函數 A，也就是函數自身定義的語彙位置。


## 總結

### 一句話總結傳統函數和箭頭函數在 `this` 判斷上的差別

* 傳統函數：看呼叫時的物件是誰。
* 箭頭函數：看函數本身定義的語彙位置。


### 既然一句話就能講完，吃飽太閒看這麼多範例？

這兩篇文章不厭其煩的將一些情境的範例用 Arrow Function 走過一遍，十分囉嗦。

![](https://i.imgur.com/mxGyGFc.png)
(Source: [Youtube](https://www.youtube.com/watch?v=wPxXT0nB36I))

其實目的是希望**能不犯了「想當然耳」的毛病**。

前面一大堆情境程式碼，很多情境的差別可能很細微，之所以不厭其煩逐一走過，其實就像一種交叉驗證，反覆驗證歸納出來的規則是否有漏洞，確認真的能夠解釋每個範例的背後原理。

**在理解觀念時，很容易在腦海裡模模糊糊以為自己都懂了，殊不知有些細節並沒有真正理解清楚**。

事實上在寫這個系列文之前，很多觀念我以為我早就熟稔。結果將腦海中的理解化為具體文章的過程，才發現自己在一些細節並不如自以為的了解。

在前面介紹各種範例的過程可以發現，很多範例的 `this` 最後呈現結果雖然一樣，可能都是 Global 物件，但背後形成「`this` 是 Global 物件」的原因並不相同。

有時程式碼 99% 一樣，僅僅是定義時用傳統函數或箭頭函數的差別，就可以讓結果天差地遠。

**如果對於背後細節原理不加分辨，未來一旦換了不同的程式碼情境，很可能就判斷錯誤**。

就像看人家講解程式題目，常常覺得聽起來很容易，以為自己都懂了，一旦輪到自己上戰場，才發現很多細節並沒有理解清楚，換個情境就卡關。

要確保自己的理解沒有死角，最好的方法就是實地走過一次。

事實上可能遇到的程式情境太多了，有太多令人混淆之極的例子可以研究。

不厭其煩地對各種情境動手實作，就是學好程式的不二法門！



## References
* [W3Schools - ECMAScript 6 - JavaScript 6](https://www.w3schools.com/js/js_es6.asp)
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](http://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
* [[ES6] Javascript 開發者必須知道的 10 個新功能](https://medium.com/@peterchang_82818/es6-10-features-javascript-developer-must-know-98b9782bef44)
* [ES6,ES7,ES8 · class - easonwang01 - GitBook](https://easonwang01.gitbooks.io/class/es6es7.html)
