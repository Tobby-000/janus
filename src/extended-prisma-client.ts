import { PrismaClient } from '@prisma/client';

export function getExtendedPrismaClient(siteUrl: string) {
    const extendedPrismaClient = new PrismaClient().$extends({
        result: {
            client: {
                client_id: {
                    needs: { id: true },
                    compute(data: { id: bigint; }) {
                        return data.id.toString();
                    }
                },
                redirect_uris: {
                    needs: { redirect: true },
                    compute(data: { redirect: string; }) {
                        const splitted: string[] = data.redirect.split(',').map((uri: string) => uri.trim());
                        return splitted;
                    }
                }
            }
        },
    }).$extends({
        result: {
            client: {
                token_endpoint_auth_method: {
                    needs: { redirect_uris: true },
                    compute: (data: { redirect_uris: string[] }) => {
                        if(data.redirect_uris.indexOf(`${siteUrl}/yggc/client/public`) !== -1) {
                            return 'none';
                        }
                    }
                }
            }
        }
    }).$extends({
        result: {
            $allModels: {
                payload: {
                    compute(data: object | undefined) {
                        if (data != undefined) {
                            return data.hasOwnProperty('payload') ? data['payload'] : data;
                        }
                    },
                }
            },
        }
    });

    return extendedPrismaClient;
}

export type ExtendedPrismaClient = ReturnType<typeof getExtendedPrismaClient>;
export const EXTENDED_PRISMA_SERVICE = 'EXTENDED_PRISMA_SERVICE';