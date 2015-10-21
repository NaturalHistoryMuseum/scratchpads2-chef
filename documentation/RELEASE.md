Scratchpads Releases
====================

The process of creating a new Scratchpads release is actually quite simple. 
There are two mechanisms for creating a release, which depends on whether the 
release could require a database update (implementation of hook_updata_N()) to 
run. These two release types can be thought of as **major** and **minor**. 
Scratchpads version numbers should reflect these two release types. The version 
numbers follow the following basic format:

2.x.y[.z]

- 2: This is the version of Scratchpads, and is currently fixed. This could be
     bumped up following an upgrade to a higher version of Drupal.
- x: This number reflects a feature release of the Scratchpads. This number
     should be bumped up if any additional features have been added to the
     Scratchpads (and y should be reset to 0).
- y: This number reflects a bug release of the Scratchpads. This number should
     be bumped when any code is released that does not have new features (and z
     should be removed).
- z: This number reflects a point release of the Scratchpads. A point release
     is similar to a bug release, but does not require any database updates,
     and probably only fixes one or two issues. This number should only be
     required if non-zero.

Creating the git tag
--------------------

Releases are created as annotated tags in the Git repository. The process of 
creating a new tag is quite simple. Firstly, ensure the `CHANGELOG.md` file has 
been updated with details about the new release (the format of the file should 
be pretty obvious, with the file being wrapped at column 80). Commit the change 
to the CHANGELOG.md file, making a note of how many lines at the top of the 
file the information about the new release takes up (in the example below, the 
new release is the top '13' lines of CHANGELOG.md). Then simply create the new 
release, e.g:

```bash
git tag -a 2.9.9 -m "Scratchpads `head -n13 CHANGELOG.md`"
git push --tags
```

Major release
-------------

A major release should be created for all feature or bug releases (any increase 
to z or y above). A basic script is included on the control server 
(sp-control-1) which creates the new release platform. The script should be run 
as Aegir.

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
create-aegir-platform [Scratchpads release, e.g. "2.9.9"]
```

Once the platform has been created and imported into the Aegir frontend, the 
sites can then be migrated from the old release platform to the new release 
platform. Login to the Aegir interface and visit the Platforms page.

http://get.scratchpads.eu/hosting/platforms

Click on the old platform, and then click on "Run" alongside "Migrate". Select 
the new platform (e.g. scratchpads-2.9.9) and click submit. The submission 
process takes a little while to run, and requires an additional approval click. 
The whole process can take a few minutes to run before all of the migration 
tasks are created. Once the migration tasks are created, your browser window 
can be closed as the migrations run in the background on the control server. A 
migration process will take at least a few hours, and can take a few days 
depending on the complexity of the update and the number of sites.

N.B. There appears to be an issue with Aegir that results in the migration 
process failing if the site backup fails. A site backup can fail if a single 
file is not read (which can happen if the permissions on temporary/private 
files prevent reading by the Aegir user) or if a file changes while it is being 
read (e.g. if advagg changes a CSS/JS file). For this reason, it may be 
necessary to "Retry" any failed migration tasks.

Minor release
-------------

A minor release is much simpler than a major release, and simply involves 
changing the code on the control server. There is no need to restart Apache to 
make the update live, it should be automatic. The example below shows the 
commands required to update the code from Scratchpads 2.9.9 to Scratchpads 
2.9.9.1.

```bash
ssh sp-control-1.nhm.ac.uk
sudo su - aegir
cd /var/aegir/platforms/scratchpads-2.9.9
git pull
git checkout 2.9.9.1
```

Upgrading Drupal
----------------

The easiest way of upgrading the version of Drupal is to create a patch from 
the pervious version to the new version. This is very simple to do, and ensures 
that any patches on the Drupal code should be retained. To create the patch, 
download the current and previous versions of Drupal and extract them. Then 
create the patch between the two. For example, to create a patch that upgrades 
Drupal from 7.39 to 7.40 the following should be done:

```bash
wget http://ftp.drupal.org/files/projects/drupal-7.40.tar.gz -qq -O - | tar xz
wget http://ftp.drupal.org/files/projects/drupal-7.39.tar.gz -qq -O - | tar xz
diff -r -c drupal-7.39/ drupal-7.40/ > drupal.patch
rm -rf drupal-7.39 drupal-7.40
mv drupal.patch /path/to/scratchpads/code
cd /path/to/scratchpads/code
patch -p1 < drupal.patch
```

You will see errors regarding missing files (always CHANGELOG.txt and 
modules/php/php.info, and possibly others), but if everything goes to plan that 
should leave you with an upgraded Scratchpads installation. The patch process 
can be repeated on sp-control-1 if the Drupal release is an important security 
release.

```bash
scp drupal.patch sp-control-1:
ssh sp-control-1
sudo su -
cd /var/aegir/platforms/scratchpads-[VERSION]
patch -p1 < ~[YOUR USERNAME]/drupal.patch
```
