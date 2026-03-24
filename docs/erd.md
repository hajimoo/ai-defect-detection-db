# ERD (Entity Relationship Diagram)

本データベースは、CNN欠陥検出システムにおける推論結果管理、ログ管理、レビュー、再学習データ生成を目的として設計されている。

---

## ER図（Mermaid）

```mermaid
erDiagram
    USERS ||--o{ UPLOADED_IMAGES : uploads
    USERS ||--o{ PREDICTIONS : runs
    UPLOADED_IMAGES ||--o{ PREDICTIONS : used_for
    PREDICTIONS ||--o| REVIEW_QUEUE : reviewed_in
    PREDICTIONS ||--o| DATASET_CANDIDATES : selected_as
    USERS ||--o{ REQUEST_LOGS : sends
    PREDICTIONS ||--o{ REQUEST_LOGS : related_to
    REQUEST_LOGS ||--o{ ERROR_LOGS : generates

    USERS {
        BIGINT id PK
        VARCHAR email
        VARCHAR password_hash
        ENUM role
        DATETIME created_at
    }

    UPLOADED_IMAGES {
        BIGINT id PK
        BIGINT user_id FK
        VARCHAR original_filename
        VARCHAR stored_path
        DATETIME created_at
    }

    PREDICTIONS {
        BIGINT id PK
        BIGINT image_id FK
        BIGINT user_id FK
        VARCHAR label
        DECIMAL confidence
        ENUM status
        DATETIME created_at
    }

    REVIEW_QUEUE {
        BIGINT id PK
        BIGINT prediction_id FK
        ENUM review_status
        VARCHAR human_label
    }

    DATASET_CANDIDATES {
        BIGINT id PK
        BIGINT prediction_id FK
        TINYINT is_dataset_candidate
    }

    REQUEST_LOGS {
        BIGINT id PK
        BIGINT user_id FK
        BIGINT prediction_id FK
        VARCHAR request_id
        INT status_code
        DATETIME created_at
    }

    ERROR_LOGS {
        BIGINT id PK
        BIGINT request_log_id FK
        VARCHAR error_message
        DATETIME created_at
    }
```

---

## 関係説明

* 1人のユーザーは複数の画像をアップロードできる
* 1人のユーザーは複数の推論を実行できる
* 1つの画像に対して複数の推論が可能
* 推論結果はレビュー対象として登録される場合がある
* 推論結果は再学習データ候補として登録される場合がある
* リクエストログはエラーログと関連付けられる

---

## 設計の特徴

* 推論結果を中心とした構造
* ログとビジネスデータの分離
* 品質改善（レビュー・再学習）を考慮
* SaaS型運用を想定した設計
