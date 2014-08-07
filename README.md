# A very simple suite of backup scripts for Duplicity
This is a very simple and rough suite of backup scripts acting as a front-end for Duplicity:

- `backups.sample.conf` - Sample configuration file.
- `backups.conf` - Your configuration file.
- `rsync-backup` - Main backup script that parses backups.conf. Performs backups and outputs to log.
- `rsync-backup-command` - Run any command against Duplicity using the configuration defined in backups.conf
- `rsync-archive-logs` - tar/gzips old logs in the log directory.
- `rsync-cleanup-prune` - Runs the `cleanup` and `remove-older-than 30D` Duplicity commands on each backup point defined in backups.conf.
- `rsync-verify-backup` - Runs the `verify` Duplicity command on each backup point defined in backups.conf.

# Requirements
- Duplicity - http://duplicity.nongnu.org
- GnuPG (for encrypted backups)
- bash, tar, rm
- A remote backup location (local host or a remote host via protocol supported by Duplicity. See duplicity documentation)

# Installation
- Install [Duplicity](http://duplicity.nongnu.org). This is also usually available from package managers.
- If you wish to encrypt your backups, create and configure an asymmetric key pair using GnuPG. See [GnuPG Documentation](http://www.dewinter.com/gnupg_howto/english/GPGMiniHowto-3.html#ss3.1) for details.
- `git clone` this repository to a directory of your choice.
- Use `backups.sample.conf` to configure your backups. Rename and save in same directory, with filename `backups.conf`.
- Use `crontab -e` or other method to schedule the backups; sample crontab is below.

## Suggested crontab

Here is a sample crontab with weekly full backups and daily incremental backups.

```
# Daily backup (Mon-Sat inc backup)
30  0    *   *   *   /home/jfritz/backup-scripts/rsync-cleanup-prune
0   1    *   *   1-6 /home/jfritz/backup-scripts/rsync-backup inc

# Weekly full backup (Sunday)
0   2    *   *   0   /home/jfritz/backup-scripts/rsync-backup full

# Monthly Log Cleanup
0   3   1   *   *   /home/jfritz/backup-scripts/rsync-archive-logs

```

**Caution: ** Be careful about putting rsync-verify-backup in your crontab; the Duplicity `verify` command downloads backups and decrypts them in order to verify them.
