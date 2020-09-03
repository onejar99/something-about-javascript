# 你不可不知的 JavaScript 二三事#Day17：this 關鍵字 (3)

## 函數執行環境下 (Function Context) (續)

### 5. 顯性函數綁定之 call()/apply() 篇 (Explicit Function Binding for call()/apply())

> `this` 物件：函數物件被執行時所指定的綁定物件，也就是 `Function.prototype.call()` 或 `Function.prototype.apply()` 的第一個參數。

由於 `apply()` 和 `call()` 幾乎一樣，差別只在於參數的形式不同：
* `call()` 接受一連串獨立的參數。
* `apply()` 接受一組陣列形式的參數。

```js
console.log( Math.max.call(null, 40, 100, 1, 5, 25, 10) );      //100
console.log( Math.max.apply(null, [40, 100, 1, 5, 25, 10]) );   //100
```

因此以下範例只用 `apply()` 來示範。

#### 5.1. 和 bind() 的差別

`apply()` / `call()` 和上一節介紹的 `bind()` 非常相似，都是對函數物件做綁定物件的指定，使用的語法形式也很像。

但同樣對某個函數物件 A 使用時， `bind()` 和 `apply()` / `call()` 的差別在於：
* `bind()` 會**建立一個新的函數物件 B，為 B 綁定一個特定物件，然後回傳 B 物件本身。B 會繼承了 A 的原型**。
    * 如果 A 已經有用 `bind()` 綁定過，B 也會繼承相同的綁定物件，無法再綁新的 (前面 4.3 的範例)。
* `apply()` / `call()` 會**執行函數物件 A，指派一個物件作為 `this`，然後回傳函數 A 的執行結果**。
    * 如果 A 已經有用 `bind()` 綁定過，用 `apply()` / `call()` 再指派其他的物件也沒用。



#### 5.2. 綁定物件範例 (一般模式 & 嚴謹模式)

由於一般模式和嚴謹模式的行為一樣，這裡以一般模式示範。

```js
var whatsThis = function() {
    return this;
};
var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var ironMan = { firstName: "Tony", lastName : "Stark" };
var captainAmerica = { firstName: "Steven", lastName : "Rogers" };

console.log(whatsThis.apply(ironMan));          // {firstName: "Tony", lastName: "Stark"}
console.log(getFullName.apply(ironMan));        // "Tony Stark"
console.log(whatsThis.apply(captainAmerica));   // {firstName: "Steven", lastName: "Rogers"}
console.log(getFullName.apply(captainAmerica)); // "Steven Rogers"
```

直接以要執行的函數物件本身 (e.g., `whatsThis`, `getFullName`) 去呼叫 `apply()`，第一個參數就是函數裡的 `this`。

透過這種方式指定函數的綁定物件，也不需要另外建立一個新的函數物件，即插即用。在使用靈活性上，我認為比 `bind()` 方便。



#### 5.3. 對已經被 Binding 過的函數物件無效

上一節提過，`bind()` 就像海誓山盟，一個函數物件只要曾經和某個物件進行綁定就會死心踏地，即使再進行二次 `bind()` 或利用 `apply()` 指派一次性的綁定物件，都不會生效。

```js
var getFullName = function() {
    return this.firstName + " " + this.lastName;
}

var ironMan = { firstName: "Tony", lastName : "Stark" };
var spiderMan = { firstName: "Peter", lastName : "Parker"};

var introIronMan = getFullName.bind( ironMan );
var introClone = introIronMan.bind();
var introSpiderMan = introIronMan.bind( spiderMan );

console.log(introIronMan());                    // "Tony Stark"
console.log(introSpiderMan());                  // "Tony Stark"
console.log(introClone());                      // "Tony Stark"
console.log(introClone.apply(spiderMan));       // "Tony Stark"
console.log(introSpiderMan.apply(spiderMan));   // "Tony Stark"
console.log(getFullName.apply(spiderMan));      // "Peter Parker"
```

以下對每個函數物件的綁定狀況逐一解說：
* `getFullName()` 這個函數物件本身沒有綁定過任何物件。
* `introIronMan()` 是透過 `getFullName()` 產生的新函數物件，綁定了 `ironMan`。
* `introClone()` 是透過 `introIronMan()` 產生的新函數物件，雖然語法沒有指定新的綁定物件，但透過繼承，同樣綁定了 `ironMan`。
* `introSpiderMan()` 是透過 `introIronMan()` 產生的新函數物件，雖然語法指定了新的綁定物件 `spiderMan`，但由於繼承了 `introIronMan()` 的綁定關係，因此綁定物件同樣是 `ironMan`。
* `introClone()` 和 `introSpiderMan()` 因為本身函數物件已經存在綁定了 `ironMan` 的關係，即使透過 `apply()` 指派新的物件，執行時函數內的 `this` 永遠仍是 `ironMan`。
* `getFullName()` 因為沒有存在任何綁定關係，因此透過 `apply()`，可以成功將函數內的 `this` 指派為 `spiderMan`。



### 6. `this` 指向 `new` 所產生的新物件

> `this` 物件：`new` 所產生的新物件。

當對函數使用 `new` 關鍵字來產生一個物件，該物件會形成自己的環境 (Context)，例如以下範例：

```js
function Hero(n){
    this.exp = n;
};

var h = new Hero(100);
console.log(h);         // Hero {exp: 100}
console.log(h.exp);     // 100
```

* 原本函數內的 `this.exp` 變成新物件 `h` 的屬性。
* 一般模式和嚴謹模式是一樣的行為。


## References
* [W3Schools - The JavaScript this Keyword](https://www.w3schools.com/js/js_this.asp)
* [this - JavaScript | MDN](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Reference/Operators/this)
* [#Javascript：this用法整理 | 英特尔® 软件](https://software.intel.com/zh-cn/blogs/2013/10/09/javascript-this)
* [JavaScript 語言核心（11）this 是什麼？ by caterpillar | CodeData](https://www.codedata.com.tw/javascript/essential-javascript-11-what-is-this/)
