BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_account" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "passwordHash" text NOT NULL,
    "salt" text NOT NULL,
    "avatarUrl" text,
    "createdAt" timestamp without time zone NOT NULL,
    "lastLoginAt" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "user_account_email_idx" ON "user_account" USING btree ("email");


--
-- MIGRATION VERSION FOR mindmap_ai
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('mindmap_ai', '20261014052145698', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261014052145698', "timestamp" = now();

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
