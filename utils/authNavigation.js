// Always return to this application, never to the previous protected page.
export function authHomeRedirect(baseUrl, basePath = '/', requestedUrl = '') {
    const home = new URL(basePath || '/', new URL(baseUrl).origin);
    try {
        const requested = new URL(requestedUrl, home);
        const timeout = requested.searchParams.get('timeout');
        if (requested.origin === home.origin && requested.pathname === home.pathname && /^\d+ (ชั่วโมง|นาที)$/.test(timeout || '')) {
            home.searchParams.set('timeout', timeout);
        }
    } catch {
        // Invalid or stale callback URLs still lead home.
    }
    return home.toString();
}

export function isPersonnelPage(path) {
    return /^\/setting\/(setting_date|setting_user|setting_useradmin|checkevaluate)(?:$|[\s/]|\d)/i.test(path);
}

export function isPersonnelRole(payload) {
    return String(payload?.[0]?.status_user ?? payload?.status_user ?? '') === '2';
}
