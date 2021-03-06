# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'V-36713' do
  title "The Windows Remote Management (WinRM) client must not allow
  unencrypted traffic."
  desc  "Unencrypted remote access to a system can allow sensitive information
  to be compromised.  Windows remote management connections must be encrypted to
  prevent this."
  impact 0.5
  tag "gtitle": 'WINCC-000124'
  tag "gid": 'V-36713'
  tag "rid": 'SV-51753r2_rule'
  tag "stig_id": 'WN12-CC-000124'
  tag "fix_id": 'F-44828r1_fix'
  tag "cci": %w[CCI-002890 CCI-003123]
  tag "cce": ['CCE-23728-9']
  tag "nist": ['MA-4 (6)', 'Rev_4']
  tag "documentable": false
  tag "check": "If the following registry value does not exist or is not
  configured as specified, this is a finding:

  Registry Hive: HKEY_LOCAL_MACHINE
  Registry Path: \\Software\\Policies\\Microsoft\\Windows\\WinRM\\Client\\

  Value Name: AllowUnencryptedTraffic

  Type: REG_DWORD
  Value: 0"
  tag "fix": "Configure the policy value for Computer Configuration ->
  Administrative Templates -> Windows Components -> Windows Remote Management
  (WinRM) -> WinRM Client -> \"Allow unencrypted traffic\" to \"Disabled\"."

  describe registry_key('HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\WinRM\\Client') do
    it { should have_property 'AllowUnencryptedTraffic' }
    its('AllowUnencryptedTraffic') { should cmp == 0 }
  end
end
