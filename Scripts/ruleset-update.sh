#!/bin/bash

# Get ruleset path from nginx config
rulesetpath=$(grep "alias /var/www/" /etc/nginx/nginx.conf | head -n 1)
rulesetpath=${rulesetpath#*"alias /var/www/"}
rulesetpath=${rulesetpath%"/;"*}

# Get list of all rulesets except temporary files
rulesetlist=$(ls -A1 /var/www/${rulesetpath} | grep -v ".1")

for k in $(seq 1 $(echo "$rulesetlist" | wc -l))
do
    ruleset=$(echo "$rulesetlist" | sed -n "${k}p")
    
    # Skip Iran-specific rule sets - download from Chocolate4U repository
    if [[ "${ruleset}" == "geoip-ir.srs" ]]
    then
        wget -q -O /var/www/${rulesetpath}/${ruleset}.1 https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geoip-ir.srs && mv -f /var/www/${rulesetpath}/${ruleset}.1 /var/www/${rulesetpath}/${ruleset}
        continue
    fi
    
    if [[ "${ruleset}" == "geosite-category-gov-ir.srs" ]]
    then
        wget -q -O /var/www/${rulesetpath}/${ruleset}.1 https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geosite-category-gov-ir.srs && mv -f /var/www/${rulesetpath}/${ruleset}.1 /var/www/${rulesetpath}/${ruleset}
        continue
    fi
    
    if [[ "${ruleset}" == "geosite-ir.srs" ]]
    then
        wget -q -O /var/www/${rulesetpath}/${ruleset}.1 https://raw.githubusercontent.com/Chocolate4U/Iran-sing-box-rules/rule-set/geosite-ir.srs && mv -f /var/www/${rulesetpath}/${ruleset}.1 /var/www/${rulesetpath}/${ruleset}
        continue
    fi
    
    # Download other rule sets from SagerNet
    wget -q -O /var/www/${rulesetpath}/${ruleset}.1 https://github.com/SagerNet/sing-geosite/raw/rule-set/${ruleset} && mv -f /var/www/${rulesetpath}/${ruleset}.1 /var/www/${rulesetpath}/${ruleset}
done

# Set proper permissions
chmod -R 755 /var/www/${rulesetpath}

# Additional optimization: clean old journal logs
journalctl --vacuum-time=7days &> /dev/null

# Restart WARP service if active
[[ $(systemctl is-active warp-svc.service) == "active" ]] && systemctl restart warp-svc.service