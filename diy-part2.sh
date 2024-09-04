#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

#sed -i 's/192.168.123.5/192.168.50.5/g' package/base-files/files/bin/config_generate




mkdir -p files/etc/config


tee files/etc/config/wireless <<EOF



config wifi-device 'radio0'
	option type 'mac80211'
	option path '1e140000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0'
	option band '2g'
	option channel '1'
	option disabled '1'
	option cell_density '0'

config wifi-iface 'default_radio0'
	option device 'radio0'
	option network 'lan'
	option mode 'ap'
	option ssid 'r3g-4g-ImmortalWrt'
	option encryption 'sae'
	option key '1234567890'
	option ocv '0'
	option disabled '1'

config wifi-device 'radio1'
	option type 'mac80211'
	option path '1e140000.pcie/pci0000:00/0000:00:01.0/0000:02:00.0'
	option band '5g'
	option channel '36'
	option htmode 'VHT80'
	option cell_density '0'

config wifi-iface 'default_radio1'
	option device 'radio1'
	option network 'lan'
	option mode 'ap'
	option ssid 'r3g-5g-ImmortalWrt'
	option encryption 'sae'
	option key '1234567890'
	option ocv '0'




EOF


tee files/etc/config/network <<EOF



config interface 'loopback'
	option device 'lo'
	option proto 'static'
	option ipaddr '127.0.0.1'
	option netmask '255.0.0.0'

config globals 'globals'
	option packet_steering '1'

config device
	option name 'br-lan'
	option type 'bridge'
	list ports 'lan1'
	list ports 'lan2'

config interface 'lan'
	option device 'br-lan'
	option proto 'static'
	option ipaddr '192.168.123.43'
	option netmask '255.255.255.0'
	option ip6assign '60'
	list dns '192.168.1.1'
	option ip6ifaceid 'eui64'

config interface 'wan'
	option device 'wan'
	option proto 'static'
	option gateway '192.168.1.1'
	list dns '192.168.1.1'
	list ipaddr '192.168.1.211/24'

config interface 'wan6'
	option device '@wan'
	option proto 'dhcpv6'
	option reqaddress 'try'
	option reqprefix 'auto'
	option ip6ifaceid 'eui64'







EOF




tee files/etc/config/dhcp <<EOF



config dnsmasq
	option domainneeded '1'
	option localise_queries '1'
	option rebind_protection '1'
	option rebind_localhost '1'
	option local '/lan/'
	option domain 'lan'
	option expandhosts '1'
	option min_cache_ttl '3600'
	option use_stale_cache '3600'
	option cachesize '8000'
	option nonegcache '1'
	option authoritative '1'
	option readethers '1'
	option leasefile '/tmp/dhcp.leases'
	option resolvfile '/tmp/resolv.conf.d/resolv.conf.auto'
	option localservice '1'
	option dns_redirect '1'
	option ednspacket_max '1232'
	list server '192.168.1.1'

config dhcp 'lan'
	option interface 'lan'
	option start '100'
	option limit '100'
	option leasetime '12h'
	option dhcpv4 'server'
	option ra 'server'
	option max_preferred_lifetime '2700'
	option max_valid_lifetime '5400'
	option dns_service '0'
	list ra_flags 'other-config'

config dhcp 'wan'
	option interface 'wan'
	option ignore '1'
	option start '100'
	option limit '150'
	option leasetime '12h'

config odhcpd 'odhcpd'
	option maindhcp '0'
	option leasefile '/tmp/hosts/odhcpd'
	option leasetrigger '/usr/sbin/odhcpd-update'
	option loglevel '4'








EOF 
