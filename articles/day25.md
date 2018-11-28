# 你不可不知的 JavaScript 二三事#Day25：不是多了塊魚 —— 立即函數的應用整理

上一篇介紹到立即函數 (Self-Invoking Functions) 的用法，過程有沒有產生一個疑惑？

例如大費周章包裝了一個立即函數：

```js
(function () {
    console.log('Hello');
})();
```

不如直接執行還比較乾脆：

```js
console.log('Hello');
```

一樣都是立刻執行的效果，何必脫褲子放屁，多此一舉，豈非多餘？


![](https://i.imgur.com/s7apwXU.png)
(Source: [Youtube](https://www.youtube.com/watch?v=3iAGnItkHA0))


## 立即函數是脫褲子放屁？

程式是工具，工具是為了幫助解決問題而存在才有意義，不會單純因為語法酷炫或用起來很潮而增加價值。

一開始學到立即函數時，我的第一個感想確實是覺得很多餘。

但我相信每個語法的存在一定有其用意，因此試著去觀摩和整理使用立即函數的場合。

以下是我目前歸納出的用途，歡迎補充：


### 用途 1：封裝一次性的 Local Scope

可以封裝一段想立刻執行的程式碼，建立一次性的 Local Scope，讓一次性變數的生命週期留在函數內，避免汙染到 Global Scope。

#### Before:

在未經封裝前，一次性用途的變數 `temp` 暴露在全域作用域下，潛藏後續對其他程式造成干擾的風險：

```js
var temp = 10 + 5;
console.log("Answer is " + temp);

// 執行其他的任務
otherMission();
function otherMission(){
    console.log(temp);     // temp 是全域變數，仍然存在
}
```

執行結果：

```
Answer is 15
15
```

#### After:

透過立即函數作封裝，避免不必要的變數影響殘留：

```js
(function (){
    var temp = 10 + 5;
    console.log("Answer is " + temp);
})();

// 執行其他的任務
otherMission();
function otherMission(){
    console.log(temp);     // temp 不存在於此作用域
}
```
執行結果：

```
Answer is 15
Uncaught ReferenceError: temp is not defined
```

自然，也可以用普通的函數包裝，再透過函數呼叫來執行，差別是還要為函數作命名：

```
function execOneTime(){
    var temp = 10 + 5;
    console.log("Answer is " + temp);
}
execOneTime();

// 執行其他的任務
otherMission();
function otherMission(){
    console.log(temp);     // temp 不存在於此作用域
}
```

好的命名也是需要花腦細胞去想，既然只是一次性而且立即性的用途，那就用立即函數吧！


### 用途 2：為物件實字 (Object Literals) 的屬性初始值產生動態值

#### Before:

原本如果想為物件屬性產生動態數值，必須先產生基本的初始物件，再額外對屬性來動態賦值：

```js
var student = {};
student.score = Math.random();
console.log(student.score);    // 0.7779381225655557
```

#### After:

透過立即函數的用法，可以在物件實字初始化階段就動態產生結果：

```js
var student = {
    score: (function (){ return Math.random(); })()
};
console.log(student.score);    // 0.7779381225655557
```


### 用途 3：將字串內容轉成函數物件

資料傳遞格式 JSON 不支援儲存函數型態的資料，理論上無法用來傳遞函數物件。

但透過立即函數，配合 `eval()`，就有機會實現用 JSON 傳遞函數型態資料，例如以下範例：

```js
var text = '{ "name":"John", "age":"function () {return 30;}"}';
var person = JSON.parse(text);

console.log(person);            // {name: "John", age: "function () {return 30;}"}
console.log(typeof person.age); // "string"

var getAge = eval("(" + person.age + ")");
console.log(getAge);            // ƒ () {return 30;}
console.log(getAge());          // 30
```

> 如果不是特殊需求，實際專案不建議這樣的作法，會造成程式維護困難。


### 用途 4 : 閉包 (Closures) 的應用

透過立即函數的封裝實現閉包應用，例如：

```js
var add = (function () {
    var counter = 0;
    return function () {return counter += 1;}
})();

console.log(add);
console.log(add());
console.log(add());
console.log(add());
console.log(counter);
```

執行結果：

```
ƒ () {return counter += 1;}
1
2
3
Uncaught ReferenceError: counter is not defined
```

變數 `counter` 被宣告於 `add()` 的函數作用域裡 (Function Scope Level)，理論上離開函數就會被消滅。但透過閉包，可以讓 `counter` 繼續存活，但又不至於被 Global Context 直接操作，只能透過 `add()` 操控。

關於閉包，我們會另外詳細討論，此處就不贅述。



### 用途 5 : 瀏覽器書籤小工具

可以把 JavaScript 程式碼包裝成立即函數，存成瀏覽器的書籤，點下去就會立即執行。

例如常見的「解除右鍵」工具就是這種用法：

```js
javascript:(function() { function R(a){ona = "on"+a; if(window.addEventListener) window.addEventListener(a, function (e) { for(var n=e.originalTarget; n; n=n.parentNode) n[ona]=null; }, true); window[ona]=null; document[ona]=null; if(document.body) document.body[ona]=null; } R("contextmenu"); R("click"); R("mousedown"); R("mouseup"); R("selectstart");})()
```


## 總結


立即函數可以應用的用途：
* 封裝一次性的 Local Scope
* 物件實字 (Object Literals) 的屬性初始值產生動態值
* 將字串內容轉成函數物件
* 閉包 (Closures) 應用
* 瀏覽器書籤小工具

相信還有其他應用情境，歡迎補充！


## References
* [W3Schools - JavaScript Functions](https://www.w3schools.com/js/js_functions.asp)
* [Javascript 開發學習心得 - 函數的多種寫法與應用限制](http://sweeteason.pixnet.net/blog/post/40371736)
