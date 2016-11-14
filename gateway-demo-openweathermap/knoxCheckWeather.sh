#!/bin/bash
###############################################################################
## Checks Knox Open Weather Map API
## John McParland
## M 14 Nov 2016
###############################################################################

## Functions
###############################################################################
printHelp() {
    echo "knoxCheckWeather.sh -a <api key> [<option(s)>]"
    echo ""
    echo -e "\t-a <api key>\tyour open weather map API key"
    echo "options include" 
    echo -e "\t-h\tprint this help information"
    echo -e "\t-s <hdp server>\tHDP 2.4 server dns/ip"
    echo -e "\t-t <topology>\tthe name of the knox topology"
    echo -e "\t-u <user>\tthe knox user"
    echo -e "\t-p <knox password>\tthe knox users password"
}

## Variables
###############################################################################
USER=guest
PASS=guest-password

HDP_SERVER=localhost
TOPOLOGY=sandbox

SERVICE=weather
SERVICE_RESOURCE=data/2.5/weather

## Get Input
###############################################################################
while getopts ":hs:a:t:u:p:" opt; do
    case $opt in
        h)
            printHelp
            exit 0
            ;;
        s) 
            HDP_SERVER=${OPTARG}
            ;;
        a)
            API_KEY=${OPTARG}
            ;;
        t)
            TOPOLOGY=${OPTARG}
            ;;
        u)
            USER=${OPTARG}
            ;;
        p)
            PASS=${OPTARG}
            ;;
        ?)
            printHelp
            exit 0
            ;;
    esac
done

## Check Input
###############################################################################
if [[ -z ${API_KEY} ]];then
    echo "[ERROR] - Sorry you must provide an API key (-a)"
    printHelp
    exit 0
fi

## Do It!
###############################################################################

HDP_URL="https://${HDP_SERVER}:8443/gateway/${TOPOLOGY}/${SERVICE}/${SERVICE_RESOURCE}?zip=95054,us&appid=${API_KEY}"

curl -ku ${USER}:${PASS} ${HDP_URL} | python -m json.tool
exit ${?}

