CNN Defect Detection Database Design

本リポジトリは、製造業向け 欠陥検出AIシステム（CNN Defect Detection System） における
データベース設計をまとめたものです。

単なる推論結果の保存ではなく、
SaaS型AIサービスの運用・分析・品質改善・再学習データ管理までを考慮した構造になっています。

Overview

本データベースは以下の機能を支援することを目的として設計されています。

CNN推論結果の保存
APIリクエストログ管理
エラーログ管理
ヒューマンレビュー管理
再学習データ候補管理
モデル性能分析

単なる推論結果保存ではなく、
AIサービスの運用基盤となるデータモデルとして設計しています。

Goals

本設計の主な目的は以下の通りです。

推論結果の管理
APIログおよびエラーログの追跡
ヒューマンレビューによる品質改善
再学習用データの収集
モデル性能分析の基盤構築
Core Tables
Table	Description
users	ユーザー管理
uploaded_images	アップロード画像管理
predictions	AI推論結果
review_queue	レビュー対象管理
dataset_candidates	再学習候補管理
request_logs	APIリクエストログ
error_logs	エラーログ
Key Design Decisions
1. predictions を中心テーブルとした理由

本システムでは 画像ではなく推論結果（prediction）を中心 として設計しています。

理由は以下の通りです。

同一画像でも モデルバージョン変更や再推論 により結果が変わる可能性がある
モデル性能分析は prediction単位 で行う必要がある
レビュー対象や再学習候補は 特定の推論結果に対して判断される

そのため、uploaded_images ではなく
predictions を中心としたデータモデルとしています。

2. review_queue を分離した理由

すべての推論結果が人手レビュー対象になるわけではありません。

レビュー対象は主に以下のケースです。

低信頼度予測
モデル検証対象
誤検知疑い

そのためレビュー対象のみを管理する
ワークフローキュー（review_queue） を分離しています。

メリット

predictions テーブルの肥大化防止
レビュー対象の高速抽出
将来的なレビュー機能拡張
3. ログテーブルを分離した理由

ログは以下の2種類に分けて管理しています。

request_logs

すべてのAPIリクエスト履歴

用途

API利用統計
レイテンシ分析
SLA監視

保存情報

endpoint
method
status_code
latency_ms
client_ip
error_logs

エラーイベントの詳細記録

用途

障害原因分析
エラー頻度分析
詳細エラーログ保存

保存情報

error_code
error_message
error_detail

この分離により

正常リクエスト分析
障害分析

を効率的に行うことができます。

4. status カラムの必要性

predictions テーブルには推論処理状態を管理する
status カラムを設けています。

例

pending
success
failed
review_needed

このカラムを設けた理由

推論処理が 非同期で実行される可能性
推論失敗の明確な記録
レビュー対象判定

confidence や label が NULL かどうかだけでは
処理状態を正確に判断できないため
明示的な状態管理 を行っています。

Data Flow

本システムにおける基本的な処理フローは以下の通りです。

1. 画像アップロード

ユーザーが画像をアップロード

↓

uploaded_images にメタデータ保存

2. 推論リクエスト

predictions レコード作成

status = 'pending'
3. モデル推論実行

CNNモデルによる推論実行

4. 推論結果保存

成功時

status = 'success'
label
confidence

失敗時

status = 'failed'
failure_reason
5. 低信頼ケース検出

信頼度が閾値以下の場合

is_low_confidence = true

↓

review_queue に登録

6. 人手レビュー

レビュー結果保存

review_status
human_label
7. 再学習候補選定

レビュー結果を基に

dataset_candidates に登録

ERD

ER図は以下を参照してください。

docs/erd.md
SQL Files
File	Description
schema.sql	テーブル定義
indexes.sql	インデックス定義
sample_data.sql	サンプルデータ
views.sql	分析用ビュー
Database Setup
1. MySQLコンテナ起動
docker start mysql-container
2. スキーマ適用
docker exec -i mysql-container mysql -u root -p < sql/schema.sql
3. インデックス適用
docker exec -i mysql-container mysql -u root -p < sql/indexes.sql
4. サンプルデータ投入（任意）
docker exec -i mysql-container mysql -u root -p < sql/sample_data.sql
5. ビュー作成（任意）
docker exec -i mysql-container mysql -u root -p < sql/views.sql
Future Improvements

今後の改善案

Review Queue Concurrency Control

レビューの同時処理防止

追加予定カラム

assigned_reviewer_id
locked_at
review_status = in_progress
Composite Index Optimization

クエリパターンに基づく複合インデックス

例

(user_id, created_at)
(status, created_at)
(review_status, created_at)
Model Performance Analytics

将来的に以下の分析機能を追加予定

モデルバージョン比較
誤検知分析
信頼度分布分析
データセット品質分析
Related Projects
Defect Detection API (FastAPI)
CNNモデル推論システム
Defect Detection Frontend (React)
Summary

本データベース設計は

推論結果管理
レビュー管理
再学習データ生成
運用ログ監視

を統合的に管理することを目的とした
AI運用基盤データモデルです。
