BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "note" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "content" text NOT NULL,
    "summary" text,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "task" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "dueAt" timestamp without time zone,
    "durationMinutes" bigint NOT NULL,
    "priority" text NOT NULL,
    "status" text NOT NULL,
    "sourceNoteId" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_preferences" (
    "id" bigserial PRIMARY KEY,
    "workingDayStartMinutes" bigint NOT NULL,
    "workingDayEndMinutes" bigint NOT NULL,
    "breakMinutes" bigint NOT NULL,
    "timezone" text NOT NULL,
    "timezoneOffsetMinutes" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR mindmap_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mindmap_ai', '20261013071500070', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261013071500070', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260924105404509', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105404509', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
