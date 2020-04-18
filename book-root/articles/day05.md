# 你不可不知的 JavaScript 二三事#Day5：湯姆克魯斯與唐家霸王槍——變數的作用域(Scope) (1)

一個變數什麼時候開始發揮作用？這個問題的答案很單純——當一個變數被宣告。

那一個變數什麼時候失效？這個問題的答案就複雜多了。

![](https://ithelp.ithome.com.tw/upload/images/20171223/20107429aYpMCDIU6H.jpg)  
(Source: [網路](https://ithelp.ithome.com.tw/upload/images/20171223/20107429aYpMCDIU6H.jpg))

俗話說：「出來混，遲早要還」，變數們在程式裡走跳，不會每個都長命百歲。

有的變數活得久，有的只作用了幾行程式碼。

有的變數只在自己的地盤——函數裡被認得；有的變數就像好萊塢大明星，在程式各個角落都有影響力。

一切，取決於這個**變數誕生的地方與宣告的方式**。

**一個變數的地盤有多大、能生效的範圍有多廣，就稱為這個變數的作用域(Scope)**。

本篇文章就來盤點 JavaScript 的變數作用域有哪些。


## 變數的作用域就像明星的地盤

**作用域**這術語聽起來很高深嚇人，但要理解它並不像它的名稱那麼困難。

可以把它想像成**地盤知名度**的概念，**變數就是明星**。

不同等級的明星會隨著他們發跡地點不同，在不同地域有不同的影響力，在某些地方知名度太低，觀眾就不會理他。

兩岸三地紅透半邊天的華人演員，在歐美可能默默無聞或跑跑龍套。

每次看到演技精湛的華人演員在好萊塢只能演花瓶或雞肋，就覺得非常感嘆，目前仍是個西方娛樂文化強勢當道的世界。

例如我極欣賞的一部電影「十月圍城」，裡面以不慍不火的沉穩演技而貫穿全片的大腕演員王學圻，在「鋼鐵人 3」裡只能飾演一個沒什麼存在感的醫生角色。(我甚至想不太起來他的橋段……)
![](https://i.imgur.com/5w180ba.png)  
(Source: [網路](http://vpic.video.qq.com/4269112134/y00123ggapv_ori_5.jpg))

而好萊塢巨星往往就有跨界的影響力。

例如今年轟動一時的新聞：好萊塢巨星湯姆克魯斯參加韓國知名綜藝節目 Running Man，雖然不同國情、文化、地域，身為國際巨星的阿湯哥依然仍發揮他的跨界影響力，為 Running Man 創下歷史高收視。
![](https://i.imgur.com/iFJjqNj.png)  
(Source: [Youtube](https://www.youtube.com/watch?v=URN9TCmoJDQ))

知名度對明星來說既現實又殘酷，就像作用域之於變數。

同樣是宣告一個變數，有的變數只有在他宣告的地盤才有作用；有的變數即使不是宣告在這個區塊，依然能跨界發揮影響力。

**變數作用域的範圍，取決於這個變數宣告的地方與方式**。


## JavaScript 的作用域有 3 個等級

在 JavaScript 裡，有 3 種等級的作用域：
1. 香港喜劇天王星爺——Function Level Scope
2. 國際巨星阿湯哥——Global Level Scope
3. 住在隔壁號稱歌神的里長阿伯——Block Level Scope (ES6)

下面我們一一來看到。



## Function Level Scope

先從最容易理解的 Function Scope 開始。

![](https://i.imgur.com/kLTbvWS.png)  
(Source: [網路](https://pic.pimg.tw/taker/1191231257_n.jpg))

只要有心，人人都可以是工程師！

喔不對，是食神。

周星馳的無厘頭搞笑文化早就深植我們的生活中(百萬鄉民站出來！)，看過星爺電影的幾乎人人都能朗朗上口幾句經典台詞。

但是如果問一個老外，比如美國人、英國人、法國人、印度人，他們可能毫無感覺。

這就是 **Function Level Scope**，在一定的地域內有著影響力，一旦超過這個地域，可能就被當無名小卒。

這種變數我們常稱為**區域變數(Local Variables)**，也是一般寫程式運用最頻繁的 Scope Level。

基本的 Function Scope 很單純，也最好判斷，地盤就是以 Function 為限，在 Function 之外就不認得。

下面是一個 Function Scope 例子：

* 宣告位置：function 內。
* 有效範圍：該 function 之內。
* 說明：
    * 在 Function 內，從宣告開始到最後都有效。
    * 在 Function 外就變成未定義。

```js
function myFunc(){
    var n1 = "OneJar";
    console.log("myFunc():  n1=", n1);
}

myFunc();
console.log("Global: typeof n1=", typeof n1); // 這裡 n1 只能印 type 不能印值，否則會拋 `ReferenceError: n1 is not defined`
```

執行結果：

```
myFunc(): n1= OneJar
Global: typeof n1= undefined
```


> *作者閒聊：其實這裡本來想從幾個華語電影公認演技派的巨星作為 Function Scope 舉例，例如劉德華、梁朝偉、梁家輝，我覺得更貼切。*
> 
> *尤其是華仔，稱為華人界有巨大廣泛影響力的國民巨星也不為過，但很遺憾至今仍未跨足好萊塢，西方娛樂市場的文化高牆無法靠演技就能收服。就像 Function Scope 裡再重要的變數，也難以將效用突破環境的作用域限制。*
> 
> *這算是身為一個工程師，同時是華語電影愛好者的感嘆。*
> 
> *不過最後猶豫很久，還是決定偷渡我最鍾愛的星爺。*


## Global Level Scope

在每個執行 JavaScript 程式的環境，會有一個**全域物件 (Global Object)**：
* 在 HTML 裡，全域物件是 `window` object。
* 在 Node.js 裡，全域物件是 `global` object。

存放在全域物件裡的變數，**無論在哪裡宣告，效力都能遍及整個程式**，我們稱為**全域變數 (Global Variables)**。

就像好萊塢明星，即使只是歐美發跡，無論中國、日本、韓國、印度，在全球範圍內都有他們的影響力。


下面是一個 Global Scope 例子：

* 宣告位置：主程式內，任何 Function 之外。
* 有效範圍：整個程式，包含所有 Function 內。
* 說明：
    * 無論 Function 內外都能使用。
    * 呼叫方式可以是直接呼叫變數名稱，或透過全域物件 `window` 去呼叫。

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



	
## Local 內的變數有可能自動轉成 Global 變數

在 JavaScript 裡有一種狀況**會自動產生全域變數**，那就是**賦值給未宣告的變數**。

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

雖然不是在函數外，而是函數內動作，但 `n1` 沒有被宣告過就進行賦值，在 JavaScript 行為會**自動**把 `n1` 變成一個全域變數。

一般來說應該**避免這種寫法**。

全域變數的影響力遍及整個程式，不應該隨便產生不需要的全域變數，造成額外的程式風險，以及變數控管上的困擾。

如果真的想要產生一個全域變數，應該在適當的地方進行明確的宣告，例如在函數外，或透過 `window` 物件。而不是在某個 Local 裡用這種隱晦語意的方式產生。

> 在 "Strict Mode" 下，不會自動產生 Global 變數。關於 "Strict Mode" 預計之後另外介紹。

## References
* [W3Schools - JavaScript Scope](https://www.w3schools.com/js/js_scope.asp)
