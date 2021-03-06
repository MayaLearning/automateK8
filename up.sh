function start_vpn { #Start sshuttle VPN
  # List of subnets to tunnel
  VPN_SUBNETS="10.0.1.0/24 10.244.0.0/16 10.42.0.0/16 10.43.0.0/16"
  pip3 install sshuttle
  BASTION=$(grep -e '^bastion' inventory.ini|awk -F'ansible_host=' '{ print $NF }'|awk '{ print $1 }')
  echo "Setting up sshuttle VPN connection through $BASTION"
  ansible -m wait_for -a "timeout=300 port=22 host=$BASTION search_regex=OpenSSH" -i inventory.ini -e ansible_connection=local bastion
  ansible-playbook -i inventory.ini bastion.yml
  cat <<EOF > start_vpn.sh
#!/bin/bash
set -e
pkill sshuttle || echo "sshuttle starting"
nohup sshuttle -e 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no' -r ubuntu@$BASTION $VPN_SUBNETS &
EOF
  chmod +x start_vpn.sh
  ./start_vpn.sh
  # Wait for all nodes to come up and become available
  ansible -m wait_for -a "timeout=300 port=22 host=$BASTION search_regex=OpenSSH" -i inventory.ini -e ansible_connection=local all
  ansible -m ping -i $DIR/workspace/inventory.ini -T 120 all
  cd $DIR
}

start_vpn

echo "Installing Kubespray"

if [ -d kubespray ]; then
  cd kubespray
else
  git clone https://github.com/kubernetes-sigs/kubespray.git
  cd kubespray
fi
git checkout release-2.15
pip3 install ansible==2.9.17
pip3 install -r requirements.txt
pip3 install openshift
#TODO: move to virtualenv

cp -rfp inventory/sample inventory/demo
cp -f ../inventory.ini inventory/demo

#Remove the bastion group, we don't want to confuse Kubespray
sed -i '/^bastion/d' inventory/demo/inventory.ini || echo "no bastion found"
sed -i "s/kube_network_plugin: calico/kube_network_plugin: flannel/g" inventory/demo/group_vars/k8s-cluster/k8s-cluster.yml
sed -i "s/cluster_name: cluster.local/cluster_name: demo.local/g" inventory/demo/group_vars/k8s-cluster/k8s-cluster.yml

# Deploy Kubespray
ansible-playbook -i inventory/demo/inventory.ini --become --become-user=root cluster.yml

# Pull out kubeconfig
cd ..
sleep 5
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@$BASTION "sudo cat /etc/kubernetes/admin.conf" > admin.conf
KUBE_API=$(python -c "import yaml; \
          f=open('admin.conf','r'); \
          y=yaml.safe_load(f); \
          print(y['clusters'][0]['cluster']['server'])"|awk -F':' '{ print $2 }')
if [[ "$KUBE_API" == "//127.0.0.1" ]]; then
  MASTER="$(ansible-inventory -i inventory.ini --host 'kube-master[0]' --toml|grep ansible_host|awk '{ print $NF }')"
  MASTER=`echo $MASTER|tr -d '"'`
  sed -i "s/127.0.0.1/$MASTER/g" admin.conf
fi
export KUBECONFIG="admin.conf"



