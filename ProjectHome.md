## Mush Platform for Web, more than CMS. ##

It make up of a small core runtime and  many addons(or plugins), just like eclipse platform but not for desktop, it is for web.

Core runtime in charge of managing all addons life cycle and composite them, both on front-end, back-end and administration console.

Every addon has several extension point, such as front-end pages, admin pages, admin navigation, back-end no-ui actions... As part of this platform, there are several core addons build-in there: site, column, article, template, user, admin. Other addons could be any web application, such as poll, comments, sns, forum, active forms, crawler etc... These addons could easily enable or disable on the fly(maybe we could provide an addon repository, in admin console user could see what's new to install or update). An addon could be easily added to any pages.

When using Mush Platform, you have a start point to any form of website or web applications. Not only developer but end user could run a website in a few minutes.

We use Ruby on Rails to build the platform.

Here we go ...

[Architecture](Architecture.md)

[References](References.md)