CREATE TABLE "public"."music" (
    "id" SERIAL,
    "name" text,
    "title" text,
    "genre" text,
    "release_year" int4,
    PRIMARY KEY ("id")
);

INSERT INTO "public"."music" ("name", "title", "genre", "release_year") VALUES
('Aphex Twin', 'Rhubarb', 'Electronica', 1987);