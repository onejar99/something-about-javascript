# 你不可不知的 JavaScript 二三事#Day7：傳統 var 關鍵字的不足

長久以來 JavaScript 宣告變數所用的關鍵字 (Keyword) 都是 `var`。

大家已經非常習慣，甚至在 `let` 和 `const` 導入這麼久之後，仍時常看到 `var` 的芳蹤。(當然一部份原因跟 ES6 支援度的普及有關係)

但傳統 `var` 有幾個缺點，容易造成程式編寫上的不嚴謹，進而導致變數控管困擾。

ES6 導入了新的宣告關鍵字—— `let` 和 `const`，有助於改善原本 `var` 不嚴謹的缺點，進而增加新的特性，例如 Day5、Day6 文章提到的舞棍阿伯……不對，是 Block Scope。

在介紹 `let` 和 `const` 之前，我們要先了解傳統 `var` 有什麼缺點。

## 學程式很重要的一點是要思考「為什麼」

程式語言的變革非常快，不同語言間時常會互抄，我是說，互相學習。

各家語言的主事者不斷推出新版本，例如常聽到的 C# 4.0、Java 9、PHP 7，就是為了不斷導入新特性或修正原先的設計缺失，讓自家語言的功能更加豐富和周全。

而這些新特性的導入往往都有其歷史原因或背後考量，不會是突然間靈光一閃，上帝啟示。

![](https://i.imgur.com/TV7vGiN.png)  
(Source: [網路](http://images2017.cnblogs.com/blog/1001567/201708/1001567-20170820105857271-267973052.png))

如果只知其然而不知其所以然，只是去背用法，但不知道為什麼需要這樣用，不僅無法融會貫通，在運用上也不容易到位。

因此在介紹 `let` 和 `const` 之前，我們要先了解傳統 `var` 有什麼缺點，才能理解為什麼需要導入 `let` 和 `const`，對程式又能有什麼幫助。

## 傳統 `var` 的變數宣告方法

傳統 `var` 宣告變數的語法如下：

```js
var gameName = "IT Help 2019";
var gamer = "OneJar", topic = "Something about JavaScript", progress = 7;
var isFinished; // A variable declared without a value will have the value **undefined**.
```

> *作者閒聊：希望 `isFinished` 能順利被賦值(遠目)*

要點懶人包：
* 使用 `var` 關鍵字來宣告變數。
* 可只用一次 `var` 一次宣告多個變數，用逗號 (`,`) 區隔。
* 宣告的同時可進行初始化，也就是賦值。
* 若沒有初始化，則預設值會是 `undefined`。

以上沒什麼問題。

但 `var` 有 3 個缺點，或稱為不足之處。

## 傳統 `var` 有什麼缺點？


### 語法允許重複宣告 (Re-Declaring)

例如以下例子：

```js
console.log(x);     // ReferenceError: x is not defined (註)
var x;
console.log(x);     // undefined
x = 123;
console.log(x);     // 123
var x;
console.log(x);     // 123
```

> 註：以上這段程式如果完整執行，第一個 `console.log(x);` 實際上會印出 `undefined` 而不是 Error，因為變數宣告有 **Hoisting** 效果。關於 Hoisting ，預計後續的文章再作詳細介紹，本篇先單純關注 `var` 的問題。

**即使在同一個作用域，同樣名稱的變數也允許重複宣告**，不會跳出任何錯誤或警告，很容易忽略自己曾宣告過。

值得注意的是，**重複宣告一個變數，並不會重置該變數的值**。

一段很長的程式，我們可能不記得前面宣告過同名的變數，後面再次宣告時往往當成第一次宣告，容易疏忽造成小 Bug。

例如以下的情境：

```js
var name = 'OneJar';
.........
.........
.........
var name;
while(true){
    if( name === undefined ){
	     console.log('The first time to execute.');
	}
	............
}
```

**允許重複宣告**不僅沒有用處，還容易造成問題。
 
> 一個較好且普遍的程式編寫習慣：將需要宣告的變數集中在該作用域的一開始，並賦予初始值。



### 不支援區塊作用域 (Block Scope)

例如我們在 Day6 舉的例子：

```js
function myFunc(){
    {
       var n1 = "OneJar";
    }
    console.log("myFunc(): n1=", n1);
}

myFunc();
```

執行結果：

```
myFunc(): n1= OneJar
```

**用 `var` 宣告的變數並不具 Block Scope 效果**。

而 Block Scope 特性在其他程式語言很常見，其他語言開發者轉到 JavaScript 時如果沒注意到這一點，容易造成變數管理上的漏洞。



### 不支援常數 (Constant) 特性

常數 (Constant) 指的是「**固定不變的數值**」。

在程式裡常需要宣告一些變數，但變數裡的值只需要作一次初始化，不需要也不希望在程式執行過程被更改，也就是我們希望這類變數具有常數性質。

例如數學的 PI 是 3.14，如果在程式某個小角落被誤改，就會造成整體運算結果的錯誤。

```js
var PI = 3.14;
PI = 1234;
```

但傳統的 `var` 無法做到這項控管，你想怎麼改變值都可以，對整體程式來說就造成風險。

許多其他程式語言對於常數性質的變數都有提供控管機制來提高安全性，一旦誤改，可能編譯階段就能發現，甚至 IDE 在編寫階段就能提醒，減少 Debug 負擔。

例如 Java 使用了 `final` 關鍵字來保護指定變數不能被更改值：

```java
public static void main(String []args){
    final double PI = 3.14;
    PI = 1234;
}
```

執行結果：

```
HelloWorld.java:5: error: cannot assign a value to final variable PI
        PI = 1234;
        ^
1 error
```

而在 C# 裡是使用 `const` 關鍵字：

```c#
public static void Main()
{
	const double PI = 3.14;
	PI = 1234;  // Compilation error
}
```

不同語言所使用的關鍵字或語法可能不一樣，但目的都是一致：保護常數性質的變數。

## 總結
總結用傳統 `var` 宣告變數的 3 個缺點：
1. 語法允許重複宣告 (Re-Declaring)
2. 不支援區塊作用域 (Block Scope)
3. 不支援常數 (Constant) 特性

以上了解傳統 `var` 的缺點和限制，下一篇文章就可以來看 ES6 的 `let` 和 `const` 如何改善這些不足。

## Referneces
* [W3Schools - JavaScript Variables](https://www.w3schools.com/js/js_variables.asp)
