import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { CustomPrismaModule } from 'nestjs-prisma';
import { EXTENDED_PRISMA_SERVICE, getExtendedPrismaClient } from './extended-prisma-client';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { OIDCProviderService } from './oidc-provider.service';
import { readFileSync } from 'fs';
import { importPKCS8, exportJWK, JWK } from 'jose';
import { validate } from './env-validation';

@Module({
    imports: [
        ConfigModule.forRoot({ isGlobal: true, validate: validate }),
        CustomPrismaModule.forRootAsync({
            name: EXTENDED_PRISMA_SERVICE,
            useFactory: (config: ConfigService) => { // SO FUCKING STUPID, someone refactor this please
                return getExtendedPrismaClient(config.get<string>('BS_SITE_URL')!);
            },
            inject: [ConfigService],
        }),
    ],
    controllers: [AppController],
    providers: [
        AppService,
        {
            provide: "JWK",
            useFactory: async (): Promise<JWK> => {
                const pkcs8: string = readFileSync("./oauth-private.key", 'utf8');
                const keyImported: CryptoKey = await importPKCS8(pkcs8, 'RS256', { extractable: true });
                return exportJWK(keyImported);
            },
        },
        OIDCProviderService
    ],
})
export class AppModule { }

