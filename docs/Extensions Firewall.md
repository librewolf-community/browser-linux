## Extensions Firewall

### Description

*This is a test experiment feature and it is disabled by default.*

A new section `Extensions Manager` is added to manage addons globally (and addons networking in the subsection `Extensions Firewalling`). Firewalling the network for addons is doable, but it requires a considerable amount of additional work in LibreWolf to make it usable through a button or in a per addon basis (this may or may not be added in a future version, it also could be abandoned as it is a test feature). Currently you can block a list of domains or block the whole network for all the extensions.

### The Settings

Available native network restriction settings for addons:

- Restricted domains list: `extensions.webextensions.restrictedDomains` this is a list of restricted domains that will be used to block some hosts for all the extensions, Firefox uses this setting to block extensions from accessing mozilla's domains/sites, by default in LibreWolf this setting is set to allow extensions to access all the web (You can edit that list to match your needs or to block a specific domain, note that the domain name has to be 'exact' (for instance facebook.com will only block facebook.com not mobile.facebook.com)
- Content security policy: `extensions.webextensions.base-content-security-policy` and `extensions.webextensions.default-content-security-policy` the later settings can be redefined/changed within an extension so it's not efficient for a firewall purpose. CSP settings are used in Firefox as an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement to distribution of malware; In short: CSP settings block and allow certain domains under certain circumstances and thus could be used to firewall the extensions ([CSP Documentations](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP), its [sources code](https://code.compassfoundation.io/general/mozilla-central/commit/623a4f866576815dfcbab26323d13b7144806bdf?view=inline&w=1) and [implementation](https://github.com/mozilla/gecko/blob/central/toolkit/components/extensions/ExtensionPolicyService.cpp))

### Blocking A Domain

Edit the restricted domains setting as follow under the `about:config` page:

- Restricted Domains Setting: `extensions.webextensions.restrictedDomains` Value: `ExactDomains1,ExactDomains2,ExactDomains3` etc.

### Blocking The Network

To enable the feature and block the network for all the extensions open `librewolf.cfg` search for `Enable-Firewall-Feature-In-The-Next-Line` and remove the `//` in the next line.

Note that this will block the network access for all the extensions and a lot of extensions needs to be connected in order to work. In the current version of LibreWolf you can block the network for all the extensions or allow it for all of them, a future version may provide additional features like "per addon" setting (By default LibreWolf allows networking for extensions).

### More Infos

Check `debug-notes.log` for additional info about future version and researches about the subject. Also check [CSP Documentations](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP), its [sources code](https://code.compassfoundation.io/general/mozilla-central/commit/623a4f866576815dfcbab26323d13b7144806bdf?view=inline&w=1) and [implementation](https://github.com/mozilla/gecko/blob/central/toolkit/components/extensions/ExtensionPolicyService.cpp).

