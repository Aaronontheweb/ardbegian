CHOICES=(
  "Cursor            AI Code Editor"
  "Doom Emacs        Emacs framework with curated list of packages"
  "JetBrains Toolbox Install JetBrains IDEs (Rider, IntelliJ, etc.)"
  "RubyMine          IntelliJ's commercial Ruby editor"
  "Windsurf          Another AI Code Editor"
  "Zed               Fast all-purpose editor"
  "<< Back           "
)

CHOICE=$(gum choose "${CHOICES[@]}" --height 9 --header "Install editor")

if [[ "$CHOICE" == "<< Back"* ]] || [[ -z "$CHOICE" ]]; then
  # Don't install anything
  echo ""
else
  # Extract the application name and map to the correct installer file
  case "$CHOICE" in
    "Cursor"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-cursor.sh"
      ;;
    "Doom Emacs"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-doom-emacs.sh"
      ;;
    "JetBrains Toolbox"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-jetbrains-toolbox.sh"
      ;;
    "RubyMine"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-rubymine.sh"
      ;;
    "Windsurf"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-windsurf.sh"
      ;;
    "Zed"*)
      INSTALLER_FILE="$OMAKUB_PATH/install/desktop/optional/app-zed.sh"
      ;;
    *)
      echo "Unknown choice: $CHOICE"
      exit 1
      ;;
  esac

  source $INSTALLER_FILE && gum spin --spinner globe --title "Install completed!" -- sleep 3
fi

clear
source $OMAKUB_PATH/bin/omakub-sub/header.sh
source $OMAKUB_PATH/bin/omakub-sub/install.sh
