#Red Hat Identity Management (IdM) Q&A

##Core Requirements:

1. Does IdM provide consistent authentication (login) for all UNIX/Linux endpoints ? 
	* Red Hat Identity Management (IdM) provides native authentication for Red Hat Enterprise Linux (RHEL) 6 and RHEL7 via SSSD, and provides both an LDAP and Kerberos interface for other Unix/Linux systems
 
1. Does IdM support integration to a centralized store of identities, such as Microsoft Active Directory 2008 R2 (and future versions of Active Directory), along with associated authorizations, credentials?
	* IdM supports a trust relationship to AD, such that users and groups in AD can be granted permissions to RHEL servers managed by IdM.

1. Does IdM provide the option to identify principals by a means other than username (UPN, employee ID, other)? 
	* Users created in IdM have additional information stored as attributes, such as first name and last name. Additional key attributes are available out-of-the box, such as email, employee number, and kerberos principal. Custom attributes can be created through modification of IdM's schema.

1. Does IdM provide the ability to reference custom attributes for users and endpoint principals as stored in active directory?
	* SSSD can fetch extended user attributes from a central identity store and make it available via a special interface. SSSD can do this for AD users, IdM users or users that are located in trusted AD domains when SSSD is joined to IdM. There is no similar support for extended attributes for hosts and services.

1. Does IdM support role-based access control (Authorization, Security)? 
	* IdM supports management of several types of policy for RHEL clients, tied to groups (roles) provided from a trusted Active Directory or created locally within IdM:
		+ Host-Based Access Control - define a group of users that can access a group of servers via a group of services
		+ sudo rules - define a group of users that can execute a list of commands on a group of servers
		+ SELinux User Maps - define the mapping to a SELinux user for a group of users on a group of servers
		+ IdM RBAC - define mapping from group of users to roles within IdM to perform administrative actions

1. Does IdM provide flexibility to easily differentiate between local and centralized accounts ? 
	* Accounts local to a RHEL server can continue to exist, centralized accounts can be scoped to a domain, e.g.; user@example.com. Given that non-RHEL systems will use LDAP to resolve users, this will be unique to each type of client. It is recommended to keep UIDs of the local users under 1000 and make UIDs of the central users be above 1000. This boundary is configurable in SSSD.

1. Does IdM provide for a user’s network homeDirectory (as defined in Active Directory) as their UNIX Home Directory?
	* There are different ways how POSIX attributes can be handled by the solution. If SSSD is joined to AD the attributes can be fetched from AD. This requires SFU which is deprecated by MSFT. If POSIX data is not stored in AD SSSD can generate these attrbutes using templates. If IdM is leveraged and SSSD is joined to IdM while IdM is in trust relations the POSIX attributes can be managed in AD's SFU, by SSSD or be menaged by IdM for AD users leveraging ID Views feature.
	* IdM will read POSIX Attributes from the Active Directory and provide them to clients, including the homeDirectory field. 

1. Does IdM support host-based access control (Authorization, Security) ? 
	* IdM natively supports host-based access control for RHEL clients, with rules created by GUI or CLI of the form: _user or group of users_ can access _host or group of hosts_ via _service or group of services_. Non-RHEL clients will each have their own mechanism for limiting access via groups read from IdM via LDAP.

1. Does IdM support security groups in Active Directory for purposes of grouping servers and users? 
	* Active Directory groups of users can as nested groups within IdM. Hosts joined to IdM will be grouped in host groups within IdM.

1. Does IdM use an extensible authentication provider (e.g. Multifactor Authentication)? 
	* IdM supports native two-factor authentication (2FA) via One Time Passwords (OTP). HOTP and TOTP are both supported. SSSD has pluggable architecture so it can be extended too. SSSD plugs into PAM and PAM allows for traditional pluggable authentication modules.
	* IdM also supports external 2FA, via configuration of a remote Radius server.

1. Is IdM based on standard technologies and protocols (Interoperability)?
	* IDM is based on LDAP and Kerberos, DNS, PKI and other standards.

1. Does IdM provide SSO capabilities for interactive login, preferably using a mechanism such as Kerberos?
	* IdM provides a Kerberos realm as part of the solution.

