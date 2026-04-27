# MVVM構成ガイド（初学者向け）

このドキュメントは、現在のプロジェクト構成に合わせて「どこに何を書くか」を迷わないためのガイドです。  
迷ったときは、まず「そのコードは UI か、状態管理か、データ保存か」を考えると整理しやすいです。

## 現在のフォルダ構成

```text
lib/
├── main.dart
├── app_router.dart
├── models/
│   ├── task.dart
│   ├── preset.dart
│   ├── data/
│   │   ├── database.dart
│   │   └── database.g.dart
│   └── repositories/
│       ├── task_repository.dart
│       └── preset_repository.dart
├── view_models/
│   ├── home_view_model.dart
│   ├── history_view_model.dart
│   ├── preset_view_model.dart
│   └── settings_view_model.dart
└── views/
    ├── pages/
    ├── dialogs/
    └── widgets/
```

## 各フォルダの役割と、追加するときの目安

### `lib/main.dart`

- 役割: アプリの起動入口（`runApp`）と、全体の初期設定（`ProviderScope` など）
- ここに書くもの:
  - アプリ起動に必須の最小設定
  - グローバルな依存注入の初期化
- ここに書かないもの:
  - 画面ごとのロジック
  - CRUD 処理や業務ロジック
  - デバッグ専用の処理（必要なら別ファイルへ）

### `lib/app_router.dart`

- 役割: 画面遷移（ルーティング）の定義をまとめるファイル
- ここに書くもの:
  - `GoRouter` のルート一覧
  - タブ構成（`StatefulShellRoute`）や画面への遷移設定
- ここに書かないもの:
  - DBアクセス
  - ビジネスロジック（集計、CRUDなど）
- 新規追加・編集するタイミング:
  - 新しい画面を追加して、遷移先を増やしたいとき
  - タブ構成やURLパスを変更したいとき

### `lib/models/`

- 役割: 「アプリ内で扱うデータの形」を定義する場所（Model層）
- 例: `TaskModel`, `PresetModel`
- ここに書くもの:
  - フィールド定義
  - 純粋な変換・判定（UIやDBに依存しない処理）
- ここに書かないもの:
  - `BuildContext`, `Navigator`, `showDialog`
  - SQL実行、HTTP通信

#### `lib/models/data/`

- 役割: 永続化の実装（DBスキーマ・接続・マイグレーション）
- 例: `database.dart`, `database.g.dart`
- 新規ファイルを追加するタイミング:
  - 新しいテーブルを追加したい
  - マイグレーションを追加したい
- 補足:
  - `database.g.dart` は生成ファイルなので手動編集しない

#### `lib/models/repositories/`

- 役割: ViewModel から見た「データ操作の窓口」
- 例: `task_repository.dart`, `preset_repository.dart`
- 新規ファイルを追加するタイミング:
  - 新しいドメイン（例: `User`, `Project`）のCRUDが増えたとき
  - DB/APIの違いを ViewModel から隠したいとき
- 書く内容:
  - `watch/get/insert/update/delete` などのデータ操作
  - DBの型とアプリの型の変換

### `lib/view_models/`

- 役割: 画面の状態管理とイベント処理（MVVMのViewModel層）
- 例:
  - `home_view_model.dart`: ホーム画面のタスク追加・更新・削除
  - `history_view_model.dart`: 履歴表示用の集計
  - `preset_view_model.dart`: プリセット操作
  - `settings_view_model.dart`: 設定値の管理
- 新規ファイルを追加するタイミング:
  - 新しいページを作り、そのページ専用の状態/操作が必要なとき
- 書く内容:
  - Riverpod の `Provider` / `Notifier` / `StreamProvider`
  - UIイベントに対する操作メソッド（例: `addTask`, `deleteTask`）

### `lib/views/`

- 役割: 見た目（UI）を作る場所（MVVMのView層）
- 原則:
  - `ref.watch(...)` で状態を受け取り表示する
  - ユーザー操作時は ViewModel のメソッドを呼ぶ
  - DBやRepositoryを直接叩かない

#### `lib/views/pages/`

- 役割: 1画面全体を表すWidget
- 新規ファイル追加の例:
  - 新しいタブや画面を追加する（`profile_page.dart` など）

#### `lib/views/widgets/`

- 役割: 複数画面で使える再利用UI部品
- 新規ファイル追加の例:
  - タスクカード、サマリーカード、共通ボタンなどを共通化したいとき

#### `lib/views/dialogs/`

- 役割: 入力・確認のダイアログUI
- 新規ファイル追加の例:
  - 「作成」「編集」「削除確認」などモーダルを追加したいとき

## 実装時の判断フロー（迷ったらここ）

1. 画面の見た目を作る → `views`
2. 画面の状態やボタン押下時の処理を書く → `view_models`
3. DB保存/取得の処理を書く → `models/repositories`
4. テーブル定義やマイグレーションを触る → `models/data`
5. データの型だけ定義する → `models`

## 命名のおすすめ

- ファイル名は責務がわかる名前にする
  - `xxx_page.dart`（画面）
  - `xxx_view_model.dart`（状態管理）
  - `xxx_repository.dart`（データアクセス）
  - `xxx_model.dart` または `xxx.dart`（データ型）
- 用語は統一する（このプロジェクトでは `Task`）

## 今後の運用ルール（このプロジェクト向け）

- コード変更時に、関連ドキュメント（`lib/text`）も一緒に更新する
- フォルダ構成を変えたら、サンプルパスと説明文を同時に更新する
- 生成ファイル（`*.g.dart`）は手編集しない
