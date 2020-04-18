# 你不可不知的 JavaScript 二三事#Day8：var 掰掰 —— ES6 更嚴謹安全的 let 和 const

上一篇文章介紹了傳統 `var` 關鍵字宣告變數的缺點。

> 懶人包支援：
> 1. 語法允許重複宣告 (Re-Declaring)
> 2. 不支援區塊作用域 (Block Scope)
> 3. 不支援常數 (Constant) 特性

今天就來介紹 ES6 的嬌客—— `let` 和 `const`，看他們究竟有什麼本事，可以改善 `var` 做不到的事。

![](https://i.imgur.com/uNKdWPM.png)  
(Source: [網路](http://3.bp.blogspot.com/_JD7pHOAgHko/SwlLKATP-OI/AAAAAAAACN8/XfqfFC--NMw/s1600/%E5%A6%82%E4%BE%86%E7%A5%9E%E6%8E%8C.jpg))

## let

### let 的語意
 
如同 `var` 關鍵字代表的語意是「**var**iable」，`let` 的語意代表什麼？

從第一次看到 `let` 關鍵字就很好奇這件事，著實想了很久：到底 `let` 是什麼單字的縮寫、簡稱，還是像 `var` 和 `const` 一樣，取單字的頭幾個字母。

雖然知不知道語意由來，對能不能學會 `let` 用法沒有影響，但有助於體會設計者在設計這個新關鍵字時，所期望賦予的意涵，也是一種小樂趣。

後來實在想不到是什麼單字，網路上一查終於真相揭曉：`let` 指的就是……「**let**」。

```js
// Hey JS, please
let 
// this variable
n = 'OneJar'
```

![](https://i.imgur.com/sw3gIzz.jpg)  
(Source: [網路](http://img.ltn.com.tw/Upload/liveNews/BigPic/600_phppqUcwz.jpg))

就是這麼簡單 (昏)。

人有時候思考事情會一股腦地往複雜的方面想，結果往往答案就是這麼單純。

根據[網路討論](https://stackoverflow.com/questions/33090193/linguistic-meaning-of-let-variable-in-programming)，其實 `let` 術語的歷史悠久，早在起源於西元 1958 年、現今第二悠久的高階程式語言 LISP 就有這個關鍵字的使用，甚至可能更早，是我見識短淺罷了 (遮臉)。

那 JavaScript 導入這個關鍵字的使用，設計上賦予了什麼性質？


### 支援 Block Scope

舞棍阿伯終於能夠在 JavaScript 裡正式登場。

![](https://i.imgur.com/PPHpxvt.jpg)  
(Source: [網路](https://i.ytimg.com/vi/GbBdx9uwe4o/maxresdefault.jpg))

Day5、Day6 的文章介紹到何謂 Block Scope，而傳統 `var` 不支援 Block Scope 的效果。

下面直接以範例來示範 `let` ：

```js
{
   let x = 2;
   {
        console.log(x); // 2
   }
   console.log(x); // 2
}
console.log(x); // ReferenceError: x is not defined
```

可以看到，**用 `let` 宣告的變數，在該 Block 和其子 Block 內有效**。一旦離開 Block 範圍，這個變數就不被認得。

> 其實不難發現，Function 也是一種比較大的 Code Block，在某種程度上 Function Scope 就像一個比較大的 Block Scope 而已。
>
> 只是對傳統 JavaScript 來說 Function Scope 和 Block Scope 有不同的支援度，因此為了避免理解混亂，在介紹上直接將這兩者視作不同的 Scope 種類。



### 禁止同一層 Block 重複宣告變數

使用 `let` 宣告變數的話，在同一層 Block 內不能重覆宣告變數，會拋錯提示：

```js
{
   let x = 10;
   let x = 2; // SyntaxError: Identifier 'x' has already been declared
}
```

即使另一個宣告是用比較寬鬆的 `var` 也不行：

```js
{
   var x = 10;
   let x = 2; // SyntaxError: Identifier 'x' has already been declared
}
```

但**一個 Block 內的子 Block 允許再宣告同名的變數**：

```js
{
   let x = 2;
   {
        let x = 10;
        console.log(x); // 10
   }
   console.log(x); // 2
}
```

其實跟前面介紹過 Function 之於 Global 主程式是一樣的邏輯。

Function 就像 Global Scope 中的子 Block，Global 宣告的變數在 Function 內仍有效用；但 Function 還是能宣告同樣名稱的變數，作用在自己的 Scope 範圍裡。

```js
function myFunc(){
    var n1 = "Stephen Chow";
    console.log("myFunc(): n1=", n1);
	console.log("myFunc(): n2=", n2);
}

var n1 = "Tom Cruise";
var n2 = "Meryl Streep";
myFunc();
console.log("Global: n1=", n1);
```

執行結果：

```
myFunc(): n1= Stephen Chow
myFunc(): n2= Meryl Streep
Global: n1= Tom Cruise
```


### 不會產生 Global Scope 變數

我們先回顧前面舉過的例子：

```js
function myFunc(){
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

var n1 = "OneJar";
myFunc();
console.log("Main: n1=", n1);
```

執行結果：

```
myFunc(): n1= OneJar
myFunc(): this.n1= OneJar
myFunc(): window.n1= OneJar
Main: n1= OneJar
```

用 `var` 在主程式內宣告 `n1`，會被視為 Global 變數，將之存放在 Global Object 裡 (在 HTML 裡就是 `window` 物件)。

但如果是用 `let` 宣告：

```js
function myFunc(){
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

let n1 = "OneJar";
myFunc();
console.log("Main: n1=", n1);
```

執行結果：

```
myFunc(): n1= OneJar
myFunc(): this.n1= undefined
myFunc(): window.n1= undefined
Main: n1= OneJar
```

可以發現 `n1` 變數：
* 主程式和 `myFunc()` 內依然有效。
* **沒有被存放在 Global Object 裡。**

這是一個微妙的差異，因為如果是在主程式和 `myFunc()` 使用，並不會感覺到什麼差異，`n1` 就像 Global 變數一樣。

**但實際上，`n1` 不是 Global 變數，不會被存放在 Global Object 裡，也無法透過 `window` 物件去取得。**

為什麼幾乎一模一樣的程式碼，宣告位置都一樣，只是把宣告方法改成 `let`，就產生這種差異？

**關鍵在於，當使用 `let` 去宣告變數，在執行時，主程式會被 JavaScript 包裝成一個 Function 去執行。**

概念上就像這樣：

```js
function MAIN(){
	function myFunc(){
		console.log("myFunc(): n1=", n1);
		console.log("myFunc(): this.n1=", this.n1);
		console.log("myFunc(): window.n1=", window.n1);
	}

	let n1 = "OneJar";
	myFunc();
	console.log("Main: n1=", n1);
}
```

所有的程式都在一個隱藏的 `MAIN()` 裡面，所以產生的任何變數嚴格來說都是 Block Scope 而已 (Function Scope 可視為比較大的 Block Scope)。

這樣的好處是進一步管控了 Global 變數，只能透過 Global Object 去存取，提升程式的嚴謹性和安全性。



## const

`const` 的語意就是常數 Constant，也就是經初始化後，裡面的值不能再變動。

**可以把 `const` 視為 `let` 的常數加強版，`let` 有的特性 `const` 都有，但 `const` 額外多了常數保護的特性。**


### 和 `let` 一樣是 Block Scope + 禁止重複宣告 + 不會產生 Global Scope

用 `const` 宣告的變數，同樣出了 Block 就會失效：

```js
{
    const x = 10;
}
console.log(x); // ReferenceError: x is not defined
```

也禁止在同一層 Block 重複宣告同名變數：

```js
var x = 10;
const x = 10; // SyntaxError: Identifier 'x' has already been declared
```

### 定義時必須初始化 (Initialization)

由於常數性質不允許後續再作值的更動，因此宣告的同時就要初始化：

```js
const x = 10;
```

如果沒作初始化會拋錯提醒：

```js
const x; // SyntaxError: Missing initializer in const declaration
```

### 後續不能更改值

也就是除了初始化，後續不能再對這個變數作賦值的動作：

```js
const x = 10;
x = 20; // TypeError: Assignment to constant variable.
```

## 總結

總結 `let` 和 `const` 的重點：

### let

* 支援 Block Scope。
* 禁止同一層 Block 重複宣告變數。
* 不會產生 Global Scope 變數。

### const

* 具備 `let` 的所有特性。
* 定義時必須初始化 (Initialization)。
* 後續不能更改值。

### 應避免使用 `var`，改用 `let` 和 `const`

ES6 導入 `let` 和 `const`，改善 `var` 在變數宣告和管制上的不足，讓程式的變數控管可以更加嚴謹，減少出錯的機率。

因此未來撰寫 JavaScript 時，應該全面使用 `let` 和 `const` 來取代 `var`，讓程式碼更加嚴謹安全。




## References
* [[ES6] Javascript 開發者必須知道的 10 個新功能](https://medium.com/@peterchang_82818/es6-10-features-javascript-developer-must-know-98b9782bef44)
* [W3Schools - JavaScript Let](https://www.w3schools.com/js/js_let.asp)
* [W3Schools - JavaScript Const](https://www.w3schools.com/js/js_const.asp)
* [Linguistic meaning of 'let' variable in programming](https://stackoverflow.com/questions/33090193/linguistic-meaning-of-let-variable-in-programming)
* [LISP - Wiki](https://zh.wikipedia.org/wiki/LISP)
