# A real macOS application

In the `/xcode` folder there is the source for a real macOS application. It is written in SwiftUI 4, so it only works on macOS Ventura. It is a frontend for the scripts.

If you build the application, it will be "self contained", e.g., all the scripts will be inside the app bundle and you can drop it anywhere you like. It has it's own configuration as well and doesn't care about the settings in `config.zsh` and the scripts don't have to be in your `$PATH`.

---

The only thing left is that you have to install the `GreatVibes` font on your system and off course the external applications like Pandoc, LuaLaTex etc...

![](images/mac-app.png)



