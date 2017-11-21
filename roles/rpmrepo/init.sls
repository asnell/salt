import:
  - repos.centos.base
  - repos.centos.extras
  - repos.centos.updates
  - repos.epel
  - repos.ius
  - repos.mongo
  - repos.salt
  - repos.nodejs
  - repos.sensu

rpmrepo-packages:
  pkg.installed:
    - pkgs:
      - yum-utils
      - createrepo
      - httpd
      - rsync

rpmrepo-directory-centos:
  file.directory:
    - name: /var/www/html/prod/centos
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-epel:
  file.directory:
    - name: /var/www/html/prod/epel
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True
    
rpmrepo-directory-salt:
  file.directory:
    - name: /var/www/html/dev/salt
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-mongo:
  file.directory:
    - name: /var/www/html/dev/mongo/7/3.0
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-node5:
  file.directory:
    - name: /var/www/html/dev/nodesource/el7/5
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-node6:
  file.directory:
    - name: /var/www/html/dev/nodesource/el7/6
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-node7:
  file.directory:
    - name: /var/www/html/dev/nodesource/el7/7
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-node8:
  file.directory:
    - name: /var/www/html/dev/nodesource/el7/8
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-ius:
  file.directory:
    - name: /var/www/html/dev/ius/7
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-sensu6:
  file.directory:
    - name: /var/www/html/dev/sensu/6
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-directory-sensu7:
  file.directory:
    - name: /var/www/html/dev/sensu/7
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

rpmrepo-httpd:
  service.running:
    - name: httpd
    - enable: True

# NOTE: Will download *ALL* available packages per /etc/yum.conf
#reposync-cmd:
#  cmd.run:
#    - name: reposync -p /var/www/html

#createrepo-cmd:
#  cmd.run:
#    - name: createrepo /var/www/html/base/Packages

# add cron jobs for reposync, createrepo --update
#reposync -p /var/www/html:
#  cron.present:
#    - identifier: RPMREPO_REPOSYNC
#    - user: root
#    - hour: 2
#    - minute: random

rpmrepo-cron-rsync-centos:
  cron.present:
    - name: /usr/bin/rsync -avzH --delete --delete-after --exclude=HEADER.* --exclude=2*/ --exclude=3*/ --exclude=4*/ --exclude=5*/ --exclude=isos/i386/ --exclude=centosplus/ --exclude=contrib/ --exclude=cr/--exclude=extras/5 --exclude=extras/4 --exclude=os/i386/ --exclude=updates/i386 --exclude=fasttrack/i386/ --exclude=isos/x86_64/ --exclude=cloud/ --exclude=sclo/ mirrors.kernel.org::centos/ /var/www/html/dev/centos
    - identifier: RPMREPO_CENTOS
    - user: root
    - hour: 3
    - minute: 0

rpmrepo-cron-rsync-epel:
  cron.present:
    - name: /usr/bin/rsync -avzH --numeric-ids --delete --delete-after --exclude=4/ --exclude=4AS/ --exclude=4ES/ --exclude=4WS/ --exclude=5/ --exclude=5Client/ --exclude=5Server/ --exclude=SRPMS/ --exclude=ppc/ --exclude=ppc64/ --exclude=ppc64le/ --exclude=testing/ --exclude=i386/ --exclude=debug/ rsync://mirrors.kernel.org/fedora-epel/ /var/www/html/dev/epel
    - identifier: RPMREPO_EPEL
    - user: root
    - hour: 4
    - minute: 0

rpmrepo-cron-rsync-salt:
  cron.present:
    - name: /usr/bin/rsync -avzH --numeric-ids --delete --delete-after --exclude=5*/ --exclude=i386/ --exclude=amazon/ --exclude=*.src.rpm rsync://repo.saltstack.com/saltstack_pkgrepo_rhel /var/www/html/dev/salt
    - identifier: RPMREPO_SALT
    - user: root
    - hour: 4
    - minute: 15

