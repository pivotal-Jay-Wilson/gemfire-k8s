VMware Tanzu GemFire Vector Database 1.2.0 README.txt


How to find End Of Support Date
-------------------------------
1. Login to https://support.broadcom.com/ and select My Dashboard 
2. Under Quick Links on the right, select Product Lifecycle
3. Search By Description = Vector Database, Show results


How to find Release Notes
-------------------------
1. Login to https://support.broadcom.com/ and select My Dashboard 
2. Under Quick Links on the right, select Product Lifecycle
3. Search By Description = Vector Database, Show results
4. Click on the blue General Availability date to go to https://techdocs.broadcom.com/us/en/vmware-tanzu/data-solutions/tanzu-gemfire-vector-database/1-2/gf-vector-db/release_notes.html


Documentation
-------------
1. https://techdocs.broadcom.com/us/en/vmware-tanzu/data-solutions/tanzu-gemfire-vector-database/1-2/gf-vector-db/overview.html
2. https://gemfire.dev/


How to obtain Tanzu GemFire Vector Database Extension (manual download)
-----------------------------------------------------------------------
1. Login to https://support.broadcom.com/ and select My Downloads
2. Search by Product Name = VMware Tanzu GemFire Vector Database
3. Click on VMware Tanzu GemFire Vector Database
4. Click on VMware Tanzu GemFire Vector Database
5. Click on 1.2.0
6. Check the box I agree to Terms and Conditions
7. Click the cloud symbol to the far right of VMware GemFire Vector Database .gfm
8. Place the .gfm in $GEMFIRE_HOME/extensions on each server (not needed for locators)


How to obtain Tanzu GemFire Vector Database Extension (cli download)
--------------------------------------------------------------------
1. Login to https://support.broadcom.com/ and select My Dashboard.
2. Under Quick Links on the right, select Tanzu API Token then click Request New Refresh Token.
3. Install pivnet-cli (see https://github.com/pivotal-cf/pivnet-cli)
4. pivnet login --api-token='my-refresh-token'
5. pivnet accept-eula -p gemfire-vectordb -r 1.2.0
6. pivnet download-product-files -p gemfire-vectordb -r 1.2.0 -i $(pivnet product-files -p gemfire-vectordb -r 1.2.0 | awk '/gfm/{print $2}')
7. Place the .gfm in $GEMFIRE_HOME/extensions on each server (not needed for locators)


How to obtain Tanzu GemFire Vector Database for Kubernetes
----------------------------------------------------------
1. Login to https://support.broadcom.com/ and select My Downloads
2. Search by Product Name = VMware Tanzu GemFire
3. Click on VMware Tanzu GemFire
4. Click on VMware Tanzu GemFire
5. Scroll down, Show All Releases, scroll down to Click Green Token for Repository Access and click on the green symbol to the far right.
6. Note your email address.  Copy your access_token (not including any surrounding quotation marks)
7. docker login registry.packages.broadcom.com
8. Enter your email address as the username and your access token as the password.
9. docker pull registry.packages.broadcom.com/gemfire-vectordb/gemfire-vectordb:1.2.0
10. see GemFire for Kubernetes documentation for details on attaching an extension container image


How to obtain Tanzu GemFire for Kubernetes From Dockerhub with Vector Database preinstalled
-------------------------------------------------------------------------------------------
1. docker pull gemfire/gemfire-all:10.1


Tanzu GemFire Vector Database Open Source Compliance
----------------------------------------------------
1. Login to https://support.broadcom.com/ and select My Downloads
2. Search by Product Name = VMware Tanzu GemFire Vector Database
3. Click on VMware Tanzu GemFire Vector Database
4. Click on VMware Tanzu GemFire Vector Database
5. Click on 1.2.0
6. Check the box I agree to Terms and Conditions
7. For 3rd Party License, Notice, and Attribution click the cloud symbol to the far right of the Open Source License file that corresponds to your chosen GemFire Vector Database packaging.
8. For 3rd Party Source Code (iff required) click the cloud symbol to the far right of the Open Source Disclosure Package file that corresponds to your chosen GemFire Vector Database packaging.
