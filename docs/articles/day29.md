# 你不可不知的 JavaScript 二三事#Day29：閉包 (Closures) 進階打怪實戰

昨天介紹了基本的閉包用法，本篇就來看一些比較進階的閉包應用，或是情境比較複雜的例子。


## 模擬 Class 物件導向用法中的私有成員變數效果

用過其他 Class-based 物件導向語言的開發者，對於 `private` 用法一定不陌生。

例如以下是一個 Java 的私有成員變數範例：

```java
class Person{
    private String name;
    public Person(String n) { this.name = n; }
    public String getName() { return this.name; }
    public void setName(String n) { this.name = n; }
    public String sayHi() { return "Hi I am " + this.name; }
}

public class HelloWorld{
    public static void main(String []args){
        Person p1 = new Person("OneJar");
        Person p2 = new Person("Tony Stark");
        System.out.println(p1.sayHi());
        System.out.println(p2.sayHi());
        
        p2.setName("Steven Rogers");
        System.out.println(p2.sayHi());
    }
}
```

執行結果：

```
Hi I am OneJar
Hi I am Tony Stark
Hi I am Steven Rogers
```

類別 `Person` 的成員變數 `name` 被設為私有 (private) 屬性，類別外的使用者無法直接對 `name` 作存取，必須透過開放的函式，例如 `getName()`、`setName()`、`sayHi()`。

這樣的好處是可以確保 `name` 的資料安全性，能對 `name` 作什麼程度的資料操控，取決於 `Person` 類別願意開放多少動作函式。

JavaScript 並非傳統 Class-based 物件導向語言，缺乏這種語法支援。

雖然可以用 `new` 關鍵字搭配函數建構子 (Function Constructors) 的用法，模擬類似物件導向效果，但仍缺乏私有成員變數的效果，無法限制外部直接對成員變數作存取。

例如下面這個範例：

```js
function Person(n) {
    this.name = n;
    this.sayHi = function(){
    	return "Hi, I'm " + this.name;
    }
}

var p1 = new Person("OneJar");
var p2 = new Person("Tony Stark");
console.log(p1.sayHi());    // "Hi, I'm OneJar"
console.log(p2.sayHi());    // "Hi, I'm Tony Stark"

p2.name = "Steven Rogers";  // (外部仍可以直接存取)
console.log(p2.sayHi());    // "Hi, I'm Steven Rogers"
```

ES6 提供了 Class 的語法，但只是一種語法糖，讓語法看起來和傳統 Class-based 寫法相像，本質仍是傳統 JavaScript，而非傳統 Class-based 物件導向。

例如下面是 ES6 的 Class 寫法，仍舊可以直接對 `name` 屬性作存取：

```js
class Person {
    constructor(name) {
        this.name = name;
    }
    sayHi(){
        return `Hi I am ${this.name}`;
    }
}

var p1 = new Person("OneJar");
var p2 = new Person("Tony Stark");
console.log(p1.sayHi());    // "Hi, I'm OneJar"
console.log(p2.sayHi());    // "Hi, I'm Tony Stark"

p2.name = "Steven Rogers";  // (外部仍可以直接存取)
console.log(p2.sayHi());    // "Hi, I'm Steven Rogers"
```


但是如果透過閉包，就能模擬出類似私有成員的效果：

```js
function createPerson(name){
	var methods = {
	  getName: function() { return name; },
	  setName: function(n) { name = n; },
	  sayHi: function() { return `Hi I am ${name}`; }
	}
	return methods;
}

var p1 = createPerson('OneJar');
var p2 = createPerson('Tony Stark');

console.log(p1.sayHi());           // "Hi I am OneJar"
console.log(p2.sayHi());           // "Hi I am Tony Stark"

p2.setName('Steven Rogers');
console.log(p2.sayHi());           // "Hi I am Steven Rogers"
```

* 變數 `name` 可以持續存活於閉包環境，不會因函數結束而失效。
* 可以對 `name` 作什麼程度的操控，取決於定義時願意開放多少動作函數。例如想修改 `name`，就一定要透過 `setName()`。
* 每個閉包引用的都是獨立的環境，因此 `p1` 和 `p2` 不互相干擾。





