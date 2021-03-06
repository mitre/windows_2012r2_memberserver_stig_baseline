# -*- encoding : utf-8 -*-
# frozen_string_literal: true

control 'V-32272' do
  title "The DoD Root CA certificates must be installed in the Trusted Root
  Store."
  desc  "To ensure secure DoD websites and DoD-signed code are properly
  validated, the system must trust the DoD Root Certificate Authorities (CAs).
  The DoD root certificates will ensure that the trust chain is established for
  server certificates issued from the DoD CAs."
  impact 0.5
  tag "gtitle": 'WINPK-000001'
  tag "gid": 'V-32272'
  tag "rid": 'SV-52961r5_rule'
  tag "stig_id": 'WN12-PK-000001'
  tag "fix_id": 'F-76901r2_fix'
  tag "cci": %w[CCI-000185 CCI-002470]
  tag "nist": ['SC-23 (5)', 'Rev_4']
  tag "documentable": false
  tag "check": "Verify the DoD Root CA certificates are installed as Trusted Root Certification Authorities.

The certificates and thumbprints referenced below apply to unclassified systems; see PKE documentation for other networks.

Run \"PowerShell\" as an administrator.

Execute the following command:

Get-ChildItem -Path Cert:Localmachine\root | Where Subject -Like \"*DoD*\" | FL Subject, Thumbprint, NotAfter

If the following certificate \"Subject\" and \"Thumbprint\" information is not displayed, this is finding.

If an expired certificate (\"NotAfter\" date) is not listed in the results, this is not a finding.

Subject: CN=DoD Root CA 2, OU=PKI, OU=DoD, O=U.S. Government, C=US
Thumbprint: 8C941B34EA1EA6ED9AE2BC54CF687252B4C9B561
NotAfter: 12/5/2029

Subject: CN=DoD Root CA 3, OU=PKI, OU=DoD, O=U.S. Government, C=US
Thumbprint: D73CA91102A2204A36459ED32213B467D7CE97FB
NotAfter: 12/30/2029

Subject: CN=DoD Root CA 4, OU=PKI, OU=DoD, O=U.S. Government, C=US
Thumbprint: B8269F25DBD937ECAFD4C35A9838571723F2D026
NotAfter: 7/25/2032

Subject: CN=DoD Root CA 5, OU=PKI, OU=DoD, O=U.S. Government, C=US
Thumbprint: 4ECB5CC3095670454DA1CBD410FC921F46B8564B
NotAfter: 6/14/2041

Alternately use the Certificates MMC snap-in:

Run \"MMC\".

Select \"File\", \"Add/Remove Snap-in\".

Select \"Certificates\", click \"Add\".

Select \"Computer account\", click \"Next\".

Select \"Local computer: (the computer this console is running on)\", click \"Finish\".

Click \"OK\".

Expand \"Certificates\" and navigate to \"Trusted Root Certification Authorities >> Certificates\".

For each of the DoD Root CA certificates noted below:

Right-click on the certificate and select \"Open\".

Select the \"Details\" Tab.

Scroll to the bottom and select \"Thumbprint\".

If the DoD Root CA certificates below are not listed or the value for the \"Thumbprint\" field is not as noted, this is a finding.

If an expired certificate (\"Valid to\" date) is not listed in the results, this is not a finding.

DoD Root CA 2
Thumbprint: 8C941B34EA1EA6ED9AE2BC54CF687252B4C9B561
Valid to: Wednesday, December 5, 2029

DoD Root CA 3
Thumbprint: D73CA91102A2204A36459ED32213B467D7CE97FB
Valid to: Sunday, December 30, 2029

DoD Root CA 4
Thumbprint: B8269F25DBD937ECAFD4C35A9838571723F2D026
Valid to: Sunday, July 25, 2032

DoD Root CA 5
Thumbprint: 4ECB5CC3095670454DA1CBD410FC921F46B8564B
Valid to: Friday, June 14, 2041"
  tag "fix": "Install the DoD Root CA certificates.
  DoD Root CA 2
  DoD Root CA 3
  DoD Root CA 4
  DoD Root CA 5

  The InstallRoot tool is available on IASE at
  http://iase.disa.mil/pki-pke/Pages/tools.aspx."

  dod_root_certificates = JSON.parse(input('dod_root_certificates').to_json)

  query = json({ command: 'Get-ChildItem -Path Cert:Localmachine\\\\root | Where {$_.Subject -Like "*DoD*"} | Select Subject, Thumbprint, @{Name=\'NotAfter\';Expression={"{0:dddd, MMMM dd, yyyy}" -f [datetime]$_.NotAfter}} | ConvertTo-Json' })

  describe 'Verify the DoD Root CA certificates are installed as Trusted Root Certification Authorities.' do
    subject { query.params }
    it { should be_in dod_root_certificates }
  end
end
