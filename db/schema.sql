CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ACCOUNTS TABLE
CREATE TABLE accounts (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    account_number VARCHAR(34) UNIQUE NOT NULL,
    holder_name VARCHAR(255) NOT NULL,
    currency VARCHAR(3) NOT NULL DEFAULT 'UGX',
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIMEZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chkstatus CHECK (status IN ('ACTIVE', 'FROZEN', 'CLOSED'))
);

-- Journals (Transaction Headers) Table
CREATE TABLE journals (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    reference_id VARCHAR(100) UNIQUE NOT NULL,
    description TEXT NOT NULL,
    posted_at TIMESTAMP WITH TIMEZONE DEFAULT CURRENT_TIMESTAMP
);

-- Journal Entries (Following the Double Entry Book-Keeping System
CREATE TABLE journal lines (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    journal_id UUID NOT NULL REFERENCES journals(id) ON DELETE RESTRICT,
    account_id UUID NOT NULL REFERENCES accounts(id) ON DELETE RESTRICT,
    direction VARCHAR(6) NOT NULL,
    amount NUMERIC(18,4) NOT NULL,
    CONSTRAINT chk_direction CHECK (direction IN ('DEBIT', 'CREDIT')),
    CONSTRAINT chk_amount_positive CHECK (amount>0),
);

-- BY Indexing Account ID, Postgres Jumps Straight To That Account Instead Of Having To Look At Every Single Row In The Banks Table, Allowing High-Performance Balance Queries.
CREATE INDEX idx_journal_lines_account ON journal_lines(account_id);


