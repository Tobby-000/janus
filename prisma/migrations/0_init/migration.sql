-- 创建表 code_id_to_uuid
CREATE TABLE code_id_to_uuid (
    id SERIAL PRIMARY KEY,
    code_id VARCHAR(255) NOT NULL,
    uuid VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (code_id)
);

-- 创建表 jobs
CREATE TABLE jobs (
    id BIGSERIAL PRIMARY KEY,
    queue VARCHAR(255) NOT NULL,
    payload TEXT NOT NULL,
    attempts SMALLINT NOT NULL,
    reserved_at INTEGER NULL,
    available_at INTEGER NOT NULL,
    created_at INTEGER NOT NULL
);
CREATE INDEX jobs_queue_index ON jobs(queue);

-- 创建表 language_lines
CREATE TABLE language_lines (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(255) NOT NULL,
    key VARCHAR(255) NOT NULL,
    text TEXT NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);
CREATE INDEX language_lines_group_index ON language_lines(group_name);

-- 创建表 migrations
CREATE TABLE migrations (
    id SERIAL PRIMARY KEY,
    migration VARCHAR(255) NOT NULL,
    batch INTEGER NOT NULL
);

-- 创建表 notifications
CREATE TABLE notifications (
    id CHAR(36) NOT NULL PRIMARY KEY,
    type VARCHAR(255) NOT NULL,
    notifiable_type VARCHAR(255) NOT NULL,
    notifiable_id BIGINT NOT NULL,
    data TEXT NOT NULL,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);
CREATE INDEX notifications_notifiable_type_notifiable_id_index ON notifications(notifiable_type, notifiable_id);

-- 创建表 oauth_access_tokens
CREATE TABLE oauth_access_tokens (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    user_id BIGINT NULL,
    client_id BIGINT NOT NULL,
    name VARCHAR(255) NULL,
    scopes TEXT NULL,
    revoked BOOLEAN NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    expires_at TIMESTAMP NULL
);
CREATE INDEX oauth_access_tokens_user_id_index ON oauth_access_tokens(user_id);

-- 创建表 oauth_auth_codes
CREATE TABLE oauth_auth_codes (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    client_id BIGINT NOT NULL,
    scopes TEXT NULL,
    revoked BOOLEAN NOT NULL,
    expires_at TIMESTAMP NULL
);
CREATE INDEX oauth_auth_codes_user_id_index ON oauth_auth_codes(user_id);

-- 创建表 oauth_clients
CREATE TABLE oauth_clients (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NULL,
    name VARCHAR(255) NOT NULL,
    secret VARCHAR(100) NULL,
    provider VARCHAR(255) NULL,
    redirect TEXT NOT NULL,
    personal_access_client BOOLEAN NOT NULL,
    password_client BOOLEAN NOT NULL,
    revoked BOOLEAN NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);
CREATE INDEX oauth_clients_user_id_index ON oauth_clients(user_id);

-- 创建表 oauth_personal_access_clients
CREATE TABLE oauth_personal_access_clients (
    id BIGSERIAL PRIMARY KEY,
    client_id BIGINT NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL
);

-- 创建表 oauth_refresh_tokens
CREATE TABLE oauth_refresh_tokens (
    id VARCHAR(100) NOT NULL PRIMARY KEY,
    access_token_id VARCHAR(100) NOT NULL,
    revoked BOOLEAN NOT NULL,
    expires_at TIMESTAMP NULL
);
CREATE INDEX oauth_refresh_tokens_access_token_id_index ON oauth_refresh_tokens(access_token_id);

-- 创建表 options
CREATE TABLE options (
    id SERIAL PRIMARY KEY,
    option_name VARCHAR(50) NOT NULL,
    option_value TEXT NOT NULL
);

