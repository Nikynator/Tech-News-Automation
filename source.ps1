$ApiKey = "acdb4d07a31e4cfba700c2fefcd15f08" 

if ([string]::IsNullOrWhitespace($ApiKey)) {
    Write-Host "Action Required: Please open this script and insert your News API key in the `$ApiKey variable." -ForegroundColor Yellow
    Exit
}

$Topics = [ordered]@{
    "AI"               = "artificial intelligence OR machine learning OR LLM"
    "Development"       = "software development OR programming OR coding OR devops"
    "Cybersecurity"     = "cybersecurity OR hacker OR data breach OR infosec"
    "Data Protection"   = "data privacy OR GDPR OR data protection"
}

$OutputFile = "$env:TEMP\multitopic_technews.html"
$HtmlBodyTabs = ""
$HtmlBodyContent = ""
$IsFirst = $true

Write-Host "Fetching news for all topics..." -ForegroundColor Cyan

foreach ($Topic in $Topics.Keys) {
    $Query = [Uri]::EscapeDataString($Topics[$Topic])
    $URL = "https://newsapi.org/v2/everything?q=$Query&sources=the-verge&language=en&sortBy=publishedAt&pageSize=15&apiKey=$ApiKey"
    
    Write-Host " -> Fetching articles for: $Topic" -ForegroundColor Gray
    
    try {
        $Response = Invoke-RestMethod -Uri $URL -Method Get -UserAgent "PowerShellNewsScript"
        if ($Response.status -ne "ok") {
            Write-Host "API Error on topic '$Topic': $($Response.message)" -ForegroundColor Red
            continue
        }
    }
    catch {
        Write-Host "Failed to connect for topic '$Topic'." -ForegroundColor Red
        continue
    }

    $ActiveClass = if ($IsFirst) { "active" } else { "" }
    $DisplayStyles = if ($IsFirst) { "display: block;" } else { "display: none;" }
    $TabId = $Topic -replace '\s+','' -replace '&',''

    $HtmlBodyTabs += "<button class='tab-link $ActiveClass' onclick='openTopic(event, `"$TabId`")'>$Topic</button>`n"
    $HtmlBodyContent += "<div id='$TabId' class='tab-content' style='$DisplayStyles'>`n"

    $ArticleCount = 0
    foreach ($Article in $Response.articles) {
        if ($Article.title -eq "[Removed]" -or [string]::IsNullOrWhitespace($Article.title)) { continue }
        $ArticleCount++

        $PublishedDate = if ($Article.publishedAt) { (Get-Date $Article.publishedAt).ToString("g") } else { "Unknown" }
        $Author = if ($Article.author) { "by $($Article.author)" } else { "" }

        $HtmlBodyContent += @"
            <article class="card">
                <h2><a href="$($Article.url)" target="_blank">$($Article.title)</a></h2>
                <div class="meta">
                    <span class="source">$($Article.source.name)</span> | $PublishedDate $Author
                </div>
                <p class="description">$($Article.description)</p>
            </article>
"@
    }

    if ($ArticleCount -eq 0) {
        $HtmlBodyContent += "<p class='no-news'>No recent articles found for this topic on The Verge.</p>"
    }

    $HtmlBodyContent += "</div>`n"
    $IsFirst = $false
}

$HtmlHeader = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>The Verge - Tech Dashboard</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f4f8;
            color: #1e293b;
            line-height: 1.6;
            margin: 0;
            padding: 20px;
        }
        .container { max-width: 1000px; margin: auto; }
        header { 
            text-align: center; 
            margin-bottom: 30px; 
            background: linear-gradient(135deg, #0f172a, #1e3a8a);
            padding: 30px 20px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1);
        }
        header h1 { color: #f8fafc; margin: 0 0 10px 0; font-size: 2.5rem; letter-spacing: -0.5px; }
        .timestamp { color: #93c5fd; font-size: 0.9rem; margin: 0; }
        
        .tab-bar {
            display: flex;
            border-bottom: 3px solid #cbd5e1;
            margin-bottom: 25px;
            gap: 8px;
        }
        .tab-link {
            background-color: #e2e8f0;
            border: none;
            outline: none;
            cursor: pointer;
            padding: 14px 24px;
            font-size: 1rem;
            font-weight: 600;
            color: #475569;
            border-radius: 8px 8px 0 0;
            transition: all 0.2s ease;
        }
        .tab-link:hover { background-color: #cbd5e1; color: #0f172a; }
        .tab-link.active { background-color: #1d4ed8; color: #ffffff; }
        
        .card {
            background: #ffffff;
            padding: 24px;
            margin-bottom: 20px;
            border-radius: 10px;
            border-left: 5px solid #2563eb;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05), 0 2px 4px -1px rgba(0,0,0,0.03);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
        }
        .card h2 { margin-top: 0; font-size: 1.4rem; font-weight: 700; }
        .card h2 a { text-decoration: none; color: #1e3a8a; transition: color 0.2s; }
        .card h2 a:hover { color: #2563eb; }
        .meta { font-size: 0.85rem; color: #64748b; margin-bottom: 12px; }
        .description { color: #334155; font-size: 1rem; }
        .source { font-weight: bold; color: #e11d48; }
        .no-news { text-align: center; color: #64748b; padding: 40px; background: #ffffff; border-radius: 10px; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>The Verge News Feed</h1>
            <p class="timestamp">Last Updated: $(Get-Date -Format "F")</p>
        </header>
        
        <div class="tab-bar">
            $HtmlBodyTabs
        </div>

        <main>
            $HtmlBodyContent
        </main>
    </div>

    <script>
        function openTopic(evt, topicId) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
            }
            tablinks = document.getElementsByClassName("tab-link");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].className = tablinks[i].className.replace(" active", "");
            }
            document.getElementById(topicId).style.display = "block";
            evt.currentTarget.className += " active";
        }
    </script>
</body>
</html>
"@

$HtmlHeader | Out-File -FilePath $OutputFile -Encoding utf8
Write-Host "Opening your updated Tech Dashboard..." -ForegroundColor Green
Start-Process $OutputFile