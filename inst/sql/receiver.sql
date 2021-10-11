/* Receivers with controlled status */
SELECT
  *,
  CASE
    WHEN status = 'Active' THEN 'active'
    WHEN status = 'Available' OR status = 'available' THEN 'available'
    WHEN status = 'Broken' THEN 'broken'
    WHEN status = 'Inactive' THEN 'inactive'
    WHEN status = 'Lost' THEN 'lost'
    WHEN status = 'Returned to manufacturer' THEN 'returned'
  END AS controlled_status
FROM
  acoustic.receivers_limited
