# 你不可不知的 JavaScript 二三事#Day30：ES10 醞釀中 —— 擁抱 JS の 未來

終於來到最後一天尾聲。

![](https://i.imgur.com/e77c9Yp.png)  
(Source: [白爛貓貼圖](https://store.line.me/stickershop/product/1236945/?ref=Desktop))

## 擁抱 JavaScript 的未來

這篇文章的題目是擁抱 JavaScript 的未來，就讓我們在尾聲來看一下 JavaScript 的歷史和未來。


### JavaScript 的誕生

先簡單介紹一下 JavaScript 的背景。還記得 Day 1 文章看到的這位老兄嗎？

![](https://i.imgur.com/mbI00JX.png)  
(Source: [Thanks Brendan for giving us the Javascript : ProgrammerHumor - Reddit](https://www.reddit.com/r/ProgrammerHumor/comments/8srix1/thanks_brendan_for_giving_us_the_javascript/))

這位笑得你心裡發寒的，就是 JavaScript 的發明者 Brendan Eich。

1995 年 Brendan Eich 在 Netscape 公司的網羅下，為用戶端瀏覽器發明一個腳本語言，最初命名為 Mocha，後來改名 LiveScript，隨後為了搭上當時 Java 話題性的順風車，再度易名為 JavaScript。

(Wiki 上說 Brendan 只用 10 天就設計出原型，果真神人……)

這個商業上的命名考量也造成歷來許多人的誤解和疑惑：Java 和 JavaScript 有什麼關係？

![](https://i.imgur.com/6qUTmr7.png)  
(Source: [Wiki - 網景](https://zh.wikipedia.org/wiki/%E7%B6%B2%E6%99%AF)、[Wiki - 昇陽電腦](https://zh.wikipedia.org/wiki/%E6%98%87%E9%99%BD%E9%9B%BB%E8%85%A6))

雖然當年 Netscape 和發明 Java 的 Sun 公司之間有合作關係，使 JavaScript 在語法上受到 Java 影響和啟發。

但基本上 **Java 和 JavaScript 的關係就像太陽和太陽餅——沒有關係**。


### ECMAScript 等於 JavaScript？

1996 年 11 月，Netscape 公司決定將 JavaScript 提交給標準化組織 ECMA，希望這種語言能夠成為國際標準。

![](https://i.imgur.com/Ni37bmp.png)  
(Source: [Wiki - Ecma國際](https://zh.wikipedia.org/wiki/Ecma%E5%9B%BD%E9%99%85))

ECMA 是一家國際性會員制度的資訊和電信標準組織。1994年之前名為**歐洲電腦製造商協會** (**E**uropean **C**omputer **M**anufacturers **A**ssociation)。1994年之後，因為電腦的國際化，改名 Ecma 國際 (Ecma International)。

1997 年 6 月，ECMA 發布 ECMA-262 標準第一版，**以 JavaScript 語言為基礎，制定了瀏覽器腳本語言的標準，並將這種語言稱為 ECMAScript**，這就是 ES 初代目—— ECMAScript 1.0。

而 JavaScript 就是 ECMAScript 最著名的實現 (Implementation)。

所以嚴格來說，**ECMAScript 指的是一種標準規格 (Standard)，JavaScript 是這個標準的實現 (Implementation)**。除了 JavaScript，ActionScript 和 JScript 也都是 ECMAScript 標準的實現語言。

不過由於 JavaScript 的強勢發展，現在我們在溝通時，幾乎可以把 ECMAScript 和 JavaScript 劃上等號。


### ECMAScript 的成長史

ECMAScript 自 1997 年正式被發布為標準後，也持續有新版本制定。

以下是到今年為止的 JavaScript 版本歷史，參考就好：

| 版本	| 正式名稱				| 發布年份	| 備註 		|
| ------ | ------------------ | ---------| ---------- |
| 1		| ECMAScript 1 		| 1997		| 第一版 |
| 2		| ECMAScript 2 		| 1998		|  |
| 3		| ECMAScript 3 		| 1999		|  |
| 4		| ECMAScript 4 		|  ---		|  從未發布 |
| 5		| ECMAScript 5 		| 2009		|  |
| 5.1		| ECMAScript 5.1 	| 2011		|  |
| 6		| ECMAScript 2015	| 2015		|  |
| 7		| ECMAScript 2016 	| 2016		|  |
| 8		| ECMAScript 2017 	| 2017		|  |
| 9		| ECMAScript 2018 	| 2018		|  |

**從 ES6 開始正式名稱改用年份表示**，因此會看到「ES6」或「ES2015」這兩種說法。

可以注意到，從 2015 年開始突然很勤勞，每一年都有一個新版本發布。


### 年年擁抱新的 ECMAScript

ECMA 中負責制定 ECMAScript 標準的是**第 39 號技術專家委員會** (Technical Committee 39)，**簡稱 TC39**。

任何人都可以向 TC39 標準委員會提案，要求增修語法。

> ECMAScript 目前所有提案可以在 [TC39 的官方 GitHub](https://github.com/tc39/ecma262) 查看。

一個新的語法從提案到變成正式標準，需要經歷五個階段，每個階段都需要由 TC39 委員會批准：
* Stage 0: Strawman (展示階段)
* Stage 1: Proposal (提案階段)
* Stage 2: Draft (草案階段)
* Stage 3: Candidate (候選階段)
* Stage 4: Finished (定案階段)

一個提案只要能進入 Stage 2，幾乎就代表會被包含進未來的正式標準裡。所以有些工具會提供定案階段前的語法測試，例如[Babel 的線上 REPL](https://babeljs.io/repl)。

![](https://i.imgur.com/hifPNmy.png)  
(Source: [Babel REPL](https://babeljs.io/repl))

TC39 委員會想讓標準的升級成為常規流程，決定**在每年的 6 月份正式發布一次，作為當年度的正式版本**。接下來的時間就在這個版本的基礎上做增修，直到下一年的 6 月，草案自然變成新一年的版本，所以可以預期明年的 6 月就會有 ES10 誕生。

每年都有一個新版本發布是一個很快的速度，各家瀏覽器的實作支援要趕上自然會有落差，所以 Babel 這樣的轉譯工具更顯重要。這樣的發布速度也反映了 JavaScript 是何等活躍。

究竟 ES10 又會有什麼新特性，就讓我們拭目以待吧！



## 尾聲

這樣有意義的技術鐵人賽相信未來幾年都還會舉辦，很想勸世未來的勇者：一定要提早準備，不要像筆者自作孽。

標題帶點日文風味，是因為過去 30 天的感覺就像每天被追稿的連載漫畫家。

![](https://i.imgur.com/juNeeAW.png)  
(Source: [網路圖片](https://www.google.com.tw/search?q=%E6%BC%AB%E7%95%AB%E5%AE%B6+%E8%B6%95%E7%A8%BF&rlz=1C1SAVA_enTW523TW523&source=lnms&tbm=isch&sa=X&ved=0ahUKEwin9KaM5s_eAhWBErwKHbsiAM8Q_AUIDigB&biw=1280&bih=882#imgrc=aAmXWBceBZbs2M:))

### 鐵人賽果然不是浪得虛名

![](https://i.imgur.com/eBaKKLW.png)  
(Source: [網路圖片](http://nos.netease.com/v163/snapshot/20180108/WaugI2823_cover.jpg))

這次參賽的決定頗為倉促，別說什麼庫存，開賽死線的前 3 天才決定報名、開始規劃主題大綱。報名時我心裡還想：哼，連續 30 天發文、每篇最低門檻才 300 字有什麼難，難道每天連一、兩個小時都撥不出來？

果然事情不是憨人想得這麼簡單。

![](https://i.imgur.com/wqbkXte.png)  
(Source: [網路圖片](http://komicolle.dreamhosters.com/pix/img12426.jpg))

技術文章和小說散文在寫作性質上有別，技術性質的內容本來就比較不易閱讀，需要花更多心力在文句修飾、編排潤飾，避免閱讀起來過於生硬乏味。

偏偏我又是屬於慢產型的寫作者，從發想、構思、將意念轉成草稿文字、編排文章脈絡、組織成條理性的敘述、想梗、潤飾、校稿，一篇文章花個五、六小時以上幾乎是基本盤，還不含技術研究的時間。

一天撥出一兩小時不難，每天撥出一兩小時就很具挑戰，何況還不是只要一兩小時。

生活也不會只有鐵人賽這一件事要忙，永遠無法知道何時會冒出事件需要處理，但一天只有 24 小時是肯定的。

在追稿狀態下要持續維持文章品質極難，回想過去 30 天的生活，扣掉一些必須處理的事件穿插，剩下的回憶幾乎是工作、吃飯、寫稿、熬夜、睡覺、工作、吃飯、寫稿、熬夜、睡覺，中間一度覺得自己快棄賽。

來到第 30 天，真的有種恍如隔世的感覺。



### 說好的 ES7、ES8 呢？

由於參賽倉促，沒時間學新東西，只好把不久前在學的 JavaScript 拿出來獻寶，看能不能炒出什麼好菜。

思考主題大綱時，本來考慮走新手教學路線，也就是規劃一份 30 天由淺入深的 JavaScript 入門教材，對象是從沒學過程式的人。

但後來覺得這件事在今年已經以現場程式教學的形式做過，雖然口頭教學和靜態教材是不同的挑戰，但在鐵人賽重複自己實在不太理想。沒辦法學新東西來參賽，還是希望在參賽過程能對自己有點收穫。

最後主題定位在針對 JavaScript 裡一些我認為比較混亂、抽象需要整理的觀念，或是比較新的用法，強化自己對 JavaScript 的掌握，所以 Day 1 文章還提到這 30 天的主題預計會包含 ES6、ES7、ES8 的新特性。

But，就是這個 But。

**有些概念在腦袋裡以為自己懂了是一回事，化成具體的口頭表達或文字描述確認自己真的懂了是另一回事，能講到別人也懂又是另一回事**。

為了將概念轉換為文字，需要更具體地去回顧細節，才發現自己可能還有某個觀念沒有釐清，本來以為很簡單的一個小觀念，越挖越深，細節竟然無窮無盡。

> 例如 Day 10 介紹了 Hoisting 觀念，本以為是一個相對簡單的小觀念，經邦友指正分享，才知道背後原理深不見底，精通二字談何容易。

不同觀念間又有先後關係，順序不對，閱讀節奏也會不順。

於是在 30 天的過程中，原先規劃的主題大綱不斷調整順序，一些本來沒在計畫內的主題也跳出來插隊。

這讓我想起作家倪匡在「我看金庸小說」一書裡，對「天龍八部」前言與小說後續發展不一的評語：

> 「寫作前的計畫、意願是一回事，寫出來的小說是怎麼樣的，又是另一回事。」
> 「計畫在創作的過程中，往往無法實踐，會中途突然改變，會有新的意念突然產生，會無法控制自己。」

沒想到這個系列最後只有帶到 ES6 少數特性，原本預計會提到的 ES6 解構賦值、Promises、Classes、Module，甚至 ES8 的 async/await，通通都沒有～

![](https://i.imgur.com/ynA5XVD.png)  
(Source: [Youtube](https://www.youtube.com/watch?v=HzXLJyHLStc))

還好，就像 Day 1 文章提到，近年 JavaScript 果然是個大明星。放眼望去今年的鐵人賽參賽主題，以 JavaScript 為題的應該可以湊個三五桌麻將，別說 ES5、ES6，甚至不乏 ES8、ES9。

![](https://i.imgur.com/F9nXAet.png)  
(Source: [Youtube](https://www.youtube.com/watch?v=b3op8Vo00Ec))

既然如此，新版本的語法介紹也不差我一個湊熱鬧。與其把一堆觀念以沾醬油的方式介紹過一輪，不如好好做個深度整理。不求主題涵蓋範圍包山包海，但求釐清一些微妙的概念。

就成果來說筆者自己還算欣慰，在維持不令自己汗顏的文章品質前提，不敢說多有深度，至少不是走馬看花淺淺帶過，多少釐清了一些抽象觀念，甚至糾正了自己原先理解錯誤的觀念。

**最後，感謝訂閱這個系列的邦友、以及正看著這篇文章的您，筆者能撐過血尿的 30 天，你們的支持是十分重要的鼓勵。**

就讓我用 Day 7 的一段範例程式碼來為這個系列劃下句點：

```js
// Day 7
var gameName = "IT Help 2019";
var gamer = "OneJar", topic = "Something about JavaScript", progress = 7;
var isFinished; // A variable declared without a value will have the value **undefined**.

// Day 30
progress = 30;
if(progress == 30){
    isFinished = true;
    console.log('Thank you guys!');
}
```


## References
* [W3Schools - JavaScript Versions](https://www.w3schools.com/js/js_versions.asp)
* [ECMAScript 6 入門](http://es6.ruanyifeng.com/#docs/intro)
* [「译」ES5, ES6, ES2016, ES.Next: JavaScript 的版本是怎么回事？](https://huangxuan.me/2015/09/22/js-version/)
* [JavaScript 的历史](http://www.w3school.com.cn/js/pro_js_history.asp)
* [Wiki - 網景](https://zh.wikipedia.org/wiki/%E7%B6%B2%E6%99%AF)
* [Wiki - 昇陽電腦](https://zh.wikipedia.org/wiki/%E6%98%87%E9%99%BD%E9%9B%BB%E8%85%A6)
* [Wiki - Ecma國際](https://zh.wikipedia.org/wiki/Ecma%E5%9B%BD%E9%99%85)
* [Wiki - ECMAScript](https://zh.wikipedia.org/wiki/ECMAScript)
* [Wiki - JavaScript](https://zh.wikipedia.org/wiki/JavaScript)