-- 创建表 players
CREATE TABLE players (
    pid SERIAL PRIMARY KEY,
    uid INTEGER NOT NULL,
    name VARCHAR(50) NOT NULL,
    tid_cape INTEGER NOT NULL DEFAULT 0,
    last_modified TIMESTAMP NOT NULL,
    tid_skin INTEGER NOT NULL DEFAULT -1,
    uuid VARCHAR(255) NULL
);

-- 创建表 reports
CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    tid INTEGER NOT NULL,
    uploader INTEGER NOT NULL,
    reporter INTEGER NOT NULL,
    reason TEXT NOT NULL,
    status INTEGER NOT NULL,
    report_at TIMESTAMP NOT NULL
);

-- 创建表 scopes
CREATE TABLE scopes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255) NOT NULL,
    UNIQUE (name)
);

-- 创建表 textures
CREATE TABLE textures (
    tid SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type VARCHAR(10) NOT NULL,
    hash VARCHAR(64) NOT NULL,
    size INTEGER NOT NULL,
    uploader INTEGER NOT NULL,
    public SMALLINT NOT NULL,
    upload_at TIMESTAMP NOT NULL,
    likes INTEGER NOT NULL DEFAULT 0
);

-- 创建表 user_closet
CREATE TABLE user_closet (
    user_uid INTEGER NOT NULL,
    texture_tid INTEGER NOT NULL,
    item_name TEXT NULL
);

-- 创建表 users
CREATE TABLE users (
    uid SERIAL PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    nickname VARCHAR(50) NOT NULL DEFAULT '',
    locale VARCHAR(255) NULL,
    score INTEGER NOT NULL,
    avatar INTEGER NOT NULL DEFAULT 0,
    password VARCHAR(255) NOT NULL,
    ip VARCHAR(45) NOT NULL,
    is_dark_mode BOOLEAN NOT NULL DEFAULT false,
    permission INTEGER NOT NULL DEFAULT 0,
    last_sign_at TIMESTAMP NOT NULL,
    register_at TIMESTAMP NOT NULL,
    verified BOOLEAN NOT NULL DEFAULT false,
    verification_token VARCHAR(255) NOT NULL DEFAULT '',
    remember_token VARCHAR(100) NULL
);

-- 创建表 uuid
CREATE TABLE uuid (
    id SERIAL PRIMARY KEY,
    pid INTEGER NULL,
    name VARCHAR(255) NOT NULL,
    uuid VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL,
    updated_at TIMESTAMP NULL,
    UNIQUE (pid),
    UNIQUE (name),
    UNIQUE (uuid)
);

-- 创建表 ygg_log
CREATE TABLE ygg_log (
    id SERIAL PRIMARY KEY,
    action VARCHAR(255) NOT NULL,
    user_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    parameters VARCHAR(2048) NOT NULL DEFAULT '',
    ip VARCHAR(255) NOT NULL DEFAULT '',
    time TIMESTAMP NOT NULL
);

-- 创建表 yggc_authorization_codes
CREATE TABLE yggc_authorization_codes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 创建表 yggc_device_codes
CREATE TABLE yggc_device_codes (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    user_code VARCHAR(191) NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 创建表 yggc_refresh_tokens
CREATE TABLE yggc_refresh_tokens (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    uid VARCHAR(255) NULL,
    consumed BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 创建表 yggc_grants
CREATE TABLE yggc_grants (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 创建表 yggc_interactions
CREATE TABLE yggc_interactions (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 创建表 yggc_sessions
CREATE TABLE yggc_sessions (
    id VARCHAR(255) NOT NULL PRIMARY KEY,
    payload JSON NOT NULL,
    uid VARCHAR(255) NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE (uid)
);

-- 添加外键约束
ALTER TABLE code_id_to_uuid ADD CONSTRAINT code_id_to_uuid_code_id_foreign FOREIGN KEY (code_id) REFERENCES oauth_auth_codes (id) ON DELETE CASCADE;

ALTER TABLE uuid ADD CONSTRAINT uuid_pid_foreign FOREIGN KEY (pid) REFERENCES players (pid) ON DELETE CASCADE;
