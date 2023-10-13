$storageThreshold = 15
$utilization = (Get-PSDrive | Where {$_.name -eq "C"}).free
if(($storageThreshold *1GB) -lt $utilization){
    write-output "Storage is fine, no remediation needed"
    exit 0}
else{
    write-output "Storage is low, remediation needed"
    exit 1}