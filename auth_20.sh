#
# Test 1: Overlap group permission
#

# generate an admin token
export JWT=$(curl -X POST ${DOJOT_HOST}/auth -H 'Content-Type:application/json' -d '{"username": "admin", "passwd" : "admin"}' 2>/dev/null | jq '.jwt' -r)

# create a new group
export GROUP_ID_1=$(curl -X POST "${DOJOT_HOST}/auth/pap/group" -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' -d '{"name": "viewer'$(( ( RANDOM % 1000 )  + 1 ))'", "description": "Grupo com acesso somente para visualizar as informações"}' 2>/dev/null | jq -r '.id')

# add group permission to read only templates
curl -X POST ${DOJOT_HOST}/auth/pap/grouppermissions/$GROUP_ID_1/3 -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' 2>/dev/null

# create an user associated with the previous group
curl -X POST ${DOJOT_HOST}/auth/user -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' -d '
{
  "username": "wilton",
  "service": "admin",
  "email": "wilton@cpqd.com.br",
  "name": "wilton",
  "profile": <group_name>
}' 2>/dev/null

# generate an user token
export JWT=$(curl -X POST localhost:8000/auth -H 'Content-Type:application/json' -d '{"username": "wilton", "passwd" : "temppwd"}' 2>/dev/null | jq '.jwt' -r)

# try create a template
curl -X POST ${DOJOT_HOST}/template -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' -d ' {
 "label": "medidor de temperatura",
 "attrs": [
   {
     "label": "temperatura",
     "type": "dynamic",
     "value_type": "float",
     "metadata": [{"label": "unidade", "type": "meta", "value_type": "string", "static_value": "°C"}]
   }
 ]
}'

# the system will deny

# generate an admin token
export JWT=$(curl -X POST localhost:8000/auth -H 'Content-Type:application/json' -d '{"username": "admin", "passwd" : "admin"}' 2>/dev/null | jq '.jwt' -r)

# enable template creation by user permission
curl -X POST ${DOJOT_HOST}/auth/pap/userpermissions/2/2 -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' 2>/dev/null

# generate an user token
export JWT=$(curl -X POST localhost:8000/auth -H 'Content-Type:application/json' -d '{"username": "wilton", "passwd" : "temppwd"}' 2>/dev/null | jq '.jwt' -r)

# try create template
curl -X POST ${DOJOT_HOST}/template -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' -d ' {
 "label": "medidor de temperatura",
 "attrs": [
   {
     "label": "temperatura",
     "type": "dynamic",
     "value_type": "float",
     "metadata": [{"label": "unidade", "type": "meta", "value_type": "string", "static_value": "°C"}]
   }
 ]
}'

# the system will permit

#
# Test 2: Test whether the user's removal operation leaves trash in the cache
#

# generate an admin token
export JWT=$(curl -X POST localhost:8000/auth -H 'Content-Type:application/json' -d '{"username": "admin", "passwd" : "admin"}' 2>/dev/null | jq '.jwt' -r)

# revoke template creation permission
curl -X DELETE ${DOJOT_HOST}/auth/pap/userpermissions/2/2 -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' 2>/dev/null

# generate an user token
export JWT=$(curl -X POST localhost:8000/auth -H 'Content-Type:application/json' -d '{"username": "wilton", "passwd" : "temppwd"}' 2>/dev/null | jq '.jwt' -r)

# try create template
curl -X POST ${DOJOT_HOST}/template -H "Authorization: Bearer ${JWT}" -H 'Content-Type:application/json' -d ' {
 "label": "medidor de temperatura",
 "attrs": [
   {
     "label": "temperatura",
     "type": "dynamic",
     "value_type": "float",
     "metadata": [{"label": "unidade", "type": "meta", "value_type": "string", "static_value": "°C"}]
   }
 ]
}'

# the system will deny



