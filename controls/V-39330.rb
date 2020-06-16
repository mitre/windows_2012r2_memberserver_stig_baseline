control "V-39330" do
  title "The Active Directory RID Manager$ object must be configured with
proper audit settings."
  desc  "When inappropriate audit settings are configured for directory service
database objects, it may be possible for a user or process to update the data
without generating any tracking data.  The impact of missing audit data is
related to the type of object.  A failure to capture audit data for objects
used by identification, authentication, or authorization functions could
degrade or eliminate the ability to track changes to access policy for systems
or data.

    For Active Directory (AD), there are a number of critical object types in
the domain naming context of the AD database for which auditing is essential.
This includes the RID Manager$ object.  Because changes to these objects can
significantly impact access controls or the availability of systems, the
absence of auditing data makes it impossible to identify the source of changes
that impact the confidentiality, integrity, and availability of data and
systems throughout an AD domain.  The lack of proper auditing can result in
insufficient forensic evidence needed to investigate an incident and prosecute
the intruder."
  impact 0.5
  tag 'severity': nil
  tag 'gtitle': 'WINAU-000212-DC'
  tag 'gid': 'V-39330'
  tag 'rid': 'SV-51174r3_rule'
  tag 'stig_id': 'WN12-AU-000212-DC'
  tag 'fix_id': 'F-44331r2_fix'
  tag 'cci': ["CCI-000172", "CCI-002234"]
  tag 'nist': ["AU-12 c", "AC-6 (9)", "Rev_4"]
  tag 'false_negatives': nil
  tag 'false_positives': nil
  tag 'documentable': false
  tag 'mitigations': nil
  tag 'severity_override_guidance': false
  tag 'potential_impacts': nil
  tag 'third_party_tools': nil
  tag 'mitigation_controls': nil
  tag 'responsibility': nil
  tag 'ia_controls': "ECAR-1, ECAR-2, ECAR-3"
  tag 'check': "Verify the auditing configuration for the RID Manager$ object.

Open \"Active Directory Users and Computers\".  (Available from various menus
or run \"dsa.msc\".)
Ensure Advanced Features is selected in the View menu.
Select System under the domain being reviewed in the left pane.
Right-click the RID Manager$ object in the right pane and select Properties.
Select the Security tab.
Select the Advanced button and then the Auditing tab.

If the audit settings on the RID Manager$ object are not at least as inclusive
as those below, this is a finding.

Type - Fail
Principal - Everyone
Access - Full Control
Inherited from - None

The success types listed below are defaults.  Where Special is listed in the
summary screens for Access, detailed Permissions are provided for reference,
various Properties selections may also exist by default.

Type - Success
Principal - Everyone
Access - Special
Inherited from - None
 (Access - Special = Write all properties, All extended rights, Change RID
master)

Two instances with the following summary information will be listed.
Type - Success
Principal - Everyone
Access - (blank)
Inherited from - (CN of domain)"
  tag 'fix': "Configure the audit settings for RID Manager$ object to include the
following.

Type - Fail
Principal - Everyone
Access - Full Control
Inherited from - None

The success types listed below are defaults.  Where Special is listed in the
summary screens for Access, detailed Permissions are provided for reference,
various Properties selections may also exist by default.

Type - Success
Principal - Everyone
Access - Special
Inherited from - None
 (Access - Special = Write all properties, All extended rights, Change RID
master)

Two instances with the following summary information will be listed.
Type - Success
Principal - Everyone
Access - (blank)
Inherited from - (CN of domain)"

domain_role = command('wmic computersystem get domainrole | Findstr /v DomainRole').stdout.strip
    if domain_role == '4' || domain_role == '5'
     distinguishedName = json(command: '(Get-ADDomain).DistinguishedName | ConvertTo-JSON').params
     acl_rules = json(command: "(Get-ACL -Audit -Path AD:'CN=RID Manager$,CN=System,#{distinguishedName}').Audit | ConvertTo-CSV | ConvertFrom-CSV | ConvertTo-JSON").params
    
     describe.one do
        acl_rules.each do |acl_rule|
          describe "Audit rule property for principal: #{acl_rule['IdentityReference']}" do
            subject { acl_rule }
            its(['AuditFlags']) { should cmp "Failure" }
            its(['IdentityReference']) { should cmp "Everyone" }
            its(['ActiveDirectoryRights']) { should cmp "GenericAll"}
          end
        end
      end

      describe.one do
        acl_rules.each do |acl_rule|
          describe "Audit rule property for principal: #{acl_rule['IdentityReference']}" do
            subject { acl_rule }
            its(['AuditFlags']) { should cmp "Success" }
            its(['IdentityReference']) { should cmp "Everyone" }
            its(['ActiveDirectoryRights']) { should cmp "WriteProperty, ExtendedRight"}
            its(['IsInherited']) { should cmp "False" }
            its(['InheritanceType']) { should cmp "None" }
          end
        end
      end


      describe.one do
        acl_rules.each do |acl_rule|
          describe "Audit rule property for principal: #{acl_rule['IdentityReference']}" do
            subject { acl_rule }
            its(['AuditFlags']) { should cmp "Success" }
            its(['IdentityReference']) { should cmp "Everyone" }
            its(['ActiveDirectoryRights']) { should cmp "WriteProperty"}
            its(['IsInherited']) { should cmp "True" }
            its(['InheritanceType']) { should cmp "Descendents" }
          end
        end
      end
    else
      impact 0.0
      desc 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers'
      describe 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers' do
       skip 'This system is not a domain controller, therefore this control is not applicable as it only applies to domain controllers'
     end
    end
end

