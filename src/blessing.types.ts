export type YggdrasilProfile = {
    id: string;
    name: string;
};

export type UserInfo = {
    sub: string;
    nickname?: string;
    email?: string;
    email_verified?: boolean;
    picture?: string;
    selectedProfile?: YggdrasilProfile;
    availableProfiles?: YggdrasilProfile[];
};

export enum YggCScopes {
    OPENID = 'openid',
    PROFILE = 'profile',
    EMAIL = 'email',
    PROFILE_SELECT = 'Yggdrasil.PlayerProfiles.Select',
    PROFILE_READ = 'Yggdrasil.PlayerProfiles.Read',
    SERVER_JOIN = 'Yggdrasil.Server.Join'
}

export enum YggCClaims {
    NICKNAME = 'nickname',
    PICTURE = 'picture',
    EMAIL = 'email',
    EMAIL_VERIFIED = 'email_verified',
    SELECTED_PROFILE = 'selectedProfile',
    AVAILABLE_PROFILES = 'availableProfiles'
}

export const BS_RESOURCE_INDICATOR: string = "https://github.com/bs-community/blessing-skin-server";
export const ACCESS_TOKEN_NAME: string = "Yggdrasil Connect";

export enum RoutesWithoutCORS {
    'auth',
    'device',
    'interaction'
}
