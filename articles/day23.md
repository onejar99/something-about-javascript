# 你不可不知的 JavaScript 二三事#Day23：ES6 物件實字威力加強版 (Enhanced Object Literals)

今天文章輕鬆一點，來介紹一個簡單的 ES6 新特性：**Enhanced Object Literals**。


## 什麼是物件實字 (Object Literals)

平常我們用大括號 (`{}`) 來建立物件的語法，就稱為物件實字 (Object Literals)。

以下例子是典型的物件實字語法：

```js
var obj = {};

var player = {
	name: "OneJar", 
	progress: 23,
	sayHi: function(){
		return "Hello";
	},
	language1: "JavaScript",
	language2: "Java",
	language3: "C"
};
```

**物件實字的語法重點：**
* 用大括號表示。
* 裡面的**屬性 (Properties)** 用**名值對 (name-value pairs)** 表示。
* 多個屬性以逗號 (comma) 分隔。
* 宣告完後，還是可以再增加 Properties 進去。


## ES6 推出物件實字語法的加強版

ES6 支援一些新的語法，讓物件實字能夠更簡潔、靈活。



### 1. 物件屬性初始化的語法簡寫

#### ES5

時常會有這樣的情境：要使用已存在的變數名稱對物件屬性作初始化，而命名習性的關係，變數名稱可能和屬性名稱一模一樣。

好拗口，我們還是來看例子吧：

```js
function getPlayerObj(name, progress){
    return {
	    name: name,
		progress: progress
	};
}

console.log( getPlayerObj("OneJar", 23) );   // {name: "OneJar", progress: 23}
```

我想把變數 `name` 和 `progress` 作為物件屬性 `name` 和 `progress` 的初始值，變數名稱和屬性名稱碰巧一模一樣。

在 ES5 以前，必須把**屬性名稱**和**進行賦值的變數名稱**都標明清楚。

寫清楚並沒有不好，只是當這種情境越來越多，程式碼看起來可能稍嫌囉嗦。


#### ES6

對於這種「**屬性名稱**和**進行賦值的變數名稱**一模一樣」的情境，ES6 提供了更簡潔的語法：

```js
function getPlayerObj(name, progress){
    return {
	    name,
		progress
	};
}

console.log( getPlayerObj("OneJar", 23) );   // {name: "OneJar", progress: 23}
```


### 2. 物件函式的語法簡寫

#### ES5

ES5 以前，物件函式的宣告方式就是使用 `function` 關鍵字進行函數的定義：

```js
function getPlayerObj(name, progress){
    return {
        sayHi: function(){
		   return `Hi, I am ${name}`;
	    }
	};
}

console.log( getPlayerObj("OneJar", 23).sayHi() ); // "Hi, I am OneJar"
```



#### ES6

ES6 支援更簡潔的寫法，省略了 `function` 關鍵字和冒號 `:`：

```js
function getPlayerObj(name, progress){
    return {
        sayHi(){
		   return `Hi, I am ${name}`;
	    }
	};
}

console.log( getPlayerObj("OneJar", 23).sayHi() ); // "Hi, I am OneJar"
```

#### 注意！ES6 簡寫語法的函數視為傳統函數

物件函式寫法除了**用 `function` 關鍵字定義傳統函數**，也可以用**箭頭函數 (Arrow Functions)** 的方式定義：

```js
function getPlayerObj(name, progress){
    return {
        sayHi: () => {
		   return `Hi, I am ${name}`;
	    }
	};
}
```

前面幾天的文章，我們談到**傳統函數**和**箭頭函數 (Arrow Functions)** 的差異，兩者的運作行為有很大不同。

**那透過 ES6 簡寫語法所定義的物件函式，行為是傳統函數還是箭頭函數？**

答案是傳統函數。

如何得知？

很簡單，只要一個簡單的測試。

例如箭頭函數不會為自己產生一個新的 `arguments` 物件，如果使用 `arguments` 發生錯誤，就代表是箭頭函數：

```js
var player = {
	sayHi: (name) => {
        console.log(arguments); // ReferenceError: arguments is not defined
		return `Hi, I am ${name}`;
	}
};

console.log( player.sayHi("OneJar") );
```

若能正常取到屬於這個函數的 `arguments`，就代表是傳統函數：

```js
var player = {
	sayHi(name){
        console.log(arguments); // Arguments(1) ["OneJar"]
		return `Hi, I am ${name}`;
	}
};

console.log( player.sayHi("OneJar") ); // "Hi, I am OneJar"
```



### 3. 具運算性的屬性名稱

#### ES5

ES5 以前的物件實字語法，無法透過運算去定義屬性名稱。

例如無法在程式執行過程，透過運算來動態決定下面 `player` 物件裡的屬性名稱要叫 `language1` 或是 `lng1`：

```js
var player = {
	language1: "JavaScript",
	language2: "Java",
	language3: "C"
};

var player = {
	lng1: "JavaScript",
	lng2: "Java",
	lng3: "C"
};
```

當然，你還是可以用以下的寫法去達到目的：

```js
var prefix = "lng";
var i = 0;

var player = {};
player[prefix + (++i)] = "JavaScript";
player[prefix + (++i)] = "Java";
player[prefix + (++i)] = "C";

console.log(player); // {lng1: "JavaScript", lng2: "Java", lng3: "C"}
```

只是這種寫法就不是所謂的物件實字而已。


#### ES6

ES6 直接在物件實字的語法內增加可運算的特性，算是提供了另一種語法選擇：

```js
var prefix = "lng";
var i = 0;

var player = {
    [prefix + (++i)]: "JavaScript",
    [prefix + (++i)]: "Java",
    [prefix + (++i)]: "C"
};

console.log(player); // {lng1: "JavaScript", lng2: "Java", lng3: "C"}
```


## 總結

ES6 提升了物件實字語法的簡潔性和靈活性，總共有 3 個部分的加強：
1. 物件屬性初始化的語法簡寫 (Shorthand for Initializing Properties)
2. 物件函式的語法簡寫 (Shorthand for Writing Methods)
3. 具運算性的屬性名稱 (Computed Properties and Object Literals)

Enhanced Object Literal 是 ES6 中算滿簡單的新特性，唯一值得特別注意的是：**透過 ES6 簡寫的物件函式，函數行為是傳統函數而非箭頭函數**。

經過前面幾天的介紹，相信對箭頭函數和傳統函數的行為差異已經有一定的概念，能夠很輕鬆地理解為什麼 ES6 簡寫的物件函式是傳統函數，這也是為什麼把本篇主題接在箭頭函數之後才介紹。


## References:
* [Enhanced Object Literals in ES6 - DEV Community](https://dev.to/sarah_chima/enhanced-object-literals-in-es6-a9d)
* [[ES6] Javascript 開發者必須知道的 10 個新功能](https://medium.com/@peterchang_82818/es6-10-features-javascript-developer-must-know-98b9782bef44)
* [ES6,ES7,ES8 · class - easonwang01 - GitBook](https://easonwang01.gitbooks.io/class/es6es7.html)
