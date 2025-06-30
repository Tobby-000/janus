# Janus for Blessing Skin

Janus 是 [Blessing Skin Server](https://github.com/bs-community/blessing-skin-server) 的外挂 Yggdrasil Connect 服务端，基于 [NestJS](https://nestjs.com) 框架和 [oidc-provider](https://github.com/panva/node-oidc-provider) 库编写。

由于 Laravel 框架缺乏合适的 OpenID Connect 服务端扩展包，故采取这种外挂 OpenID Connect 服务端的方式为 Blessing Skin Server 实现 Yggdrasil Connect。

Janus 需要与 Blessing Skin Server 使用同一个 MySQL/MariaDB 数据库。不支持 PostgreSQL 和 SQLite 数据库。

## 环境需求

- Node.js >= 22.12.0
- Blessing Skin Server >= 6
    - 需要安装 [Yggdrasil Connect](https://github.com/bs-community/blessing-skin-plugins/blob/master/plugins/yggdrasil-connect) 插件，可在插件市场中下载
        - 该插件不需要也不可以与原版 Yggdrasil API 插件同时启用，但插件数据可以通用
        - 在安装完该插件后，请务必阅读该插件的 [README](https://github.com/bs-community/blessing-skin-plugins/blob/master/plugins/yggdrasil-connect/README.md)，了解如何配置该插件

## 部署指南

请查看 [Wiki - 部署指南](https://github.com/bs-community/janus/wiki/%E9%83%A8%E7%BD%B2%E6%8C%87%E5%8D%97)。

Janus **不是** 开箱即用的，需要手动构建。部署 Janus 并不难，但最好有一定的运维经验。

## 公共客户端支持

应用无需进行特殊设置，即可使用 Janus 通过 Authorization Code Grant 配合 Client Secret 获取 Access Token 和 ID Token。

但若要使用 Device Authorization Grant 等公共客户端使用的授权方式，则需要在应用设置中为应用启用公共客户端支持。请查看 [Wiki - 为应用启用公共客户端支持](https://github.com/bs-community/janus/wiki/%E4%B8%BA%E5%BA%94%E7%94%A8%E5%90%AF%E7%94%A8%E5%85%AC%E5%85%B1%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%94%AF%E6%8C%81)。

## 版权信息

Copyright 2025-present Blessing Skin Team. All rights reserved. Open source under the MIT license.

_Disclaimer：某站产品经理自己写代码的原则就是代码和人有一个能跑就行，自然有些代码很粗糙很难看很低效。如果你看着哪里的代码不爽，欢迎直接重构并 PR。_
