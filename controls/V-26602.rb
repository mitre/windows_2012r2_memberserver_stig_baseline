control "V-26602" do
  title "The Microsoft FTP service must not be installed unless required."
  desc  "Unnecessary services increase the attack surface of a system. Some of
  these services may not support required levels of authentication or encryption."
  impact 0.5
  tag "gtitle": "Microsoft FTP Service Disabled"
  tag "gid": "V-26602"
  tag "rid": "SV-52237r4_rule"
  tag "stig_id": "WN12-SV-000101"
  tag "fix_id": "F-74887r1_fix"
  tag "cci": ["CCE-23863-4", "CCI-000382"]
  tag "nist": ["CCE-23863-4", "CCI-000382"]
  tag "nist": ["CM-7 b", "Rev_4"]
  tag "documentable": false
  tag "check": "If the server has the role of an FTP server, this is NA.

  Run \"Services.msc\".

  If the \"Microsoft FTP Service\" (Service name: FTPSVC) is installed and not
  disabled, this is a finding."
  tag "fix": "Remove or disable the \"Microsoft FTP Service\" (Service name:
  FTPSVC).

  To remove the \"FTP Server\" role from a system:
  Start \"Server Manager\"
  Select the server with the \"FTP Server\" role.
  Scroll down to \"ROLES AND FEATURES\" in the left pane.
  Select \"Remove Roles and Features\" from the drop down \"TASKS\" list.
  Select the appropriate server on the \"Server Selection\" page, click \"Next\".
  De-select \"FTP Server\" under \"Web Server (IIS).
  Click \"Next\" and \"Remove\" as prompted."
  describe wmi({:namespace=>"root\\cimv2", :query=>"SELECT startmode FROM Win32_Service WHERE name='ftpsvc'"}).params.values do
    its("join") { should eq "Disabled" }
  end
end 

