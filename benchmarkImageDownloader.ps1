$baseUrl = "https://www.moonboard.com/Problems/View"

$json = Get-Content .\MoonBoard2016Benchmarks.json | ConvertFrom-Json
write-host $pwd.Path
foreach($benchmark in $json.Data)
{
    $name = $benchmark.Name.ToLower()
    $grade = $benchmark.Grade
    $id = $benchmark.Id
    $problemId = $benchmark.ProblemId
    $url = "$baseUrl/$problemId/$name"
    Write-Host "Testing: $url" 
    $response = ""
    $response = Invoke-WebRequest $url -ErrorAction Ignore
    if($response -eq "" -xor $response.Content -like "*no longer exists*")
    {
        Write-Host "No problem found for $name, skipping" -ForegroundColor DarkYellow
        continue
    }
    Write-Host "grabbing image for route: $name at url: $url" -ForegroundColor Green

    $outputDir = "$pwd/moonBoardBenchmarkImages/$grade/$name.png"
    New-Item -ItemType Directory -Force -Path "$pwd/moonBoardBenchmarkImages/$grade" 


    Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList $url,"--screenshot=$outputDir","--headless","--hide-scrollbars","--window-size=650,1000","--disable-gpu", "--virtual-time-budget=5000" -Wait
}