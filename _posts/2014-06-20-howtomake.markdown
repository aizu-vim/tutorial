---
layout: post
title:  "How To Make Vim Plugin ~Aizu.vim #2~"
date:   2014-06-20 00:00:00
categories: vim 
---


ここでは基本的なVim pluginの作り方を説明します.  
作成にあたって必要なこともまとめます.  
また、ここだけではなく、Vimの組み込みヘルプファイルも参照してみてください.  
[`:help plugin`](http://vim-jp.org/vimdoc-ja/usr_05.html#05.4)  
日本語は[vimdoc-ja](http://vim-jp.org/vimdoc-ja/)を参照するか、これのpluginをインストールしてください.  
**あまり細かいことは言わずに、とりあえず作ってみる方針で書いています.**  
のでおかしな所があれば言ってくれるととてもうれしいです.  


*****


### Vim plugin とは
* **Vimをよりパワフルにし、さらなる機能を提供してくれるもの.**


*********


### Vim plugin の種類
普段は, ただpluginと言って一口にまとめて言っていますが、 pluginにもいくつかの種類があります.  
私の独断ですが、大まかにまとめてみました.

- Vim plugin
    - global 
        - command
        - operator
        - text-obj
        - etc...
    - fileType 
        - indent 
        - syntax 

大体こんな感じだと思います.  
多く作られているのがglobal属のpluginですね.  
中でもテキストオブジェクト系なんかはすごく便利なので積極的に入れていきたいです.  
filetype属のpluginでは、Vimが標準でサポートしていない言語のインデントやシンタックスハイライトを追加するときに使用されます.


******


### Vim plugin を作るために
Vim pluginはもちろんVim scriptで書かれます.  
ですが、Vimはいくつかの言語と連携できるのでscript以外でも書くことが可能です.  
Python, Ruby, Lua, Perlなどなどあります.  
しかし、デフォルトで連携可能になっているわけではないので極力Vim scriptで書くことをおすすめします。  
以降ではVim scriptのみ、また、上項のglobal属を前提としていきます.


******


### Vim script を書く
Vim plugin を書くにあたってをさらっと以下に記します.  
Vimのhelpは充実しているので、わからないことや詳細を知りたければそちらを参照して欲しいです.  
これらを使って、自分の書いたscriptをユーザに呼び出してもらうわけです.  

とりあえず、コマンドの定義です.  
{% highlight vim %}

:command! Hoge echo "Hoge"

{% endhighlight %}
これで
{% highlight vim %}

:Hoge
"-> 'Hoge'

{% endhighlight %}
こんな感じにコマンドが使用出来るようになります.  
と言ってもステータス行に'Hoge'と表示されるだけです.  
  
これだけではインタラクティブでは無いですね.  
ですので、以下のようにして、ユーザの入力を受け取ります.  
{% highlight vim %}

function! DoIt(arg1, arg2)
    echomsg string(a:arg1) . string(a:arg2)
endfunction
command! -nargs=* ExecuteHoge call DoIt(<f-args>)

{% endhighlight %}
このようにコマンドを定義すると
{% highlight vim %}

:ExecuteHoge nantoka kantoka
"-> 'nantoka''kantoka'

{% endhighlight %} 
ユーザからの入力が取れます.  
さらなる詳細は[`:help command`](http://vim-jp.org/vimdoc-ja/map.html#user-commands)を参照ください.  
  
他にもマッピングを定義したほうが便利な時もあります.  
しかし、デフォルトで決め打ちのマッピングにすると、すでにユーザが使っているかもしれません.  
なので、ユーザが自分でマップ出来るようにしましょう.  
{% highlight vim %}

nnoremap <Plug>(sample-sugoi) :call DoIt('sugoi', 'kanari')<CR>
nmap <Leader>sg <Plug>(sample-sugoi)
"-> 'sugoi''kanari'

{% endhighlight %} 
`<Plug>(sample-sugoi)`のように、先頭に`<Plug>`をつけるとキーボードから入力されないことが保証されます.  
なので、次の行のようにもう一段階マッピングして、ユーザに好きなマップを使用してもらうわけです.  
さらなる詳細は[`:help mapping`](http://vim-jp.org/vimdoc-ja/map.html#user-commands)を参照ください.  


*******


### Vim plugin を書く前に
Vim pluginはVim scriptの集合ではありますが、 ディレクトリ構成が決まっています.
pluginを書く前にそれらを見ていきます.  
  
nantoka pluginを例とします.  

- nantoka_plugin/
    - autoload/
        - nantoka.vim
        - nantoka/
            - utils.vim
    - doc/
        - nantoka.txt
        - nantoka.jax
    - plugin/
        - nantoka.vim
  
まず、pluginのルートディレクトリは`nantokaディレクトリ`になります.  
pluginを有効にするには.vimrcにてオプション`runtimepath`にルートディレクトリを設定します.  
{% highlight vim %}

" 既存の値を消さないために=ではなく+=であることに注意.
set runtimepath+=/home/mopp/vim_plugins/nantoka_plugin/

{% endhighlight %}
こうしておくと、nantoka_pluginが使用出来るようになります.  

さて、ルートディレクトリ内には`autoloadディレクトリ`, `docディレクトリ`, `pluginディレクトリ`の3つがあります.
それぞれ、役割あるのそれぞれ見ていきます.  

**pluginディレクトリ**  
    plugin script用のディレクトリです.  
    ここにVim scriptを書き記したファイルを入れておくと起動時にVimが読み込んでくれます.  
    ですので、先に紹介したコマンドやマッピングの定義はここで行いましょう.  
  
**autoloadディレクトリ**  
    ここには"呼びだされた時に通り自動的に読み込んでほしい関数"を定義したファイルをおいておきます.  
    pluginディレクトリは起動時にすべてのファイルが読み込まれます.  
    当然、関数が大きく、たくさん定義されていれば読み込みには時間がかかってしまいます.  
    これはVimmer(特にCUI派)にとって由々しき事態です.  
    それを回避するために、初期化処理以外を出来る限りautoloadディレクトリに置くべきです.  
    そして、その関数の定義は通常のものと区別するために少しだけ違います.  
    また、名前空間的な役割も持っています.  
    詳しくは[`:help write-library-script`](http://vim-jp.org/vimdoc-ja/usr_41.html#41.15)を参照してください.  

**docディレクトリ**  
    名前から大体想像がつくと思いますが、pluginのドキュメントファイルをおいておきます.  
    この例だと`help nantoka`というふうに参照されます.  
    txtファイルが通常のヘルプ(英語)でjaxが日本語のヘルプファイルになります.  
    詳しくは[`:help write-local-help`](http://vim-jp.org/vimdoc-ja/usr_41.html#write-local-help)を参照してください.  


******


### Vim plugin を書く
[`:help plugin`](http://vim-jp.org/vimdoc-ja/usr_05.html#05.4)にもあるような感じに、適当なサンプルpluginを見て行きましょう.  
  
サンプルはこいつです.  
**[mopp/shinchoku.vim](https://github.com/mopp/shinchoku.vim)**

以前、ノリで作ったものです.  
ディレクトリ構成は前項にならってます.  

- shinchoku.vim/
    - autoload/
        - shinchoku.vim
    - plugin/
        - shinchoku.vim
    - README.md

README.mdには最低限の説明を書いておくといいでしょう<s>(ドキュメントを書くのがめんどいので)</s>  
  
{% highlight vim %}
if exists('g:loaded_shinchoku')
    finish
endif
let g:loaded_shinchoku = 1

let s:save_cpo = &cpo
set cpo&vim


augroup shinchoku
    autocmd!
    autocmd CursorHold,CursorHoldI * call shinchoku#echo_shinchoku()
    autocmd CursorHold,CursorHoldI * call shinchoku#ask_shinchoku()
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
{% endhighlight %}

頭の方から説明していきましょう.  
`if exists('g:loaded_shinchoku')`から始まる先頭4行はこのscriptファイルの多重読み込み防止用に書いておきます.  
`cpo`関連は互換オプションの設定です、以降のscriptで変更があるかもしれないので保存しておきます.  
ここまではテンプレのようなものです.  
  
続いて、オートコマンドを定義します.  
ここでも、普通はplugin名でいいと思いますがオートグループ名はかぶりにくいものにしましょう.  
  
さて、このオートコマンドでは`call shinchoku#echo_shinchoku()`と、関数を呼び出しています.  
これが先に説明した、autoloadの関数です.  
autoload関数の名前は、#の前が読み込むファイル名、それに続いて、関数名となっています.  
この例ではautoload内の`shinchoku.vim`というが関数呼び出し時に、読み込まれていなければ読み込まれて、から関数が実行されます.  
次に、そのautoload関数の定義を見てみましょう.  
{% highlight vim %}
let s:save_cpo = &cpo
set cpo&vim


let g:shinchoku#say_command = get(g:, 'shinchoku#say_command', '')

let s:is_shaberu = exists(':ShaberuSay') == 2 ? 1 : 0
let s:shinchoku_str = '進捗どうですか'
let s:no_shinchoku_counter = 0

function! s:say_shinchoku()
    execute "ShaberuSay" s:shinchoku_str
endfunction

function! shinchoku#echo_shinchoku()
    let s:no_shinchoku_counter += 1

    if s:no_shinchoku_counter % 2 == 0
        let s:shinchoku_str .= '!'
    endif

    echomsg s:shinchoku_str
endfunction


function! shinchoku#ask_shinchoku()
    if s:is_shaberu != 1
        return
    endif

    if g:shinchoku#say_command != ''
        let store = g:shaberu_user_define_say_command
        let g:shaberu_user_define_say_command = g:shinchoku#say_command
        call s:say_shinchoku()
        let g:shaberu_user_define_say_command = store
    else
        call s:say_shinchoku()
    endif
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
{% endhighlight %}

`function! shinchoku#echo_shinchoku()`のように`ファイル名#関数名`として定義します.  
短いpluginなのでこのくらいの説明で問題ないと思います.  
  
こんな感じでpluginを書いていきましょう.  


******


### 参考
[モテる男のVim Script短期集中講座](http://mattn.kaoriya.net/software/vim/20111202085236.htm)  
[Vimスクリプト基礎文法最速マスター](http://d.hatena.ne.jp/thinca/20100201/1265009821)  


