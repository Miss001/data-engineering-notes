## 关闭虚拟机
## 编辑 *.vmx 文件
将e1000 修改为 vmxnet3
```
ethernet0.virtualDev = "vmxnet3"
```
## 重启虚拟机
## 查看网卡名称是否变更
```
ip link show
```
## 修改网卡配置
网卡名变更时修改配置
```
cd /etc/sysconfig/network-scripts
mv ifcfg-ens33 ifcfg-ens160

vi ifcfg-ens160
NAME=ens160
DEVICE=ens160

```
