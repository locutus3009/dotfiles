local filesystem = require('gears.filesystem')
local config_dir = filesystem.get_configuration_dir()
local utils_dir = config_dir .. 'utilities/'

local editorGui 		= os.getenv("VISUAL") or "emacsclient -c -a emacs" or "emacs -nw"
local browser_google	    = "google-chrome-stable"
local browser_google_flags  = " --high-dpi-support=1 --force-device-scale-factor=1 --enable-extensions --embed-flash-fullscreen  --ignore-gpu-blacklist --password-store=basic --proxy-server=\"127.0.0.1:3128\""
local browser_firefox       = "firefox"
local browser_firefoxPrfls  = browser_firefox .. " --ProfileManager"
local browser    			= browser_google .. browser_google_flags
local browser_alternatives  = browser_firefoxPrfls

return {
   -- The default applications that we will use in keybindings and widgets
   default = {
      -- Default terminal emulator
      terminal = 'kitty',
      -- Default web browser
      web_browser = browser,
      web_browser_alternatives = browser_alternatives,
      -- Default text editor
      text_editor = editorGui,                                         -- GUI Text Editor
      -- Default file manager
      file_manager = 'nautilus',                                       -- GUI File manager
      file_manager_console = 'kitty --name ranger --class ranger ranger',             -- Console File manager
      -- Default media player
      multimedia = 'mpv',
      -- Default media player
      musicplayer = 'kitty --name ncmpcpp --class ncmpcpp ncmpcpp',
      -- Default game, can be a launcher like steam
      mail_client = 'thunderbird',
      -- Default graphics editor
      graphics = 'gimp-2.10',
      -- Default sandbox
      sandbox = 'virtualbox',
      -- Default IDE
      development = 'emacsclient',
      -- Default network manager
      network_manager = 'kitty --start-as maximized sleep && nmtui',
      -- Default bluetooth manager
      bluetooth_manager = 'blueman-manager',
      -- Default power manager
      power_manager = 'xfce4-power-manager',
      -- Default GUI package manager
      package_manager = 'pamac-manager',
      -- Default locker
      lock = 'awesome-client "awesome.emit_signal(\'module::lockscreen_show\')"',
      -- Default quake terminal
      quake = 'kitty --name QuakeTerminal',
      -- Default rofi global menu
      rofi_global = 'rofi -dpi ' .. screen.primary.dpi ..
         ' -show "Global Search" -modi "Global Search":' .. config_dir ..
         '/configuration/rofi/global/rofi-spotlight.sh' ..
         ' -theme ' .. config_dir ..
         '/configuration/rofi/global/rofi.rasi',
      -- Default app menu
      rofi_appmenu = 'rofi -dpi ' .. screen.primary.dpi ..
         ' -show drun -theme ' .. config_dir ..
         '/configuration/rofi/appmenu/blurry.rasi'

      -- You can add more default applications here
   },

   -- List of apps to start once on start-up
   run_on_start_up = {
      -- Compositor
      'picom -b --dbus --config ' ..
         config_dir .. '/configuration/picom.conf',
      -- Blueman applet
      -- 'blueman-applet',
      -- Music server
      'mpd',
      -- Polkit and keyring
      '/usr/bin/lxqt-policykit-agent &' ..
         ' eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)',
      -- Load X colors
      'xrdb $HOME/.Xresources',
      -- Audio equalizer
      -- 'pulseeffects --gapplication-service',
      -- Lockscreen timer
      -- [[
	  --   xidlehook --not-when-fullscreen --not-when-audio --timer 600 \
	  --   "awesome-client 'awesome.emit_signal(\"module::lockscreen_show\")'" ""
	  --   ]],

      -- You can add more start-up applications here
      'pulseaudio -vvvv --log-time=1 > $HOME/.cache/pulseverbose.log 2>&1',
      '/usr/lib/gsd-xsettings > $HOME/.cache/gnome-settings.log 2>&1'
   },

   -- List of binaries/shell scripts that will execute for a certain task
   utils = {
      -- Fullscreen screenshot
      full_screenshot = utils_dir .. 'snap full',
      -- Area screenshot
      area_screenshot = utils_dir .. 'snap area',
      -- Update profile picture
      update_profile  = utils_dir .. 'profile-image'
   }
}
