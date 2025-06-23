import * as oidc from 'oidc-provider';
import { OIDCAdapter } from './oidc-adapter';
import { EXTENDED_PRISMA_SERVICE, ExtendedPrismaClient } from './extended-prisma-client';
import { JWK } from 'jose';
import { getDateWithTimezoneOffset } from './helper';
import { ConfigService } from '@nestjs/config';
import { UserInfo, YggCClaims, YggCScopes, YggdrasilProfile } from './blessing.types';
import { CodeIdToUUID, PassportAccessToken, Player, UUID } from '@prisma/client';
import { Inject, Injectable } from '@nestjs/common';
import { CustomPrismaService } from 'nestjs-prisma';

export const BS_RESOURCE_INDICATOR: string = "https://github.com/bs-community/blessing-skin-server";
export const ACCESS_TOKEN_NAME: string = "Yggdrasil Connect";

@Injectable()
export class OIDCProviderService {
    readonly provider: oidc.Provider;
    readonly siteUrl: string;
    readonly session: oidc.Session;

    constructor(
        private readonly config: ConfigService,
        @Inject(EXTENDED_PRISMA_SERVICE) private readonly prisma: CustomPrismaService<ExtendedPrismaClient>,
        @Inject("JWK") private readonly jwk: JWK,
    ) {
        const siteUrl: string = this.config.get<string>("BS_SITE_URL")!;
        const issuer: string = this.config.get<string>("ISSUER")!;
        const tokenExpiresIn1: number = this.config.get<number>("TOKEN_EXPIRES_IN_1")!;
        const tokenExpiresIn2: number = this.config.get<number>("TOKEN_EXPIRES_IN_2")!;
        const deviceCodeExpiresIn: number = this.config.get<number>("DEVICE_CODE_EXPIRES_IN")!;
        const grantExpiresIn: number = this.config.get<number>("GRANT_EXPIRES_IN")!;
        const sharedClientId: string | undefined = this.config.get<string>("SHARED_CLIENT_ID");

        const basePolicy = oidc.interactionPolicy.base();
        const loginPrompt = basePolicy.get('login')!;
        const consentPrompt = basePolicy.get('consent')!;
        const grantPrompt = new oidc.interactionPolicy.Prompt({ name: 'grant', requestable: true }, new oidc.interactionPolicy.Check('grant', 'invalid grant', (ctx) => {
            const oidcContext = ctx.oidc;
            if (!oidcContext.entities.Grant) {
                return oidc.interactionPolicy.Check.REQUEST_PROMPT;
            }
            return oidc.interactionPolicy.Check.NO_NEED_TO_PROMPT;
        }));

        const provider = new oidc.Provider(issuer, {
            adapter: OIDCAdapter.getAdapterFactory(this.prisma.client, this.config),
            jwks: {
                keys: [this.jwk]
            },
            clientAuthMethods: [
                'client_secret_post',
                'none'
            ],
            responseTypes: ['code', 'id_token', 'code id_token'],
            claims: {
                [YggCScopes.PROFILE]: [YggCClaims.NICKNAME, YggCClaims.PICTURE],
                [YggCScopes.EMAIL]: [YggCClaims.EMAIL, YggCClaims.EMAIL_VERIFIED],
                [YggCScopes.PROFILE_SELECT]: [YggCClaims.SELECTED_PROFILE],
                [YggCScopes.PROFILE_READ]: [YggCClaims.AVAILABLE_PROFILES]
            },
            scopes: [
                YggCScopes.EMAIL,
                YggCScopes.PROFILE,
                YggCScopes.PROFILE_SELECT,
                YggCScopes.PROFILE_READ,
                YggCScopes.SERVER_JOIN,
                'offline_access',
                'openid'
            ],
            async loadExistingGrant(ctx: oidc.KoaContextWithOIDC) {
                const grantId = ctx.oidc.result?.consent?.grantId;
                if (grantId) {
                    return ctx.oidc.provider.Grant.find(grantId);
                }
                return undefined;
            },
            findAccount: this.findAccount.bind(this),
            conformIdTokenClaims: false,
            features: {
                deviceFlow: {
                    enabled: true,
                },
                dPoP: {
                    enabled: false
                },
                devInteractions: { enabled: false },
                resourceIndicators: {
                    enabled: true,
                    defaultResource(ctx: oidc.KoaContextWithOIDC, client: oidc.Client, oneOf: string[] | undefined) {
                        return BS_RESOURCE_INDICATOR;
                    },
                    getResourceServerInfo(ctx: oidc.KoaContextWithOIDC, resourceIndicator: string, client: oidc.Client) {
                        return {
                            scope: Array.from(ctx.oidc.requestParamScopes).join(' '),
                            audience: BS_RESOURCE_INDICATOR,
                            accessTokenFormat: 'jwt',
                            jwt: {
                                sign: { alg: 'RS256' },
                            },
                        };
                    },
                    useGrantedResource(ctx: oidc.KoaContextWithOIDC, model) {
                        return true;
                    },
                },
                pushedAuthorizationRequests: {
                    enabled: false
                },
                rpInitiatedLogout: {
                    enabled: false
                }
            },
            formats: {
                customizers: {
                    async jwt(ctx, token, jwt) {
                        jwt.payload.aud = ctx.oidc.client!.clientId;
                        return jwt;
                    },
                }
            },
            interactions: {
                policy: [
                    loginPrompt,
                    grantPrompt,
                    consentPrompt
                ],
                url(ctx, interaction) {
                    const prompt = interaction.prompt;
                    return `/interaction/${interaction.uid}`;
                },
            },
            async extraTokenClaims(ctx: oidc.KoaContextWithOIDC, token: oidc.AccessToken) {
                const oidcContext = ctx.oidc;
                const claims: oidc.AccountClaims | undefined = await oidcContext.account?.claims('id_token', token.scope!, {}, []);
                const selectedProfile = claims?.selectedProfile as YggdrasilProfile | undefined;
                return {
                    selectedProfile: selectedProfile?.id,
                    scopes: Array.from(oidcContext.entities.RefreshToken?.scopes ?? token.scopes)
                };
            },
            expiresWithSession(ctx: oidc.KoaContextWithOIDC, token): boolean {
                return false;
            },
            ttl: {
                AccessToken: tokenExpiresIn1,
                AuthorizationCode: 10 * 60,
                DeviceCode: deviceCodeExpiresIn,
                Grant: grantExpiresIn,
                IdToken: tokenExpiresIn1,
                RefreshToken: tokenExpiresIn2,
                Session: 15 * 60,
                Interaction: 15 * 60,
            },
            rotateRefreshToken: true,
            routes: {
                userinfo: '/userinfo'
            },
            clientDefaults: {
                application_type: 'native',
                response_types: ['code', 'id_token', 'code id_token'],
                grant_types: ['authorization_code', 'implicit', 'refresh_token', 'urn:ietf:params:oauth:grant-type:device_code'],
                token_endpoint_auth_method: "client_secret_post"
            },
            discovery: {
                shared_client_id: sharedClientId?.length ? sharedClientId : undefined,
            },
        });

        provider.proxy = true;

        provider.on('server_error', (ctx, error) => {
            console.log(error);
            console.log(error.stack);
        });

        /* 
            如果签发的 Access Token 是 JWT，oidc-provider 不会把 Access Token 写到数据库里
            所以要手动把 Access Token 保存到 Laravel Passport 的数据表中
        */
        provider.on('access_token.issued', async (token: oidc.AccessToken) => {

            const date: Date = getDateWithTimezoneOffset();
            const maxTokenCount = parseInt(await this.getBlessingOption("ygg_tokens_limit", "5"));
            const tokenIssued: PassportAccessToken[] = await prisma.client.passportAccessToken.findMany({
                where: {
                    client_id: parseInt(token.clientId!),
                    user_id: parseInt(token.accountId),
                    name: ACCESS_TOKEN_NAME,
                    revoked: false,
                    expires_at: {
                        gte: date
                    }
                }
            });

            if (tokenIssued.length >= maxTokenCount) {
                tokenIssued.slice(0, tokenIssued.length - maxTokenCount + 1).forEach(async (token) => {
                    await prisma.client.passportAccessToken.update({
                        where: {
                            id: token.id
                        },
                        data: {
                            revoked: true,
                        }
                    });
                });
            }

            await prisma.client.passportAccessToken.create({
                data: {
                    id: token.jti,
                    client_id: parseInt(token.clientId!),
                    user_id: parseInt(token.accountId),
                    name: ACCESS_TOKEN_NAME,
                    scopes: JSON.stringify(token.extra?.scopes),
                    revoked: false,
                    created_at: date,
                    expires_at: new Date(date.getTime() + token.expiration * 1000),
                }
            });
        });

        provider.on('refresh_token.consumed', async (rotatedRefreshToken: oidc.RefreshToken) => {
            const passportRefreshToken = await prisma.client.passportRefreshToken.findFirst({
                where: {
                    id: rotatedRefreshToken.jti,
                    revoked: false,
                    expires_at: {
                        gte: getDateWithTimezoneOffset()
                    }
                },
                select: {
                    access_token_id: true,
                }
            });

            if (passportRefreshToken) {
                await prisma.client.passportAccessToken.update({
                    where: {
                        id: passportRefreshToken.access_token_id
                    },
                    data: {
                        revoked: true
                    }
                });

                await prisma.client.passportRefreshToken.update({
                    where: {
                        id: rotatedRefreshToken.jti
                    },
                    data: {
                        revoked: true
                    }
                });
            }
        });

        /*
            刷新 Access Token 时也没法吊销原先的 Access Token，因为 oidc-provider 根本不知道上次签发的 Access Token 是哪个
            所以要把 Refresh Token 对应的 Access Token 存起来，在刷新 Access Token 时手动吊销
        */
        provider.on('access_token.issued', this.saveRefreshTokenToPassport.bind(this));
        provider.on('refresh_token.saved', this.saveRefreshTokenToPassport.bind(this));

        this.siteUrl = siteUrl;
        this.provider = provider;
    }

