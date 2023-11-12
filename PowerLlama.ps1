<#
.SYNOPSIS
    A short one-line action-based description, e.g. 'Tests if a function is valid'
.DESCRIPTION
    A longer description of the function, its purpose, common use cases, etc.
.NOTES
    Information or caveats about the function e.g. 'This function is not supported in Linux'
.LINK
    Specify a URI to a help page, this will show when Get-Help -Online is used.
.EXAMPLE
    Test-MyTestFunction -Verbose
    Explanation of the function or its result. You can include multiple examples with additional .EXAMPLE lines
#>




function New-OllamaCompletion {
    <#
    .SYNOPSIS
        Generate a response for a given prompt with a provided model.
    .DESCRIPTION
        Generate a response for a given prompt with a provided model. This is a streaming endpoint, so will be a series of responses. The final response object will include statistics and additional data from the request.
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Model
        The Model Name As A String Like "llama2"
    .PARAMETER Prompt
        The Prompt To Generate A Response For
    .PARAMETER Format
        the format to return a response in. Currently the only accepted value is json
    .EXAMPLE
        New-OllamaCompletion -URI "http://10.1.0.1:11434" -Model "llama2" -Format json -Prompt "Why is the sky blue?" -Stream "false"

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#generate-a-completion
    #>

    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI,

        [Parameter(mandatory = $true)]
        [string] $Model,

        [Parameter(mandatory = $true)]
        [string] $Prompt,

        [Parameter(mandatory = $true)]
        [ValidateSet("json")]
        [string] $Format,

        [string] $Options,

        [string] $System,

        [string] $Template,

        [string] $Context,

        [ValidateSet("true", "false")]
        [string] $Stream,

        [ValidateSet("true", "false")]
        [string] $Raw
    )
    process {
        try {
            $RequestBody = @{
                "model"  = $Model;
                "prompt" = $Prompt;
                "format" = "json"
            }

            if (![string]::IsNullOrEmpty($Options)) {
                $RequestBody["options"] = $Options
            }
            elseif (![string]::IsNullOrEmpty($System)) {
                $RequestBody["system"] = $System
            }
            elseif (![string]::IsNullOrEmpty($Template)) {
                $RequestBody["template"] = $Template
            }
            elseif (![string]::IsNullOrEmpty($Context)) {
                $RequestBody["context"] = $Context
            }
            elseif (![string]::IsNullOrEmpty($Stream)) {
                if ($Stream -eq "false") {
                    $RequestBody["stream"] = $false
                }
                else {
                    $RequestBody["stream"] = $true
                }
                
            }
            elseif (![string]::IsNullOrEmpty($Raw)) {
                $RequestBody["raw"] = $Raw
            }
            
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/generate" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.RawContent
            }
            
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function New-OllamaModel {
    <#
    .SYNOPSIS
        Create A Model From A Modelfile
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        The Name To Be Given To The Model As A String Like "mario"
    .PARAMETER Path
        Path To The Model File On Remote System "~/Modelfile"
    .PARAMETER Stream
        If "false" The Response Will Be Returned As A Single Response Object, Rather Than A Stream Of Objects
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#create-a-model
    #>
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI,

        [Parameter(mandatory = $true)]
        [string] $Name,

        [Parameter(mandatory = $true)]
        [string] $Path,

        [ValidateSet("true", "false")]
        [string] $Stream
    )
    process {
        try {
            $RequestBody = @{
                "name" = $Name;
                "path" = $Path;
            }
            if (![string]::IsNullOrEmpty($Stream)) {
                if ($Stream -eq "false") {
                    $RequestBody["stream"] = $false
                }
                else {
                    $RequestBody["stream"] = $true
                } 
            }
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/create" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.RawContent
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function Get-OllamaModels {
    <#
    .SYNOPSIS
        Create A Model From A Modelfile
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        The Name To Be Given To The Model As A String Like "mario"
    .PARAMETER Path
        Path To The Model File On Remote System "~/Modelfile"
    .PARAMETER Stream
        If "false" The Response Will Be Returned As A Single Response Object, Rather Than A Stream Of Objects
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#create-a-model
    #>
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI
    )
    process {
        try {
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/tags" -Method Get
                $Response.RawContent
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function Show-OllamaModel {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI,

        [Parameter(mandatory = $true)]
        [string] $Name
    )
    process {
        try {
            $RequestBody = @{
                "name" = $Name;
            }
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/show" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.RawContent
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function Copy-OllamaModel {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI,

        [Parameter(mandatory = $true)]
        [string] $Source,

        [Parameter(mandatory = $true)]
        [string] $Destination
    )
    process {
        try {
            $RequestBody = @{
                "source"      = $Source;
                "destination" = $Destination;
            }
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/copy" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.StatusCode
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function Remove-OllamaModel {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $URI,
        
        [Parameter(mandatory = $true)]
        [string] $Name
    )
    process {
        try {
            $RequestBody = @{
                "name" = $Name;
            }
            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/delete" -Method Delete -Body $($RequestBody | ConvertTo-Json)
                $Response.StatusCode
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function Install-OllamaModel {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $Name,

        [ValidateSet("true", "false")]
        [string] $AllowInsecure,

        [ValidateSet("true", "false")]
        [string] $Stream
    )
    process {
        try {
            $RequestBody = @{
                "name" = $Name;
            }

            if (![string]::IsNullOrEmpty($Stream)) {
                if ($Stream -eq "false") {
                    $RequestBody["stream"] = $false
                }
                else {
                    $RequestBody["stream"] = $true
                }
            }
            elseif (![string]::IsNullOrEmpty($AllowInsecure)) {
                if ($AllowInsecure -eq "false") {
                    $RequestBody["insecure"] = $false
                }
                else {
                    $RequestBody["insecure"] = $true
                }
            }

            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/pull" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.RawContent
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

function New-OllamaModel {
    [CmdletBinding()]
    param (
        [Parameter(mandatory = $true)]
        [string] $Name,

        [ValidateSet("true", "false")]
        [string] $AllowInsecure,

        [ValidateSet("true", "false")]
        [string] $Stream
    )
    process {
        try {
            $RequestBody = @{
                "name" = $Name;
            }

            if (![string]::IsNullOrEmpty($Stream)) {
                if ($Stream -eq "false") {
                    $RequestBody["stream"] = $false
                }
                else {
                    $RequestBody["stream"] = $true
                }
            }
            elseif (![string]::IsNullOrEmpty($AllowInsecure)) {
                if ($AllowInsecure -eq "false") {
                    $RequestBody["insecure"] = $false
                }
                else {
                    $RequestBody["insecure"] = $true
                }
            }

            if ([uri]::IsWellFormedUriString($URI, 'RelativeOrAbsolute') -and ([uri] $URI).Scheme -in 'http', 'https') {
                $Response = Invoke-WebRequest -Uri $URI"/api/push" -Method Post -Body $($RequestBody | ConvertTo-Json)
                $Response.RawContent
            }
        }
        catch {
            $StatusCode = $_.Exception
            $StatusCode
        }
    }
}

# Private Functions

New-OllamaCompletion -URI "http://10.1.0.42:11434" -Model "llama2" -Format json -Prompt "Why is the sky blue in less than 2 sentences?" -Stream "false"
Pause