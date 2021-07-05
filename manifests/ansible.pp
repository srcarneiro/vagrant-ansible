exec {"change-hostname":
		command => "/usr/bin/hostnamectl set-hostname ansible.intra.local --static"}
		
exec {"add-repo-java":
		command => "/usr/bin/add-apt-repository ppa:openjdk-r/ppa"}
		
exec {"add-repo-ansible":
		command => "/usr/bin/apt-add-repository ppa:ansible/ansible",
		require => Exec['add-repo-java']
}
		
exec {"apt-add-key-postgresql":
		command => "/usr/bin/wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
		require => Exec['add-repo-ansible']
}

exec {"add-repo-postgresql":
		path => ['/bin','/usr/bin'],
		command => "echo \"deb [arch=amd64] http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main\" > /etc/apt/sources.list.d/pgdg.list",
		require => Exec['apt-add-key-postgresql']}	
		
exec {"apt-update":
		command => "/usr/bin/apt-get update",
		require => Exec['add-repo-postgresql']}
			
package {["ansible","python","openjdk-11-jdk","postgresql-client-10"]:
		ensure => installed,
		require => Exec["apt-update"]}


file {"/home/liquibase":
		ensure => directory,
		require => Package["openjdk-11-jdk"]}
		
group {"groupadd-liquibase":
		name => "liquibase",
		ensure => present,
		require => File["/home/liquibase"]
		}
	
user {"useradd-liquibase":
		name => "liquibase",
		home => "/home/liquibase",
		groups => "liquibase",
		shell => "/bin/bash",
		comment => "[LIQUIBASE] - Administrador Liquibase",
		ensure => present,
		require => Group["groupadd-liquibase"]}
		
exec {'home-liquibase-ownership':
	command => '/bin/chown -R liquibase.liquibase /home/liquibase',
	require => User["useradd-liquibase"]}

file {"/usr/local/liquibase":
		owner => 'liquibase',
		group => 'liquibase',
		mode => '0650',
		ensure => directory,
		require => Exec["home-liquibase-ownership"]}
		
exec {'untar-liquibase':
	command => "/bin/tar -zxvf /vagrant/packages/liquibase/liquibase-4.3.4.tar.gz -C /usr/local/liquibase",
	unless => "/usr/bin/test -e /usr/local/liquibase/changelog.txt",
	require => File["/usr/local/liquibase"]}

exec {'check-liquibase':
	command => '/bin/true',
	onlyif => '/usr/bin/test -e /usr/local/liquibase/liquibase',
	require => Exec["untar-liquibase"]}
	
exec {'owner-liquibase':
	command => '/bin/chown -R liquibase.liquibase /usr/local/liquibase',
	require => Exec["check-liquibase"]}
	
file {'/sbin/liquibase':
	ensure => 'link',
	target => '/usr/local/liquibase/liquibase',
	require => Exec["owner-liquibase"]}