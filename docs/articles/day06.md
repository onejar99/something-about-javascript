# 你不可不知的 JavaScript 二三事#Day6：湯姆克魯斯與唐家霸王槍——變數的作用域(Scope) (2)

## 星爺強碰阿湯哥誰會贏？Global Scope vs. Function Scope

![](https://i.imgur.com/KkQVLtA.png)  
(Source: [網路1](https://puui.qpic.cn/qqvideo_ori/0/k0505psezun_496_280/0) / [網路2](http://globedia.com/imagenes/noticias/2015/9/4/mision-imposible-tom-cruise-corre-horas_1_2287136.jpg))

俗話說天高皇帝遠，十里外的瀑布不如眼前的一杯水。

全球來說，在杜拜第一高樓跳來跳去的阿湯哥毫無疑問有較廣泛的知名度。但對我們而言，星爺在我們的生活中有更深的影響力。

Global 變數和 Local 變數也是如此。

也許**對整個程式來說，Local 變數不及 Global 變數效用來得廣**，但**在函數的 Local 範圍內，Local 變數的存在感比較高**。

所以如果 Global 和 Function 內宣告了同樣名稱的變數，在 Function 內會是 Local 變數生效，Function 外依然是 Global 稱王。

如下面這個例子：

```js
function myFunc(){
    var n1 = "Stephen Chow";
    console.log("myFunc(): n1=", n1);
    console.log("myFunc(): this.n1=", this.n1);
    console.log("myFunc(): window.n1=", window.n1);
}

var n1 = "Tom Cruise";
myFunc();
console.log("Global: n1=", n1);
```

執行結果：

```
myFunc(): n1= Stephen Chow
myFunc(): this.n1= Tom Cruise
myFunc(): window.n1= Tom Cruise
Global: n1= Tom Cruise
```

要注意的是，如果在 Function 內透過如 `window.n1` 的方式，明確表明「**我要取的是 Global 變數的 `n1`，而不是 Local 的 `n1`**」，一樣會是 Global 變數發揮效用。


## Block Level Scope

除了 Global Level 和 Function Level，還有第三種等級：Block Level。

![](https://i.imgur.com/PPHpxvt.jpg)  
(Source: [網路](https://i.ytimg.com/vi/GbBdx9uwe4o/maxresdefault.jpg))

Block Level 就像住在你家隔壁號稱歌神的里長阿伯。

不要小看他們，也許不要說離開這個縣市，可能出了這一里就沒人認得他們，但在這一里的範圍內，他們就是婆婆媽媽們心中最強的情歌王子。

Block Level 的作用域範圍可能非常小，只是一個函數裡的某一段程式。

程式裡 Block 指的是一段用大括號 (`{` 和 `}`) 包起來的區塊。


我們用 Java 來舉例：

(為什麼用 Java 舉例而不是用 JavaScript，你馬上就會知道)


### Block Scope 的 Java 例子

以下是一段 Block 的例子：

```java
public static void main(String []args){
    {
        int x = 10;
        System.out.println(x);
    }
}
```

執行結果：

```
10
```

很正常印出 `x` 的值，好像沒什麼異狀。

我們改在 Block 外面去呼叫 `x` 變數：

```java
public static void main(String []args){
    {
        int x = 10;
    }
    System.out.println(x);
}
```

執行結果：

```
HelloWorld.java:7: error: cannot find symbol
        System.out.println(x);
                           ^
  symbol:   variable x
  location: class HelloWorld
1 error
```

Java 編譯器說他不認得 `x` 這個變數。

這就是 Block Scope 的效果。雖然在同一個 Function 內，只要一出 Block，變數就失去效用。


### JavaScript 的 `var` 在 Block Scope 使用的例子

輪到 JavaScript 上場了！

我們一樣在 Block 內宣告變數，預期出了 Block 就不認得 `n1` 變數：

```js
{
   var n1 = "OneJar";
}
console.log("Global: n1=", n1);
console.log("Global: this.n1=", this.n1);
console.log("Global: window.n1=", window.n1);
```

執行結果：

```
Global: n1= OneJar
Global: this.n1= OneJar
Global: window.n1= OneJar
```

![](https://i.imgur.com/Xx9HKan.png)  
(Source: [網路](https://vignette.wikia.nocookie.net/evchk/images/e/ec/2471912.jpg/revision/latest?cb=20171012125530))

怎麼還是印得出來？而且是個全域變數。

一定有什麼誤會，可能只有 Function 內的 Block 有效，我們改在 Function 內的小 Block 去宣告：

```js
function myFunc(){
    {
       var n1 = "OneJar";
    }
    console.log("myFunc(): n1=", n1);
	console.log("myFunc(): this.n1=", this.n1);
	console.log("myFunc(): window.n1=", window.n1);
}

myFunc();
```

執行結果：

```
myFunc(): n1= OneJar
myFunc(): this.n1= undefined
myFunc(): window.n1= undefined
```

![](https://i.imgur.com/FKU24ly.png)  
(Source: [網路](https://vignette.wikia.nocookie.net/evchk/images/e/ec/2471912.jpg/revision/latest?cb=20171012125530))

還是印得出來，雖然不再是 Global 變數，但看起來是 Function Level Scope，而不是上面所描述的 Block Scope。

到底怎麼回事？

## 對，傳統 JavaScript 只有 Global 和 Function 兩種等級的作用域

![](https://i.imgur.com/GLkuwLF.png)  
(Source: [Youtube](https://www.youtube.com/watch?v=o9US59aO71s))

剛剛一大段 Block Scope 都在講辛酸的嗎？

放心，都找了舞棍阿伯出來站台，怎麼可能是假的。

確實**在 ES5 以前，用 `var` 關鍵字去宣告的變數，只會有 Global Level 和 Function Level 兩種等級的作用域**。

**ES6 導入了新的變數宣告關鍵字：`let` 和 `const`，不僅提高變數控管的嚴謹性，也增加了 Block Scope 的用途**。

明天後面的文章我們就來介紹 ES6 的 `let` 和 `const`。

## References
* [W3Schools - JavaScript Scope](https://www.w3schools.com/js/js_scope.asp)
