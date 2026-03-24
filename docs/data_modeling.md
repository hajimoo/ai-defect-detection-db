# データモデル設計

## 1. 概要

本システムは、CNNによる欠陥検出モデルの推論結果を管理するだけでなく、
SaaS型AIサービスとしての運用・分析・品質改善・再学習データ生成を目的としたデータモデルを設計する。

---

## 2. 設計方針

* データの正規化による冗長性の排除
* 推論結果を中心とした構造設計
* ログおよび障害追跡の分離
* レビューおよび再学習フローのデータ化
* 将来的な拡張性の確保

---

## 3. エンティティ構成

### users

ユーザー情報を管理する。

### uploaded_images

アップロードされた画像のメタ情報を管理する。

### predictions

AI推論結果を管理する中核テーブル。

### review_queue

低信頼または検証対象の予測を管理する。

### dataset_candidates

再学習に使用するデータ候補を管理する。

### request_logs

APIリクエスト履歴を記録する。

### error_logs

エラーおよび障害情報を記録する。

---

## 4. リレーション

* users : predictions = 1:N
* users : uploaded_images = 1:N
* uploaded_images : predictions = 1:N
* predictions : review_queue = 1:0..1
* predictions : dataset_candidates = 1:0..1
* request_logs : error_logs = 1:N

---

## 5. 拡張フィールド

将来的な分析およびAI補助機能を考慮し、以下のフィールドを設計に含める。

* ai_review_summary
* ai_review_recommendation
* is_low_confidence
* failure_reason
* similar_case_group

---

## 6. 活用例

* 誤検知分析
* モデル精度改善
* 低信頼ケースの抽出
* 再学習データ生成
* システム運用監視