    async findAccount(ctx: oidc.KoaContextWithOIDC, id: string, token?: oidc.AuthorizationCode | oidc.AccessToken | oidc.DeviceCode | oidc.RefreshToken): Promise<oidc.Account | undefined> {
        const grantId = ctx.oidc.result?.consent?.grantId ?? token?.grantId;

        const authCode = await this.prisma.client.passportAuthCode.findFirst({
            where: {
                id: grantId,
                user_id: parseInt(id),
            }
        });

        if (!authCode) {
            return undefined;
        }

        const grant = ctx.oidc.entities.Grant ?? await ctx.oidc.provider.Grant.find(grantId!);
        if (!grant) {
            return undefined;
        }

        const user = await this.prisma.client.user.findFirst({
            where: {
                uid: Number(authCode.user_id),
                verified: true,
                permission: {
                    not: -1
                }
            }
        });

        if (!user) {
            return undefined;
        }

        const userInfo: UserInfo = {
            sub: id,
            nickname: user.nickname,
            email: user.email,
            email_verified: Boolean(user.verified),
            picture: `${this.siteUrl}/avatar/user/${user.uid}`,
        };

        const scopes: string[] | undefined = grant.resources?.[BS_RESOURCE_INDICATOR]?.split(' ');

        if (scopes?.includes(YggCScopes.PROFILE_SELECT)) {
            const codeIdToUUID: CodeIdToUUID | null = await this.prisma.client.codeIdToUUID.findFirst({
                where: {
                    code_id: grantId
                }
            });
            if (!codeIdToUUID) {
                return undefined;
            }
            const uuid = await this.prisma.client.uUID.findFirst({
                where: {
                    uuid: codeIdToUUID.uuid
                },
                include: {
                    player: true
                }
            });
            if (!uuid) {
                return undefined;
            }
            userInfo.selectedProfile = {
                id: uuid.uuid,
                name: uuid.player!.name
            };
        }

        if (scopes?.includes(YggCScopes.PROFILE_READ)) {
            const players: Player[] = await this.prisma.client.player.findMany({
                where: {
                    uid: user.uid
                }
            });
            userInfo.availableProfiles = await Promise.all(players.map(async (player) => {
                const uuid: UUID | null = await this.prisma.client.uUID.findFirst({
                    where: {
                        pid: player.pid
                    }
                });
                return uuid ? { id: uuid.uuid, name: player.name } : null;
            })).then(profiles => profiles.filter(profile => profile !== null));
        }

        return {
            accountId: userInfo.sub,
            async claims(use: string, scope: string, claims: object, rejected: string[]) {
                return userInfo;
            }
        };
    }

