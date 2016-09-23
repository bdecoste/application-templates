#JDV with two external datasources
This example shows how to deploy JDV with 2 external datasources:
 * Postgresql: exposed as an OpenShift Service/Endpoint
 * Oracle: exposed directly

##Structure
 * ose-dba: The source required to build the source/injected image used to configure the Oracle driver module and the datasource definitions to be exposed as a Secret
 * ose-cicd: The template used to deploy JDV
