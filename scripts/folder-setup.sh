#!/bin/bash

# Ensure in home directory
cd "$HOME" || { echo "Failed to change to home directory"; exit 1; }

# Coloring
INFO="\e[34m"
SUCCESS="\e[32m"
WARNING="\e[33m"
RESET="\e[0m"

# Newline
newline() {
  printf "\n"
}

# Setup folders
MAINFOLDERS=("Downloads" "Pictures" "Personal")
SUBFOLDERS=("archives" "works" "projects" "resources" "systems" "temp")

echo -e "${INFO}[+] Creating main folders${RESET}"
for main in "${MAINFOLDERS[@]}"; do
  mkdir -p "$main"
  echo -e "${SUCCESS}Folder $main created${RESET}"
done

newline

PERSONAL_DIR="Personal"
cd "$PERSONAL_DIR" || { echo "Failed cd into $PERSONAL_DIR"; exit 1; }

echo -e "${INFO}[+] Creating subfolders${RESET}"
for sub in "${SUBFOLDERS[@]}"; do
  mkdir -p "$sub"
  echo -e "${SUCCESS}Folder $sub created${RESET}"
done

newline

# Functions
simple_loop() {
  local NAME=$1

  shift

  local ITEM=("$@")

  echo -e "${INFO}[+] Creating $NAME folders${RESET}"
  for item in "${ITEM[@]}"; do
    mkdir -p "$item"
    echo -e "${SUCCESS}Folder $item created${RESET}"
  done
}

find_folder() {
  local TARGET="$1"

  for item in "${SUBFOLDERS[@]}"; do
    if [[ "$item" == "$TARGET" ]]; then
      echo "$item"
      return
    fi
  done
  echo ""
}

# Create folders inside archives folder
archives() {
  local ARCHIVE_FOLDERS=("files" "project-completed" "backup-conf")
  local ARCHIVE_SUBFOLDERS=("cli" "devops" "open-source" "szuryuu" "web")

  local ARCHIVE_DIR
  ARCHIVE_DIR=$(find_folder "archives")

  cd $ARCHIVE_DIR || { echo "Failed cd into $ARCHIVE_DIR"; exit 1; }

  echo -e "${INFO}[+] Creating archives folders${RESET}"
  for item in "${ARCHIVE_FOLDERS[@]}"; do
    mkdir -p "$item"
    echo -e "${SUCCESS}Folder $item created${RESET}"

    if [ "$item" == "project-completed" ]; then

      cd "$item"
      newline

      for sub in "${ARCHIVE_SUBFOLDERS[@]}"; do
        mkdir -p "$sub"

        echo -e "${SUCCESS}Subfolder $sub created${RESET}"
      done

      cd ..
      newline
    fi
  done

  cd ..
  newline
}

projects() {
  local PROJECT_FOLDERS=("cli" "devops" "open-source" "szuryuu" "web")
  local PROJECT_DIR
  PROJECT_DIR=$(find_folder "projects")

  cd $PROJECT_DIR || { echo "Failed cd into $PROJECT_DIR"; exit 1; }
  simple_loop "projects" "${PROJECT_FOLDERS[@]}"

  cd ..
  newline
}

resources() {
  local RESOURCE_FOLDERS=("knowledge" "sandbox" "notes" "templates" "snippets")
  local RESOURCE_DIR
  RESOURCE_DIR=$(find_folder "resources")

  cd $RESOURCE_DIR || { echo "Failed cd into $RESOURCE_DIR"; exit 1; }
  simple_loop "resources" "${RESOURCE_FOLDERS[@]}"

  cd ..
  newline
}

systems() {
  local SYSTEM_FOLDERS=("app" "fonts")
  local SYSTEM_DIR
  SYSTEM_DIR=$(find_folder "systems")

  cd $SYSTEM_DIR || { echo "Failed cd into $SYSTEM_DIR"; exit 1; }
  simple_loop "systems" "${SYSTEM_FOLDERS[@]}"

  cd ..
  newline
}

work() {
  local WORK_FOLDERS=("freelances" "industries" "internships")
  local WORK_DIR
  WORK_DIR=$(find_folder "works")

  cd $WORK_DIR || { echo "Failed cd into $WORK_DIR"; exit 1;}
  simple_loop "works" "${WORK_FOLDERS[@]}"

  cd ..
  newline
}

archives
projects
resources
systems
work