    /* 
        oidc-provider 的事件触发很奇怪
        当通过请求授权签发 Access Token 时，会先触发 access_token.issued 事件，再触发 refresh_token.saved 事件
        但在刷新 Access Token 时，会先触发 refresh_token.saved 事件，再触发 access_token.issued 事件
        所以两个事件的监听器中都需要尝试 upsert，确保 Refresh Token 保存在 Laravel Passport 的数据表中
    */
    async saveRefreshTokenToPassport() {
        // @ts-ignore
        const ctx: oidc.OIDCContext | undefined = oidc.Provider.ctx?.oidc;

        if (ctx?.entities.AccessToken && ctx?.entities.RefreshToken) {
            const accessToken = ctx.entities.AccessToken;
            const refreshToken = ctx.entities.RefreshToken;
            await this.prisma.client.passportRefreshToken.upsert({
                where: {
                    id: refreshToken.jti
                },
                create: {
                    id: refreshToken.jti,
                    access_token_id: accessToken.jti,
                    revoked: false,
                    expires_at: new Date(getDateWithTimezoneOffset().getTime() + refreshToken.expiration * 1000),
                },
                update: {}
            });
        }
    }

    async getBlessingOption(name: string): Promise<string | null>;
    async getBlessingOption(name: string, defaultValue: string): Promise<string>;
    async getBlessingOption(name: string, defaultValue?: string): Promise<string | null> {
        const option = await this.prisma.client.option.findFirst({
            where: {
                name: name
            },
            select: {
                value: true
            }
        });

        if (!option) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            return null;
        }

        return option.value;
    }
}
