import { Inject, Injectable } from '@nestjs/common';
import * as oidc from 'oidc-provider';
import { BS_RESOURCE_INDICATOR, OIDCProviderService } from './oidc-provider.service';
import { Request, Response } from "express";
import { CustomPrismaService } from 'nestjs-prisma';
import { EXTENDED_PRISMA_SERVICE, ExtendedPrismaClient } from './extended-prisma-client';
import { getDateWithTimezoneOffset } from './helper';
import { CodeIdToUUID, PassportAuthCode, User } from '@prisma/client';
import { YggCScopes } from './blessing.types';

@Injectable()
export class AppService {

    readonly callback: (req: Request, res: Response) => Promise<void>;
    private readonly provider: oidc.Provider;
    private readonly siteUrl: string;

    constructor(
        @Inject(EXTENDED_PRISMA_SERVICE) private readonly prisma: CustomPrismaService<ExtendedPrismaClient>,
        private readonly oidcProvider: OIDCProviderService,
    ) {
        this.provider = this.oidcProvider.provider;
        this.siteUrl = this.oidcProvider.siteUrl;
        this.callback = this.provider.callback();
    }

    async interaction(req: Request, res: Response): Promise<object | void> {

        const result = await this.provider.interactionDetails(req, res);

        const { params } = result;
        const url = `${this.siteUrl}/oauth/authorize?client_id=${params.client_id}&response_type=code&scope=${params.scope}&redirect_uri=${this.siteUrl}/yggc/callback&state=${result.jti}&prompt=consent`

        /* if(result.deviceCode) {
            return res.json({
                url: url
            });
        } */

        return res.redirect(url);
    }

    async interactionCallback(req: Request, res: Response): Promise<void> {
        const { code, error, error_description } = req.query as { code: string; error: string | undefined; error_description: string | undefined; };
        const { client_id, scope } = (await this.provider.interactionDetails(req, res)).params as { client_id: string; scope: string; };

        if (error) {
            return this.provider.interactionFinished(req, res, {
                error: error,
                error_description: error_description
            }, { mergeWithLastSubmission: false });
        }

        const authCode: PassportAuthCode | null = await this.prisma.client.passportAuthCode.findFirst({
            where: {
                id: code,
                revoked: false,
                expires_at: {
                    gte: getDateWithTimezoneOffset()
                }
            }
        });

        if (!authCode) {
            return this.provider.interactionFinished(req, res, {
                error: "invalid_grant",
                error_description: "Invalid or expired code"
            });
        }

        const user: User | null = await this.prisma.client.user.findFirst({
            where: {
                uid: Number(authCode?.user_id),
                verified: true,
                permission: {
                    not: -1
                }
            }
        });

        if (!user) {
            return this.provider.interactionFinished(req, res, {
                error: "invalid_grant",
                error_description: "Invalid or expired code"
            });
        }

        const scopesInSession: Set<string> = new Set(scope.split(" "));
        const scopesInBSAuth: Set<string> = new Set(scopesInSession);
        const scopes = scopesInSession.intersection(scopesInBSAuth);

        if (scopes.has(YggCScopes.PROFILE_SELECT)) {
            const codeIdToUUID: CodeIdToUUID | null = await this.prisma.client.codeIdToUUID.findFirst({
                where: {
                    code_id: code
                }
            });
            if (!codeIdToUUID) {
                return this.provider.interactionFinished(req, res, {
                    error: "invalid_grant",
                    error_description: "Invalid or expired code"
                });
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
                return this.provider.interactionFinished(req, res, {
                    error: "invalid_grant",
                    error_description: "Invalid or expired code"
                });
            }
        }

        const grant: oidc.Grant = new this.provider.Grant({
            clientId: client_id,
            accountId: user.uid.toString(),
        });

        scopes.forEach((scope) => {
            grant.addOIDCScope(scope);
            grant.addResourceScope(BS_RESOURCE_INDICATOR, scope);
        });

        grant.jti = code;
        await grant.save();

        await this.prisma.client.passportAuthCode.update({
            where: {
                id: code
            },
            data: {
                revoked: true,
            }
        });

        return this.provider.interactionFinished(req, res, {
            login: {
                accountId: user.uid.toString()
            },
            consent: {
                grantId: code
            }
        }, { mergeWithLastSubmission: false });
    }

    getSiteUrl(): string {
        return this.siteUrl;
    }
}
