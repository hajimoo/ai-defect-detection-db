# CNN Defect Detection Database Design

本リポジトリは、製造業向け欠陥検出AIシステムにおけるデータベース設計をまとめたものです。

単なる推論結果の保存ではなく、SaaS型サービスとしての運用・分析・品質改善・再学習データ管理までを考慮した構造になっています。

---

## 目的

本設計の目的は以下の通りです：

* 推論結果の管理
* APIログおよびエラーログの追跡
* ヒューマンレビューによる品質改善
* 再学習用データの収集
* モデル性能分析の基盤構築

---

##  主なテーブル

| Table              | Description |
| ------------------ | ----------- |
| users              | ユーザー管理      |
| uploaded_images    | アップロード画像管理  |
| predictions        | 推論結果管理      |
| request_logs       | APIリクエストログ  |
| error_logs         | エラーログ       |
| review_queue       | レビュー対象管理    |
| dataset_candidates | 再学習候補データ    |

---

##  ERD

ER図は以下を参照してください：

* `docs/erd.md`


---

##  データモデル設計

詳細な設計内容は以下に記載しています：

* `docs/data_modeling.md`

---

## SQL構成

| File            | Description |
| --------------- | ----------- |
| schema.sql      | テーブル定義      |
| indexes.sql     | インデックス定義    |
| sample_data.sql | サンプルデータ     |
| views.sql       | 分析用ビュー      |

---

## 特徴

本データベース設計は以下の点を重視しています：

### 1. トレーサビリティ

どのユーザーがどの画像をアップロードし、どの予測結果が生成されたか追跡可能

### 2. 品質改善ループ

低信頼予測 → レビュー → 再学習候補 という流れをデータで管理

### 3. 運用監視

リクエストログ・エラーログによりシステムの状態を可視化

### 4. 拡張性

AIレビュー、類似ケース分析、モデルバージョン管理などへの拡張を考慮


---

## 関連プロジェクト

* [Defect Detection API (FastAPI)](https://github.com/hajimoo/defect-detection-api/tree/main)  
* [CNNモデル推論システム](https://github.com/hajimoo/cnn-manufacturing-defect)  
* [Defect Detection frontend(Reatct)](https://github.com/hajimoo/defect-detection-frontend) 

