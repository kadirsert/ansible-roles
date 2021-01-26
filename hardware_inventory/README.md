This is an ansible role that collect OS Version; HardWare Model,Vendor,Serial; IP; CPU; RAM; Disk and Mount information.

Run with:

`# ansible-playbook site.yml |grep \"msg\" |grep -v FAILED |tr -s " " |cut -d':' -f2- |sed 's/.$//; s/^..//' |sort`
