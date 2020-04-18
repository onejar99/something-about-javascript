# 你不可不知的 JavaScript 二三事#Day26：程式界的哈姆雷特 —— Pass by value, or Pass by reference？

![](https://i.imgur.com/3jXfT1v.png)  
(圖片素材來源: [網路圖片](http://cc2e7e3e75a47f276cc1-88ad9aa911bb90089a975b5bf54af6e6.r50.cf2.rackcdn.com/uploaded/l/0e7119966_1521467067_lego-hamlet.jpg))

「To be or not to be, that is the question.」

這是莎士比亞經典《哈姆雷特》中，哈姆雷特王子的名句，是一個人生真諦的千古大哉問。

你知道程式世界裡也有一個萬年經典題嗎？

![](https://i.imgur.com/pmU2gU1.png)  
(圖片素材來源: [網路圖片](https://i.ebayimg.com/images/i/400819020350-0-1/s-l1000.jpg))

「Pass by value, or pass by reference, that is the question.」

對程式開發者來說，一個程式語言的變數是 **Pass by value** 還是 **Pass by reference**，可是至關重要的問題。

變數內容的傳遞方式是 Pass by value (傳值) 或 Pass by reference (傳址)，對於程式開發是一個很基本、但極為重要的觀念，直接影響著程式對變數的操作，相信大部分開發者也都不陌生。

**那 JavaScript 是 Pass by value 還是 Pass by reference？為何有人說其實是 Pass by sharing？甚至有人說 JavaScript 只有 Pass by value？**

今天就來探討這個萬年引戰題。



## Pass by value vs. Pass by reference

在探討 JavaScript 是哪一者之前，照例先快速介紹一下問題本身：**什麼是 Pass by value 和 Pass by reference**？

### Pass by value (傳值)

以下是一個典型的 Pass by value 的例子：

```js
var x = 5;
var y = x;
console.log(x);     // 5
console.log(y);     // 5

x = 10;
console.log(x);     // 10
console.log(y);     // 5
```

* 變數 `x` 被賦予 `5` 這個數值，然後透過 `y = x` 的方式為變數 `y` 賦值，因此 `x` 和 `y` 一開始的變數內容都是 `5`。
* 接著針對 `x` 賦予新的值 `10`，此時 `x` 是 `10`，但 `y` 仍是 `5`。

為什麼改變 `x` 的值，`y` 會不受影響？

下面是一個概念性的示意圖：

![](https://i.imgur.com/XMfBK7L.png)

**因為當變數內容傳遞方式是 Pass by value (傳值)，也就是將舊變數的值內容複製一份，放進一塊新的記憶體，讓新變數指向過去**。

以上面的例子來說，就是將變數 `y` 指向一塊新的記憶體，然後將變數 `x` 裡的值**複製**一份放進去，等於變數 `x` 和 `y` 裡存放的是兩份獨立的資料，其中一份改變，不會影響另一份。



### Pass by reference (傳址)

換來看一個Pass by reference的例子：

```js
var person1 = { money: 111 };
var person2 = person1;
console.log(person1);  // {money: 111}
console.log(person2);  // {money: 111}

person1.money = 222;
console.log(person1);  // {money: 222}
console.log(person2);  // {money: 222}
```

* 變數 `person1` 賦予一個物件，透過 `person2 = person1` 的方式為 `person2` 賦值，`person1` 和 `person2` 兩個物件的 `money` 屬性一樣都是 `111`。
* 針對 `person1.money` 更換值的內容，連 `person2` 的屬性也一起變動到。

下面是概念性的示意圖：

![](https://i.imgur.com/3dyBVcA.png)

**因為當變數內容傳遞方式是 Pass by reference (傳址)，新變數會直接指向舊變數的記憶體位址，等於新舊變數共用同一個位址的資料**。

**所以 `person1` 和 `person2` 其實指向同一個物件**，就像同一個房間有兩個入口，從哪一個入口進去，看到的都是同一個房間內容。因此，對 `person1` 作任何變動，也等同對 `person2` 作變動。





## JavaScript 什麼時候是 Pass by value？什麼時候是 Pass by reference？

基本上**看變數的資料型別，決定傳遞行為是 Pass by value 或 Pass by reference**。

### 當變數的值是原生型別 (Primitive) 時，行為是 Pass by value

在 JavaScript 中，原生型別 (Primitive) 包含：
* String
* Number
* Boolean
* Undefined
* Null (註)

> 註：`null` 雖然用 `typeof` 運算的結果是回傳 `object`，但 `null` 在行為上歸屬原生型別。

以下是這五種型別的行為測試：


```js
/* string */
var str1 = "111";
var str2 = str1;
console.log(str1); // "111"
console.log(str2); // "111"

str1 = "222";
console.log(str1); // "222"
console.log(str2); // "111"


/* number */
var n1 = 111;
var n2 = n1;
console.log(n1); // 111
console.log(n2); // 111

n1 = 222;
console.log(n1); // 222
console.log(n2); // 111


/* boolean */
var bool1 = true;
var bool2 = bool1;
console.log(bool1); // true
console.log(bool2); // true

bool1 = false;
console.log(bool1); // false
console.log(bool2); // true


/* null */
var nu1 = null;
var nu2 = nu1;
console.log(nu1); // null
console.log(nu2); // null

nu1 = "something";
console.log(nu1); // "something"
console.log(nu2); // null


/* undefined */
var ud1 = undefined;
var ud2 = ud1;
console.log(ud1); // undefined
console.log(ud2); // undefined

ud1 = "something";
console.log(ud1); // "something"
console.log(ud2); // undefined
```



### 當變數的值是物件型別 (Object) 時，行為是 Pass by reference

在 JavaScript 中的物件型別常見的例如：
* Array
* Object

以下是這兩種型別的行為測試：


```js
/* array */
var ary1 = [1, 2, 3];
var ary2 = ary1;
console.log(ary1); // [1, 2, 3]
console.log(ary2); // [1, 2, 3]

ary1[0] = 99;
console.log(ary1); // [99, 2, 3]
console.log(ary2); // [99, 2, 3]


/* object */
var person1 = { money: 111 };
var person2 = person1;
console.log(person1);  // {money: 111}
console.log(person2);  // {money: 111}

person1.money = 222;
console.log(person1);  // {money: 222}
console.log(person2);  // {money: 222}
```




## Pass by sharing 又是怎麼一回事？

以上到目前為止，一切看起來很單純美好，沒什麼問題：JavaScript 裡，原生型別 (Primitive) 是 Pass by value，物件型別 (Object) 是 Pass by reference。

為何會冒出一個 Pass by sharing 的說法？

問題出在以下情境：


### 1. 函數參數傳遞

```js
function rename(obj){
    obj = { name: "XXX" };
}

var person = { name: "OneJar" };
console.log(person);
rename(person);
console.log(person);
```

上面這個範例，將物件 `person` 傳遞給函數 `rename()` 作為參數，並在 `rename()` 裡面改變值。

根據前面的結論，物件型別 (Object) 是 Pass by reference，那麼執行結果應該是先印 `{name: "OneJar"}` 再印 `{name: "XXX"}` 囉？

執行結果：

```
{name: "OneJar"}
{name: "OneJar"}
```

![](https://i.imgur.com/Pi6huxi.png)  
(Source: [網路圖片](https://img.appledaily.com.tw/images/twapple/640pix/20110919/_Other/826_altek01.jpg))

怎麼好像和前面說好的不一樣？

上述例子可以再作抽離，縮小範圍，只看對 `obj` 變更值的部分。例子中是使用**物件實字 (Object Literals)** 的方式來變更值。


### 2. 使用陣列實字 (Array Literals) 和物件實字 (Object Literals) 重新賦值

```js
/* array literals */
var ary1 = [1, 2, 3];
var ary2 = ary1;
console.log(ary1); // [1, 2, 3]
console.log(ary2); // [1, 2, 3]

ary1 = [99, 100];
console.log(ary1); // [99, 100]
console.log(ary2); // [1, 2, 3]


/* object literals */
var person1 = { money: 111 };
var person2 = person1;
console.log(person1);  // {money: 111}
console.log(person2);  // {money: 111}

person1 = { money: 222 };
console.log(person1);  // {money: 222}
console.log(person2);  // {money: 111}
```

可以發現到，雖然是物件型別 (Object) 的變數，**如果用實字 (Literals) 對變數作重新賦值，並不會連另一個變數一起變更**。

### 3. 使用第三方變數作重新賦值

即使不是直接用實字 (Literals)，而是透過第三方變數去作重新賦值，同樣不會影響到第二個變數：

```js
/* array re-assigned */
var ary1 = [1, 2, 3];
var ary2 = ary1;
console.log(ary1); // [1, 2, 3]
console.log(ary2); // [1, 2, 3]

var ary3 = [99, 100];
ary1 = ary3;
console.log(ary1); // [99, 100]
console.log(ary2); // [1, 2, 3]
console.log(ary3); // [99, 100]


/* object re-assigned */
var person1 = { money: 111 };
var person2 = person1;
console.log(person1);  // {money: 111}
console.log(person2);  // {money: 111}

var person3 = { money: 333 };
person1 = person3;
console.log(person1);  // {money: 333}
console.log(person2);  // {money: 111}
console.log(person3);  // {money: 333}
```


### Pass by reference 和 Pass by value 的融合版

從前面例子發現到，雖然是物件型別 (Object) 的變數，如果是對物件變數作重新賦值，只會變更自己的值，不會連另一個變數一起變更。

這和前面提到的 Pass by reference 行為似乎不太一樣，反而有點像 Pass by value。

如此一來，稱為 Pass by reference 也不對，稱為 Pass by value 也不對，於是就出現了 **Pass by sharing** 的說法。

![](https://i.imgur.com/Ek5XCoa.jpg)  
(Source: [網路圖片](https://www.google.com.tw/search?q=%E4%B8%83%E9%BE%8D%E7%8F%A0+%E8%9E%8D%E5%90%88%E8%A1%93&rlz=1C1GCEU_zh-TWTW821&source=lnms&tbm=isch&sa=X&ved=0ahUKEwjU-rqW2cbeAhWDurwKHfIgDYwQ_AUIEygB&biw=1745&bih=853&dpr=1.1#imgrc=3fvdxKl6L9GHlM:))

**不少人將 JavaScript 的變數內容傳遞方式，稱為 Pass by sharing**：
*  碰到原生型別 (Primitive)，表現行為是 Pass by value。
*  碰到物件型別 (Object)，如果只是對物件內容作操作(例如陣列元素或物件屬性)，表現行為是 Pass by reference。
*  碰到物件型別 (Object)，如果對物件作重新賦值，表現行為是 Pass by value。

或者也有人視為：**JavaScript 的 Primitive 是 Pass by Value，Object 是 Pass by sharing**。



## JavaScript 只有 Pass by value？

那為何有人說 JavaScript 只有 Pass by value？

這要稍微牽涉到變數的記憶體儲存方式。

### 我不是骨阿默，但我今天還是要來說一個電腦資料儲存原理的故事

電腦在執行程式的過程，是將資料暫存在記憶體裡，以供運算過程使用。

![](https://i.imgur.com/1n19mQ2.jpg)  
(Source: [網路圖片](http://www.adata.com/upload/products/list/226.jpg))

對電腦來說，記憶體每一個空間都有對應的位址，就像住址編號一樣。

![](https://i.imgur.com/bSSwTdX.png)

想像一下，如果大家寫程式都得這樣：

```js
0x002 = 10;
0x085 = 5;
0x108 = 0x002 + 0x085;
console.log(0x108);
.........
.........
```

應該會有 87% 的程式開發者想要逃坑。

![](https://i.imgur.com/HFk2nx0.png)  
(Source: 進擊的巨人)

還好，一個偉大的發明拯救了程式苦海中的眾生：**變數**。

**宣告變數，就是跟記憶體要某一個位址的空間來存放資料**。

在高階程式語言裡一定有支援變數，讓開發者能用更具可讀性的名稱來儲存資料。

**對電腦來說，實際運作和辨認資料位置是以「位址」為準；變數名稱只是為了方便人類呼叫、類似別名的存在，由程式幫忙和實際的資料儲存位址作連結。**

![](https://i.imgur.com/H0VNZEZ.png)

而我們透過變數儲存資料時，由於電腦對記憶體儲存資料有其機制，**不同的資料型別會有不同儲存方式**。

以 JavaScript 來說會有兩種：
1. 資料是**原生型別 (Primitive) 時，變數在記憶體內儲存的是「資料的內容」**，也就是我們常稱的 Pass by value。
2. 資料是**物件型別 (Object) 時，變數在記憶體內儲存的是「資料的位址」**，通過這個位址，可以找到實際儲存資料的地方，也就是我們常稱的 Pass by reference

![](https://i.imgur.com/uWHAPys.png)

> 筆者按：這裡的介紹比較偏向概念性，大幅簡化細節，實際上作業系統底層對記憶體的操控機制沒那麼簡單。但對於上層高階語言來說，這樣概念性的理解應該足夠應付一般開發所需。


### 為什麼有人認為 JavaScript 只有 Pass by value？

我們先看原生型別 (Primitive) 的狀況：

```js
var x = 5;
var y = x;
console.log(x);     // 5
console.log(y);     // 5

x = 10;
console.log(x);     // 10
console.log(y);     // 5
```
![](https://i.imgur.com/sgeL5cm.png)


再來看物件型別 (Object) 的狀況：

```js
var x = { money: 111 };
var y = person1;
console.log(x);  // {money: 111}
console.log(y);  // {money: 111}

x.money = 222;
console.log(x);  // {money: 222}
console.log(y);  // {money: 222}
```

![](https://i.imgur.com/Rnr3Z8W.png)


從底層實際運作的角度來看，不管是原生型別 (Primitive) 或物件型別 (Object)，在作 `x = y` 這個動作時，都是把 `x` 內儲存的值複製一份到 `y` 裡 (不管這個值的內容是一個數值或一個位址)。

這就是為什麼有人認為 JavaScript 只有 Pass by value。





## 萬年引戰的癥結點：人人定義不同

Pass by value 或 Pass by reference 直接關係著程式的變數運作，而且是每個程式語言都會碰到，不是 JavaScript 獨有。

這種理當在程式語言開天闢地時代就遇到的基本議題，怎麼會到今日仍爭議不斷？

我覺得這篇文章 —— [深入探討 JavaScript 中的參數傳遞：call by value 還是 reference？](https://blog.techbridge.cc/2018/06/23/javascript-call-by-value-or-reference/) —— 點出一個癥結點：

> 大家對 call by reference 以及 call by value 的「定義」其實都不盡相同，而且也沒有一個權威性的出處能夠保證這個定義是正確的。

**例如所謂 Value，指的究竟是「資料的內容」，還是「存放在變數記憶體位址裡的值」？**

以下面變數 `n` 和 `obj` 來說：

```js
var n = 123;
var obj = { name: "OneJar" };
```

| 變數    | 資料的內容              | 存放在變數記憶體位址裡的值        |
| ------- | ----------------------- | --------------------------------- |
| n       | `123`                   | `123`                             |
| obj     | `{ name: "OneJar" }`    | 類似 `0x0001` 這樣的記憶體位址    |


* **如果 Value 指的是「資料的內容」**：
    * 物件 (Object) 間的 `obj1 = obj2` 傳值，就屬於 Reference 的複製，而非 Value 的複製。
    * 因此有 Pass by value 和 Pass by reference 分別。
* **如果 Value 指的是「存放在變數記憶體位址裡的值」**：
    * 所有的 `x = y` 傳值都屬於 Value 的複製。
    * 因此只有 Pass by value。

**這就是最初的定義不同、觀點不同，導致最後的結論不同**。

所以下面哪一句是對的：
1. JavaScript 只有 Pass by value。
2. JavaScript 的 Primitive 是 Pass by Value，Object 是 Pass by sharing。

答案都是對的，視乎立足的定義和觀點。

傳統 Java 在教變數資料型態時，Pass by Value 和 Pass by Reference 一直是一大考題。但如果從「Value 指的是**存放在變數記憶體位址裡的值**」的角度來看，這些考題全都該丟垃圾桶，因為都只有 Pass by Value。

其實不只是 Pass by Value 和 Pass by Reference 有這種名詞定義上的困擾，[各種 MV-Whatever 名詞定義](https://www.ithome.com.tw/voice/97137)也是爭吵不休。

會有這麼多技術名詞上的歧義，就像[這篇文章](https://www.ithome.com.tw/voice/94877)所言：

> 程式開發的世界中，名詞的創造經常是隨意的。
>
> 這些名詞通常沒有明確的定義，一開始只是為了溝通方便，而隨著聽聞者各自的領會與轉述，加上時間與歷史的推移，它們的定義會發生岐義而各自發展，最後失去了溝通的意義。





## 所以…… JavaScript 到底 Pass by WTF

[技術名詞紛爭多](https://www.ithome.com.tw/voice/94877)這篇文章最後總結得很好：

> 在《松本行弘的程式設計世界》的〈語彙與共通語言的重要性〉這篇文章中，作者談到，為某個概念決定適當的名詞，目的是在設計時能有共同的語彙，也能讓開發者意識到它們的存在，這才是名詞存在的真正意義。

**技術名詞是為了方便溝通，不是為了吵架**。

![](https://i.imgur.com/CTZSbHS.jpg)  
(Source: [網路圖片](https://0.share.photo.xuite.net/jingyueanfj/10e8827/8119399/320526272_m.jpg))

技術名詞的概念統一定義很重要，因為能讓大家在一個共通的語彙概念上溝通或學習。

這就是為什麼許多負責訂定標準或名詞定義的權威單位受人重視，他們所訂的名詞、定義等標準未必所有人都同意，但大部分的人願意接受和信服，因此大家一起遵循這樣的標準，使所有人能在同樣的理解共識下工作。

但如果為了在技術名詞上鑽牛角尖，反而把自己越弄越糊塗，變成為了捍衛技術名詞的存在而存在，我認為是本末倒置。

**技術名詞是為了描述概念而存在，而不是概念為了技術名詞而存在。**

**最重要的是背後期望表達的概念，也就是體現出來的「行為」。**


## References
* [深入探討 JavaScript 中的參數傳遞：call by value 還是 reference？](https://blog.techbridge.cc/2018/06/23/javascript-call-by-value-or-reference/)
* [技術名詞紛爭多](https://www.ithome.com.tw/voice/94877)
* [MV-Whatever大家族](https://www.ithome.com.tw/voice/97137)
* [[筆記] 談談JavaScript中by reference和by value的重要觀念](https://pjchender.blogspot.com/2016/03/javascriptby-referenceby-value.html)
* [重新認識 JavaScript: Day 05 JavaScript 是「傳值」或「傳址」？](https://ithelp.ithome.com.tw/articles/10191057)
