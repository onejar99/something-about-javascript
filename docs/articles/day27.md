# 你不可不知的 JavaScript 二三事#Day27：別管變數 Pass by Whatever，尋找容易理解的銀色子彈 (Silver Bullet)

![](https://i.imgur.com/EmnBEyG.jpg)  
(Source: [網路圖片](https://www.nurtur-health.eu/WebRoot/StoreNL/Shops/62902058/50AB/33F7/232B/F188/F3CD/C0A8/28BE/BCA0/SBPacks_ml.JPG))


昨天的文章談到 Pass by value 和 Pass by reference。

一個程式語言的變數運作機制究竟是 Pass by value 還是 Pass by reference，不管在 JavaScript 或其他語言，一直都爭議不斷。

而爭議不斷的癥結點源自於名詞定義和觀點的不同。

**技術名詞是為了描述概念而存在，而不是概念為了技術名詞而存在**。

不需要對名詞字眼鑽牛角尖，**最重要的是背後的概念，也就是體現出來的「行為」**。

以行為結果來看，JavaScript 的變數行為大致可以歸納成以下：
*  碰到原生型別 (Primitive)，表現行為是 Pass by value。
*  碰到物件型別 (Object)，如果只是對物件內容作操作(例如陣列元素或物件屬性)，表現行為是 Pass by reference。
*  碰到物件型別 (Object)，如果對物件作重新賦值，表現行為是 Pass by value。


## 知道行為結果，但說不出為什麼

然而上述的行為整理對我而言，只是表面行為的描述，難以對背後原理提出一個解釋或理解模式。

例如同樣是物件型別 (Object)，為什麼重新賦值和非重新賦值的狀況，表現行為會不同？

也許深入鑽研到系統底層核心對記憶體的操縱機制，自然能提出完美解釋，但這對大多數上層應用程式開發者來說成本太高。

就算無法解釋為什麼，只要記熟上述行為結果，大概也足以應付程式中變數行為的推導。

但我對這種死記硬背規則的方式滿抗拒的。

尤其軟體開發要記的知識已經太多，身為一個金魚腦開發者，必須盡量用「理解」取代「硬記」，否則即使短時間內記得，也容易隨著時間變得印象模糊，更別提「硬記」這件事本身有多累。

![](https://i.imgur.com/j2x63SC.png)  
(Source: [網路圖片](Shttps://scontent-atl3-1.cdninstagram.com/vp/eb29f41249b13e02315e33b79c683a50/5C2829EA/t51.2885-15/e35/40268872_1509711539173717_664853700400906240_n.jpg))

**對於情境千變萬化的議題，我偏好試著去找出一個簡單、容易掌握、而且能夠自圓其說的模式，無論遇上任何情境都能用同一個模式推導出正確行為，就像一顆銀色子彈**。

> 銀色子彈（英語：Silver bullet）是一種由白銀製成的子彈，有時也被稱為銀彈。在西方的宗教信仰和傳說中，它作為一種武器，成為唯一能和狼人、女巫及其他怪物對抗的利器。
> 
> 銀色子彈也可用於比喻，喻作強有力的，一勞永逸的，適應各種場合的解決方案。
>
> (引用自維基百科)



## 推導變數行為的銀色子彈：盒子圖像概念

我對銀色子彈的條件：
1. 化繁為簡，必須依靠記憶的前提規則越少越好 (否則叫金魚腦怎麼辦)。
2. 內容盡量質樸，越具體、越簡單、越貼近生活經驗，就越容易理解和運用，能圖像化更佳，有時候甚至帶點稚氣也無所謂 (有趣的童書和沉悶的論文，我更願意擁抱前者)。
3. 能適用所有情境，或至少必須適用絕大部分情境，僅需額外備註極少數的例外 (否則也不稱其為銀色子彈)。

**針對「推導各種程式碼情境的變數行為」，我的銀色子彈就是「盒子圖像概念」。**

其實這個思路我不認為是什麼創建，很多文章或教學講述的都是類似的概念。

**這篇文章比較像進行一個明確的歸納整理，套上盒子這種貼近生活的比喻，搭配圖像化的理解，期望讓這個概念成為一個具體且親切的模式，能被簡易且有系統地運用和分享。**

根據我的經驗，到目前為止碰到各種令人困惑混淆的程式碼情境，都可以用這套「盒子圖像概念」有個說得通的解釋，順利推導變數行為，幫助 Debug。

必須先聲明一件事，避免造成誤解：**這個「盒子圖像概念」純粹是對程式上層行為一個概念式的理解方法，用於上層變數行為的推導，不代表系統底層對記憶體位址的實際操作原理**。

對於深諳底層系統機制的高手來說，這個概念在許多地方的理解或描述可能是十分粗糙、遠遠不夠精確。

但以「推導變數行為」的目的而言，相信可以達到一定效果。

俗話說，黑貓白貓，能抓老鼠的就是好貓。

這顆銀色子彈也許不夠精美，最重要的是希望能幫助變數行為的程式碼撰寫更加容易。




## 盒子圖像概念的起手式

### 記憶體每一塊空間是一個盒子

記憶體有很多個儲存空間，就像一個個不同的盒子 (或抽屜的概念也行)。

* 盒子的名字 => 變數名稱
* 盒子編號是第幾號 => 記憶體位址
* 盒子裡面的東西 => 記憶體儲存的值

比如這樣一個儲存資料的變數：

```js
var age = 18;
```

用盒子的圖像概念來思考：

![](https://i.imgur.com/YVDYuhb.png)


### 宣告變數就是跟電腦討一個盒子

例如下面是宣告變數的動作：

```js
var n;
var s;
var person;
```

已宣告變數但還沒賦值之前，盒子內的值就是 `undefined`。

![](https://i.imgur.com/azeVP3A.png)


### 使用實字 (Literals) 或 `new` 關鍵字，其實都是跟電腦討一個匿名盒子

實字 (Literals) 包含各種型別，例如數字實字、字串實字、陣列實字、物件實字等。

```js
5;
"Hello";
{name: “OneJar”, money: 250};
```

![](https://i.imgur.com/t6oGO5O.png)

此外，`new` 這個關鍵字，就意涵著「跟電腦取得一塊新的記憶體」。

但光是討了盒子沒有用，我們不知道盒子的編號，無法將資料取出來用，**匿名盒子對開發者來說沒有用**。

在高階程式語言裡，記憶體位址幾乎不可控，通常由電腦分配。所以**需要把這些資料進一步傳到有名字的盒子裡，才能受開發者掌控**。



### 將資料放進有名字的盒子

```js
var n = 5;
var s = "Hello";
var person = {name: "OneJar", money: 250};
```

由於電腦系統底層對記憶體儲存資料的機制，根據資料的型別不同，盒子間傳遞值的方式有兩種狀況：
1. 原生型別 (Primitive)：
	* 簡單型資料可以直接複製一份進變數盒子內。
	* **這種類型我們稱為 Pass by Value**。
2. 物件型別 (Object)：
	* 複雜型資料無法直接複製進有名字的盒子內，所以只會把「資料的位址」放進變數盒子，讓程式自動根據位址去找到擁有實際資料的匿名盒子。
	* **這種類型我們稱為 Pass by Reference**。

![](https://i.imgur.com/ekp2haS.png)


### 沒有用的匿名盒子很快會被消滅

俗話說限量是殘酷的，記憶體空間有限，為了能讓記憶體作最大化的運用，系統會回收已經用不到的盒子，以便提供給下一個人使用。

**用不到的盒子的標準是什麼？就是沒機會再被呼叫到**。

匿名盒子對開發者來說就是用不到的盒子，因為沒有辦法呼叫使用，在完成複製資料的任務之後，匿名盒子就會被系統回收走。

![](https://i.imgur.com/IrVSBRb.png)

發現有一個位在 `0x093` 的匿名盒子倖存下來，為什麼？

因為這個匿名盒子和變數 `person` 之間有著引用關係 (Reference)，這個關係就像一條隱形的紅線，牽起兩個盒子之間親密的關係。

![](https://i.imgur.com/TeE6WGd.png)  
(Source: [網路圖片](https://www.google.com.tw/search?rlz=1C1SAVA_enTW523TW523&biw=1280&bih=882&tbm=isch&sa=1&ei=OP7lW9nZNsT08QW346nwDA&q=%E6%9F%AF%E5%8D%97+%E7%B4%85%E7%B7%9A&oq=%E6%9F%AF%E5%8D%97+%E7%B4%85%E7%B7%9A&gs_l=img.3...5065461.5068983.0.5069522.20.18.2.0.0.0.126.1122.14j3.17.0....0...1c.1j4.64.img..2.10.418...0j0i24k1.0.eiv3m89iKIc#imgrc=zSz_-sm0CaTzxM:))

透過變數 `person`，還有機會存取到 `0x093` 盒子的資料，因此 `0x093` 盒子還不會被回收。

換句話說，**只要身上還綁著紅線 (引用關係)，代表還被別人需要，盒子就不會被回收**。



### 引用關係 (Reference) 可以取消或改變

就像紅線可以被斷，引用關係可以被取消或移情別戀。

例如下面的例子：

```js
var person = {name: "OneJar", money: 250};
person = undefined;
person = {name: "John"};
```

不管是將 `person` 指派原生型別的資料，或是給予新的引用關係，都代表原本的引用失效，使得匿名盒子不再被任何人引用，進而被回收。

![](https://i.imgur.com/4eOCOVU.png)

**只要還存在被別人需要的引用關係 (Reference)，匿名盒子就不會被回收**。

**反之，如果不存在被需要的引用關係 (Reference)，匿名盒子就視同被消滅**。

![](https://i.imgur.com/iiA5FDt.jpg)  
(Source: [網路圖片](https://pic.pimg.tw/locking1218/1377625199-1383853375.jpg))


## 盒子圖像概念新手村結束，準備上戰場

以上的概念都還滿單純，運用的幾乎都是多數開發者早已熟知的基礎概念。

但已經足以解釋為什麼 Pass by Reference 的情況下，函數參數有時候會變更到外部參數、有時候不會。


### (A) 會變更到外部參數的範例

範例程式碼如下：

```js
function rename(obj){
    obj.name = "XXX";
}

var person = { name: "OneJar" };
console.log(person);

rename(person);
console.log(person);
```

執行結果：

```
{name: "OneJar"}
{name: "XXX"}
```

我們跟著程式碼，用盒子圖像概念逐步來看。


#### 1. 宣告 `person` 並給予初始值

```js
var person = { name: "OneJar" };
console.log(person);
```

這時候還很單純，就是一個變數盒子 `person` 引用一個匿名盒子，匿名盒子裡存著實際資料 `{ name: "OneJar" }`。

如下圖示意：

![](https://i.imgur.com/IvN1im5.png)


#### 2. 呼叫函數 `rename()`，並傳入 `person` 作為參數

```js
rename(person);
```

這短短的一行程式其實作了很多事，這裡要用慢鏡頭分解。

#### 2.1. 建立一個函數執行環境 (Function Execution Context)

當呼叫某個函數執行時，JavaScript 首先會建立一個新的函數執行環境 (Function Execution Context)。

**函數的參數名稱也是一種變數宣告**，因此這裡會產生一個名為 `obj` 的變數盒子，值是 `undefined`。

![](https://i.imgur.com/HXp3J1N.png)


#### 2.2. 承接傳入的參數

`obj` 的盒子建立後，就能去承接傳進來的參數 `person` 的值。`person` 的值是一個位址 `0x093`，所以 `obj` 內存的也是位址 `0x093`。

![](https://i.imgur.com/rnXuNRE.png)

變數 `obj` 透過位址，等於和 `0x093` 的匿名盒子建立紅線，因此可以存取到實際資料 `{ name: "OneJar" }`。

![](https://i.imgur.com/62X2Dvr.png)



#### 3. 執行函數內的操作物件

前置作業完成後，就可以正式來看函數內的執行動作：

```js
function rename(obj){
    obj.name = "XXX";
}
```

這裡要對變數 `obj` 的屬性 `name` 作操作。

由於透過 `obj`，存取的實際資料是位址 `0x093` 盒子，因此變數 `person` 印出來的資料也變成 `{name: "XXX"}`。

![](https://i.imgur.com/vPnKIVC.png)





### (B) 不會變更到外部參數的範例

範例程式碼如下：

```js
function rename(obj){
    obj = { name: "XXX" };
}

var person = { name: "OneJar" };
console.log(person);

rename(person);
console.log(person);
```

執行結果：

```
{name: "OneJar"}
{name: "OneJar"}
```

同樣用盒子的概念來看這個例子。

前面部分是一樣的，我們可以稍微快轉到「2.2. 承接傳入的參數」之後：

![](https://i.imgur.com/62X2Dvr.png)



#### 3. 執行函數內的操作物件

```js
function rename(obj){
    obj = { name: "XXX" };
}
```

這裡一樣用慢鏡頭來看。


#### 3.1. 為物件實字產生一個匿名盒子

先跟電腦要一個匿名盒子來暫時儲存 `{ name: "XXX" }` 這份資料：

![](https://i.imgur.com/bf2OP2u.png)


#### 3.2. 將匿名盒子的資料傳給變數盒子 `obj`

由於匿名盒子裡裝的是物件型別的資料，無法直接複製一份進變數盒子，因此是存入一個位址的值。

![](https://i.imgur.com/JjXZvH1.png)

可以看到，**其實從這一步開始，變數 `obj` 和 `person` 就已經沒有任何牽連**，因此最後 `person` 印出來仍是 `{name: "OneJar"}`。




## 總結

JavaScript 究竟是 Pass by value、Pass by reference、還是 Pass by sharing，我想在有一個權威性單位定出一個明確的定義觀點之前，恐怕很難有爭執完全結束的一天。

但比起在技術名詞上鑽牛角尖，我更傾向找到一個容易掌握的模式，增加對行為上的理解。

畢竟對現實的專案開發來說，比起訂立一個漂漂亮亮的技術名詞，確保對程式行為的掌握才是首要任務。

**在「盒子圖像概念」裡，Value 採用「資料的內容」的觀點角度，分為 Pass by value 和 Pass by reference 兩種行為**。

根據上面的逐步示範，Pass by reference 完全能夠解釋為什麼有時會影響到外部變數、有時不會，並不需要額外的 Pass by sharing 讓事情更複雜。

目前為止，我個人碰到各種令人混淆的程式碼情境，都可以套用「盒子圖像概念」來解釋和推導，幫助 Debug。

事實上這個概念我仍持續在嘗試補充，因為有些細節的解釋總覺得還不夠圓滑。

如果看倌發現有程式碼情境是這套模式無法解釋，歡迎分享，我很願意修正這套模式。

**就像技術名詞的目的是為了表達概念，銀色子彈是為了解決問題，重要的不是它們的存在本身，而是它們能不能達到目的**。




## References
* [深入探討 JavaScript 中的參數傳遞：call by value 還是 reference？](https://blog.techbridge.cc/2018/06/23/javascript-call-by-value-or-reference/)
* [技術名詞紛爭多](https://www.ithome.com.tw/voice/94877)
* [[筆記] 談談JavaScript中by reference和by value的重要觀念](https://pjchender.blogspot.com/2016/03/javascriptby-referenceby-value.html)
* [重新認識 JavaScript: Day 05 JavaScript 是「傳值」或「傳址」？](https://ithelp.ithome.com.tw/articles/10191057)
* [維基百科 - 銀色子彈](https://zh.wikipedia.org/wiki/%E9%8A%80%E8%89%B2%E5%AD%90%E5%BD%88)
