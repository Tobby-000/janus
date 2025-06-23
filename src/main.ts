import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { NestExpressApplication } from '@nestjs/platform-express';
import { RoutesWithoutCORS } from './blessing.types';
import { Request } from 'express';

async function bootstrap() {
  BigInt.prototype['toJSON'] = function () {
    const int = Number.parseInt(this.toString());
    return int ?? this.toString();
  };

  const app = await NestFactory.create<NestExpressApplication>(AppModule);

  /*
    > The Token Endpoint ... and any other endpoints directly accessed by Clients SHOULD support the use of Cross-Origin Resource Sharing (CORS) ...
    > The use of CORS at the Authorization Endpoint is NOT RECOMMENDED as it is redirected to by the client and not directly accessed.
    https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata
  */
  app.enableCors((req: Request, callback) => {
      callback(null, {
          origin: req.path.split('/', 2)[1] in RoutesWithoutCORS ? false : '*'
        }
      );
  });

  app.enable('trust proxy');
  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
