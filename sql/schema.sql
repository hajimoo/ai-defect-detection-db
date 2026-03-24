CREATE TABLE users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE uploaded_images (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL,
    original_filename VARCHAR(255),
    stored_path VARCHAR(500),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE predictions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    image_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    label VARCHAR(100),
    confidence DECIMAL(5,4),
    status ENUM('success', 'failed', 'pending'),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (image_id) REFERENCES uploaded_images(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE review_queue (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    prediction_id BIGINT UNIQUE,
    review_status ENUM('pending', 'reviewed', 'rejected'),
    human_label VARCHAR(100),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prediction_id) REFERENCES predictions(id)
);

CREATE TABLE dataset_candidates (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    prediction_id BIGINT UNIQUE,
    is_dataset_candidate TINYINT(1),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (prediction_id) REFERENCES predictions(id)
);

CREATE TABLE request_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT,
    prediction_id BIGINT,
    request_id VARCHAR(100),
    status_code INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (prediction_id) REFERENCES predictions(id)
);

CREATE TABLE error_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_log_id BIGINT,
    error_message VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_log_id) REFERENCES request_logs(id)
);
