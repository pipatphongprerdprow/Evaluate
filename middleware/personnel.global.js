import { isPersonnelPage, isPersonnelRole } from '~/utils/authNavigation';

export default defineNuxtRouteMiddleware(async (to) => {
    if (!isPersonnelPage(to.path)) return;
    const { getSession } = useAuth();
    try {
        const session = await getSession();
        const user = session?.user?.name;
        if (!user?.STAFFID) return navigateTo('/', { replace: true });
        const result = await $fetch('http://127.0.0.1:8000/api/testUser', {
            method: 'POST',
            body: { staff: user.STAFFID, faculty: user.SCOPES?.staffdepartment },
            timeout: 10000
        });
        if (!isPersonnelRole(result)) return navigateTo('/', { replace: true });
    } catch {
        return navigateTo('/', { replace: true });
    }
});
