{ stdenv, writeScript, writeScriptBin, feh, rsync }:

let
  action = writeScript "action" ''
    #!${stdenv.shell}
    if [ $(($2 > $3)) -eq 1 ]; then
      ${feh}/bin/feh --bg-fill "$1"
      ln "$1" $HOME/pics/wallpapers/current
    else
      ln "$1" $HOME/pics/wallpapers/phone
      ${rsync}/bin/rsync -avz --delete $HOME/pics/wallpapers/phone/ inf:/webroot/www/pwp
    fi
  '';
in writeScriptBin "pics" ''
  ${feh}/bin/feh -.zZY -B black -A "${action} %F %w %h &" -D 3 ~/pics/anime
''
