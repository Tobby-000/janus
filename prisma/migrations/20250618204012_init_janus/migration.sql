-- 创建表 yggc_authorization_codes
CREATE TABLE yggc_authorization_codes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_authorization_codes_id_key ON yggc_authorization_codes (id);
CREATE UNIQUE INDEX yggc_authorization_codes_uid_key ON yggc_authorization_codes (uid) WHERE uid IS NOT NULL;

-- 创建表 yggc_device_codes
CREATE TABLE yggc_device_codes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    user_code VARCHAR(191) NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_device_codes_id_key ON yggc_device_codes (id);
CREATE UNIQUE INDEX yggc_device_codes_uid_key ON yggc_device_codes (uid) WHERE uid IS NOT NULL;

-- 创建表 yggc_refresh_tokens
CREATE TABLE yggc_refresh_tokens (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_refresh_tokens_id_key ON yggc_refresh_tokens (id);
CREATE UNIQUE INDEX yggc_refresh_tokens_uid_key ON yggc_refresh_tokens (uid) WHERE uid IS NOT NULL;

-- 创建表 yggc_grants
CREATE TABLE yggc_grants (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_grants_id_key ON yggc_grants (id);
CREATE UNIQUE INDEX yggc_grants_uid_key ON yggc_grants (uid) WHERE uid IS NOT NULL;

-- 创建表 yggc_interactions
CREATE TABLE yggc_interactions (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_interactions_id_key ON yggc_interactions (id);
CREATE UNIQUE INDEX yggc_interactions_uid_key ON yggc_interactions (uid) WHERE uid IS NOT NULL;

-- 创建表 yggc_sessions
CREATE TABLE yggc_sessions (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSONB NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP(3) NOT NULL
);

-- 创建唯一索引
CREATE UNIQUE INDEX yggc_sessions_id_key ON yggc_sessions (id);
CREATE UNIQUE INDEX yggc_sessions_uid_key ON yggc_sessions (uid) WHERE uid IS NOT NULL;
