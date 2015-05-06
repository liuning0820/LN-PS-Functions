#
# Invoke-Remote-PS-File.ps1
#

# the example below will download something based on the ps1.
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))





