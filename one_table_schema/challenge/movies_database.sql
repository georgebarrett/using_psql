
-- Table Definition
CREATE TABLE "public"."movies" (
    "id" SERIAL,
    "title" text,
    "genre" text,
    "release_year" int4,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."movies" ("title", "genre", "release_year") VALUES
('Bladerunner', 'sci-fi', 1982);
