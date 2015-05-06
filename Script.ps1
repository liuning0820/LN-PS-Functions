Configuration MyWebConfig
    {
       # Parameters are optional
       param ($MachineName, $WebsiteFilePath)

       # A Configuration block can have one or more Node blocks
       Node $MachineName
       {
          # Next, specify one or more resource blocks
          # WindowsFeature is one of the resources you can use in a Node block
          # This example ensures the Web Server (IIS) role is installed
          WindowsFeature IIS
          {
             # To ensure that the role is not installed, set Ensure to "Absent"
              Ensure = "Present" 
              Name = "Web-Server" # Use the Name property from Get-WindowsFeature  
          }

          # You can use the File resource to create files and folders
          # "WebDirectory" is the name you want to use to refer to this instance
          File WebDirectory
          {
             Ensure = "Present"  # You can also set Ensure to "Absent“
             Type = "Directory“ # Default is “File”
             Recurse = $true
             SourcePath = $WebsiteFilePath
             DestinationPath = "C:\inetpub\wwwroot"
            
             # Ensure that the IIS block is successfully run first before
             # configuring this resource
             Requires = "[WindowsFeature]IIS"  # Use Requires for dependencies     
          }
       }
    }