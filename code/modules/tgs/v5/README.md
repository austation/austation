# DMAPI V5

This DMAPI implements bridge requests using HTTP GET requests to TGS. It has no security restrictions.

- [_defines.dm](./_defines.dm) contains constant definitions.
- [api.dm](./api.dm) contains the bulk of the API code.
- [bridge.dm](./bridge.dm) contains functions related to making bridge requests.
- [chunking.dm](./chunking.dm) contains common function for splitting large raw data sets into chunks BYOND can natively process.
- [commands.dm](./commands.dm) contains functions relating to `/datum/tgs_chat_command`s.
<<<<<<< HEAD
=======
- [serializers.dm](./serializers.dm) contains function to help convert interop `/datum`s into a JSON encodable `list()` format.
- [topic.dm](./topic.dm) contains functions related to processing topic requests.
>>>>>>> 915bbb1b08 (Update TGS DMAPI (#8893))
- [undefs.dm](./undefs.dm) Undoes the work of `_defines.dm`.
