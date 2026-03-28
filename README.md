# CNN Defect Detection — Database Design

製造業向け **欠陥検出AIシステム** のデータベース設計リポジトリです。

単なる推論結果の保存にとどまらず、**SaaS型AIサービスの運用・分析・品質改善・再学習データ管理**までを考慮した設計になっています。

---

## Overview

| 目的 | 内容 |
|------|------|
| 推論結果管理 | CNN推論結果の保存・追跡 |
| ログ管理 | APIリクエスト・エラーログの記録 |
| 品質改善 | ヒューマンレビューによるフィードバック |
| 再学習支援 | 再学習用データ候補の収集・管理 |
| 性能分析 | モデル性能分析の基盤構築 |

---

## Core Tables

| Table | Description |
|-------|-------------|
| `users` | ユーザー管理 |
| `uploaded_images` | アップロード画像管理 |
| `predictions` | AI推論結果 |
| `review_queue` | レビュー対象管理 |
| `dataset_candidates` | 再学習候補管理 |
| `request_logs` | APIリクエストログ |
| `error_logs` | エラーログ |

---

## Key Design Decisions

### 1. predictions を中心テーブルとした理由

本システムでは **画像ではなく推論結果（prediction）を中心** として設計しています。

- 同一画像でも **モデルバージョン変更・再推論** により結果が変わる可能性がある
- モデル性能分析は **prediction 単位** で行う必要がある
- レビュー対象や再学習候補は **特定の推論結果に対して判断される**

そのため uploaded_images ではなく predictions を中心としたデータモデルとしています。

---

### 2. review_queue を分離した理由

すべての推論結果が人手レビュー対象になるわけではありません。レビュー対象は主に以下のケースです。

- 低信頼度予測
- モデル検証対象
- 誤検知疑い

そのため、レビュー対象のみを管理する **ワークフローキュー（review_queue）** を分離しています。

**メリット**
- `predictions` テーブルの肥大化防止
- レビュー対象の高速抽出
- 将来的なレビュー機能拡張が容易

---

### 3. ログテーブルを分離した理由

ログは用途に応じて2種類に分けて管理しています。

#### `request_logs` — APIリクエスト履歴

| 保存情報 | 用途 |
|----------|------|
| `endpoint` / `method` / `status_code` | API利用統計・SLA監視 |
| `latency_ms` | レイテンシ分析 |
| `client_ip` | クライアント追跡 |

#### `error_logs` — エラーイベント詳細

| 保存情報 | 用途 |
|----------|------|
| `error_code` / `error_message` | エラー頻度分析 |
| `error_detail` | 障害原因の詳細調査 |

この分離により、**正常リクエスト分析**と**障害分析**を独立して効率的に行えます。

---

### 4. `status` カラムの必要性

`predictions` テーブルには推論処理状態を管理する `status` カラムを設けています。

```
pending → success / failed / review_needed
```

`confidence` や `label` が NULL かどうかだけでは処理状態を正確に判断できないため、**明示的な状態管理**を行っています。

- 推論処理が非同期で実行される可能性への対応
- 推論失敗の明確な記録
- レビュー対象の自動判定

---

## Data Flow

```
1. 画像アップロード
   └─ uploaded_images にメタデータ保存

2. 推論リクエスト
   └─ predictions 作成（status = 'pending'）

3. モデル推論実行（CNN）

4. 推論結果保存
   ├─ 成功: status = 'success', label, confidence
   └─ 失敗: status = 'failed', failure_reason

5. 低信頼ケース検出
   └─ is_low_confidence = true → review_queue に登録

6. 人手レビュー
   └─ review_status, human_label を保存

7. 再学習候補選定
   └─ dataset_candidates に登録
```

---

## ERD

```
docs/erd.md
```

---

## SQL Files

| File | Description |
|------|-------------|
| `schema.sql` | テーブル定義 |
| `indexes.sql` | インデックス定義 |
| `sample_data.sql` | サンプルデータ |
| `views.sql` | 分析用ビュー |

---

## Database Setup

```bash
# 1. MySQLコンテナ起動
docker start mysql-container

# 2. スキーマ適用
docker exec -i mysql-container mysql -u root -p < sql/schema.sql

# 3. インデックス適用
docker exec -i mysql-container mysql -u root -p < sql/indexes.sql

# 4. サンプルデータ投入（任意）
docker exec -i mysql-container mysql -u root -p < sql/sample_data.sql

# 5. ビュー作成（任意）
docker exec -i mysql-container mysql -u root -p < sql/views.sql
```

---

## Future Improvements

### Review Queue Concurrency Control
レビューの同時処理防止のため以下を追加予定
- `assigned_reviewer_id`
- `locked_at`
- `review_status = 'in_progress'`

### Composite Index Optimization
クエリパターンに基づく複合インデックス
```sql
(user_id, created_at)
(status, created_at)
(review_status, created_at)
```

### Model Performance Analytics
- モデルバージョン比較
- 誤検知分析
- 信頼度分布分析
- データセット品質分析

---

## Related Projects

- Defect Detection API (FastAPI)
- CNN モデル推論システム
- Defect Detection Frontend (React)

---

## Summary

本データベース設計は **推論結果管理 / レビュー管理 / 再学習データ生成 / 運用ログ監視** を統合的に扱う **AI運用基盤データモデル**です。
