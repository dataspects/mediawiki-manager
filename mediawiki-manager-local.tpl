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
      # CreateCampEMWCon2021: introduce volume type switch: owner, group, permissions
      volumes:
        # Restic
        - name: snapshots
          hostPath:
            path: ${SYSTEM_SNAPSHOT_FOLDER_ON_HOSTING_SYSTEM}
        - name: currentresources
          hostPath:
            path: ${CURRENT_RESOURCES_ON_HOSTING_SYSTEM}
        - name: restic_password
          hostPath:
            path: ${RESTIC_PASSWORD_ON_HOSTING_SYSTEM}
        - name: mwmsqlite
          hostPath:
            path: ${MWCLI_CONFIG_DB_ON_HOSTING_SYSTEM}
        # MediaWiki        
        - name: system_root_w_extensions
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/extensions
        - name: system_root_w_skins
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/skins
        - name: system_root_w_vendor
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/vendor
        - name: system_root_w_composerLocalJSON
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/composer.local.json
        - name: system_root_w_composerLocalLock
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/composer.local.lock
        - name: system_root_w_images
          hostPath:
            path: ${SYSTEM_ROOT_FOLDER_ON_HOSTING_SYSTEM}/w/images
        # Apache
        - name: apache_sites_available
          hostPath:
            path: ${APACHE_CONF_ON_HOSTING_SYSTEM}
        # MWM
        - name: mwmCLI
          hostPath:
            path: ${MEDIAWIKI_CLI_ON_HOSTING_SYSTEM}
        - name: mwmLogs
          hostPath:
            path: ${MWCLI_SYSTEM_LOG_ON_HOSTING_SYSTEM}
        # MariaDB
        - name: mariadb_data
          hostPath:
            path: ${MARIADB_FOLDER_ON_HOSTING_SYSTEM}
      containers:
        # CreateCampEMWCon2021: optimize Dockerfile: executing user and permissions: https://github.com/dataspects/dataspectsSystemBuilder/tree/master/docker-images/mediawiki
        - image: ${MEDIAWIKI_IMAGE}
          name: mediawiki
          volumeMounts:
            # MediaWiki
            # - mountPath: $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/extensions
            #   name: system_root_w_extensions
            # - mountPath: $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/skins
            #   name: system_root_w_skins
            # - mountPath: $SYSTEM_ROOT_FOLDER_IN_CONTAINER/w/vendor
            #   name: system_root_w_vendor
            - mountPath: ${SYSTEM_ROOT_FOLDER_IN_CONTAINER}/w/composer.local.json
              name: system_root_w_composerLocalJSON
            - mountPath: ${SYSTEM_ROOT_FOLDER_IN_CONTAINER}/w/composer.local.lock
              name: system_root_w_composerLocalLock
            - mountPath: ${SYSTEM_ROOT_FOLDER_IN_CONTAINER}/w/images
              name: system_root_w_images
            # MWM
            - mountPath: ${MWCLI_SYSTEM_LOG_IN_CONTAINER}
              name: mwmLogs
            - mountPath: ${MWCLI_CONFIG_DB_IN_CONTAINER}
              name: mwmsqlite
            - mountPath: ${MEDIAWIKI_CLI_IN_CONTAINER}
              name: mwmCLI
            # Apache
            - mountPath: ${APACHE_CONF_IN_CONTAINER}
              name: apache_sites_available
            # Restic
            - mountPath: ${RESTIC_PASSWORD_IN_CONTAINER}
              name: restic_password
            - mountPath: ${SYSTEM_SNAPSHOT_FOLDER_IN_CONTAINER}
              name: snapshots
            - mountPath: ${CURRENT_RESOURCES_IN_CONTAINER}
              name: currentresources
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
            # CreateCampEMWCon2021: optimize Apache Virtual Host config: mwmITLocal, mwmITIntra, mwmITCloud: https://github.com/dataspects/dataspectsSystemBuilder/tree/master/docker-images/mediawiki
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