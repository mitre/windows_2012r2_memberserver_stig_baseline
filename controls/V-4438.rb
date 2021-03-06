# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'V-4438' do
  title "The system must limit how many times unacknowledged TCP data is
  retransmitted."
  desc "In a SYN flood attack, the attacker sends a continuous stream of SYN
  packets to a server, and the server leaves the half-open connections open until
  it is overwhelmed and is no longer able to respond to legitimate requests."
  impact 0.3
  tag "gtitle": 'TCP Data Retransmissions'
  tag "gid": 'V-4438'
  tag "rid": 'SV-52929r2_rule'
  tag "stig_id": 'WN12-SO-000048'
  tag "fix_id": 'F-45855r3_fix'
  tag "cci": ['CCI-002385']
  tag "cce": ['CCE-25455-7']
  tag "nist": %w[SC-5 Rev_4]
  tag "documentable": false
  tag "check": "If the following registry value does not exist or is not
  configured as specified, this is a finding:

  Registry Hive:  HKEY_LOCAL_MACHINE
  Registry Path:  \\SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters\\

  Value Name:  TcpMaxDataRetransmissions

  Value Type:  REG_DWORD
  Value:  3 (or less)"
  tag "fix": "Configure the policy value for Computer Configuration >> Windows
  Settings >> Security Settings >> Local Policies >> Security Options >> \"MSS:
  (TcpMaxDataRetransmissions) How many times unacknowledged data is retransmitted
  (3 recommended, 5 is default)\" to \"3\" or less.

  (See \"Updating the Windows Security Options File\" in the STIG Overview
  document if MSS settings are not visible in the system's policy tools.)"

  describe registry_key('HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Services\\Tcpip\\Parameters') do
    it { should have_property 'TcpMaxDataRetransmissions' }
    its('TcpMaxDataRetransmissions') { should cmp <= 3 }
  end
end
