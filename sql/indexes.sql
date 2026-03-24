CREATE INDEX idx_predictions_user_id ON predictions(user_id);
CREATE INDEX idx_predictions_image_id ON predictions(image_id);
CREATE INDEX idx_predictions_status ON predictions(status);

CREATE INDEX idx_uploaded_images_user_id ON uploaded_images(user_id);

CREATE INDEX idx_request_logs_user_id ON request_logs(user_id);
CREATE INDEX idx_request_logs_created_at ON request_logs(created_at);

CREATE INDEX idx_error_logs_request_log_id ON error_logs(request_log_id);

CREATE INDEX idx_review_queue_status ON review_queue(review_status);
CREATE INDEX idx_dataset_candidates_flag ON dataset_candidates(is_dataset_candidate);
