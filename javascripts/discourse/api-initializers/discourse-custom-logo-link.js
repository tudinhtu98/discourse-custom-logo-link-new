import { apiInitializer } from "discourse/lib/api";
import getURL from "discourse-common/lib/get-url";

export default apiInitializer("1.8.0", (api) => {
  api.registerValueTransformer(
    "home-logo-href",
    () => {
    const site = api.container.lookup("service:site");
    const user = api.getCurrentUser();

    let url;
    if (site.desktopView) {
      url = user ? settings.logged_in_desktop_url : settings.desktop_url;
    } else {
      url = user ? settings.logged_in_mobile_url : settings.mobile_url;
    }

    if (!url.length) {
      return getURL("/");
    }

    if (user) {
      url = url.replace("$username", user.username);
      url = url.replace("$user_id", user.id);
    }
    
    return url;
  });
});
