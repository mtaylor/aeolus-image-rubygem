%global gemdir %(ruby -rubygems -e 'puts Gem::dir' 2>/dev/null)
%global gemname aeolus-image
%global geminstdir %{gemdir}/gems/%{gemname}-%{version}
%global mandir %{_mandir}/man1
%global rubyabi 1.8

Summary: Command-line interface for working with the Aeolus cloud suite
Name: rubygem-aeolus-image
Version: 0.1.0
Release: 3%{?extra_release}%{?dist}
Group: Development/Languages
License: ASL 2.0
URL: http://aeolusproject.org

# The source for this packages was pulled from the upstream's git repo.
# Use the following commands to generate the gem
# git clone  git://git.fedorahosted.org/aeolus/conductor.git
# git checkout next
# cd services/image_factory/aeolus-image
# rake gem
# grab image_factory_console-0.0.1.gem from the pkg subdir
Source0: %{gemname}-%{version}.gem

Requires: ruby(abi) = %{rubyabi}
Requires: rubygems
Requires: rubygem(nokogiri) >= 1.4.0
Requires: rubygem(rest-client)
Requires: rubygem(imagefactory-console) >= 0.4.0

BuildRequires: ruby
BuildRequires: rubygems

BuildArch: noarch
Provides: rubygem(%{gemname}) = %{version}

%description
QMF Console for Aeolus Image Factory

%prep
%setup -q -c -T
mkdir -p ./%{gemdir}
gem install --local --install-dir ./%{gemdir} --force --rdoc %{SOURCE0}

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{gemdir}
cp -a .%{gemdir}/* %{buildroot}%{gemdir}/

mkdir -p %{buildroot}/%{_bindir}
mv %{buildroot}%{gemdir}/bin/* %{buildroot}/%{_bindir}
find %{buildroot}%{geminstdir}/bin -type f | xargs chmod 755
rmdir %{buildroot}%{gemdir}/bin
rm -rf %{buildroot}%{gemdir}/gems/%{gemname}-%{version}/.yardoc

mkdir -p %{buildroot}%{mandir}
mv %{buildroot}%{geminstdir}/man/* %{buildroot}%{mandir}

%files
%doc %{geminstdir}/COPYING
%{_bindir}/aeolus-image
%dir %{geminstdir}
%{geminstdir}/Rakefile
%{geminstdir}/bin
%{geminstdir}/examples
%{geminstdir}/lib
%{geminstdir}/man
%{geminstdir}/spec
%doc %{gemdir}/doc/%{gemname}-%{version}
%{gemdir}/cache/%{gemname}-%{version}.gem
%{gemdir}/specifications/%{gemname}-%{version}.gemspec
%{mandir}/*

%changelog
* Wed Jul 20 2011 Mo Morsi <mmorsi@redhat.com>  - 0.0.1-3
- more updates to conform to fedora guidelines

* Fri Jul 15 2011 Mo Morsi <mmorsi@redhat.com>  - 0.0.1-2
- updated package to conform to fedora guidelines

* Mon Jul 04 2011  <mtaylor@redhat.com>  - 0.0.1-1
- Added man files

* Wed Jun 15 2011  <jguiditt@redhat.com> - 0.0.1-1
- Initial package
