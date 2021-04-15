# Generation of Kubernetes YAML is still under development!
#
# Save the output of this file and use kubectl create -f to import
# it into Kubernetes.
#
# Created with podman-3.0.1
apiVersion: v1
kind: Deployment
metadata:
  name: mwm-deployment
  labels:
    app: mwm
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mwm
  template:
    metadata:
      labels:
        app: mwm
    spec:
      volumes:
        # MediaWiki
        - name: mediawiki_root_mwmLocalSettingsPHP
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/mwmLocalSettings.php
        - name: mediawiki_root_mwmSQLiteBACKUP
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/mwmSQLiteBACKUP
        - name: mediawiki_root_w_extensions
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/w/extensions
        - name: mediawiki_root_w_skins
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/w/skins
        - name: mediawiki_root_w_vendor
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/w/vendor
        - name: mediawiki_root_w_composerJSON
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/w/composer.json
        - name: mediawiki_root_w_images
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mediawiki_root/w/images
        # Apache
        - name: apache_sites_available
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/conf/apache/sites-available
        # MWM
        - name: mwmCLI
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/cli
        - name: mwmsqlite
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mwm.sqlite
        - name: mwmLogs
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/logs
        # Restic
        - name: restic_password
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/conf/restic/restic_password
        - name: restic-backup-repository
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/restic-backup-repository
        - name: cloneLocation
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/cloneLocation
        # MariaDB
        - name: mariadb_data
          hostPath:
            path: ${SYSTEM_INSTANCE_ROOT}/mariadb_data
      containers:
        - image: ${MEDIAWIKI_IMAGE}
          name: mediawiki
          volumeMounts:
            # MediaWiki
            - mountPath: /var/www/html/mwmLocalSettings.php
              name: mediawiki_root_mwmLocalSettingsPHP
            - mountPath: /var/www/html/w/mwmSQLiteBACKUP
              name: mediawiki_root_mwmSQLiteBACKUP
            - mountPath: /var/www/html/w/extensions
              name: mediawiki_root_w_extensions
            - mountPath: /var/www/html/w/skins
              name: mediawiki_root_w_skins
            - mountPath: /var/www/html/w/vendor
              name: mediawiki_root_w_vendor
            - mountPath: /var/www/html/w/composer.json
              name: mediawiki_root_w_composerJSON
            - mountPath: /var/www/html/w/images
              name: mediawiki_root_w_images
            # MWM
            - mountPath: /var/www/html/logs
              name: mwmLogs
            - mountPath: /var/www/html/mwm.sqlite
              name: mwmsqlite
            - mountPath: /var/www/html/cli
              name: mwmCLI
            # Apache
            - mountPath: /etc/apache2/sites-available
              name: apache_sites_available
            # Restic
            - mountPath: /var/www/restic_password
              name: restic_password
            - mountPath: /var/www/html/restic-repo
              name: restic-backup-repository
            - mountPath: /var/www/html/clone-location
              name: cloneLocation
          env:
            - name: MYSQL_HOST
              value: ${MYSQL_HOST}
            - name: DATABASE_NAME
              value: ${DATABASE_NAME}
            - name: MYSQL_USER
              value: ${MYSQL_USER}
            - name: WG_DB_PASSWORD
              value: ${WG_DB_PASSWORD}
          ports:
            - containerPort: 443
              hostPort: 4443
        - image: docker.io/library/mariadb:10.5.5
          name: mariadb
          env:
          - name: MYSQL_ROOT_PASSWORD
            value: 123456
          volumeMounts:
            - mountPath: /var/lib/mysql
              name: mariadb_data
      dnsConfig: {}
    status: {}