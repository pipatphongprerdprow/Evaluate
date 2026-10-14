import { isSuperAdmin } from '~/utils/superAdmins';

export default defineNuxtRouteMiddleware(async () => {
    const { getSession } = useAuth();
    const session = await getSession();
    if (!isSuperAdmin(session?.user?.name?.STAFFID)) {
        return navigateTo('/');
    }
});
