CREATE VIEW vw_prediction_summary AS
SELECT
    p.id,
    p.label,
    p.confidence,
    p.status,
    u.email,
    ui.original_filename,
    rq.review_status,
    dc.is_dataset_candidate
FROM predictions p
JOIN users u ON p.user_id = u.id
JOIN uploaded_images ui ON p.image_id = ui.id
LEFT JOIN review_queue rq ON p.id = rq.prediction_id
LEFT JOIN dataset_candidates dc ON p.id = dc.prediction_id;
