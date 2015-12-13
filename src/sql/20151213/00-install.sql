CREATE TABLE "core_user" (
  "id" bigserial PRIMARY KEY,
  "username" varchar(50) NOT NULL UNIQUE CHECK (length("username") > 0),
  "private_key" bytea NOT NULL,
  "public_key" bytea NOT NULL
);
