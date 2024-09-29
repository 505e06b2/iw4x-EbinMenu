![screenshot](https://github.com/user-attachments/assets/28b9c7f2-835a-4076-b6fb-6186826c0c36)  
A scriptmenu for MW2, inspired by GSC menus of the past and with a focus on administration

## Why a ScriptMenu and not GSC?
- Doesn't appear in killcams
- Mouse-friendly
- Emulates the look and feel of the original in-game menus

## Mod Installation
1. Follow the steps on the [Alterware forum](https://forum.alterware.dev/t/how-to-install-the-alterware-launcher/56) to download and install the Alterware launcher
1. Download the mod asset from the [latest release](https://github.com/505e06b2/iw4x-EbinMenu/releases/latest/download/ebinmenu_mod.zip)
1. From inside this `.zip`, extract `ebinmenu` into your game's `mods` folder

## UserRaw Installation
1. Follow the steps on the [Alterware forum](https://forum.alterware.dev/t/how-to-install-the-alterware-launcher/56) to download and install the Alterware launcher
1. Download the userraw asset from the [latest release](https://github.com/505e06b2/iw4x-EbinMenu/releases/latest/download/ebinmenu_userraw.zip)
1. Change the extension of the downloaded `.zip` file to `.iwd`
1. Place this `.iwd` file into your game's `userraw` folder

## Manual Installation for Development
```bash
cd "$HOME/.steam/steam/steamapps/common/Call of Duty Modern Warfare 2"
mkdir -p mods
cd mods
git clone --recurse-submodules 'https://github.com/505e06b2/iw4x-EbinMenu' ebinmenu
cd ..
ln -rs mods/ebinmenu/ebinmenu_images.iwd userraw/
```

## Credits
This would not be possible without:
| Item | Author |
| --- | --- |
| [IW4x](https://github.com/iw4x/iw4x-client) | [The IW4x team and contributors](https://github.com/iw4x) |
| [Bot Warfare Mod](https://github.com/ineedbots/iw4_bot_warfare) | [INeedGames/INeedBot(s)](https://ineedbots.github.io/) |
| [IW4 Rawfiles](https://github.com/shit-ware/IW4) | [shit-ware](https://github.com/shit-ware/IW4) |
| Picking up where XLabs left off | [The Alterware team](https://alterware.dev/) |
