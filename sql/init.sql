/* Initialises empty db */

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

\i users.sql
\i riders.sql

\i restaurants.sql
\i food.sql
\i categories.sql
\i foodcategories.sql
\i promotions.sql

\i orders.sql
\i foodorders.sql
\i foodreviews.sql
\i deliveryratings.sql

\i locations.sql

\i util.sql

\i stats.sql