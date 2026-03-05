WITH FunnelBase AS (
    SELECT
        COUNT(DISTINCT CASE WHEN event_type = 'view' THEN user_session END) AS total_view_sessions,
        COUNT(DISTINCT CASE WHEN event_type = 'cart' THEN user_session END) AS total_cart_sessions,
        COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_session END) AS total_purchase_sessions
    FROM fiery-chess-489213-b0.ecommerce_data.raw_events
)

SELECT
    total_view_sessions,
    total_cart_sessions,
    total_purchase_sessions,
    -- Calculate the conversion rates
    ROUND((total_cart_sessions / NULLIF(total_view_sessions, 0)) * 100, 2) AS view_to_cart_percent,
    ROUND((total_purchase_sessions / NULLIF(total_cart_sessions, 0)) * 100, 2) AS cart_to_purchase_percent,
    ROUND((total_purchase_sessions / NULLIF(total_view_sessions, 0)) * 100, 2) AS overall_conversion_percent
FROM FunnelBase;