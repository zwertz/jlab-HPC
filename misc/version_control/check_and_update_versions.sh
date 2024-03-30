#!/bin/bash

# Paths to relevant files and scripts
USER_VERSION_PATH="user_env_version.conf"
GITREPOS_FILE="gitrepos.sh"
SETUP_GITREPOS_SCRIPT="setup-gitrepos.sh"
SET_USER_VERSION_INFO_SCRIPT="set-user-version-info.sh"

# Function to check for missing versions or hashes
check_missing_versions() {
    if grep -E '^[A-Z_]+=$' "$USER_VERSION_PATH" > /dev/null; then
        return 0 # True, missing versions/hashes
    else
        return 1 # False, all versions/hashes are present
    fi
}

# Function to check for missing repository paths
check_missing_repos() {
    source "$GITREPOS_FILE"
    if [[ -z $G4SBS_REPO || -z $SIMC_REPO || -z $LIBSBSDIG_REPO || -z $SBSOFFLINE_REPO || -z $SBS_REPLAY_REPO ]]; then
        return 0 # True, missing repos
    else
        return 1 # False, no missing repos
    fi
}

# First, check for missing versions or hashes
if check_missing_versions; then
    echo "Missing versions or hashes in $USER_VERSION_PATH."
    # Next, check if any repository paths are missing
    if check_missing_repos; then
        echo "Missing repository paths detected. Executing $SETUP_GITREPOS_SCRIPT."
        ./$SETUP_GITREPOS_SCRIPT
    fi
    # Update user environment version information
    echo "Updating user environment version information."
    ./$SET_USER_VERSION_INFO_SCRIPT
else
    echo "All versions and hashes are present in $USER_VERSION_PATH."
fi

# Verify if updates were successful
if check_missing_versions; then
    echo "Warning: Not all versions or hashes could be updated in $USER_VERSION_PATH."
    read -p "Do you want to exit? (yes/no) " decision
    if [[ $decision == "yes" ]]; then
        echo "Exiting script..."
        exit 1
    else
        echo "Continuing without all versions or hashes."
    fi
else
    echo "Verification successful: All versions and hashes are now present."
fi
