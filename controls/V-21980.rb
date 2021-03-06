# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'V-21980' do
  title 'Explorer Data Execution Prevention must be enabled.'
  desc  "Data Execution Prevention (DEP) provides additional protection by
  performing  checks on memory to help prevent malicious code from running.  This
  setting will prevent Data Execution Prevention from being turned off for File
  Explorer."
  impact 0.5
  tag "gtitle": 'Explorer Data Execution Prevention'
  tag "gid": 'V-21980'
  tag "rid": 'SV-53125r1_rule'
  tag "stig_id": 'WN12-CC-000089'
  tag "fix_id": 'F-46051r1_fix'
  tag "cci": ['CCI-002824']
  tag "cce": ['CCE-25147-0']
  tag "nist": %w[SI-16 Rev_4]
  tag "documentable": false
  tag "check": "If the following registry value does not exist or is not
  configured as specified, this is a finding:

  Registry Hive: HKEY_LOCAL_MACHINE
  Registry Path: \\Software\\Policies\\Microsoft\\Windows\\Explorer\\

  Value Name: NoDataExecutionPrevention

  Type: REG_DWORD
  Value: 0"
  tag "fix": "Configure the policy value for Computer Configuration ->
  Administrative Templates -> Windows Components -> File Explorer -> \"Turn off
  Data Execution Prevention for Explorer\" to \"Disabled\"."

  describe registry_key('HKEY_LOCAL_MACHINE\\Software\\Policies\\Microsoft\\Windows\\Explorer') do
    it { should have_property 'NoDataExecutionPrevention' }
    its('NoDataExecutionPrevention') { should cmp == 0 }
  end
end
