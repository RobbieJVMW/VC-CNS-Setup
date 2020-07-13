# VC-CNS-Setup
Automation to setup VMware vCenter Permissions for the VMware Cloud Native Storage provider for vanilla Kubernetes.

Quick & Easy setup without having to navidate the virtual center UI.
Very useful if the you don't have direct access to virtual center (but your K8S instance does).

You need to provide either a complete environment var to your virtual center instance complete the login & password. 

e.g.
docker run -e GOVC_URL='https://username@sso.domain:password@virtualcentername.domain/sdk'

or seperate out the environment variables out. 
e.g
GOVC_URL=virtual-center.domain
GOVC_USERNAME=administrator@vsphere.local
GOVC_PASSWORD=Pa$$word

Note
Currently explicit privilages are not set on object inside virtual center only the pre-requisite roles for CNS are created and setup.  If you VC service account used for K8S CNS has object level restrictions these must be manually configured.  This is a //TODO. 

( https://vsphere-csi-driver.sigs.k8s.io/driver-deployment/prerequisites.html ) 
