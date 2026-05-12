# memo_app

## 概要

簡易的なメモ管理ができるアプリです。<br>
メモの作成・編集・削除等の基本機能を備えています。

## 機能

- メモの一覧表示
- メモの新規作成
- メモの編集
- メモの削除

## インストール方法

1. 任意のディレクトリにてリポジトリをクローンします。

```bash
$ git clone -b feature/add-postgresql https://github.com/nswdry/memo_app.git
```

2. ディレクトリに移動します。

```bash
$ cd memo_app
```

3. PostgreSQLをインストールし、起動させます。

```bash
$ brew install postgresql

$ brew services start postgresql
```

4. 必要なgemをインストールします。

```bash
$ bundle install
```

5. DBを作成します。

```bash
$ createdb memo_app
```

## 使用技術

- Ruby 3.4.8
- Sinatra
- WEBrick
- PostgreSQL

## アプリの起動

1. 以下のコマンドでアプリを起動します。

```bash
$ bundle exec ruby app.rb
```

2. ブラウザで以下にアクセスします。<br>
   http://localhost:4567

## 操作方法

1. 「追加」ボタンからメモを新規作成
2. 各メモの「編集」ボタンで内容を変更
3. 各メモの「削除」ボタンでメモを削除

## DDL文

```sql
CREATE TABLE IF NOT EXISTS memos (
  id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title TEXT NOT NULL,
  content TEXT NOT NULL
);
```
