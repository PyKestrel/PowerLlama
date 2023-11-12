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
    <#
    .SYNOPSIS
        Get Details About A Model, Including Its Modelfile, Template, Parameters, License & System Prompt
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        The Name Of The Model As A String Like "mario"
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#show-model-information
    #>
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
    <#
    .SYNOPSIS
        Copy A Model By Creating Another From An Existing Model.
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Source
        Source Name Of The Model As A String Like "mario"
    .PARAMETER Destination
        Destination Name Of The Model As A String Like "mario2"
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#copy-a-model
    .OUTPUTS
        Status Code Of Request
    #>
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
    <#
    .SYNOPSIS
        Delete An Existing Model.
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        Name Of The Model As A String Like "mario"
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#delete-a-model
    .OUTPUTS
        Status Code Of Request
    #>
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
    <#
    .SYNOPSIS
        Download A Model From The Ollama Library.
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        Name Of The Model In The Follow Format "<namespace>/<model>:<tag>"
    .PARAMETER AllowInsecure
        Allow Insecure Connections ("true"||"false")
    .PARAMETER Stream
        If "false" The Response Will Be Returned As A Single Response Object, Rather Than A Stream Of Objects
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#pull-a-model
    #>
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
    <#
    .SYNOPSIS
        Upload A Model To The Ollama Library. (Requires registering for ollama.ai and adding a public key first.)
    .PARAMETER URI
        Properly Formmated URI Like "https://{IP OR DOMAIN_NAME}:{PORT}"
    .PARAMETER Name
        Name Of The Model As A String Like "mario"
    .PARAMETER AllowInsecure
        Allow Insecure Connections ("true"||"false")
    .PARAMETER Stream
        If "false" The Response Will Be Returned As A Single Response Object, Rather Than A Stream Of Objects
    .EXAMPLE

    .LINK
        https://github.com/jmorganca/ollama/blob/main/docs/api.md#push-a-model
    #>
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