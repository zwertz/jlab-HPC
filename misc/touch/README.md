## Usage Instructions

1. **Update `directories.txt`**:
   - Include full paths to directories containing files that need preservation, one path per line.
   - Example:
     ```
     /full/path/to/volatile/directory1
     /full/path/to/volatile/directory1/subdirectory
     /full/path/to/volatile/directory2
     ```

2. **Set Script Permissions**:
   - Make `touch_files.sh` executable:
     ```
     chmod u+x touch_files.sh
     ```

3. **Configure Crontab**:
   - Schedule the script in crontab for automatic execution. For weekly runs on Sunday:
     ```
     0 0 * * 0 /path/to/touch_files.sh
     ```
   - Adjust the crontab entry according to your scheduling needs.

This setup ensures your files remain accessible by periodically updating their timestamps, circumventing the auto-deletion policy of /volatile storage.