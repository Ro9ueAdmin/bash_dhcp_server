# Bash: DHCP Server
Collection of scripts to install and manage DHCP Server.

## Configuration
Edit `setup.conf`.

```
CLUSTER_DHCP_SERVER_INTERFACE="eth0"
CLUSTER_DCHP_DOMAIN="ubuntu_pxe.local"
CLUSTER_DCHP_DOMAIN_SERVER="ubuntu_pxe.local"
CLUSTER_NET_IP1_IP2_IP3="192.168.82"
CLUSTER_NET_IP_FROM=10
CLUSTER_NET_IP_TO=254
```

## Usage

* Install DHCP Server

```
sudo ./install_dhcp_server_deb.sh
```

## Verified in 
* Ubuntu 14.04.x

## Known Issues
If you discover any bugs, feel free to create an issue on GitHub fork and send us a pull request.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License
Copyright © 2015 Clark Hsu

Licensed under the [Apache License, Version 2.0] [Apache].

Distributed under the [MIT License] [mit].

[Apache]: http://www.apache.org/licenses/LICENSE-2.0
[MIT]: http://www.opensource.org/licenses/mit-license.php
