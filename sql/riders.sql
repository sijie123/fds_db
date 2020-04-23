CREATE TABLE Riders (
    username    VARCHAR(50),
    latitude    NUMERIC NOT NULL,
    longitude   NUMERIC NOT NULL,
    orderid     INTEGER,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Users(username) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION checkPartTimeSchedule(BOOLEAN[7][12])
returns BOOLEAN as $$ 
declare
    cday    INTEGER := 1;
    cshift  INTEGER := 1;
    counter INTEGER := 0;
    htotal  INTEGER := 0;
    result  BOOLEAN := 0;
begin
    LOOP
        IF ($1)[cday][cshift] THEN
            htotal := htotal + 1;
            counter := counter + 1;
        ELSE
            counter := 0;
        END IF;
        IF counter > 4 THEN
            RAISE EXCEPTION 'consec check fail at cday: % cshift: %', cday, cshift;
            result := 0;
            RETURN result;
        END IF;
        IF cshift > 12 THEN
            cday := cday + 1;
            cshift := 1;
            counter := 0;
        ELSE
            cshift := cshift + 1;
        END IF;
        EXIT WHEN cday > 7;
    END LOOP;

    result := (htotal >= 10 AND htotal <= 48);
    -- RAISE NOTICE 'htotal: %', htotal;
    RETURN result;
end 
$$ language plpgsql;

CREATE TABLE PartTimeRiders (
    username    VARCHAR(50),
    ws          BOOLEAN[7][12],
    weeksalary  MONEY DEFAULT 0,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Riders(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT wws_correct check(checkPartTimeSchedule(ws))
);

CREATE OR REPLACE FUNCTION checkFullTimeSchedule(BOOLEAN[7][12])
returns BOOLEAN as $$ 
declare
    cday    INTEGER := 1;
    cshift  INTEGER := 1;
    zero12map BIT(12)   := B'000000000000';
    one12map BIT(12)    := B'000000000001';
    sbitmap BIT(12)     := B'000000000000';
    wshifts BIT(12)[4] := ARRAY[
        B'111101111000',
        B'011110111100',
        B'001111011110',
        B'000111101111'];
    dbitmap BIT(7)  := B'0000000';
    one7map BIT(7)  := B'0000001';
    wdays   BIT(7)[4] := ARRAY[
        B'0011111',
        B'1001111',
        B'1100111',
        B'1110011',
        B'1111001',
        B'1111100',
        B'0111110'];
    sctr    INTEGER := 0;
    dctr    INTEGER := 0;
    result  BOOLEAN := 0;
begin
    -- LOOP DAYS --
    LOOP
        cshift := 1;
        sctr := 0;
        sbitmap := sbitmap & zero12map;
        -- LOOP HOURS --
        LOOP
            IF ($1)[cday][cshift] THEN
                sbitmap := (sbitmap << 1) | one12map;
                IF sctr = 0 THEN
                    sctr = cshift;
                END IF;
            ELSE
                sbitmap := (sbitmap << 1);
            END IF;
            cshift := cshift + 1;
            EXIT WHEN cshift > 12;
        END LOOP;
        -- COUNT WORKING DAYS --
        IF (sbitmap::INTEGER > 0) THEN
            dbitmap := dbitmap << 1 | one7map;
        ELSE
            dbitmap := dbitmap << 1;
        END IF;
        -- VERIFY HOURLY SCHEDULE --
        -- If not working today, continue --
        IF (sbitmap::INTEGER > 0) AND ((sctr > 5) OR ((sbitmap # wshifts[sctr])::INTEGER > 1)) THEN
            RAISE EXCEPTION 'invalid hourly schedule at cday: % cshift: % schedule: %', cday, cshift, sbitmap;
            result := 0;
            RETURN result;
        END IF;
        cday := cday + 1;
        EXIT WHEN cday > 7;
    END LOOP;
    -- VERY DAILY SCHEDULE -- 
    cday := 1;
    LOOP
        result := result OR ((dbitmap # wdays[cday])::INTEGER = 0);
        cday := cday + 1;
        EXIT WHEN cday > 7;
    END LOOP;
    IF NOT result THEN
        RAISE EXCEPTION 'invalid daily schedule schedule: %', dbitmap;
    END IF;    
    RETURN result;
end 
$$ language plpgsql;

CREATE TABLE FullTimeRiders (
    username    VARCHAR(50),
    ws          BOOLEAN[7][12],
    monthsalary MONEY DEFAULT 0,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Riders(username) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT mws_correct check(checkFullTimeSchedule(ws))
);
