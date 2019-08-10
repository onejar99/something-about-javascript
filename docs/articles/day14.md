# 你不可不知的 JavaScript 二三事#Day14：來挖挖恐龍骨—— with 語法

JavaScript 有一個語法 `with` 似乎相對冷門，比較少看到被使用。

事實上連 [W3Schools 的 JavaScript 教材](https://www.w3schools.com/js/) 都沒有 `with` 語法教學！查了一下網路討論，`with` 曾經也是有人認為很好用的語法。那麼究竟發生什麼事，讓 `with` 像個黑歷史一樣，被 W3Schools 刻意遺忘？

Day13 介紹嚴謹模式 (Strict Mode) 的例子時提到，`with` 語法甚至已經在 ES5 導入嚴謹模式後被禁止使用。

那本篇去研究一個已經被淘汰的語法有什麼意義？

對，語法沒意義，你知道了也不能用 (毆)。

![](https://i.imgur.com/OWsV1lC.png)
(Source: [豆卡頻道貼圖](https://store.line.me/stickershop/product/1140900/zh-Hant?from=sticker))

這一篇文章的定位確實有點像考古文，瞭解一下 JavaScript 曾有過這個語法。

但想要探討的**不是這個語法怎麼寫，而是它為什麼會被摒棄？**

![](https://i.imgur.com/wWManCT.png)
(Source: [網路圖片](https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTiDBrJIeJcp-GaSZI42hma6hssYcdsJsTQMnuntRtUAkZT4vljGA))

一個語法或特性被特地發展出來，然後又被淘汰，一定有其缺點或原因。

**瞭解這些缺點，相當於學到什麼是較被建議的程式思維**。這種概念性上的收穫就像內功一樣，可能不會直接轉化成某種語法的顯性應用，但有助於隱性的程式撰寫思維。

當然，要想探討 `with` 的缺點，首先要先知道語法怎麼寫。



## `with` 的語法

`with` 語法可以為一段程式敘述指定預設物件，用來簡化特定情形下必須撰寫的程式碼量。

語法模板如下：

```js
with(<object>){
    // statement
    // ....
    // ....
}
```

以上是 `with` 標準的語法說明。

如果光看這種論文式的說明就知道怎麼用，你一定是百年一見的練武奇才。

![](https://i.imgur.com/2ee8sjQ.jpg)
(Source: [網路圖片](https://s9.rr.itc.cn/r/wapChange/20164_15_14/a0sisi1715111647352.JPEG))

沒學過如來神掌的人，請跟著導遊繼續往下看實際舉例。





## `with` 使用於內建物件的範例

下面是一個使用 JavaScript 內建數學運算物件 `Math` 的例子：

```js
var x = Math.cos(3 * Math.PI) + Math.sin(Math.LN10);
var y = Math.tan(14 * Math.E);
console.log(x);     // -0.2560196630425069
console.log(y);     // 0.37279230719931067
```

可以發現 `Math` 被不斷重複呼叫，使得這一段程式碼看起來很累贅。

這時候可以利用 `with`，讓程式碼變得較簡潔易讀：

```js
var x, y;
with (Math){
    x = cos(3 * PI) + sin(LN10);
    y = tan(14 * E);
};
console.log(x);     // -0.2560196630425069
console.log(y);     // 0.37279230719931067
```

可以看到，在 `with(Math){....}` 區塊內，不用再逐一指定每個函式或屬性的呼叫物件，因為已經在 `with` 的小括號內指定了 `Math` 作為預設的呼叫物件。

簡單來說，**當你需要對同一個物件的多個屬性或函式作操作時，就可以使用 `with` 來簡化你的程式碼**。

除了用在內建的 JavaScript 物件，也可以用在自定義的物件上嗎？

當然可以。






## `with` 使用於自訂物件的範例

以下想對自訂物件 `player` 的多個屬性作操作，印出想要的資訊：

```js
function showHeroStatus(hero){
    console.log("Name: " + hero.name);
    console.log("Level: " + hero.level);
    console.log("Exp: " + hero.currentExp);
    console.log("You need more " + (hero.nextLevelNeededExp - hero.currentExp) + " Exp points for Level " + (hero.level + 1) + ".");
}

var player = {
    name: "OneJar",
    level: 1,
    currentExp: 50,
    nextLevelNeededExp: 200
};

showHeroStatus(player);
```

執行結果：

```
Name: OneJar
Level: 1
Exp: 50
You need more 150 Exp points for Level 2.
```

可以看到 `showHeroStatus()` 的內容有點囉嗦，不斷重複對 `hero` 的呼叫。

可以利用 `with` 語法讓這段程式碼更簡潔：

```js
function showHeroStatus(hero){
    with(hero){
        console.log("Name: " + name);
        console.log("Level: " + level);
        console.log("Exp: " + currentExp);
        console.log("You need more " + (nextLevelNeededExp - currentExp) + " Exp points for Level " + (level + 1) + ".");
    }
}
```



## 撞名會發生什麼事？

看到這邊，應該可以隱約感覺到 `with` 語法的疑慮：**如果我另外有同名的變數會發生什麼事？**


### 1. 變數是在 `with` 區塊之外宣告

```js
function showHeroStatus(hero){
    var level = 99;     // Function Scope
    var money = 1300;   // Function Scope

    with(hero){
        console.log("Name: " + name);
        console.log("Level: " + level);     // `with` 預設物件優先
        console.log("Exp: " + currentExp);
        console.log("You need more " + (nextLevelNeededExp - currentExp) + " Exp points for Level " + (level + 1) + ".");
        console.log("Money: " + money);
    }
}
```

執行結果：

```
Name: OneJar
Level: 1
Exp: 50
You need more 150 Exp points for Level 2.
Money: 1300
```

* 在 `with` 之內會以預設物件的屬性為優先。
* 如果該屬性名稱不存在於物件內，會按照作用域鏈 (Scope Chain)的順序，繼續找其他變數定義。
* 在這個例子裡：
    * `level` 會以 `hero.level` 優先。
    * `hero` 沒有 `money` 這個屬性，所以 `money` 會找到 Function Scope 所宣告的 `money` 變數。





### 2. 變數是在 `with` 區塊之內宣告

```js
function showHeroStatus(hero){
    with(hero){
        var level = 99;     // The Same Block

        console.log("Name: " + name);
        console.log("Level: " + level);
        console.log("Exp: " + currentExp);
        console.log("You need more " + (nextLevelNeededExp - currentExp) + " Exp points for Level " + (level + 1) + ".");
    }
}
```

執行結果：

```
Name: OneJar
Level: 99
Exp: 50
You need more 150 Exp points for Level 100.
```

* 會以**在 `with` 之內的宣告變數為優先**。
* 在這個例子裡：
    * 呼叫 `level` 時，會以區塊內的 `var level = 99` 優先。





### 3. 變數是在 `with` 區塊之外宣告，但在 `with` 區塊之內被使用

```js
function showHeroStatus(hero){
    var level = 99;     // Function Scope

    with(hero){
        level = 70;

        console.log("Name: " + name);
        console.log("Level: " + level);
        console.log("Exp: " + currentExp);
        console.log("You need more " + (nextLevelNeededExp - currentExp) + " Exp points for Level " + (level + 1) + ".");
    }
}
```

執行結果：

```
Name: OneJar
Level: 70
Exp: 50
You need more 150 Exp points for Level 71.
```

* 雖然 `level` 宣告在 `with` 區塊之外，而 `hero` 有 `hero.level` 這個屬性名稱，但在 `with` 之內還是先找到變數 `level`。



## 總結 `with` 作用域的優先順序

當遇到一個呼叫名稱時 (例如 `level`, `money`)：
1. 先從 `with` 區塊內尋找，有使用過即可，不必是在區塊內宣告的變數。
2. 如果找不到，再從預設物件 (例如 `hero`) 的屬性去找同名稱的屬性。
3. 如果以上都找不到，再根據一般的作用域鏈 (Scope Chain) 繼續往外找。





## `with` 的風險

從上面的例子應該可以體會到，**使用 `with` 固然可以節省一點程式碼，但對於程式的作用域運作可能造成混亂**。

例如上面的例子 1 和 3，`level` 都是宣告在 `with` 之外，卻因為是否曾經在 `with` 之內被使用而有不同行為，這對於程式維護安全性來說並非好事。

尤其從現實專案風險的角度來看：
1. 使用 `with` 能節省的程式碼量可能有限；而且簡化程式碼通常屬於「能做到最好，但不能危害到程式運作」的加分項目。
2. 如果使用 `with` 不慎，造成程式運作的行為不同，屬於「一旦發生，會危害到程式運作」的問題。

專案最大的課題就是權衡 (trade-off)。從以上兩點來看，毫無疑問第 2 點對專案的殺傷力遠大於第 1 點，使用 `with` 所得到的效益可能遠不及它隱含的風險，因此 `with` 的摒棄是可以被理解。





## `with` 掰掰～

如前面文章介紹到，在 ES5 導入的嚴謹模式已經禁止 `with` 語法的使用。

[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/with) 建議：
> Using with is not recommended, and is forbidden in ECMAScript 5 strict mode.
> The recommended alternative is to assign the object whose properties you want to access to a temporary variable.

如果單純希望程式碼可以再簡潔一點，MDN 的建議是「將需要重複呼叫的物件暫存於一個名稱簡短的變數」就好。

例如下面這樣：

```js
"use strict";
var m = Math;
var x = m.cos(3 * m.PI) + m.sin(m.LN10);
var y = m.tan(14 * m.E);
console.log(x);     // -0.2560196630425069
console.log(y);     // 0.37279230719931067
```




## References
* [with - JavaScript | MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/with)
* [【转载】JavaScript中with、this用法小结](http://king39461.pixnet.net/blog/post/361793370-%E3%80%90%E8%BD%AC%E8%BD%BD%E3%80%91javascript%E4%B8%ADwith%E3%80%81this%E7%94%A8%E6%B3%95%E5%B0%8F%E7%BB%93)
* [[JavaScript] with的用法](http://stannotes.blogspot.com/2014/10/javascript-with.html)
