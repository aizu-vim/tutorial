# チュートリアル関連

[![Build Status](https://travis-ci.org/aizu-vim/tutorial.svg?branch=master)](https://travis-ci.org/aizu-vim/tutorial)

## 方針

検討中...

* スライド
  * 各種チュートリアルはこの辺に
  * PDFとかも置けるようにする (TODO)
* ブログ
  * 更新履歴とかを適当にまとめる？

### 編集について

以下のファイル・ブランチ以外は自由に編集してもらって大丈夫です。

* .travis.yml ファイル
* `gh-pages` ブランチ

## ブランチについて

* `master`: このブランチの内容が gh-pages に反映される
* `gh-pages`: このブランチは bot によって自動的に更新される（.travis.yml 参照）

## URLについて

* `master`ブランチの内容を反映しているURL
  * `https://aizu-vim.github.io/tutorial/`
* そのほかのブランチ
  * `https://aizu-vim.github.io/tutorial/branches/{repo}/`


## ディレクトリについて

* `_`で始まるファイル・ディレクトリはGitHub Pagesに反映されない
* `_posts`: ブログ記事のソース
* `_slide`: スライドのソース

## ローカルで諸々を確認する手順

### 使用するツールをインストールする

* Ruby をインストールしておくこと

```
$ bundle install
```

### ブログを生成する

```
$ bundle exec jekyll server
-> 指定されたURLへブラウザからアクセス
```


### スライドを生成する

```
$ bundle exec slideshow build -o slide _slide
```


### 使用しているソフトウェアについて

* jekyll
  * http://jekyllrb.com/
* slideshow
  * https://github.com/slideshow-s9/slideshow

