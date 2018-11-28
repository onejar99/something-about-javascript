# 你不可不知的 JavaScript 二三事#Day28：閉包 (Closures)

閉包 (Closures) 是 JavaScript 中名號響噹噹的一個概念。鐵人賽接近尾聲，終於輪到閉包出場。

閉包是什麼呢？

我們來看一下 W3Schools 的定義：

> A closure is a function having access to the parent scope, even after the parent function has closed.

**閉包 (Closures) 是一個能存取父作用域的函數，即使父作用域已經結束**。

![](https://i.imgur.com/lcqSy7g.png)
(Source: [網路圖片](http://colorfulblanche.com/wp-content/uploads/2018/01/%E6%8A%95%E5%BD%B1%E7%89%8713-1024x576.png))

看到這種論文式的定義說明就能心領神會的練武奇才，可以考慮左轉離開去找對你更有價值的知識 (誤)。

沒學過如來神掌的觀眾，我們還是從頭來好好認識一下閉包。

![](https://i.imgur.com/2ee8sjQ.jpg)
(Source: [網路圖片](https://s9.rr.itc.cn/r/wapChange/20164_15_14/a0sisi1715111647352.JPEG))


## 閉包 (Closures) 先修課

閉包在 JavaScript 中是一個很重要、相對理解上也較為複雜的概念，運用很多其他 JavaScript 相關知識。

如果對這些必要的知識缺乏掌握，會造成閉包理解過程的阻礙。

因此正式踏入閉包副本打怪之前，建議先入手幾項技能包，否則越級打怪只會覺得痛苦，過程中似懂非懂、甚至不知所云。

好消息是，這些知識都是我們前面所介紹過的概念！

以下是傳送門整理：

1. **變數運作行為：**
	* [Day26：程式界的哈姆雷特 —— Pass by value, or Pass by reference？](https://ithelp.ithome.com.tw/articles/10209104)
	* [Day27：別管變數 Pass by Whatever，尋找容易理解的銀色子彈 (Silver Bullet)](https://ithelp.ithome.com.tw/articles/10209287)
2. **變數作用域 (Scope)：**
	* [Day5：湯姆克魯斯與唐家霸王槍——變數的作用域(Scope) (1)](https://ithelp.ithome.com.tw/articles/10203387)
	* [Day6：湯姆克魯斯與唐家霸王槍——變數的作用域(Scope) (2)](https://ithelp.ithome.com.tw/articles/10203306)
	* [Day7：傳統 var 關鍵字的不足](https://ithelp.ithome.com.tw/articles/10203548)
	* [Day8：var 掰掰 —— ES6 更嚴謹安全的 let 和 const](https://ithelp.ithome.com.tw/articles/10203715)
3. **Hoisting (宣告的提升效果)：**
	* [Day10：程式也懂電梯向上？ —— Hoisting](https://ithelp.ithome.com.tw/articles/10204951)
4. **立即函數：**
	* [Day24：函數呼叫 (Function Invocation) 與立即函數 (Self-Invoking Functions)](https://ithelp.ithome.com.tw/articles/10208709)



## 先不要管閉包，你有沒有聽過……

閉包是一個略為複雜的概念，特地發展出這樣一個複雜的運用，絕對不是為了自虐，一定是為了解決某個問題或情境。

咱們先不要管什麼是閉包，先來看個範例程式。

在前面的文章，我們已經知道作用域 (Scope) 的運作，根據作用域鏈 (Scope Chain)，Local Scope 可以存取到 Global Scope 的變數。

例如以下例子：

```js
var counter = 0;
function sellTicket(buyer){
  counter +=1;
  console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
}

sellTicket('OneJar');          // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');      // (Total Sold: 2) Buyer: Tony Stark
sellTicket('Steven Rogers');   // (Total Sold: 3) Buyer: Steven Rogers
```

每當成功賣出一張票，就會呼叫 `sellTicket()`，印出購票者，並將售票總數加一。

但這樣寫有一個缺點，就是**大家都能直接存取變數 `counter`，無法限制必須透過 `sellTicket()` 來保障變數 `counter` 的運作**，對於變數 `counter` 來說是不安全的。

例如可能發生這樣的事：

```js
var counter = 0;
function sellTicket(buyer){
  counter +=1;
  console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
}

sellTicket('OneJar');          // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');      // (Total Sold: 2) Buyer: Tony Stark
counter +=1;
sellTicket('Steven Rogers');   // (Total Sold: 4) Buyer: Steven Rogers
```

你可以說，那就口頭要求大家都必須透過 `sellTicket()` 來存取。

但你知我知獨眼龍也知，工程師哪有這麼乖。

![](https://i.imgur.com/UO4AaaY.png)
(Source: [Youtube](https://www.youtube.com/watch?v=m_24DLLpNDU))

這道理就像小孩子跟爸媽拿零用錢，如果爸媽允許小孩直接去錢包自己拿，等於依賴小孩的自律，無法保證哪天小孩鬼迷心竅直接拿信用卡去刷爆。

> 筆者閒聊：類似的事件近年已經不是什麼[新聞](https://unwire.hk/2018/04/04/micro-transaction/fun-tech/)。

對程式來說，這種人為自律沒有保障，通常都不是惡意，但偶然不小心誤用就足以對程式系統造成麻煩。

所以程式設計中才會有封裝的概念，除了降低不必要的細節暴露，也提高安全控管，例如 getter、setter 就是典型例子。

那為了不讓大家都能直接存取 `counter`，我將變數 `counter` 放進 `sellTicket()` 裡，外部環境無法直接存取，一定要透過 `sellTicket()` 才能控制：

```js
function sellTicket(buyer){
  var counter = 0;
  counter +=1;
  console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
}

sellTicket('OneJar');          // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');      // (Total Sold: 1) Buyer: Tony Stark
sellTicket('Steven Rogers');   // (Total Sold: 1) Buyer: Steven Rogers
```

因為變數 `counter` 存在 Local Scope 裡，一旦每次 `sellTicket()` 的函數執行環境消失，變數 `counter` 就會跟著失效，導致總票數永遠都是 `1`，這顯然不合需求。

**由此可以歸納出我們需要的效果**：
1. 變數 `counter` 需要存在於的 Local Scope 裡，讓外部環境無法直接存取，必須透過 `sellTicket()` 來確保執行動作的安全。
2. 但即使函數執行結束，變數 `counter` 還是能持續存活不失效。

這就是閉包想要做到的事情。



## 從目標分析閉包需要的要素

上述目標效果主要有兩個要點：

### 1. 變數資料存在於的 Local Scope 裡，讓外部環境無法直接存取，以確保動作安全

換句話說，將我們希望操控的變數宣告於一個 Local Scope 內，限制它的存取權。

這是相對容易做到的，一個普通的函數就能達到目的。

**所以我們知道了閉包的第一個要素：函數。**

比較麻煩的是第二點。


### 2. 即使 Local 的執行環境結束，Local 環境內建立的資料還是能持續存活

每一次呼叫函數，都是建立一個新的函數執行環境，一旦函數執行結束，這個環境就會失效，包含環境內所宣告的變數，這也是 Local Scope 能成立的前提。

那在這個前提下，**如何做到即使函數執行環境結束，裡面的變數能持續存活？**

還記得 [Day27](https://ithelp.ithome.com.tw/articles/10209287) 我們提到使用盒子圖像的概念來思考資料儲存。

在一個函數裡宣告一個變數，就是產生一個新的變數盒子。

而當函數執行結束，函數執行環境失效，等於變數的宣告失效，就代表拿掉盒子的變數名稱，變成一個匿名盒子。

匿名盒子因為無法再被呼叫使用，很快就會被系統回收，徹底消滅。

**那什麼情況下，一個匿名盒子可以繼續存活不被回收？**

> 只要盒子身上還綁著被別人需要的紅線，盒子就不會被回收。

**紅線就是引用關係 (Reference)。**

舉例來說以下的例子：

```js
function createCar(brandName){
  var car = { brand:brandName };
  return car;
}

var myCar = createCar("BMW");
console.log(myCar);   // {brand: "BMW"}
```

我們用盒子圖像概念來分解過程發生什麼事。

**1. 呼叫 `createCar()`，建立一個新的函數執行環境，也就是一個 Local 環境。**

```js
function createCar(brandName){
  ......
}

var myCar = createCar("BMW");
.....
```

![](https://i.imgur.com/rolkUBp.png)

* Global 環境呼叫 `createCar()` 的同時，產生一個字串實字 (Object Literals) `"BMW"`，暫時放在位址 `0x001` 的盒子，準備用來傳入參數。
* Local 環境自動宣告一個 Local 變數 `brandName` 負責儲存參數。
* 將 Global 環境的 `"BMW"` 資料複製到 Local 變數 `brandName`。
* (完成複製資料的任務後，位址 `0x001` 的匿名盒子因為不再有機會被呼叫，很快就會被回收。)



**2. 在 Local 環境內產生一個新物件。**

```js
function createCar(brandName){
  var car = { brand:brandName };
  .....
}
```

![](https://i.imgur.com/jnzAr83.png)

* 利用變數 `brandName` 的資料當素材，產生一個物件實字 (Object Literals) `{brand: "BMW"}`，放在位址 `0x003` 的匿名盒子。
* 宣告一個 Local 變數 `car` 負責儲存新物件，但因為新物件是物件型態 (Object Types)，無法直接存放到 `car` 變數盒子裡，因此儲存的是位址 `0x003`，建立引用關係。




**3. 將 Local 環境的物件回傳給 Global 環境。**

```js
function createCar(brandName){
  var car = { brand:brandName };
  return car;
}

var myCar = createCar("BMW");
.......
```

![](https://i.imgur.com/UEbjZvT.png)

* Global 環境宣告變數 `myCar` 準備承接回傳資料。
* Local 環境回傳 `car` 變數，將 `car` 變數的內容傳給 `myCar`，也就是 `0x003` 這個位址。
* `myCar` 和存放 `{brand: "BMW"}` 的匿名盒子建立引用關係。


**4. Local 環境結束。**

```js
.......
console.log(myCar);   // {brand: "BMW"}
```

![](https://i.imgur.com/LmNjDk0.png)

* 在 Local 環境宣告的變數名稱失效，沒有機會再被呼叫的盒子都被消滅回收。
* 但位址 `0x003` 的匿名盒子因為還存在引用關係，所以仍然存活。

這就是為什麼理論上 `{brand: "BMW"}` 是 Local Scope 產生的資料，在 Global 環境卻可以繼續使用。

**這就是閉包的第二個要素：引用。**



## 正式進入閉包的用法

前面了解到，**函數和引用是閉包的原理重點**。

我們來看要如何實際應用。


### 閉包基本示範

我們延續前面的 sellTicket 範例，來看看如何用閉包達到我們的目的。

以下是這個範例的閉包寫法：

```js
function getSellTicketClosure(){
  var counter = 0;
  function action(buyer){
    counter +=1;
    console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
  }
  return action;
}

var sellTicket = getSellTicketClosure();

sellTicket('OneJar');          // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');      // (Total Sold: 2) Buyer: Tony Stark
sellTicket('Steven Rogers');   // (Total Sold: 3) Buyer: Steven Rogers
```

解說：
* 利用 `getSellTicketClosure()` 的包裝，讓變數 `counter` 建立在 Local 環境，無法被 Global 環境直接存取。
* 將執行動作的邏輯仍然打包成一個函數，名為 `action()`，但是宣告在 `getSellTicketClosure()` 內，也就是一個內部函數。
* 將 `action()` 的**函數物件**回傳出去給 Global 環境，宣告一個 `sellTicket` 負責承接。
* **`sellTicket` 是一個函數物件，也是一個閉包**。

可以發現這裡還運用了函數作用域的一個性質：**內部函數可以使用父函數的變數**。

也就是內部函數 `action()` 可以使用父函數 `getSellTicketClosure()` 裡的變數 `counter`。

**這個性質是將閉包的兩個要素——函數和引用——串聯起來的重要關鍵。**

這裡用圖像來進一步詳解過程：

**1. 執行 `getSellTicketClosure()`，建立一個 Local 環境，宣告 Local 變數和內部函數。**

```js
function getSellTicketClosure(){
  var counter = 0;
  function action(buyer){
    counter +=1;
    console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
  }
  ..............
}

var sellTicket = getSellTicketClosure();
.......
```

![](https://i.imgur.com/vh3qdwf.png)

* 在 Local Scope 宣告變數 `counter`，初始值是 `0`。
* 宣告一個函數 `action`，包裝要執行的動作邏輯。在 JavaScript 內函數是一種物件，因此相當於宣告一個變數名叫 `action`，儲存函數物件的位址。
* 函數 `action` 裡的動作使用到 `counter` 變數，也就是說**內部函數引用了父函數的變數**。


**2. 將內部函數作為物件回傳出去 Global 環境。**

```js
function getSellTicketClosure(){
  .........
  return action;
}

var sellTicket = getSellTicketClosure();
...........
```

![](https://i.imgur.com/S77Tzxz.png)

* 將函數物件 `action` 回傳出去。
* Global 環境宣告一個變數 `sellTicket` 負責承接傳出來的 `action`，也就是函數物件的位址 `0x002`。


**3. `getSellTicketClosure()` 的 Local 環境結束。**

```js
...........

var sellTicket = getSellTicketClosure();

sellTicket('OneJar');          // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');      // (Total Sold: 2) Buyer: Tony Stark
sellTicket('Steven Rogers');   // (Total Sold: 3) Buyer: Steven Rogers
```

![](https://i.imgur.com/iSZcrsM.png)

* Local 執行環境結束，宣告的 Local 變數名稱失效，原本的 Local 變數盒子都變成匿名盒子。
* 沒有機會再被呼叫，也沒有被別人引用的匿名盒子，都會被回收。
* 位址 `0x002` 的盒子，被 `sellTicket` 引用，所以持續存活。
* 位址 `0x001` 的盒子，被位址 `0x002` 引用，所以間接活著。
* Global 環境無法直接存取位址 `0x001` 的盒子，必須透過 `sellTicket`，去引用位址 `0x002` 的函數，保障了原本 `counter` 變數的資料安全。



### 每一個閉包保存的都是一個獨立的環境

例如以下程式碼：

```js
function getSellTicketClosure(){
  var counter = 0;
  function action(buyer){
    counter +=1;
    console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
  }
  return action;
}

var sellTicket1 = getSellTicketClosure();
sellTicket1('OneJar');            // (Total Sold: 1) Buyer: OneJar
sellTicket1('Tony Stark');        // (Total Sold: 2) Buyer: Tony Stark
sellTicket1('Steven Rogers');     // (Total Sold: 3) Buyer: Steven Rogers

var sellTicket2 = getSellTicketClosure();
sellTicket2('Luffy');             // (Total Sold: 1) Buyer: Luffy
sellTicket2('Nami');              // (Total Sold: 2) Buyer: Nami
```

由於每一次呼叫 `getSellTicketClosure()`，都是建立一個新的函數執行環境，所以回傳的閉包函數也都各自獨立不互相干擾。



### 利用立即函數簡化語法

由於函數 `getSellTicketClosure()` 的目的只是為了回傳一個閉包的函數物件，定義後可以馬上執行，而且只會執行一次，因此語法上可以用立即函數作簡化。

此外，裡面的內部函數只是用於定義動作，不需要在父函數裡執行，因此函數名稱也不重要。

簡化後的語法如下：

```js
var sellTicket = (function(){
  var counter = 0;
  return function(buyer){
    counter +=1;
    console.log(`(Total Sold: ${counter}) Buyer: ${buyer}`);
  }
})();

sellTicket('OneJar');            // (Total Sold: 1) Buyer: OneJar
sellTicket('Tony Stark');        // (Total Sold: 2) Buyer: Tony Stark
sellTicket('Steven Rogers');     // (Total Sold: 3) Buyer: Steven Rogers
```


## 總結

目前看到的閉包教學，大部分都是從「定義」或「語法」切入，然後試著在過程中體會閉包的「目的」。

但是這種方式我覺得相對抽象，**比較像為了學閉包而學，而不是為了解決問題**，一開始理解上容易有隔閡，需要花比較長的時間慢慢體會閉包的效果。

因此本篇文章嘗試**從「目的」切入，先提出遇到的困境、分析解決困境需要什麼要素，然後自然導出閉包的用法，比較屬於目標導向的思路**。

希望這樣的思路能提供不一樣的風格，讓學習閉包之路更為順暢。

現在再來看文章開頭的閉包定義，應該就比較有感：

> A closure is a function having access to the parent scope, even after the parent function has closed.

**閉包 (Closures) 是一個能存取父作用域的函數，即使父作用域已經結束**。


**閉包重點整理：**
* 閉包是一個函數，能「記得」被建立時的環境的一種機制。
* 閉包運用的技巧：
	1. 函數對變數的 Local Scope 封裝。
	2. 內部函數對外層函數變數的引用。
	3. 回傳內部函數的物件，形成閉包。
* 閉包實際上儲存的是對外層函數變數的引用 (References)。
* 每一個閉包中保存的都是一個獨立的環境，不同閉包間不互相干擾。
* 可以用立即函數的寫法來簡化語法。


## References
* [W3Schools - JavaScript Closures](https://www.w3schools.com/js/js_function_closures.asp)
* [JavaScript Function Closure (閉包)](https://www.fooish.com/javascript/function-closure.html)
* [Javascript中的傳遞參考與closure (2)](https://ithelp.ithome.com.tw/articles/10130860)
