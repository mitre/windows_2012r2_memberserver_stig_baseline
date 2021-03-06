# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'V-26496' do
  title "Unauthorized accounts must not have the Manage auditing and security
  log user right."
  desc "Inappropriate granting of user rights can provide system,
  administrative, and other high-level capabilities.

  Accounts with the \"Manage auditing and security log\" user right can
  manage the security log and change auditing configurations.  This could be used
  to clear evidence of tampering.
  "
  impact 0.5
  tag "gtitle": 'Manage auditing and security log'
  tag "gid": 'V-26496'
  tag "rid": 'SV-53039r3_rule'
  tag "stig_id": 'WN12-UR-000032'
  tag "fix_id": 'F-45965r2_fix'
  tag "cci": %w[CCI-000162 CCI-000163 CCI-000164
                CCI-000171 CCI-001914]
  tag "cce": ['CCE-23456-7']
  tag "nist": ['AU-9', 'AU-12 b', 'AU-12 (3)', 'Rev_4']
  tag "documentable": false
  tag "check": "Verify the effective setting in Local Group Policy Editor.
  Run \"gpedit.msc\".

  Navigate to Local Computer Policy >> Computer Configuration >> Windows Settings
  >> Security Settings >> Local Policies >> User Rights Assignment.

  If any accounts or groups other than the following are granted the \"Manage
  auditing and security log\" user right, this is a finding:

  Administrators

  If the organization has an Auditors group, the assignment of this group to the
  user right would not be a finding.

  If an application requires this user right, this would not be a finding.
  Vendor documentation must support the requirement for having the user right.
  The requirement must be documented with the ISSO.
  The application account must meet requirements for application account
  passwords, such as length (V-36661) and required changes frequency (V-36662)."
  tag "fix": "Configure the policy value for Computer Configuration >> Windows
  Settings >> Security Settings >> Local Policies >> User Rights Assignment >>
  \"Manage auditing and security log\" to only include the following accounts or
  groups:

  Administrators"

  describe security_policy do
    its('SeSecurityPrivilege') { should eq ['S-1-5-32-544'] }
  end
end
