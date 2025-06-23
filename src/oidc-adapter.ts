import { Adapter, AdapterPayload, AdapterFactory } from 'oidc-provider';
import { ExtendedPrismaClient } from './extended-prisma-client';
import { ConfigService } from '@nestjs/config';

export type ModelType =
    "Grant" |
    "Session" |
    "AccessToken" |
    "AuthorizationCode" |
    "RefreshToken" |
    "ClientCredentials" |
    "Client" |
    "InitialAccessToken" |
    "RegistrationAccessToken" |
    "DeviceCode" |
    "Interaction" |
    "ReplayDetection" |
    "BackchannelAuthenticationRequest" |
    "PushedAuthorizationRequest";

export class OIDCAdapter implements Adapter {

    private readonly model: string;

    constructor(private readonly type: ModelType, private readonly prisma: ExtendedPrismaClient, private readonly config: ConfigService) {
        this.model = type.charAt(0).toLowerCase() + type.slice(1);
    }

    public static getAdapterFactory(prisma: ExtendedPrismaClient, config: ConfigService): AdapterFactory {
        return (type: ModelType) => {
            return new OIDCAdapter(type, prisma, config);
        };
    }

    async upsert(id: string, payload: AdapterPayload): Promise<any> {
        const data = {
            uid: payload.uid,
            payload: payload,
            userCode: payload.userCode
        };

        await this.prisma[this.model].upsert({
            where: {
                id: id
            },
            create: {
                id: id,
                ...data
            },
            update: {
                ...data
            }
        });
    }

    async find(id: string): Promise<AdapterPayload | undefined> {

        const data = await this.prisma[this.model].findFirst({
            where: {
                id: this.type == 'Client' ? parseInt(id) : id
            }
        });

        if (!data) {
            return undefined;
        }

        const accountId = data.payload?.accountId;
        if (accountId) {
            const user = await this.prisma.user.findFirst({
                where: {
                    uid: parseInt(accountId)
                }
            });

            if (!user) {
                return undefined;
            }
        }

        return data.payload;
    }

    async findByUserCode(userCode: string): Promise<AdapterPayload | undefined> {
        const data = await this.prisma.deviceCode.findFirst({
            where: {
                userCode: userCode
            }
        });

        if (data) {
            return data.payload;
        }
    }

    async findByUid(uid: string): Promise<AdapterPayload | undefined> {
        const data = await this.prisma[this.model].findFirst({
            where: {
                uid: uid
            }
        });

        if (!data) {
            return undefined;
        }

        return data.payload;
    }

    async consume(id: string): Promise<void> {
        await this.prisma[this.model].update({
            where: {
                id: id
            },
            data: {
                consumed: true
            }
        });
    }

    async destroy(id: string): Promise<void> {
        await this.prisma[this.model].deleteMany({
            where: {
                id: id
            }
        });
    }

    async revokeByGrantId(grantId: string): Promise<undefined | void> {
        await this.prisma.grant.deleteMany({
            where: {
                id: grantId
            }
        });
    }
}
