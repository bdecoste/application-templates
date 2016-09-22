#JDV xPaaS Image All-In-One Example/Demo
This project, along with jdv-demo-app and jdv-demo-vdb, contains all of the source for an all-in-one example/demo for deploying a
web application in an EAP pod accessing data via a JDV pod. The JDV pod and deployed VDBs are backed by several datasources including postgresql, flat file, 
excel file, and webservice.

##Structure
The example/demo is divided into 4 roles:
 * ose-app: Responsible for authoring the web application deployed in EAP (jdv-demo-app git repo)
 * ose-vdb: Responsible for authoring the VDB(s) deployted in JDV (jdv-demo-vdb git repo)
 * ose-dba: Responsible for providing all of the artifacts (e.g. drivers, resource adapters, translators) and configuration for the available/applicable datasources (jdv-demo/ose-dba git repo)
 * ose-cicd: Responsible for deploying to OpenShift (jdv-demo/ose-cicd git repo)

##JDV Example

Create "demo" project

```
$ oc new-project demo
```

Create Secret containing SSL keys for JDBC over SSL

```
$ oc create -f ose-cicd/datavirt-demo-secret.json 
```

Create source/injected images for EAP and JDV S2I. These images are used to provide the required datasource artifacts and configration to the EAP and JDV Pods. Replace REGISTRY with the
appropriate registry hostname:port (e.g. registry.example.com:5000)

```
$ cd ose-dba
$ docker build -f Dockerfile.eap .
$ docker tag ### registry/jboss-datavirt-6/jdv-demo-eap:1.0
$ docker push registry/jboss-datavirt-6/jdv-demo-eap:1.0

$ docker build -f Dockerfile.jdv .
$ docker tag ### registry/jboss-datavirt-6/jdv-demo-jdv:1.0
$ docker push registry/jboss-datavirt-6/jdv-demo-jdv:1.0

```

Create ImageStreams for source/injected images. Replace "registry.example.com:5000" in ose-cicd/demo-image-stream.json with the appropriate registry hostname:port

```
$ oc create -f ose-cicd/demo-image-stream.json
$ oc import-image jdv-demo-eap --insecure=true
$ oc import-image jdv-demo-jdv --insecure=true
```

Create Secret containing datasource configuration (Secret created from ose-dba/datasources-eap.properties

```
$ oc create -f ose-cicd/datasources-demo-secret.json
```

Deploy example/demo

```
$ oc process -f ose-cicd/datavirt63-demo-s2i.json | oc create -f -
```

Test application via http://datavirt-eap-demo.cloudapps.example.com/demo-webapp (hostname is environment specific so may need to be changed)
