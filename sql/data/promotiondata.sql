-- PROMOTIONS --

/*
 * FDS Promotion
 * 10% off total order for first-time customers
 */
SELECT addPromotion(
    promocode=>'FIRSTTIME',
    promodescription=>'10% off your first order with us!',
    promostartdate=>'2010-03-29');
SELECT implementPromotion(
    promocode=>'FIRSTTIME',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
declare
    cname   VARCHAR(50);
begin
    cname   := (
        SELECT  O.customerName
        FROM    Orders O
        WHERE   O.id = orderid
    );
    IF (SELECT  count(*)
        FROM    Orders O
        WHERE   O.customerName = cname) = 1 THEN
        UPDATE  Orders
        SET     totalCost = totalCost * 0.9
        WHERE   id = orderid;
        return 1::BOOLEAN;
    END IF;
    return 0::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * FDS Promotion
 * 20% off if total order is more than $100
 */
SELECT addPromotion(
    promocode=>'EATMORE',
    promodescription=>'20% off if you spend more than $100!',
    promostartdate=>'2020-04-01',
    promoenddate=>'2020-05-01');
SELECT implementPromotion(
    promocode=>'EATMORE',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
begin
    IF (SELECT  O.totalCost
        FROM    Orders O
        WHERE   O.oid = $1) >= 100 THEN
        UPDATE  Orders
        SET     totalCost = totalCost * 0.8
        WHERE   id = orderid;
        return 1::BOOLEAN;
    END IF;
    return 0::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * FDS Promotion
 * Free delivery during these trying times
 */
SELECT addPromotion(
    promocode=>'STAYHOME',
    promodescription=>'Free delivery so stay the * home!',
    promostartdate=>'2020-04-01',
    promoenddate=>'2020-05-01');
SELECT implementPromotion(
    promocode=>'STAYHOME',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(orderid INTEGER)
returns BOOLEAN as $$
begin
    UPDATE  Orders
    SET     deliveryFee = 0
    WHERE   id = orderid;
    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * Restaurant (Gongcha) Promotion
 * 50% off Taro Milk Tea
 */
SELECT addPromotion(
    promocode=>'TAROMT',
    promodescription=>'50% Taro Milk Tea!',
    promostartdate=>'2020-01-29',
    promoenddate=>'2020-12-29',
    rname=>'Gongcha');
SELECT implementPromotion(
    promocode=>'TAROMT',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(oid INTEGER)
returns BOOLEAN as $$
declare
    orderrname  VARCHAR(50) := (
        SELECT  FO.restaurantName
        FROM    FoodOrders FO
        WHERE   FO.orderid = oid
        LIMIT   1);
    qty         INTEGER := 0;
    discountacc MONEY := 0;
begin
    qty := (
        SELECT  sum(FO.quantity)
        FROM    FoodOrders FO
        WHERE   FO.orderId = oid AND FO.foodName = ''Taro Milk Tea'');

    discountacc := (
        SELECT  F.price
        FROM    Food F
        WHERE   F.restaurantName = orderrname AND F.name = ''Taro Milk Tea'') * 0.5 * qty;

    UPDATE  Orders
    SET     totalCost = totalCost - discountacc
    WHERE   id = oid;

    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);

/*
 * EXPIRED
 * Restaurant (Gongcha) Promotion
 * 50% off Taro Milk Tea
 */
SELECT addPromotion(
    promocode=>'TAROMTEXP',
    promodescription=>'50% Taro Milk Tea!',
    promostartdate=>'2020-01-29',
    promoenddate=>'2020-12-29',
    rname=>'Gongcha');
SELECT implementPromotion(
    promocode=>'TAROMTEXP',
    functioncode=>'
CREATE OR REPLACE FUNCTION %s(oid INTEGER)
returns BOOLEAN as $$
declare
    orderrname  VARCHAR(50) := (
        SELECT  FO.restaurantName
        FROM    FoodOrders FO
        WHERE   FO.orderid = oid
        LIMIT   1);
    qty         INTEGER := 0;
    discountacc MONEY := 0;
begin
    qty := (
        SELECT  sum(FO.quantity)
        FROM    FoodOrders FO
        WHERE   FO.orderId = oid AND FO.foodName = ''Taro Milk Tea'');

    discountacc := (
        SELECT  F.price
        FROM    Food F
        WHERE   F.restaurantName = orderrname AND F.name = ''Taro Milk Tea'') * 0.5 * qty;

    UPDATE  Orders
    SET     totalCost = totalCost - discountacc
    WHERE   id = oid;

    return 1::BOOLEAN;
end 
$$ language plpgsql;
    '
);