#0 3 * * * /usr/bin/rsync -avzH --delete --delete-after --exclude=HEADER.* --exclude=2*/ --exclude=3*/ --exclude=4*/ --exclude=5*/ --exclude=isos/i386/ --exclude=centosplus/ --exclude=contrib/ --exclude=cr/--exclude=extras/5 --exclude=extras/4 --exclude=os/i386/ --exclude=updates/i386 --exclude=fasttrack/i386/ --exclude=isos/x86_64/ --exclude=cloud/ --exclude=sclo/ mirrors.kernel.org::centos/ /var/www/html/dev/centos
#0 4 * * * /usr/bin/rsync -avzH --numeric-ids --delete --delete-after --exclude=4/ --exclude=4AS/ --exclude=4ES/ --exclude=4WS/ --exclude=5/ --exclude=5Client/ --exclude=5Server/ --exclude=SRPMS/ --exclude=ppc/ --exclude=ppc64/ --exclude=ppc64le/ --exclude=testing/ --exclude=i386/ --exclude=debug/ rsync://mirrors.kernel.org/fedora-epel/ /var/www/html/dev/epel
#15 4 * * * /usr/bin/rsync -avzH --numeric-ids --delete --delete-after --exclude=5*/ --exclude=i386/ --exclude=amazon/ --exclude=*.src.rpm rsync://repo.saltstack.com/saltstack_pkgrepo_rhel /var/www/html/dev/salt
#21 4 * * * /usr/bin/reposync -r mongodb-org-3.0-el7-x86_64 -p /var/www/html/dev/mongo/7/3.0
#25 4 * * * /usr/bin/reposync -r nodesource-5-el7 -p /var/www/html/dev/nodesource/el7/5
#26 4 * * * /usr/bin/reposync -r nodesource-6-el7 -p /var/www/html/dev/nodesource/el7/6
#27 4 * * * /usr/bin/reposync -r nodesource-7-el7 -p /var/www/html/dev/nodesource/el7/7
#27 4 * * * /usr/bin/reposync -r nodesource-8-el7 -p /var/www/html/dev/nodesource/el7/8
#29 4 * * * /usr/bin/reposync -r ius-el7 -p /var/www/html/dev/ius/7/
#30 4 * * * /usr/bin/reposync -r sensu-centos-el6 -p /var/www/html/dev/sensu/6/
#31 4 * * * /usr/bin/reposync -r sensu-centos-el7 -p /var/www/html/dev/sensu/7/
#
#2 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/6/os/x86_64/
#3 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/6/extras/x86_64/
#4 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/6/updates/x86_64/
#5 5 * * * /usr/bin/createrepo --update /var/www/html/dev/epel/7/x86_64/
#6 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/7/os/x86_64/
#7 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/7/extras/x86_64/
#8 5 * * * /usr/bin/createrepo --update /var/www/html/dev/centos/7/updates/x86_64/
#9 5 * * * /usr/bin/createrepo --update /var/www/html/dev/epel/7/x86_64/
#10 5 * * * /usr/bin/createrepo --update /var/www/html/dev/salt/redhat/6/x86_64/
#11 5 * * * /usr/bin/createrepo --update /var/www/html/dev/salt/redhat/7/x86_64/
#12 5 * * * /usr/bin/createrepo --update /var/www/html/dev/mongo/6/3.0
#13 5 * * * /usr/bin/createrepo --update /var/www/html/dev/mongo/7/3.0
#17 5 * * * /usr/bin/createrepo --update /var/www/html/dev/nodesource/el7/5
#18 5 * * * /usr/bin/createrepo --update /var/www/html/dev/nodesource/el7/6
#19 5 * * * /usr/bin/createrepo --update /var/www/html/dev/nodesource/el7/7
#19 5 * * * /usr/bin/createrepo --update /var/www/html/dev/nodesource/el7/8
#21 5 * * * /usr/bin/createrepo --update /var/www/html/dev/ius/7/
#22 5 * * * /usr/bin/createrepo --update /var/www/html/dev/sensu/6
#23 5 * * * /usr/bin/createrepo --update /var/www/html/dev/sensu/7

