SELECT 
    user_session,
    MAX(user_id) AS user_id,
    
    -- Feature 1: How active were they?
    COUNT(*) AS total_events_in_session,
    
    -- Feature 2 & 3: What exactly did they do?
    SUM(CASE WHEN event_type = 'view' THEN 1 ELSE 0 END) AS total_views,
    SUM(CASE WHEN event_type = 'cart' THEN 1 ELSE 0 END) AS total_cart_adds,
    
    -- Feature 4: How long did they stay on the site?
    TIMESTAMP_DIFF(MAX(event_time), MIN(event_time), SECOND) AS session_duration_seconds,
    
    -- THE TARGET VARIABLE: Did this session end in a purchase? (1 = Yes, 0 = No)
    MAX(CASE WHEN event_type = 'purchase' THEN 1 ELSE 0 END) AS made_purchase

FROM fiery-chess-489213-b0.ecommerce_data.raw_events
WHERE user_session IS NOT NULL
GROUP BY user_session

-- We put a limit here just to test it quickly. We will remove it later!
LIMIT 1000;