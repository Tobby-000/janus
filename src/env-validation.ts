import { plainToInstance } from "class-transformer";
import { IsNotEmpty, IsNumber, IsString, IsUrl, Max, Min, registerDecorator, validateSync, ValidationArguments, ValidationOptions } from "class-validator";

class Env {

    @IsNumber()
    @Min(0)
    @Max(65535)
    PORT: number;

    @IsString()
    @IsNotEmpty()
    DB_HOST: string;

    @IsNumber()
    @Min(0)
    @Max(65535)
    DB_PORT: number;

    @IsString()
    @IsNotEmpty()
    DB_USERNAME: string;

    @IsString()
    @IsNotEmpty()
    DB_PASSWORD: string;

    @IsString()
    @IsNotEmpty()
    DB_NAME: string;

    @IsUrl({ require_tld: false })
    @IsSecureUrl()
    ISSUER: string;

    @IsUrl({ require_tld: false })
    @IsSecureUrl()
    BS_SITE_URL: string;

    @IsString()
    SHARED_CLIENT_ID: string;

    @IsNumber()
    TOKEN_EXPIRES_IN_1: number;

    @IsNumber()
    TOKEN_EXPIRES_IN_2: number;

    @IsNumber()
    DEVICE_CODE_EXPIRES_IN: number;

    @IsNumber()
    GRANT_EXPIRES_IN: number;
}

function IsSecureUrl(property?: string, validationOptions?: ValidationOptions) {
    return function (object: Object, propertyName: string) {
        registerDecorator({
            name: 'isSecureUrl',
            target: object.constructor,
            propertyName: propertyName,
            options: validationOptions,
            constraints: [property],
            validator: {
                validate(value: string, args: ValidationArguments) {
                    const url = new URL(value);
                    return (url.protocol === 'https:' || url.hostname == 'localhost') && !url.search.length && !url.hash.length && !value.endsWith('/');
                },
                defaultMessage(args: ValidationArguments) {
                    return `${args.property} must be a secure URL (either localhost or HTTPS), not end with a slash, and not contain queries and fragments.`;
                }
            }
        })
    };
}

export function validate(config: Record<string, unknown>) {
    const validatedConfig = plainToInstance(
        Env,
        config,
        { enableImplicitConversion: true },
    );
    const errors = validateSync(validatedConfig, { skipMissingProperties: false });

    if (errors.length > 0) {
        throw new Error(errors.toString());
    }
    return validatedConfig;
}