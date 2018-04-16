#set -x

# 1. We are going to set our environmental properties, by sourcing the env-[DEV|TEST|PROD] file that you wish to use.
#export ICS_INTEGRATION_ENV='TEST_aucri'
#export ICS_INTEGRATION_NAME='S2VIIA_SC_GETCONTA_INT'
#export ICS_USERNAME='carlos_priscila@bigpond.com'
#export ICS_PASSWD=''

cd ${ICS_INTEGRATION_NAME}

chmod 755 env-${ICS_INTEGRATION_ENV}

source ./env-${ICS_INTEGRATION_ENV}

# 2. Package the ICS Integration "package" as an IAR integration archive . We are going to use jar for this.

#jar cvf ${ICS_INTEGRATION_IAR_FILENAME} icspackage


# 3. Import the ICS Integration archive (IAR)

curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Accept: application/json" -X POST -F "file=@${ICS_INTEGRATION_IAR_FILENAME};type=application/octet-stream" ${ICS_INTEGRATION_POST_IMPORT_URI} -v

# Sleep 5 seconds to give time to complete before configuring the adapters.
sleep 5

# 4. Configure and activate my ICS Connectors:

# 	4.1 DB Connector Connector

# Configure DB Connector:
curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Content-Type:application/json" -X PUT -d @${ICS_CONNECTOR_DB_CONFIG_NAME} ${ICS_CONNECTOR_DB_URI} -v

# Sleep 5 seconds to give time to complete before configuring the next adapter.
sleep 5

#	4.2 REST Connector

# Configure REST Connector, in this case I just want to force Test it, so it gets activated:
curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Content-Type:application/json" -X PUT -d @${ICS_CONNECTOR_REST_CONFIG_NAME} ${ICS_CONNECTOR_REST_URI} -v

# Sleep 5 seconds to give time to complete before Activating the ICS Integration.
sleep 5

# 5. Activate the Integration

curl -u "${ICS_USERNAME}:${ICS_PASSWD}" -H "Accept: application/json" -X POST ${ICS_INTEGRATION_POST_ACTIVATE_URI} -v



