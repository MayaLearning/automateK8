function start_vpn { #Start sshuttle VPN
  # List of subnets to tunnel
  VPN_SUBNETS="10.0.1.0/24 10.244.0.0/16 10.42.0.0/16 10.43.0.0/16"

  cd ./deployments
  BASTION=$(grep -e '^bastion' ./workspace/inventory.ini|awk -F'ansible_host=' '{ print $NF }'|awk '{ print $1 }')
  echo "Setting up sshuttle VPN connection through $BASTION"
  #ansible -m wait_for_connection -i $DIR/workspace/inventory.ini bastion
  ansible -m wait_for -a "timeout=300 port=22 host=$BASTION search_regex=OpenSSH" -i $DIR/workspace/inventory.ini -e ansible_connection=local bastion
  ansible-playbook -i $DIR/workspace/inventory.ini $DIR/deployments/bastion.yml
  cat <<EOF > $DIR/workspace/start_vpn.sh
#!/bin/bash
set -e
pkill sshuttle || echo "sshuttle starting"
nohup sshuttle -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -r $SSH_USER@$BASTION $VPN_SUBNETS &
EOF
  #TODO: 10.0.0.0/8 could be smarter, but since we want to cover both 10.0.1.0/24 and the SDN, this will do for now
  chmod +x $DIR/workspace/start_vpn.sh
  $DIR/workspace/start_vpn.sh
  # Wait for all nodes to come up and become available
  ansible -m wait_for -a "timeout=300 port=22 host=$BASTION search_regex=OpenSSH" -i $DIR/workspace/inventory.ini -e ansible_connection=local all
  ansible -m ping -i $DIR/workspace/inventory.ini -T 120 all
  cd $DIR
}

start_vpn

echo "Installing Kubespray
cd ./
if [ -d kubespray ]; then
  cd kubespray
else
  git clone https://github.com/kubernetes-sigs/kubespray.git
  cd kubespray
fi
git checkout "$KSPRAY_RELEASE"
pip3 install ansible==2.9.17
pip3 install -r requirements.txt
pip3 install openshift
#TODO: move to virtualenv

cp -rfp inventory/sample inventory/$SETUP_NAME
cp -f $DIR/workspace/inventory.ini inventory/$SETUP_NAME/

#Remove the bastion group, we don't want to confuse Kubespray
sed -i '/^bastion/d' inventory/$SETUP_NAME/inventory.ini || echo "no bastion found"
sed -i "s/kube_network_plugin: calico/kube_network_plugin: flannel/g" inventory/$SETUP_NAME/group_vars/k8s-cluster/k8s-cluster.yml
sed -i "s/cluster_name: cluster.local/cluster_name: $SETUP_NAME.local/g" inventory/$SETUP_NAME/group_vars/k8s-cluster/k8s-cluster.yml

# Deploy Kubespray
ansible-playbook -i inventory/$SETUP_NAME/inventory.ini --become --become-user=root cluster.yml

# Pull out kubeconfig
cd $DIR/workspace
sleep 5
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $SSH_USER@$BASTION "sudo cat /etc/kubernetes/admin.conf" > admin.conf
KUBE_API=$(python -c "import yaml; \
          f=open('$DIR/workspace/admin.conf','r'); \
          y=yaml.safe_load(f); \
          print(y['clusters'][0]['cluster']['server'])"|awk -F':' '{ print $2 }')
if [[ "$KUBE_API" == "//127.0.0.1" ]]; then
  MASTER="$(ansible-inventory -i $DIR/workspace/inventory.ini --host 'kube-master[0]' --toml|grep ansible_host|awk '{ print $NF }')"
  MASTER=`echo $MASTER|tr -d '"'`
  sed -i "s/127.0.0.1/$MASTER/g" $DIR/workspace/admin.conf
fi
export KUBECONFIG="$DIR/workspace/admin.conf"
