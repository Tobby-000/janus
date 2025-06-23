-- CreateTable
CREATE TABLE `code_id_to_uuid` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `code_id` VARCHAR(255) NOT NULL,
    `uuid` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),

    UNIQUE INDEX `code_id_to_uuid_code_id_unique`(`code_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `jobs` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `queue` VARCHAR(255) NOT NULL,
    `payload` LONGTEXT NOT NULL,
    `attempts` TINYINT UNSIGNED NOT NULL,
    `reserved_at` INTEGER UNSIGNED NULL,
    `available_at` INTEGER UNSIGNED NOT NULL,
    `created_at` INTEGER UNSIGNED NOT NULL,

    INDEX `jobs_queue_index`(`queue`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `language_lines` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `group` VARCHAR(255) NOT NULL,
    `key` VARCHAR(255) NOT NULL,
    `text` TEXT NOT NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,

    INDEX `language_lines_group_index`(`group`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `migrations` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `migration` VARCHAR(255) NOT NULL,
    `batch` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `notifications` (
    `id` CHAR(36) NOT NULL,
    `type` VARCHAR(255) NOT NULL,
    `notifiable_type` VARCHAR(255) NOT NULL,
    `notifiable_id` BIGINT UNSIGNED NOT NULL,
    `data` TEXT NOT NULL,
    `read_at` TIMESTAMP(0) NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,

    INDEX `notifications_notifiable_type_notifiable_id_index`(`notifiable_type`, `notifiable_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `oauth_access_tokens` (
    `id` VARCHAR(100) NOT NULL,
    `user_id` BIGINT UNSIGNED NULL,
    `client_id` BIGINT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NULL,
    `scopes` TEXT NULL,
    `revoked` BOOLEAN NOT NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,
    `expires_at` DATETIME(0) NULL,

    INDEX `oauth_access_tokens_user_id_index`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `oauth_auth_codes` (
    `id` VARCHAR(100) NOT NULL,
    `user_id` BIGINT UNSIGNED NOT NULL,
    `client_id` BIGINT UNSIGNED NOT NULL,
    `scopes` TEXT NULL,
    `revoked` BOOLEAN NOT NULL,
    `expires_at` DATETIME(0) NULL,

    INDEX `oauth_auth_codes_user_id_index`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `oauth_clients` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT UNSIGNED NULL,
    `name` VARCHAR(255) NOT NULL,
    `secret` VARCHAR(100) NULL,
    `provider` VARCHAR(255) NULL,
    `redirect` TEXT NOT NULL,
    `personal_access_client` BOOLEAN NOT NULL,
    `password_client` BOOLEAN NOT NULL,
    `revoked` BOOLEAN NOT NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,

    INDEX `oauth_clients_user_id_index`(`user_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `oauth_personal_access_clients` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `client_id` BIGINT UNSIGNED NOT NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `oauth_refresh_tokens` (
    `id` VARCHAR(100) NOT NULL,
    `access_token_id` VARCHAR(100) NOT NULL,
    `revoked` BOOLEAN NOT NULL,
    `expires_at` DATETIME(0) NULL,

    INDEX `oauth_refresh_tokens_access_token_id_index`(`access_token_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `options` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `option_name` VARCHAR(50) NOT NULL,
    `option_value` LONGTEXT NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `players` (
    `pid` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `uid` INTEGER NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `tid_cape` INTEGER NOT NULL DEFAULT 0,
    `last_modified` DATETIME(0) NOT NULL,
    `tid_skin` INTEGER NOT NULL DEFAULT -1,

    PRIMARY KEY (`pid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `reports` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `tid` INTEGER NOT NULL,
    `uploader` INTEGER NOT NULL,
    `reporter` INTEGER NOT NULL,
    `reason` LONGTEXT NOT NULL,
    `status` INTEGER NOT NULL,
    `report_at` DATETIME(0) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `scopes` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) NOT NULL,
    `description` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `scopes_name_unique`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `textures` (
    `tid` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `type` VARCHAR(10) NOT NULL,
    `hash` VARCHAR(64) NOT NULL,
    `size` INTEGER NOT NULL,
    `uploader` INTEGER NOT NULL,
    `public` TINYINT NOT NULL,
    `upload_at` DATETIME(0) NOT NULL,
    `likes` INTEGER UNSIGNED NOT NULL DEFAULT 0,

    PRIMARY KEY (`tid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user_closet` (
    `user_uid` INTEGER NOT NULL,
    `texture_tid` INTEGER NOT NULL,
    `item_name` TEXT NULL
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `users` (
    `uid` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(100) NOT NULL,
    `nickname` VARCHAR(50) NOT NULL DEFAULT '',
    `locale` VARCHAR(255) NULL,
    `score` INTEGER NOT NULL,
    `avatar` INTEGER NOT NULL DEFAULT 0,
    `password` VARCHAR(255) NOT NULL,
    `ip` VARCHAR(45) NOT NULL,
    `is_dark_mode` BOOLEAN NOT NULL DEFAULT false,
    `permission` INTEGER NOT NULL DEFAULT 0,
    `last_sign_at` DATETIME(0) NOT NULL,
    `register_at` DATETIME(0) NOT NULL,
    `verified` BOOLEAN NOT NULL DEFAULT false,
    `verification_token` VARCHAR(255) NOT NULL DEFAULT '',
    `remember_token` VARCHAR(100) NULL,

    PRIMARY KEY (`uid`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `uuid` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `pid` INTEGER UNSIGNED NULL,
    `name` VARCHAR(255) NOT NULL,
    `uuid` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP(0) NULL,
    `updated_at` TIMESTAMP(0) NULL,

    UNIQUE INDEX `uuid_pid_unique`(`pid`),
    UNIQUE INDEX `uuid_name_unique`(`name`),
    UNIQUE INDEX `uuid_uuid_unique`(`uuid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ygg_log` (
    `id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
    `action` VARCHAR(255) NOT NULL,
    `user_id` INTEGER NOT NULL,
    `player_id` INTEGER NOT NULL,
    `parameters` VARCHAR(2048) NOT NULL DEFAULT '',
    `ip` VARCHAR(255) NOT NULL DEFAULT '',
    `time` DATETIME(0) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_authorization_codes` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_authorization_codes_id_key`(`id`),
    UNIQUE INDEX `yggc_authorization_codes_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_device_codes` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `userCode` VARCHAR(191) NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_device_codes_id_key`(`id`),
    UNIQUE INDEX `yggc_device_codes_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_refresh_tokens` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `consumed` BOOLEAN NOT NULL DEFAULT false,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_refresh_tokens_id_key`(`id`),
    UNIQUE INDEX `yggc_refresh_tokens_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_grants` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_grants_id_key`(`id`),
    UNIQUE INDEX `yggc_grants_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_interactions` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_interactions_id_key`(`id`),
    UNIQUE INDEX `yggc_interactions_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `yggc_sessions` (
    `id` VARCHAR(255) NOT NULL,
    `payload` JSON NOT NULL,
    `uid` VARCHAR(255) NULL,
    `created_at` TIMESTAMP(0) NOT NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` DATETIME(3) NOT NULL,

    UNIQUE INDEX `yggc_sessions_id_key`(`id`),
    UNIQUE INDEX `yggc_sessions_uid_key`(`uid`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `code_id_to_uuid` ADD CONSTRAINT `code_id_to_uuid_code_id_foreign` FOREIGN KEY (`code_id`) REFERENCES `oauth_auth_codes`(`id`) ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `uuid` ADD CONSTRAINT `uuid_pid_foreign` FOREIGN KEY (`pid`) REFERENCES `players`(`pid`) ON DELETE CASCADE ON UPDATE NO ACTION;

