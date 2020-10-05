cat $PSScriptRoot/script.js | `
    docker run -i -v ${PWD}:/data `
        loadimpact/k6 run `
            --summary-export=/data/export.json `
            --vus 5 `
            --duration 20s -