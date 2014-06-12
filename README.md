# チュートリアル関連

[![Build Status](https://travis-ci.org/aizu-vim/tutorial.svg?branch=wip%2Ftravis)](https://travis-ci.org/aizu-vim/tutorial)

## ブランチについて

* `master`: このブランチの内容が gh-pages に反映される
* `gh-pages`: このブランチは bot によって自動的に更新される（.travis.yml 参照）

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

