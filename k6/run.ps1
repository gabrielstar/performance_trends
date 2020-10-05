cat $PSScriptRoot/script.js | docker run -i loadimpact/k6 run --vus 5 --duration 20s -
#cat script.js | docker run -i loadimpact/k6 run --vus 5 --duration 20s -