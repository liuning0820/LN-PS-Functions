Function Get-Weather { 
<#   
.SYNOPSIS   
   Display weather data for a specific country and city. 
.DESCRIPTION 
   Display weather data for a specific country and city. There is a possibility for this to fail if the web service being used is unavailable. 
.PARAMETER Country 
    Country of city to view weather 
.PARAMETER ListCities 
    List all cities in specified country   
.PARAMETER City 
    City to view weather of 
.PARAMETER Credential 
    Use alternate credentials 
.PARAMETER UseDefaultCredential             
    Use default credentials            
.NOTES   
    Name: Get-Weather 
    Author: Boe Prox 
    DateCreated: 15Feb2011  
.LINK  
    http://www.webservicex.net/ws/default.aspx 
.LINK  
    http://boeprox.wordpress.com        
.EXAMPLE   
    Get-Weather -Country "United States" -ListCities 
     
Description 
------------ 
Returns all of the available cities that are available to retrieve weather information from. 
.EXAMPLE   
    Get-Weather -Country "United States" -City "San Francisco"
    
    
.EXAMPLE   
     Get-Weather -Country "China" -City "ShangHai"
Description 
------------ 
Retrieves the current weather information for San Francisco 
 
#>  
[cmdletbinding( 
    DefaultParameterSetName = 'Default', 
    ConfirmImpact = 'low' 
)] 
    Param( 
        [Parameter( 
            Mandatory = $True, 
            Position = 0, 
            ParameterSetName = '', 
            ValueFromPipeline = $True)] 
            [string]$Country, 
        [Parameter( 
            Position = 1, 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [switch]$ListCities, 
        [Parameter( 
            Position = 1, 
            Mandatory = $False, 
            ParameterSetName = '')] 
            [string]$City,  
        [Parameter( 
            Position = 2, 
            Mandatory = $False, 
            ParameterSetName = 'DefaultCred')] 
            [switch]$UseDefaultCredental,   
        [Parameter( 
            Position = 3, 
            Mandatory = $False, 
            ParameterSetName = 'AltCred')] 
            [System.Management.Automation.PSCredential]$Credential                                                 
                         
        ) 
Begin { 
    $psBoundParameters.GetEnumerator() | % {   
        Write-Verbose "Parameter: $_"  
        } 
    #Ensure that user is not using both -City and -ListCities parameters 
    Write-Verbose "Verifying that both City and ListCities is not being used in same command." 
    If ($PSBoundParameters.ContainsKey('ListCities') -AND $PSBoundParameters.ContainsKey('City')) { 
        Write-Warning "You cannot use both -City and -ListCities in the same command!" 
        Break 
        } 
    Switch ($PSCmdlet.ParameterSetName) { 
        AltCred { 
            Try { 
                #Make connection to known good weather service using DefaultCredentials 
                Write-Verbose "Create web proxy connection to weather service using Alternate Credentials" 
                $weather = New-WebServiceProxy 'http://www.webservicex.net/globalweather.asmx?WSDL' -Credential $credential 
                } 
            Catch { 
                Write-Warning "$($Error[0])" 
                Break 
                }  
           } 
        DefaultCred {              
            Try { 
                #Make connection to known good weather service using Alternate Credentials 
                Write-Verbose "Create web proxy connection to weather service using DefaultCredentials" 
                $weather = New-WebServiceProxy 'http://www.webservicex.net/globalweather.asmx?WSDL' -UseDefaultCredential 
                } 
            Catch { 
                Write-Warning "$($Error[0])" 
                Break 
                }  
           }  
        Default {              
            Try { 
                #Make connection to known good weather service 
                Write-Verbose "Create web proxy connection to weather service" 
                $weather = New-WebServiceProxy 'http://www.webservicex.net/globalweather.asmx?WSDL' 
                } 
            Catch { 
                Write-Warning "$($Error[0])" 
                Break 
                }  
           }  
       }                      
    } 
Process { 
    #Determine if we are only to list the cities for a given country or get the weather from a city 
    If ($PSBoundParameters.ContainsKey('ListCities')) { 
        Try { 
            #List all cities available to query for weather 
            Write-Verbose "Listing cities in country: $($country)" 
            (([xml]$weather.GetCitiesByCountry("$country")).newdataset).table | Sort City | Select City 
            Break 
            } 
        Catch { 
            Write-Warning "$($Error[0])" 
            Break 
            } 
        } 
    If ($PSBoundParameters.ContainsKey('City')) { 
        Try { 
            #Get the weather for the city and country 
            Write-Verbose "Getting weather for Country: $($country), City $($city)" 
            ([xml]$weather.GetWeather("$city", "$country")).CurrentWeather 
            Break 
            } 
        Catch { 
            Write-Warning "$($Error[0])" 
            Break 
            } 
        } 
    } 
End { 
    Write-Verbose "End function" 
    }    
}


#Example
Get-Weather -Country "China" -City "ShangHai"
Get-Weather -Country "China" -ListCities