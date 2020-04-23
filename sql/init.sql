/* Initialises empty db */

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

CREATE TABLE Users (
    username        VARCHAR(50),
    password        VARCHAR(50),
    token           VARCHAR(50),
    creationdate    DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (username)
);

\i customers.sql
\i staff.sql
\i riders.sql
\i managers.sql

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