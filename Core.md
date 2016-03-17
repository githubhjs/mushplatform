## Summary ##

**Core** will be in charge of all plugins life cycle and provide core extension points, plugin api, administration console as well the entry of front-end.

  * **Plugin API**
  * **Plugins Init and Registry**
  * **Admin Console**
  * **Entry of Front-End**
  * **Core Extension Points**

## Details ##
We use [rails-engines](http://rails-engines.org) as part of our plugin core. Because engines has already implemented a mechanism which could extract some application code into a plugin.

For plugin with in Mush Platform, it is a common rails plugin and most of its code is just as normal rails code which has controllers, models, views, helpers, migrations even rake tasks. Except the normal code, as a plugin in Mush Platform, it should also follow below rules:

  * All plugins located in $RAILS\_ROOT/plugins
  * In plugin direcory there should have a class(file) maybe named PluginName(plugin.rb) extends plugin interface, in this class we could define some plugin's activities, include author, version, desc, routes, scriptlets, extension-points registration and etc ...
  * We should have a set of helper class which utilize extension-point registration, extension-point execution, scriptlet render etc ...
  * At any places we use scriptlet(such as template, artilce or other plugin page), there should have some helper method to include the required plugin files.

Detail description of each parts

#### [Plugin API](PluginAPI.md) ####
Define serials packages, classes and utils for plugins, core module could invoke every plugin in same way, as well as reduce effort to develop plugins

  * **Common code**
  * models
  * controllers
  * views
  * helpers
  * migrations
  * etc ...

  * **Extension class**
  * extends from Extension base class
  * some utilized methods for extensions

  * **Scriptlet class**
  * extends from Scriptlet base class
  * some utilized methods for scriptlets using in other places

  * **Plugin declare class**
  * extends from Plugin base class
  * declare controllers, helpers, views if needed
  * declare routes
  * declare extensions (add\_extension or add\_filter or add\_action), add methods to different extension-points
  * declare scriptlets

  * **Init.rb**
  * normal init.rb file

#### [Plugins Init and Registry](PluginRegistry.md) ####
Load all plugins in certain directory and register all their extension (which will be invoke at certain extension point) into a global registry waiting be invoked

  * **Initialize plugins**
  * load plugin
  * initialize if active
  * register extensions
  * register scriptlets

  * **Extension-Point execution**
  * search for specific extension-point
  * execute every registered method
  * return result or nothing or follow the chain

  * **Using scriptlets**
  * require plugin files
  * render scriptlets

#### [Admin Console](AdminConsole.md) ####
The default admin console for plugin administration and could carry on core admin console extension points

#### [Entry of Front-End](EntryOfFE.md) ####
This part is for front end, we must have some places to display our front-end plugin's render result

#### [Core Extension Points](CoreExtensionPoints.md) ####
Define some core extension points for other plugins use, not only for core plugin but 3rd parties'