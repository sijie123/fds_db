/* Data for db population */

\i data/userdata.sql
\i data/riderdata.sql
\i data/locationdata.sql
\i data/restaurantfooddata.sql
\i data/promotiondata.sql
\i data/orderreviewrating_completed.sql
\i data/orderreviewrating_ongoing.sql

CREATE OR REPLACE FUNCTION initRiderStats()
RETURNS VOID AS $$
declare
    orderdate   RECORD;
begin
    FOR orderdate in (
        SELECT      week, month, year
        FROM        parseOrdersDate() OD
        GROUP BY    (OD.week, OD.month, OD.year)
    ) LOOP
        PERFORM updatePartTimeRiderStats(MAKE_TIMESTAMP(orderdate.year, orderdate.month, orderdate.week * 7, 0, 0, 0));
        PERFORM updateFullTimeRiderStats(MAKE_TIMESTAMP(orderdate.year, orderdate.month, 1, 0, 0, 0));
    END LOOP;
end
$$ language plpgsql;
SELECT initRiderStats();
