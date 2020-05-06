CREATE TABLE PartTimeRiders (
    username    VARCHAR(50),
    ws          BOOLEAN[7][12] NOT NULL,
    weeksalary  MONEY DEFAULT 0,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Riders ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FullTimeRiders (
    username    VARCHAR(50),
    ws          BOOLEAN[7][12] NOT NULL,
    monthsalary MONEY DEFAULT 0,
    PRIMARY KEY (username),
    FOREIGN KEY (username) REFERENCES Riders ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE OR REPLACE FUNCTION checkPartTimeSchedule()
returns TRIGGER as $$
declare
    sched   BOOLEAN[7][12] := NEW.ws;
    cday    INTEGER := 1;
    cshift  INTEGER := 1;
    counter INTEGER := 0;
    htotal  INTEGER := 0;
begin
    LOOP
        IF sched[cday][cshift] THEN
            htotal := htotal + 1;
            counter := counter + 1;
        ELSE
            counter := 0;
        END IF;
        IF counter > 4 THEN
            RAISE EXCEPTION 'Consec check fail at cday: % cshift: % for rider %', cday, cshift, NEW.username;
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

    IF (htotal < 10) THEN
        RAISE EXCEPTION 'Insufficient hours (%) rider %', htotal, NEW.username;
    ELSIF (htotal > 48) THEN
        RAISE EXCEPTION 'Too many hours (%) rider %', htotal, NEW.username;
    ELSE
        RETURN NEW;
    END IF;
end
$$ language plpgsql;

CREATE TRIGGER _1checkPartTimeSchedule_trigger
    BEFORE INSERT
    ON PartTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE checkPartTimeSchedule();

CREATE OR REPLACE FUNCTION checkFullTimeSchedule()
returns TRIGGER as $$
declare
    sched   BOOLEAN[7][12] := NEW.ws;
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
            IF sched[cday][cshift] THEN
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
            RAISE EXCEPTION 'Invalid hourly schedule for rider: %, cday: % cshift: % schedule: %', NEW.username, cday, cshift, sbitmap;
        END IF;
        cday := cday + 1;
        EXIT WHEN cday > 7;
    END LOOP;
    -- VERIFY DAILY SCHEDULE --
    cday := 1;
    LOOP
        result := result OR ((dbitmap # wdays[cday])::INTEGER = 0);
        cday := cday + 1;
        EXIT WHEN cday > 7;
    END LOOP;
    IF NOT result THEN
        RAISE EXCEPTION 'Invalid daily schedule for rider: %, schedule: %', NEW.username, dbitmap;
    END IF;
    RETURN NEW;
end
$$ language plpgsql;

CREATE TRIGGER _1checkFullTimeSchedule_trigger
    BEFORE INSERT
    ON FullTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE checkFullTimeSchedule();

CREATE OR REPLACE FUNCTION calculateBaseSalary(
    riderName  VARCHAR(50),
    isPartTime BOOLEAN DEFAULT NULL,
    sched      BOOLEAN[7][12] DEFAULT NULL)
returns MONEY as $$
declare
    isPartTime BOOLEAN :=
    CASE
        WHEN isPartTime IS NULL THEN (
            EXISTS(
                SELECT  1
                FROM    PartTimeRiders
                WHERE   username = riderName))
        ELSE
            (isPartTime)
    END;
    sched   BOOLEAN[7][12] :=
    CASE
        WHEN sched is NULL THEN (
            CASE
                WHEN isPartTime THEN (
                    SELECT  ws
                    FROM    PartTimeRiders
                    WHERE   username = riderName)
                ELSE (
                    SELECT  ws
                    FROM    FullTimeRiders
                    WHERE   username = riderName)
            END)
        ELSE
            (sched)
    END;
    cday    INTEGER := 1;
    cshift  INTEGER := 1;
    salary  MONEY := 0;
    hourly  MONEY := 0;
    peak    MONEY := 1;
begin
    IF isPartTime THEN
        hourly := 7.5;
    ELSE
        hourly := 8;
    END IF;

    LOOP
        cshift := 1;
        LOOP
            IF (cshift BETWEEN 3 AND 4) OR (cday > 5) THEN
                -- lunch peak (12-2pm) or weekend
                salary := salary + (hourly + peak) * sched[cday][cshift]::int;
            ELSE
                salary := salary + hourly * sched[cday][cshift]::int;
            END IF;
            cshift := cshift + 1;
            EXIT WHEN cshift > 12;
        END LOOP;
        cday := cday + 1;
        EXIT WHEN cday > 7;
    END LOOP;
    RETURN salary;
end
$$ language plpgsql;

CREATE OR REPLACE FUNCTION calculateBaseSalaryHelper()
returns TRIGGER as $$
begin
    IF TG_TABLE_NAME = 'parttimeriders' THEN
        NEW.weeksalary := calculateBaseSalary(NEW.username, 1::BOOLEAN, NEW.ws);
    ELSE
        NEW.monthsalary := calculateBaseSalary(NEW.username, 0::BOOLEAN, NEW.ws) * 4;
    END IF;
    RETURN NEW;
end
$$ language plpgsql;

CREATE TRIGGER _2calculateBaseSalary_trigger
    BEFORE INSERT OR UPDATE OF ws
    ON FullTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE calculateBaseSalaryHelper();

CREATE TRIGGER _2calculateBaseSalary_trigger
    BEFORE INSERT OR UPDATE OF ws
    ON PartTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE calculateBaseSalaryHelper();

CREATE OR REPLACE FUNCTION riderTypeEnforcement()
returns TRIGGER as $$
declare
    ok  BOOLEAN;
begin
    IF TG_TABLE_NAME = 'parttimerider' THEN
        SELECT true INTO ok
        FROM FullTimeRiders
        WHERE username = NEW.username;
    ELSE -- full-time rider
        SELECT true INTO ok
        FROM FullTimeRiders
        WHERE username = NEW.username;
    END IF;

    IF FOUND THEN
        RAISE EXCEPTION 'Rider % has an existing rider type', NEW.username;
    END IF;

    RETURN NEW;
end
$$ language plpgsql;

CREATE TRIGGER riderTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON FullTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE riderTypeEnforcement();

CREATE TRIGGER riderTypeEnforcement_trigger
    BEFORE INSERT OR UPDATE OF username
    ON PartTimeRiders
    FOR EACH ROW
    EXECUTE PROCEDURE riderTypeEnforcement();

CREATE OR REPLACE FUNCTION getHourIntervalWorkerCount()
	RETURNS SETOF RECORD
AS $$
declare
    score   INTEGER[7][12] := ARRAY[
    -----1  2  3  4  5  6  7  8  9  A  B  C
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- M
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- W
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- T
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- F
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], -- S
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  -- S
        ];
    sched   BOOLEAN[7][12];
    rider   VARCHAR(50);
    d       INTEGER;
    h       INTEGER;
begin
    FOR rider, sched IN
        SELECT username, ws FROM PartTimeRiders
        UNION
        SELECT username, ws from FullTimeRiders
    LOOP
        d := 1;
        LOOP -- days
            h := 1;
            LOOP -- hours
                IF sched[d][h] THEN
                    score[d][h] := score[d][h] + 1;
                END IF;
                h := h + 1;
                EXIT WHEN h > 12;
            END LOOP;
            d := d + 1;
            EXIT WHEN d > 7;
        END LOOP;
    END LOOP;

    d := 1;
    LOOP -- days
        h := 1;
        LOOP -- hours
            RETURN NEXT ROW(d, h + 9, score[d][h]);
            h := h + 1;
            EXIT WHEN h > 12;
        END LOOP;
        d := d + 1;
        EXIT WHEN d > 7;
    END LOOP;
end; $$
language plpgsql;