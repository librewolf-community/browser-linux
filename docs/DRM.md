## DRM Compatibility

Digital rights management (DRM) is enforced off by default (this is needed for Netflix and similar); you can enable it with the following instructions:

- Open `librewolf.cfg`
- Under the section `Section: User Settings`
- Comment the active lines with `// ` under the subsection `User Settings: DRM/CDM - Main`
- Comment the active lines with `// ` under the subsection `User Settings: DRM/CDM - Widevine`
- Restart Firefox then open `about:preferences` and enable `Play DRM...` under general section
- Firefox will download Widevine and enable it (under `about:addons` plugins section) you can force the download by clicking `Check for updates` under the tools button