1. Does IdM provide SSO capabilities for web-based applications running on UNIX/Linux endpoints, using a mechanism such as Kerberos, Oauth, SAML or similar? 
	* Solution provides SSO using Kerberos. Roadmap includes a SAML IdP (see upstream Ipsilon project for more details).

1. Does IdM support integration with file sharing applications?
	* Samba File server can be configured to use IdM server as source of authentication, SSO and identity information. See [Integrating a Samba File Server With IPA](http://www.freeipa.org/page/Howto/Integrating_a_Samba_File_Server_With_IPA)

1. Can IdM scale to support at minimum 100,000 Linux/Unix identities, including 15,000 Linux/Unix server identities? 
	* IdM can support 100,000 different identities inclusing users, groups, hosts, host groups, netgroups and kerberized services. The IdM based solution supports up to 20 replicas in flexibile topology. SSSD containes caches that allows reducing the load on the central IdM servers.

## Systems Integration
1. Does IdM support cloud Infrastructure As A Service (IAAS) endpoints? 
	* Any Linux system that has corresponig SSSD and IdM client software can be joined into IdM environment.

1. Does IdM leverage service-discovery to reduce expense of endpoint configuration and ensure changes in the sources of authentication services are rapidly and consistently picked-up? 
	* The default configuration of the SSSD is to use service discovery (via DNS SRV records) to determine available servers.

1. Does IdM provide automation for endpoint enrollment and configuration, possibly leveraging existing configuration management solution such as Puppet (Manageability, Integration)? 
	* The clients can be enrolled by running ipa-client-install command. There are publicly available Puppet modules to automate this process. Satellite 6 is also able to orchestrate automatic client enrollment.
 
1. Does IdM log enrollment and de-enrollment events both locally (within the endpoint) and to a centralized logging infrastructure, and explain how 
	* All client and server side activity is audited and stored in special logs and selectively in syslog. The logs can be aggregated using rsyslog into a central point and processsed there by a preferred log analyses solution.

1. Does IdM expose a Webservice, API or scriptable CLI for configuration and management, or leverage configuration management tools for all agent-management responsibilities?
	* IdM provides a scriptable CLI. Some of the operations (particularly read operations) can be performed over LDAP. Roadmap includes JSON based remote API.

1.Does IdM leverage incumbent infrastructure where appropriate (e.g., Microsoft Active Directory, DNS, Time). If the solution duplicates infrastructure, can IdM interoperate with infrastructure which it duplicates without exposing the incumbent infrastructure to risk of disruption?
	* IdM integrates with AD (via trust), DNS (via zone delegation) and CAs (as a subordinate CA). It brings its own optional DNS and PKI components that can be omitted in favor of DNS and PKI components already available in the infrastructure.

1. Does IdM support patching and upgrade via an existing configuration management solution such as Puppet, and explain how ?
	* IdM is part of Red Hat Enterprise Linux (RHEL), and follows the same patching methodology and lifecycle as RHEL.

1. Does IdM run on a supported platform (RHEL 6 or later or Windows Server 2012R2 or later) ?
	* The IdM servers should be run on RHEL 7.1 or later, but can also be installed on RHEL6.

1. What is the expected resource consumption of the IdM agent (SSSD) ?
	* SSSD consists of several services that work together to provide authentication, authorization and identity data. All parts of SSSD are built using non blocking IO calls and do not consume resources when idle.

1. Is IdM compatible with a virtualized environment (VMware) ? 
	* Yes, IdM is independent of the platform where the OS runs.

## Availability
1. Does IdM provide automated failure-discovery and automated reconfiguration to pick-up new sources?
	* As soon as a new IdM server is added the integrated DNS server is automatically updated with the information about this server. Clients that use service discovery can start taking advantage of this server right away.

1. Does IdM localize requests for information whenever possible to reduce inter-site traffic and provide for predictable, short response-times (an example of this capability is the "Sites and Services" concept in Microsoft Active Directory)?
	* Support for location-aware fuctionality (like "Sites and Subnets") in IdM is on the roadmap. SSSD supports concept of sites when it is joined directly to AD and will be able to support IdM sites as soon as this capbility is added to IdM.

1. Does IdM continue to provide service after sustaining the loss of more than one authentication server within a site (HA within a Datacenter)?
	* All IdM servers are masters, such that all remaining servers can continue to provive service. The deployment supports automatical failover and loadbalacing built into clients side re-connection logic.
