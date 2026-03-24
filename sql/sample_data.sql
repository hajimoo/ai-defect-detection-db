INSERT INTO users (email, password_hash, role)
VALUES
('user1@test.com', 'hashed_pw_1', 'user'),
('admin@test.com', 'hashed_pw_admin', 'admin');

INSERT INTO uploaded_images (user_id, original_filename, stored_path)
VALUES
(1, 'sample1.jpg', '/data/sample1.jpg'),
(1, 'sample2.jpg', '/data/sample2.jpg');

INSERT INTO predictions (image_id, user_id, label, confidence, status)
VALUES
(1, 1, 'normal', 0.95, 'success'),
(2, 1, 'defect', 0.52, 'pending');

INSERT INTO review_queue (prediction_id, review_status)
VALUES
(2, 'pending');

INSERT INTO dataset_candidates (prediction_id, is_dataset_candidate)
VALUES
(2, 1);

INSERT INTO request_logs (user_id, prediction_id, request_id, status_code)
VALUES
(1, 1, 'REQ-001', 200),
(1, 2, 'REQ-002', 200);

INSERT INTO error_logs (request_log_id, error_message)
VALUES
(2, 'Low confidence detected');
