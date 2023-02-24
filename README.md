# Aya stats for Prometheus

A Grafana dashboard that uses tendermint metrics and a textfile-collector script for Prometheus.

## Preview

![1](https://raw.githubusercontent.com/retropool/ayad-stats-prom/main/imgs/preview.jpg)

## Prerequisites

 - Grafana
 - Prometheus
 - Aya Testnet

## 1) Enable Tendermint metrics

    sed -i 's/prometheus = false/prometheus = true/g' /opt/aya/config/config.toml

After restarting your node, you should be able to access the tendermint metrics (default port is 26660): <http://ip-address-of-node:26660>

If the port isn't open you may need to allow if through UFW.

    sudo ufw allow 26660

## 2) Configure Prometheus Targets

Edit prometheus.yml to append a job under the scrape_configs 

    sudo nano /etc/prometheus/prometheus.yml

Copy the new target and save file: (Change IP if required)

        - targets: ['127.0.0.1:26660']  
          labels:  
          alias: 'aya'

## 3) Restart Prometheus

    sudo systemctl restart prometheus.service

## 4) Download textfile-collector script

Download textfile-collector script

    cd $home
    wget https://raw.githubusercontent.com/retropool/aya-stats-prom/main/ayastats.sh


## 5) Add your **ayavaloper** address to the script

On line 4 of ayastats.sh, change the ayavaloper address to your own

    sudo nano ayastats.sh

## 6) Create a cronjob to send metrics to Prometheus node exporter

Open the crontab file
```
crontab -e
```
Add this job to the bottom of the file. Be sure to edit the location of the file you downloaded eariler!

    */1 * * * * sudo bash -l /home/###/ayastats.sh 

*(This commands sets the job to run every 1 minute)*

## 7) Check Prometheus for new metrics

If you go to the Prometheus metrics page in your browser you should now see ayad_stats down the bottom
```
 http://ip-address-of-node:9100/metrics
```
## 8) Import Grafana dashboard

Right click and save [Aya Testnet Grafana dashboard](https://raw.githubusercontent.com/retropool/aya-stats-prom/main/Aya%20Testnet-1677275598492.json)

Import it into Grafana

![import](https://raw.githubusercontent.com/retropool/aya-stats-prom/main/imgs/import.jpg)


(Remember to add your Prometheus data source)

![data-source](https://raw.githubusercontent.com/retropool/aya-stats-prom/main/imgs/datasource.jpg)
