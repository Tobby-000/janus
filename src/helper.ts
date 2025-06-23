export function getDateWithTimezoneOffset(): Date {
    return new Date(Date.now() - new Date().getTimezoneOffset() * 60 * 1000);
}