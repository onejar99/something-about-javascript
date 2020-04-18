# 你不可不知的 JavaScript 二三事#Day9：圖解變數作用域(Scope)

前幾天的文章談到各種等級的 Scope 效果。

> 懶人包支援：
>
> 在 JavaScript 裡，有 3 種等級的作用域：
> 1. 香港喜劇天王星爺——Function Level Scope
> 2. 國際巨星阿湯哥——Global Level Scope
> 3. 住在隔壁號稱歌神的里長阿伯——Block Level Scope (ES6)

不同情境下各種 Scope 如何作用，有時光靠文字描述仍略覺模糊。

尤其同樣在主程式宣告，使用 `let` 和 `const` 產生的變數是 Block Scope，使用 `var` 產生的變數是 Global Scope 這一段，相對不易理解。

俗話說一張圖勝過千言萬語，這篇文章的目標是將不同 Scope 的情境用圖解的方式說明，希望讓 Scope 一目瞭然。

## 圖解之旅行前說明

![](https://i.imgur.com/4E3HL4J.png)

上面這張圖代表我們一般撰寫 JavaScript 程式的程式結構。

我們會在主程式區——正式一點的名稱為**全域執行環境 (Global Execution Context)** ——開始撰寫程式 (意即程式碼不在任何函數內)。

過程中會用到如 `if-else` 或 `for loop`，形成一個個 Block (如 `Block A`、`Block B`)。

漸漸地，我們會把一些程式片段包裝成函數，形成 Function 區塊 (如 `myFunc1()`、`myFunc2()`)，而函數內又可能再形成小 Block。

對應到實際的程式碼，會類似以下：

```js
/* Global Execution Context (outside of any function) */
var i;
console.log(i);

// Block A
if(true){
	.......
}

// Block B
for( i = 0 ; i < 5 ; i ++){
	.......
}


function myFunc1(){
	..........
	// Block C
	if(true){
		........
	}
	// Block D
	if(true){
		.........
	}	
}

function myFunc2(){
	..........
	// Block E
	if(true){
		........
	}
	// Block F
	if(true){
		.........
	}	
}
```

以下會用實際的程式碼情境，配合程式結構圖片來說明各種 Scope 的有效範圍。


## Example 1：宣告在 Function 內 (使用 `var`、`let`、`const` 都一樣)

```js
function myFunc(){
    var n1 = "OneJar";
    console.log("myFunc(): typeof n1=", typeof n1, " value=", n1);
}

myFunc();
console.log("Global: typeof n1=", typeof n1); // 這裡 n1 只能印 type 不能印值，否則會拋 `ReferenceError: n1 is not defined`
```

執行結果：

```
myFunc(): n1= OneJar
Global: typeof n1= undefined
```

![](https://i.imgur.com/Mofh4SU.png)

紅色是 `n1` 宣告的地方，淺藍色部分就是 `n1` 的 Scope。

* 基本 Function Scope。
* 只有在自己這個 function 內有效，包含 function 內的子 Block。
* 別的 function 不認得。
* 主程式區也不認得。



## Example 2：宣告在主程式區 (使用 `var`)

```js
function myFunc(){
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

var n1 = "OneJar";
myFunc();
console.log("Global: n1=", n1);
```

執行結果：

```
myFunc(): n1= OneJar
myFunc(): this.n1= OneJar
myFunc(): window.n1= OneJar
Global: n1= OneJar
```

![](https://i.imgur.com/bqN3GhA.png)

* `n1` 使用 `var` 宣告在主程式區，會存放在 Global Object 裡，屬於 Global 變數。
* 主程式區內的所有子 Block 和函數都認得。




## Example 3：宣告在主程式區 (使用 `let` 或 `const`)

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

![](https://i.imgur.com/TRA72Cs.png)

* 可和 Example 2 比較。
* **在執行時，主程式區會被 JavaScript 包裝成一個 Function 去執行** (圖中隱藏的 `Main()`)。
* 所以變數 `n1` 不會成為 Global Scope，而是 Function Scope / Block Scope。





## Example 4：賦值給未宣告的變數，所自動產生的全域變數

```js
function myFunc(){
    n1 = "OneJar";  // 自動變成一個 Global 變數
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

myFunc();
console.log("Global: n1=", n1);
```

執行結果：

```
myFunc(): n1= OneJar
myFunc(): this.n1= OneJar
myFunc(): window.n1= OneJar
Global: n1= OneJar
```

![](https://i.imgur.com/d7OI6WR.png)

* 紫色代表 `n1 = "OneJar"`，也就是沒有宣告就對 `n1` 賦值的地方。
* 雖然賦值的地方是在 function 內，但因為沒有先宣告，JavaScript 的行為會自動將 `n1` 產生為 Global 變數，所以變成 Global Scope。





## Example 5：Global 和 Function 內同時存在同名變數 (使用 `var`、`let`、`const` 都一樣)

```js
function myFunc(){
    var n1 = "Stephen Chow";
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

var n1 = "Tom Cruise";
myFunc();
console.log("Global: n1=", n1);
```

執行結果：

```
myFunc(): n1= Stephen Chow
myFunc(): this.n1= Tom Cruise
myFunc(): window.n1= Tom Cruise
Global: n1= Tom Cruise
```

![](https://i.imgur.com/oMQ4z8h.png)

* 紅色是 `var n1 = "Tom Cruise"`，宣告在主程式區，屬於 Global Scope。
* 綠色是 `var n1 = "Stephen Chow"`，宣告在主程式區，屬於 Function Scope。
* 淺藍色區域，會生效的是紅色的 `n1`。
* 黃色區域，會生效的是綠色的 `n1`。



## Example 6：Block 內使用 `var` 宣告

```js
if(true){
   var x = 2;
   {
        console.log(x); // 2
   }
   console.log(x); // 2
}
console.log(x); // 2
```

![](https://i.imgur.com/6FMj3eY.png)

* 傳統 `var` 不支援 Block Scope。
* 若是宣告在主程式區的 Block，會是 Global Scope (如上圖所示)。
* 若是宣告在函數內的 Block 內 (例如 `Block C` 內)，會是 Function Scope。



## Example 7：Block 內使用 `let` 或 `const` 宣告

```js
if(true){
   let x = 2;
   {
        console.log(x); // 2
   }
   console.log(x); // 2
}
console.log(x); // ReferenceError: x is not defined
```

![](https://i.imgur.com/n1wiHBY.png)

* 可和 Example 6 比較。
* 使用 `let` 或 `const` 宣告變數，支援 Block Scope 效果。
* 變數 `x` 只會在被宣告的那個 Block 和其子 Block 被認得。



## 總結

作用域 (Scope) 在程式設計裡是滿重要的一個概念。

不同程式語言隨著不同特性，可能有不同的 Scope 類型。

例如 Java 是物件導向語言，在物件的成員變數和函式前面會加上 `public` 或 `private` 等修飾子來宣告作用域，和 JavaScript 的作用域又是不同的運作原理。

不管是使用哪一種語言開發，都應該注意該語言的作用域運作原理。


## References
* [W3Schools - JavaScript Scope](https://www.w3schools.com/js/js_scope.asp)
