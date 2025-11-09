-- Run once during first postgres initialization.
-- Creates one logical database per service and a dedicated user for each.

-- Auth service
CREATE ROLE auth_user WITH LOGIN PASSWORD 'auth_pass_local';
CREATE DATABASE auth_db OWNER auth_user;

-- User service
CREATE ROLE user_user WITH LOGIN PASSWORD 'user_pass_local';
CREATE DATABASE user_db OWNER user_user;

-- Content service
CREATE ROLE content_user WITH LOGIN PASSWORD 'content_pass_local';
CREATE DATABASE content_db OWNER content_user;

-- Ingest service
CREATE ROLE ingest_user WITH LOGIN PASSWORD 'ingest_pass_local';
CREATE DATABASE ingest_db OWNER ingest_user;

-- QA service
CREATE ROLE qa_user WITH LOGIN PASSWORD 'qa_pass_local';
CREATE DATABASE qa_db OWNER qa_user;

-- Gateway (if it needs metadata storage)
CREATE ROLE gateway_user WITH LOGIN PASSWORD 'gateway_pass_local';
CREATE DATABASE gateway_db OWNER gateway_user;

-- Optional: extension for uuid-ossp and pg_trgm for text search
\c auth_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\c user_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\c content_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\c ingest_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\c qa_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;
\c gateway_db
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- NOTE: Passwords here are local dev-only. Use Vault/Secrets Manager in CI/prod.