## 閉包引用外層函數變數的混淆範例

下面是偶然看到的閉包範例，覺得非常有趣。

### 範例 1

```js
function buildFunctions() {
  var arr = [];

  for(var i = 0; i < 3; i++) {
    arr.push(function() {
      console.log(i);
    });
  }

  return arr;
}

var fs = buildFunctions();
fs[0]();
fs[1]();
fs[2]();
```

`fs` 是一個陣列，儲存了 3 個函數，各別呼叫會印出什麼？

我第一眼看過去，直覺以為會印出 `0`、`1`、`2`，因為不是說每個閉包都是獨立的環境嗎？

執行結果：

```
3
3
3
```

![](https://i.imgur.com/JC52Dvn.png)
(Source: [白爛貓貼圖](https://store.line.me/stickershop/product/1236945/?ref=Desktop))

趕快出動我的銀色子彈，分析一下發生什麼事。



**1. 呼叫 `buildFunctions()` ，宣告陣列變數：**

```js
function buildFunctions() {
  var arr = [];
  ...........
}

var fs = buildFunctions();
..........
```

![](https://i.imgur.com/uVMczgK.png)

* 陣列在 JavaScript 裡是 Object 型別，所以 `arr` 變數盒子裡存放的會是一個位址，引用到陣列實際的資料位置。



**2. 進入 for 迴圈，當 for 迴圈的 `i = 0`：**

```js
function buildFunctions() {
  var arr = [];
  for(var i = 0; i < 3; i++) {
    arr.push(function() {
      console.log(i);
    });
  }
  .................
}

................
```

![](https://i.imgur.com/1B58IFU.png)

* 宣告變數 `i` 作為計數器。
* 建立一個新的函數物件，存放在匿名盒子 `0x101`。
* `0x101` 函數物件內容的 `console.log(i)`，會引用變數 `i`。
* `arr[0]` 會引用 `0x101`。




**3. 當 for 迴圈的 `i = 1`：**

![](https://i.imgur.com/BwcuLh2.png)

* 建立一個新的函數物件，存放在匿名盒子 `0x102`。
* `0x102` 函數物件內容的 `console.log(i)`，會引用變數 `i`。
* `arr[1]` 會引用 `0x102`。


**4. 當 for 迴圈的 `i = 2`：**

![](https://i.imgur.com/IiIxo0C.png)

* 建立一個新的函數物件，存放在匿名盒子 `0x103`。
* `0x103` 函數物件內容的 `console.log(i)`，會引用變數 `i`。
* `arr[2]` 會引用 `0x103`。




**5. 當 for 迴圈的 `i = 3`，離開迴圈：**

![](https://i.imgur.com/lCIoFlR.png)

* 變數 `i` 的值會再被加一，所以 `i` 的內容是 `3`，然後才跳離迴圈。




**6. 回傳 `arr` 到 Global 環境：**

```js
function buildFunctions() {
  ............
  return arr;
}

var fs = buildFunctions();
.............
```

![](https://i.imgur.com/HN24G2z.png)

* Global 環境宣告變數 `fs`，承接 `arr` 所存的位址 `0x002`。
* 變數 `fs` 和 `0x002` 建立引用關係。


**7. Local 環境結束，回收用不到的盒子：**

```js
................

var fs = buildFunctions();
fs[0]();
fs[1]();
fs[2]();
```

![](https://i.imgur.com/Sel9rpk.png)

* `0x001` 的變數名稱 `arr` 失效，變成匿名盒子，且沒有被任何人引用，回收。
* `0x003` 的變數名稱 `i` 失效，變成匿名盒子，但因為還被其他人引用，因此繼續存活。
* `0x002` 原本就是匿名盒子，原本的引用者 `arr` 被回收，但仍被 Global 變數 `fs` 引用，因此繼續存活。
* `fs[0]`、`fs[1]`、`fs[2]` 裡面的 `console.log(i)` 都是引用 `0x003`，因此印出來都是 `3`。



### 範例 2

延續上面的範例，如果希望印出來是 `0`、`1`、`2` 呢？

可以利用 `let` 宣告一個 Block Scope 的變數來達到效果：

```js
function buildFunctions() {
  var arr = [];

  for(var i = 0; i < 3; i++) {
    let j = i;             // 用 `let` 宣告變數 `j`
    arr.push(function() {
      console.log(j);      // 這裡引用變數 `j`
    });
  }

  return arr;
}

var fs = buildFunctions();
fs[0]();
fs[1]();
fs[2]();
```

執行結果：

```
0
1
2
```

為什麼這樣就能印出 `0`、`1`、`2`？



**1. 呼叫 `buildFunctions()`，宣告陣列變數：**

```js
function buildFunctions() {
  var arr = [];
  ...........
}

var fs = buildFunctions();
..........
```

![](https://i.imgur.com/uVMczgK.png)

* 這裡和範例 1 沒有差別。



**2. 進入 for 迴圈，當 for 迴圈的 `i = 0`，建立新的 Block Scope：**

```js
function buildFunctions() {
  ..................
  for(var i = 0; i < 3; i++) {
    let j = i;
    ...................
  }
  .......................
}

................
```

![](https://i.imgur.com/3QUWxvI.png)

* 用 `var` 宣告變數 `i` 作為計數器，`i` 屬於 Function Scope。
* 用 `let` 宣告變數 `j`，**因為用 `let` 宣告，會產生一個新的 Block Scope**。
* `j` 複製一份當前 `i` 的值。




**3. 當 for 迴圈的 `i = 0`，產生新的函數物件：**

```js
function buildFunctions() {
  .....................
  for(var i = 0; i < 3; i++) {
    let j = i;
    arr.push(function() {
      console.log(j);
    });
  }
  ................
}

.............
```

![](https://i.imgur.com/A5PQuEJ.png)

* 建立一個新的函數物件，存放在匿名盒子 `0x101`。
* `0x101` 函數物件內容的 `console.log(j)`，會引用變數 `j`。
* `arr[0]` 會引用 `0x101`。


**4. 當 for 迴圈的 `i = 0` 結束，Block Scope 失效：**

![](https://i.imgur.com/gksbidh.png)

* `0x004` 的變數名稱 `j` 失效，變成匿名盒子，但因為還被其他人引用，因此繼續存活。



**5. 當 for 迴圈的 `i = 1`，建立新的 Block Scope：**

```js
function buildFunctions() {
  ..................
  for(var i = 0; i < 3; i++) {
    let j = i;
    ...................
  }
  .......................
}

................
```

![](https://i.imgur.com/mIg5qFx.png)

* 再次用 `let` 在新的 Block Scope 宣告變數 `j`，儲存當前 `i` 的值。
* 和 `i = 0` 時是不同的 Block Scope，所以 `j` 的變數資料互相無關。




**6. 當 for 迴圈的 `i = 1`，產生新的函數物件：**

```js
function buildFunctions() {
  .....................
  for(var i = 0; i < 3; i++) {
    let j = i;
    arr.push(function() {
      console.log(j);
    });
  }
  ................
}

.............
```

![](https://i.imgur.com/EINWfm5.png)

* 建立一個新的函數物件，存放在匿名盒子 `0x102`。
* `0x102` 函數物件內容的 `console.log(j)`，會引用變數 `j`。
* `arr[1]` 會引用 `0x102`。


**7. 當 for 迴圈的 `i = 1` 結束，Block Scope 失效：**

![](https://i.imgur.com/gfRDN8N.png)

* `0x005` 的變數名稱 `j` 失效，變成匿名盒子，但因為還被其他人引用，因此繼續存活。





**8. 當 for 迴圈的 `i = 3`，離開迴圈：**

![](https://i.imgur.com/ZOGgoxp.png)

* 當 `i = 2` 的情況依此類推。
* 當 `i = 3` 時，然後跳離迴圈。



**9. 將 `arr` 回傳到 Global 環境：**

```js
function buildFunctions() {
  ............
  return arr;
}

var fs = buildFunctions();
.............
```

![](https://i.imgur.com/2HTBRz8.png)

* Global 環境宣告變數 `fs`，承接 `arr` 所存的位址 `0x002`。



**10. Local 環境結束，回收用不到的盒子：**

```js
................

var fs = buildFunctions();
fs[0]();
fs[1]();
fs[2]();
```

![](https://i.imgur.com/S9KpfGp.png)

* `0x001` 的變數名稱 `arr` 失效，變成匿名盒子，且沒有被任何人引用，回收。
* `0x003` 的變數名稱 `i` 失效，變成匿名盒子，且沒有被任何人引用，回收。
* `0x002` 是匿名盒子，被 Global 變數 `fs` 引用，繼續存活。
* `fs[0]`、`fs[1]`、`fs[2]` 裡面的 `console.log(j)` 各自引用 `0x004`、`0x005`、`0x006`，因此印出結果是 `0`、`1`、`2`。



### 範例 3

如果範例 2 不是用 `let` 宣告變數 `j`，改用 `var`，其他程式碼都不變：

```js
function buildFunctions() {
  var arr = [];

  for(var i = 0; i < 3; i++) {
    var j = i;              // 改用 `var` 宣告
    arr.push(function() {
      console.log(j);
    });
  }

  return arr;
}

fs2 = buildFunctions();

fs2[0]();
fs2[1]();
fs2[2]();
```

會印出 `0`、`1`、`2` 還是  `3`、`3`、`3` 呢？

執行結果：

```
2
2
2
```

![](https://i.imgur.com/ap8KLrg.png)
(Source: [網路圖片](https://fs2.my-bras.com/upload/ftp/00.Web/04.Column/Chau.jpg))

為什麼？

**這是因為變數宣告的 Hoisting 效果**，會將變數宣告提到 Scope 最頂端，**而用 `var` 宣告的變數屬於 Function Scope Level**，所以變數 `i` 和 `j` 都相當於宣告在函數一開始：

```js
function buildFunctions() {
  var arr = [];
  var i, j;    // 因為 Hoisting 效果，相當於宣告在這
  for(i = 0; i < 3; i++) {
    j = i;
    arr.push(function() {
      console.log(j);
    });
  }

  return arr;
}
```

所以範例 3 和 範例 1 的狀況是相近的，在函數 `buildFunctions()` 內只會產生一次 `j` 的變數盒子，三個閉包函數都是引用同一個 `j` 的資料盒子，所以印出來的結果都一樣。

而之所以印出 `2` 而非 `3`，是 for 迴圈的關係，`j = i` 在 for 迴圈內執行，但當 `i = 3` 時並不會進入迴圈內，因此 `j` 會停留在 `2`。

這個範例原理和範例 1 類似，就不附分解示意圖 (用手畫可能不用 1 分鐘，畫成投影片超乎想像地費時……Orz)。



## 總結

變數的引用 (References) 相對抽象，需要自己想像變數間的牽連。

閉包概念就是建立在函數和引用的基礎上，而程式碼可能組成的情境又是千變萬化，一個疏忽可能就想錯了結果。

為了確保自己不會想錯程式邏輯，找到一個套路，類似數學公式的效果，幫助開發過程不管遇到什麼程式碼情境，都能套用同一套思考模式來導出正確的行為，也就是我暱稱的銀色子彈。

從這篇文章的範例來看，銀色子彈的效果還不錯，可以避免自己一些似是而非的直覺性邏輯。




## References
* [W3Schools - JavaScript Closures](https://www.w3schools.com/js/js_function_closures.asp)
* [JavaScript Function Closure (閉包)](https://www.fooish.com/javascript/function-closure.html)
* [Javascript中的傳遞參考與closure (2)](https://ithelp.ithome.com.tw/articles/10130860)
* [Day 20 閉包](https://ithelp.ithome.com.tw/articles/10207900)
