# iOS SMS merge

This is a simple script to merge iOS SMS message SQLite databases. The script does not move attachment files, which can be found in `System Files/Media Domain/Library/SMS`. I developed this script for use with iOS 9.2, but it may work for older/newer versions.

**Always make backups of your backups before messing with things. Perform these steps at your own risk!**

### Instructions

1. Export your databases with something like iBackupBot (SMS messages are under User Information Manager) and place in the directory along this script.
2. Update the target and source database paths in `models.rb`
3. Install dependencies with `bundle install`
3. Run the script with `ruby merge_messages.rb`
4. Import the updated target db back into your phone (note: this can only be done to unencrypted backups)
5. Manually merge attachment folders and import back into your phone.
6. Restore the backup (using iTunes)
