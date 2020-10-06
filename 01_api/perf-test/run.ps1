cat $PSScriptRoot/test-perf-index.js | `
    docker run -i -v ${PSScriptRoot}:/data `
        loadimpact/k6 run `
            --summary-export=/data/perf-test-results.json `
            --vus 5 `
            --duration 20s -