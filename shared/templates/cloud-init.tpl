#cloud-config
package_update: true
package_upgrade: true
packages:
  - htop
  - git
  - curl
  - unzip
write_files:
  - path: /opt/license.txt
    permissions: '0644'
    owner: root:root
    content: |
%{ for line in split("\n", license_content) ~}
      ${line}
%{ endfor ~}
  - path: /opt/bienvenida.txt
    permissions: '0644'
    owner: root:root
    content: |
      Bienvenido profesor. La licencia se encuentra en /opt/license.txt
runcmd:
  - echo "VM Provisionada correctamente $(date)" >> /var/log/provision.log
  - hostnamectl set-hostname vm-${host_name}
