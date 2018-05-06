#set -x

# 1. We are going to set our environmental properties, by sourcing the env-[DEV|TEST|PROD] file that you wish to use.

export ICS_INTEGRATION_ENV='PROD_Castle'

cd ${ICS_INTEGRATION_NAME}

chmod 755 env-${ICS_INTEGRATION_ENV}

source ./env-${ICS_INTEGRATION_ENV}.properties

# 2. Build and Configure the IAR integration archive.

# Keeping the original IAR in GIT repo/artifactory, until until we find value on expanding it.
#jar cvf ${ICS_INTEGRATION_IAR_FILENAME} icspackage

# Setup Connectors with environment variables
./setupConnectors.sh


# 3. Import the ICS Integration archive (IAR)

curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Accept: application/json" -X POST -F "file=@${ICS_INTEGRATION_IAR_FILENAME};type=application/octet-stream" ${ICS_INTEGRATION_POST_IMPORT_URI} -v

# Sleep 5 seconds to give time to complete before configuring the adapters.
sleep 5

# 4. Configure and activate my ICS Connectors:

# 	4.1 Sales Cloud Connector

# Configure Sales Cloud Connector:
curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Content-Type:application/json" -X PUT -d @${ICS_CONNECTOR_SC_CONFIG_NAME} ${ICS_CONNECTOR_SC_URI} -v

# Sleep 5 seconds to give time to complete before configuring the next adapter.
sleep 5

#	4.2 Salesforce Connector

# Configure Salesforce Connector:
curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Content-Type:application/json" -X PUT -d @${ICS_CONNECTOR_SF_CONFIG_NAME} ${ICS_CONNECTOR_SF_URI} -v

# Sleep 5 seconds to give time to complete before Activating the ICS Integration.
sleep 5

# 5. Activate the Integration

curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Accept: application/json" -X POST ${ICS_INTEGRATION_POST_ACTIVATE_URI} -v



