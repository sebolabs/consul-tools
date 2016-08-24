#!/bin/bash
ec=0
services=($(curl -s http://localhost:8500/v1/catalog/services | jq -r 'keys[]'))
for service in "${services[@]}"; do
           healthy=0
           echo -n "Checking service: ${service}"
           statuses=($(curl -s http://localhost:8500/v1/health/service/${service} | jq -r '.[].Checks[].Status'))
           for stat in "${statuses[@]}"; do
               if [[ "$stat" != "passing" ]]; then ec=1; healthy=1; fi
           done
           if [[ $healthy -eq 0 ]]; then echo ' - healthy'; else echo ' - unhealthy'; fi
done
exit $ec
