#!/bin/bash

#obtenemos los parametros
getParametersList(){
 while getopts "m:u:" option; do
  case "${option}" in
   m) m_parameter="${OPTARG}";;
   u) u_parameter="${OPTARG}"::
  esac
 done
 shift $((OPTIND-1))
}
getParametersList "$@"

#funciones

data_curl(){
 data='{
  "ftp":{},
  "db":{},
  "validations";{}
 }'
 echo "$data">$PWD/utils/get_keys.json
}
data_json(){
 data='{
  "ftp":{
    "host":"company",
    "user":"ftp_user",
    "password":"ftp_password",
    "port":21,
    "list_port":{
      "start":40000,
      "end":50000
    }
  },
  "db":{
    "host":"localhost",
    "user":"root",
    "password":"",
    "db":"company",
    "port":3306
   },
  "validations":{
  }
 }'
  echo "$data">$PWD/utils/get_keys.json
}


#validamos que el valor exista y que tipo de valor es
if [[ -z "${m_parameter}" ]]; then
 $(data_curl)
elif [[ "${m_parameter}" == "j" ]] || [[ "${m_parameter}" == "json" ]]; then
 data=$(data_json)
else
 data=$(data_curl)
fi

echo "$data"
