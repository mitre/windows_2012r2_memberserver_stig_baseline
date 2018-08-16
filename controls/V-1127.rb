 ADMINISTRATORS1 = attribute(
  'administrators',
  description: 'List of authorized users in the local Admionistrators group',
  default: %w[
            Admn
            Administrator
           ]
)

 ADMINISTRATORS_DOMAIN = attribute(
  'administrators_domain',
  description: 'List of authorized users in the local Admionistrators domain group',
  default: %w[
            Admn
            Administrator
           ]
)

control "V-1127" do
  title "Only administrators responsible for the member server must have
  Administrator rights on the system."
  desc  "An account that does not have Administrator duties must not have
  Administrator rights.  Such rights would allow the account to bypass or modify
  required security restrictions on that machine and make it vulnerable to attack.

  System administrators must log on to systems only using accounts with the
  minimum level of authority necessary.

  For domain-joined member servers, the Domain Admins group must be replaced
  by a domain member server administrator group (see V-36433 in the Active
  Directory Domain STIG).  Restricting highly privileged accounts from the local
  Administrators group helps mitigate the risk of privilege escalation resulting
  from credential theft attacks.

  Systems dedicated to the management of Active Directory (AD admin
  platforms, see V-36436 in the Active Directory Domain STIG) are exempt from
  this.  AD admin platforms may use the Domain Admins group or a domain
  administrative group created specifically for AD admin platforms (see V-43711
  in the Active Directory Domain STIG).

  Standard user accounts must not be members of the built-in Administrators
  group.
  "
  impact 0.7
  tag "gtitle": "Restricted Administrator Group Membership"
  tag "gid": "V-1127"
  tag "rid": "SV-51511r3_rule"
  tag "stig_id": "WN12-GE-000004-MS"
  tag "fix_id": "F-58527r1_fix"
  tag "cci": ["CCI-002235"]
  tag "nist": ["AC-6 (10)", "Rev_4"]
  tag "documentable": false
  tag "ia_controls": "ECPA-1"
  tag "check": "Review the local Administrators group.  Only the appropriate
  administrator groups or accounts responsible for administration of the system
  may be members of the group.

  For domain-joined member servers, the Domain Admins group must be replaced by a
  domain member server administrator group.

  Systems dedicated to the management of Active Directory (AD admin platforms,
  see V-36436 in the Active Directory Domain STIG) are exempt from this.  AD
  admin platforms may use the Domain Admins group or a domain administrative
  group created specifically for AD admin platforms (see V-43711 in the Active
  Directory Domain STIG).

  Standard user accounts must not be members of the local Administrator group.

  If prohibited accounts are members of the local Administrators group, this is a
  finding.

  The built-in Administrator account or other required administrative accounts
  would not be a finding."
  tag "fix": "Configure the system to include only administrator groups or
  accounts that are responsible for the system in the local Administrators group.

  For domain-joined member servers, replace the Domain Admins group with a domain
  member server administrator group.

  Systems dedicated to the management of Active Directory (AD admin platforms,
  see V-36436 in the Active Directory Domain STIG) are exempt from this.  AD
  admin platforms may use the Domain Admins group or a domain administrative
  group created specifically for AD admin platforms (see V-43711 in the Active
  Directory Domain STIG).

  Remove any standard user accounts."
  
  is_domain = command('wmic computersystem get domain | FINDSTR /V Domain').stdout.strip
  administrator_group = command("net localgroup Administrators | Format-List | Findstr /V 'Alias Name Comment Members - command'").stdout.strip.split('\n')
  administrator_domain_group = command("net localgroup Administrators /DOMAIN | Format-List | Findstr /V 'Alias Name Comment Members - command request'").stdout.strip.split('\n')

  if is_domain == 'WORKGROUP'
    administrator_group.each do |user|
        describe "#{user}" do
          it { should be_in ADMINISTRATORS1}
        end            
      end 
  else  
    administrator_domain_group.each do |users|
      describe "#{users}" do
        it { should be_in ADMINISTRATORS_DOMAIN}
      end  
    end 
  end
  
end

 