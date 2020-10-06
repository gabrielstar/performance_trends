$user=$env:UserName
cat $PSScriptRoot/test-perf-index.js | `
    docker run -i -v ${PSScriptRoot}:/data `
        loadimpact/k6 run `
            --summary-export=/data/perf-test-results.json `
            --vus 2 `
            --tag user=$user `
            --out csv=/data/results.csv `
            --duration 5s -