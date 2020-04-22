-- Creating a promotion:
-- 1) Decide on promotion code e.g. 'PROMOCODE'
-- 2) Create row in CodePromotions
-- 3) Create row in FDSPromotion/RestaurantPromotion
-- 4) Create function '_promo_<promocode>': INTEGER (orderid) -> boolean (success), e.g. '_promo_PROMOCODE'
--      This function should edit the Order row directly

-- Examples:
-- Restaraunt:  20% off for orders >= $100 in period
-- FDS:         10% for 1st time customers
-- FDS:         Free delivery in period
-- FDS:         

-- Ideas:
-- 1) hashmap rname/foodname/cat => discount
-- > Not general enough
-- 2) id maps to a function promo_id(): order -> order, find in pg_proc
-- > Probably works, dynamically call
-- >> https://stackoverflow.com/questions/3524859/how-to-display-full-stored-procedure-code
-- >> https://stackoverflow.com/questions/24773603/how-to-find-if-a-function-exists-in-postgresql
-- > MUST apply with code, no automatically applied promos
-- > Requires fooditems to be attribute in order
-- 2.5) Can maintain a seperate table for global promos, to be checked against on every retrieval of food item prices
-- > Need to manage conflict with applied promos
-- > Can make promoApplication(order, code=NULL) function simultaneously check against global and applied, take the min for each food price

-- errormedaddy

CREATE TABLE CodePromotions (
    id          INTEGER GENERATED ALWAYS AS IDENTITY,
    startdate   DATE NOT NULL DEFAULT CURRENT_DATE,
    enddate     DATE, -- NULL means perm
    code        VARCHAR(10) UNIQUE NOT NULL, -- Must be lowercase, since stored procedures all lowercase
    description VARCHAR(100) DEFAULT '',
    usecount    INTEGER DEFAULT 0,

    PRIMARY KEY(id)
);

CREATE OR REPLACE FUNCTION code_lower() 
returns TRIGGER AS $$
begin
    NEW.code := LOWER(NEW.code);
    return NEW;
end
$$ language plpgsql;

CREATE TRIGGER code_lower_trigger
    BEFORE UPDATE OR INSERT
    ON CodePromotions
    FOR EACH ROW
    EXECUTE PROCEDURE code_lower();

CREATE TABLE RestaurantPromotions (
    id      INTEGER,
    rname   VARCHAR(50),

    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES CodePromotions(id),
    FOREIGN KEY (rname) REFERENCES Restaurants(name)
);

CREATE TABLE FDSPromotions (
    id      INTEGER,

    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES CodePromotions(id)
);

CREATE OR REPLACE FUNCTION checkPromotionExists(VARCHAR(10))
returns BOOLEAN as $$
begin
    return EXISTS(
        SELECT  1
        FROM    CodePromotions CP
        WHERE   CP.code = $1)
        AND
        EXISTS(
        SELECT  1
        FROM    pg_proc P
        WHERE   P.proname = LOWER('_promo_' || $1));
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION checkPromotionValid(VARCHAR(10), DATE)
returns BOOLEAN as $$
declare
    curdate         DATE := $2;
    promostartdate  DATE;
    promoenddate    DATE;
begin
    promostartdate := (
        SELECT  CP.startdate
        FROM    CodePromotions CP
        WHERE   CP.code = $1
    );
    promoenddate := (
        SELECT  CP.enddate
        FROM    CodePromotions CP
        WHERE   CP.code = $1
    );
    return 
        (promostartdate <= curdate) AND
        (promoenddate IS NULL or curdate <= promoenddate);
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION applyPromotionCode(VARCHAR(10), INTEGER)
returns BOOLEAN as $$
declare
    codelower   VARCHAR(10) := LOWER($1);
    oid         INTEGER := $2;
    orderdate   DATE := (
        SELECT  creation::DATE 
        FROM    Orders 
        WHERE   id = oid);
    orderrname  VARCHAR(50) := (
        SELECT  FO.restaurantName
        FROM    FoodOrders FO
        WHERE   FO.orderid = oid
        LIMIT   1
    );
    promorname  VARCHAR(50) := (
        SELECT  RP.rname
        FROM    RestaurantPromotions RP, CodePromotions CP 
        WHERE   CP.code = codelower AND CP.id = RP.id);
    result      BOOLEAN := 0::BOOLEAN;
begin
    -- Check if promo code given
    IF codelower = '' THEN
        RAISE NOTICE 'No promotion code applied';
        RETURN 1::BOOLEAN;
    END IF;
    -- Check if promotion exists/valid
    IF NOT checkPromotionExists(codelower) THEN
        RAISE EXCEPTION 'Promotion code does not exist';
    ELSIF NOT checkPromotionValid(codelower, orderdate) THEN
        RAISE EXCEPTION 'Promotion has not started or has ended';
    END IF;
    
    -- Check if promotion is retaurant specific, and verify order is from restaurant if yes
    IF promorname IS NOT NULL AND promorname <> orderrname THEN
        RAISE EXCEPTION 'Promotion is for %', promorname;
    END IF;

    -- Apply the promotion
    EXECUTE 'SELECT _promo_' 
            || codelower 
            || '(' 
            || (oid::VARCHAR) 
            || ')' 
    INTO    result;

    IF NOT result THEN
        RAISE EXCEPTION 'Promotion conditions not met';
        RETURN result;
    ELSE
        UPDATE  CodePromotions
        SET     usecount = usecount + 1
        WHERE   code = codelower;
        RETURN result;
    END IF;
end 
$$ language plpgsql;

-- $1:          promotion code
-- $2:          startdate
-- $3:          enddate DEFAULT NULL
-- $4:          restaurant name DEFAULT NULL
-- ret:         boolean
CREATE OR REPLACE FUNCTION addPromotion(
    promocode       VARCHAR(10),
    promodescription VARCHAR(100),
    promostartdate  DATE, 
    promoenddate    DATE DEFAULT NULL, 
    rname           VARCHAR(50) DEFAULT NULL)
returns BOOLEAN as $$
begin
    promocode := LOWER(promocode); -- Very important

    IF EXISTS (
        SELECT  1
        FROM    CodePromotions CP
        WHERE   CP.code = promocode) THEN
        RAISE EXCEPTION 'Promotion code % already used', promocode;
    END IF;

    INSERT INTO CodePromotions (startdate, enddate, code, description) VALUES
    (promostartdate, promoenddate, promocode, promodescription);

    IF rname IS NULL THEN
        INSERT INTO FDSPromotions (id)
            SELECT  CP.id
            FROM    CodePromotions CP
            WHERE   CP.code = promocode;
    ELSE
        INSERT INTO RestaurantPromotions (id, rname)
            SELECT  CP.id, (SELECT rname)
            FROM    CodePromotions CP
            WHERE   CP.code = promocode;
    END IF;

    return 1::BOOLEAN;
end
$$ language plpgsql;

-- $1:          promotion code
-- $2:          function code
-- ret:         boolean
CREATE OR REPLACE FUNCTION implementPromotion(
    promocode       VARCHAR(10), 
    functioncode    VARCHAR)
returns BOOLEAN as $$
begin
    promocode := LOWER(promocode);

    IF EXISTS(
        SELECT  1
        FROM    pg_proc P
        WHERE   P.proname = LOWER('_promo_' || promocode)) THEN
        RAISE EXCEPTION 'Promotion for code % already implemented', promocode;
    END IF;

    functioncode := FORMAT(functioncode, '_promo_' || promocode);
    EXECUTE(functioncode); -- Totally safe kappa
    return 1::BOOLEAN;
end
$$ language plpgsql;