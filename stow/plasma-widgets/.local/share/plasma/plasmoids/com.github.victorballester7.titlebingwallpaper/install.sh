# copy contents inside /package to .local/share/plasma/plasmoids/
folder="com.github.victorballester7.titlebingwallpaper"
dir="$HOME/.local/share/plasma/plasmoids/$folder"
# remove old files
rm -rf $dir
# copy new files
mkdir -p $dir
cp -r ./package/* $dir