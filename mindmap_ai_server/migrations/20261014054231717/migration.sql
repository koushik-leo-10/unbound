BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "mind_map" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "rootNodeJson" text NOT NULL,
    "sourceNoteId" bigint,
    "userId" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR mindmap_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mindmap_ai', '20261014054231717', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014054231717', "timestamp" = now();

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
