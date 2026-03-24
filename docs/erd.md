# ERD (Entity Relationship Diagram)

このデータベースは **CNN欠陥検出システム** における推論結果管理、ログ管理、レビュー、再学習データ生成を目的として設計されています。以下は GitHub Markdown に適した整理済みの内容です。

---

##  ER図（Mermaid）

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
        TINYINT is_active
        DATETIME created_at
        DATETIME updated_at
    }

    UPLOADED_IMAGES {
        BIGINT id PK
        BIGINT user_id FK
        VARCHAR original_filename
        VARCHAR stored_path
        VARCHAR mime_type
        BIGINT file_size
        CHAR file_hash
        INT width
        INT height
        DATETIME created_at
    }

    PREDICTIONS {
        BIGINT id PK
        BIGINT image_id FK
        BIGINT user_id FK
        VARCHAR model_version
        VARCHAR label
        DECIMAL confidence
        ENUM status
        TINYINT is_low_confidence
        TEXT failure_reason
        VARCHAR similar_case_group
        DATETIME created_at
        DATETIME updated_at
    }

    REVIEW_QUEUE {
        BIGINT id PK
        BIGINT prediction_id FK
        ENUM review_status
        VARCHAR human_label
        TEXT ai_review_summary
        TEXT ai_review_recommendation
        DATETIME reviewed_at
        DATETIME created_at
    }

    DATASET_CANDIDATES {
        BIGINT id PK
        BIGINT prediction_id FK
        TINYINT is_dataset_candidate
        VARCHAR candidate_reason
        ENUM candidate_status
        DATETIME created_at
        DATETIME updated_at
    }

    REQUEST_LOGS {
        BIGINT id PK
        BIGINT user_id FK
        BIGINT prediction_id FK
        VARCHAR request_id
        VARCHAR endpoint
        VARCHAR method
        VARCHAR client_ip
        INT status_code
        INT latency_ms
        DATETIME created_at
    }

    ERROR_LOGS {
        BIGINT id PK
        BIGINT request_log_id FK
        VARCHAR error_code
        VARCHAR error_message
        TEXT error_detail
        DATETIME created_at
    }
```

---

## 関係説明
- ユーザーは複数の画像をアップロード可能  
- ユーザーは複数の推論を実行可能  
- 1つの画像に対して複数の推論が可能  
- 推論結果はレビュー対象として登録される場合がある  
- 推論結果は再学習データ候補として登録される場合がある  
- ユーザーは複数のAPIリクエストを送信可能  
- リクエストログはエラーログと関連付けられる  

---

## 設計の特徴
- **推論結果を中心とした構造**  
- **ログとビジネスデータの分離**  
- **品質改善（レビュー・再学習）を考慮**  
- **SaaS型運用を想定した設計**  
- **将来的な分析項目の拡張を考慮**  

